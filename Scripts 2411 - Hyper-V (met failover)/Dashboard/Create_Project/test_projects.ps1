# ==============================
# CONFIG
# ==============================
$CSVProjects   = 'C:\Temp\Projects.csv'
$CSVLocGRnotes = 'C:\Temp\GroupNotes.csv'
$HyperVHosts   = @("VMS1","VMS2","VMS3")
$MinFreeGB     = 2  # Verhoogd naar 2GB buffer voor veiligheid

$LocalScriptPath  = "C:\Users\Administrator\Desktop\Scripts\Dashboard\Main\New_VM.ps1"
$RemoteScriptPath = "C:\HyperV-Scripts\New_VM.ps1"

$LogPath = "C:\Temp\VM_Deploy_$(Get-Date -Format 'yyyyMMdd_HHmmss').log"

Write-Host "`n================ PROJECT UITROL (SMART PRE-ALLOCATION) ================" -ForegroundColor Cyan

# ==============================
# Logging
# ==============================
function Write-Log {
    param([string]$Message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "[$timestamp] $Message"
    Add-Content -Path $LogPath -Value $logMessage
    Write-Host $Message -ForegroundColor "White"
}

# ==============================
# Backup + CSV Import
# ==============================
if (-not (Test-Path $CSVProjects)) {
    Write-Log "ERROR: Projects.csv niet gevonden op $CSVProjects" "Red"
    exit
}

try {
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    $backup = "C:\Temp\Projects_backup_$timestamp.csv"
    Copy-Item $CSVProjects $backup -Force
    Write-Log "Backup gemaakt: $backup" "Green"
} catch {
    Write-Log "WAARSCHUWING: Backup mislukt: $($_.Exception.Message)" "Yellow"
}

$projects = Import-Csv $CSVProjects
if (-not $projects) {
    Write-Log "ERROR: Projects.csv bevat geen regels" "Red"
    exit
}

# ==============================
# Script sync
# ==============================
function Sync-NewVMFile {
    param([string[]]$AllHosts)
    foreach ($HVHost in $AllHosts) {
        try {
            Invoke-Command -ComputerName $HVHost -ScriptBlock {
                if (-not (Test-Path "C:\HyperV-Scripts")) {
                    New-Item -Path "C:\HyperV-Scripts" -ItemType Directory | Out-Null
                }
            } -ErrorAction Stop
            
            Copy-Item -Path $LocalScriptPath -Destination "\\$HVHost\C$\HyperV-Scripts\New_VM.ps1" -Force
            Write-Log "New_VM.ps1 gesynchroniseerd naar $HVHost" "Green"
        } catch {
            Write-Log "Sync error naar ${HVHost}: $($_.Exception.Message)" "Red"
        }
    }
}
Sync-NewVMFile -AllHosts $HyperVHosts

# ==============================
# VERBETERDE Host Memory Info
# ==============================
function Get-DetailedHostInfo {
    param([string]$HostName)
    
    try {
        $info = Invoke-Command -ComputerName $HostName -ScriptBlock {
            # OS info
            $os = Get-CimInstance -ClassName Win32_OperatingSystem
            $freePhysical = $os.FreePhysicalMemory * 1KB
            $totalPhysical = $os.TotalVisibleMemorySize * 1KB
            
            # VM info
            $runningVMs = Get-VM | Where-Object State -eq "Running"
            $stoppedVMs = Get-VM | Where-Object State -eq "Off"
            $allocatedMemory = ($runningVMs | Measure-Object -Property MemoryAssigned -Sum).Sum
            if (-not $allocatedMemory) { $allocatedMemory = 0 }
            
            # Hyper-V host info
            $vmHost = Get-VMHost
            
            [PSCustomObject]@{
                HostName = $env:COMPUTERNAME
                FreePhysicalBytes = $freePhysical
                TotalPhysicalBytes = $totalPhysical
                AllocatedToVMs = $allocatedMemory
                RunningVMCount = $runningVMs.Count
                StoppedVMCount = $stoppedVMs.Count
                HyperVCapacity = $vmHost.MemoryCapacity
            }
        } -ErrorAction Stop
        
        return $info
    } catch {
        Write-Log "Kan info van $HostName niet ophalen: $($_.Exception.Message)" "Red"
        return $null
    }
}

# ==============================
# SLIMME HOST SELECTIE (Pre-allocation strategie)
# ==============================
function Select-OptimalHost {
    param(
        [string]$PreferredHost,
        [int64]$RequiredMemoryBytes,
        [bool]$WillAutoStart
    )

    $RequiredGB = [math]::Round($RequiredMemoryBytes / 1GB, 2)
    
    Write-Log "`n   ╔══════════════════════════════════════════════╗" "Cyan"
    Write-Log "   ║  HOST SELECTIE voor ${RequiredGB}GB VM" "Cyan"
    Write-Log "   ║  AutoStart: $WillAutoStart | Buffer: ${MinFreeGB}GB" "Cyan"
    Write-Log "   ╚══════════════════════════════════════════════╝" "Cyan"

    # Verzamel info van alle hosts
    $hostData = @()
    foreach ($hostVM in $HyperVHosts) {
        $info = Get-DetailedHostInfo -HostName $hostVM
        if ($info) {
            $freeGB = [math]::Round($info.FreePhysicalBytes / 1GB, 2)
            $totalGB = [math]::Round($info.TotalPhysicalBytes / 1GB, 2)
            $usedGB = [math]::Round(($info.TotalPhysicalBytes - $info.FreePhysicalBytes) / 1GB, 2)
            
            # Bereken hoeveel er ECHT beschikbaar is
            # Voor AutoStart VMs hebben we meer ruimte nodig
            $effectiveBuffer = if ($WillAutoStart) { $MinFreeGB + 0.5 } else { 0.5 }
            $availableForVM = $freeGB - $effectiveBuffer
            $canHostVM = $availableForVM -ge $RequiredGB
            
            $hostData += [PSCustomObject]@{
                Name = $hostVM
                FreeGB = $freeGB
                TotalGB = $totalGB
                UsedGB = $usedGB
                AvailableForVM = $availableForVM
                CanHost = $canHostVM
                RunningVMs = $info.RunningVMCount
                StoppedVMs = $info.StoppedVMCount
                IsPreferred = ($hostVM -eq $PreferredHost)
            }
        }
    }

    # Toon overzicht
    Write-Log "   Host Status:"
    Write-Log "   " + ("=" * 70)
    foreach ($h in $hostData) {
        $status = if ($h.CanHost) { "[✓ OK]  " } else { "[✗ VOL] " }
        $pref = if ($h.IsPreferred) { " ← PREFERRED" } else { "" }
        $line = "   $status $($h.Name): ${h.FreeGB}GB free / ${h.TotalGB}GB | " +
                "Available: ${h.AvailableForVM}GB | " +
                "VMs: $($h.RunningVMs)R/$($h.StoppedVMs)S" + $pref
        
        if ($h.CanHost) {
            Write-Log $line "Green"
        } else {
            Write-Log $line "Red"
        }
    }
    Write-Log "   " + ("=" * 70)

    # Selectie logica
    $selected = $null

    # 1. Probeer preferred host als die voldoende capaciteit heeft
    if ($PreferredHost) {
        $pref = $hostData | Where-Object { $_.IsPreferred }
        if ($pref) {
            if ($pref.CanHost) {
                $selected = $pref
                Write-Log "   → SELECTIE: $PreferredHost (preferred, heeft capaciteit)" "Green"
            } else {
                Write-Log "   → $PreferredHost (preferred) heeft ONVOLDOENDE capaciteit!" "Yellow"
                Write-Log "     (Needed: ${RequiredGB}GB + ${effectiveBuffer}GB buffer = $($RequiredGB + $effectiveBuffer)GB, Available: $($pref.AvailableForVM)GB)" "Yellow"
            }
        }
    }

    # 2. Als preferred niet werkt, kies beste alternatief
    if (-not $selected) {
        $candidates = $hostData | Where-Object { $_.CanHost } | Sort-Object AvailableForVM -Descending
        
        if ($candidates) {
            $selected = $candidates[0]
            Write-Log "   → SELECTIE: $($selected.Name) (beste alternatief, ${selected.AvailableForVM}GB beschikbaar)" "Cyan"
        }
    }

    # 3. Geen geschikte host gevonden
    if (-not $selected) {
        Write-Log "   → ✗ GEEN GESCHIKTE HOST GEVONDEN!" "Red"
        Write-Log "   → Alle hosts hebben onvoldoende capaciteit voor ${RequiredGB}GB + buffer" "Red"
        Write-Log "   → Suggesties:" "Yellow"
        Write-Log "     • Stop onnodige VMs" "Yellow"
        Write-Log "     • Verlaag VM memory requirements in CSV" "Yellow"
        Write-Log "     • Voeg meer RAM toe aan hosts" "Yellow"
        return $null
    }

    Write-Log "   ╚══════════════════════════════════════════════╝`n" "Cyan"
    return $selected.Name
}

# ==============================
# MAIN DEPLOY LOOP
# ==============================
Write-Log "`n=== DEPLOYMENT START ===" "Cyan"

foreach ($group in ($projects.GroupName | Sort-Object -Unique)) {
    Write-Log "`n╔════════════════════════════════════════╗" "Cyan"
    Write-Log "║  GROEP: $group" "Cyan"
    Write-Log "╚════════════════════════════════════════╝" "Cyan"

    $vms = $projects | Where-Object { $_.GroupName -eq $group }
    $notes = ($vms.Notes | Where-Object { $_ -and $_.Trim() -ne "" }) -join "; "
    $endDate = ($vms.EndDate | Where-Object { $_ -and $_.Trim() -ne "" } | Select-Object -First 1)

    foreach ($entry in $vms) {
        $VMName   = $entry.VMName
        $ISO      = $entry.ISO
        $memBytes = [int64]$entry.MemoryGB * 1GB
        $diskGB   = [int]$entry.DiskGB
        $prefHost = $entry.PreferredHost
        $auto     = $entry.AutoStart
        $vmEndStr = $entry.EndDate
        
        $willAutoStart = ($auto -and $auto.ToUpper() -eq "Y")

        Write-Log "`n┌─ VM: $VMName ────────────────────────" "Yellow"
        Write-Log "│  Specs: $($entry.MemoryGB)GB RAM | ${diskGB}GB Disk | ISO: $ISO"
        Write-Log "│  Preferred: $prefHost | AutoStart: $willAutoStart"

        # ===== CRUCIALE STAP: SELECTEER HOST VOOR AANMAAK EN AUTOSTART =====
        $TargetHost = Select-OptimalHost `
            -PreferredHost $prefHost `
            -RequiredMemoryBytes $memBytes `
            -WillAutoStart $willAutoStart

        if (-not $TargetHost) {
            Write-Log "│  ✗ Geen geschikte host → VM wordt NIET aangemaakt" "Red"
            Write-Log "└────────────────────────────────────────"
            continue
        }

        Write-Log "│  ✓ Geselecteerde host: $TargetHost" "Green"

        # ===== VM AANMAKEN OP GESELECTEERDE HOST =====
        Write-Log "│  → VM aanmaken op $TargetHost..."
        try {
            Invoke-Command -ComputerName $TargetHost -ScriptBlock {
                param($VMName, $ISO, $MemoryBytes, $DiskGB, $RemoteScriptPath)

                # Check of VM al bestaat
                $existing = Get-VM -Name $VMName -ErrorAction SilentlyContinue
                if ($existing) {
                    throw "VM '$VMName' bestaat al op deze host"
                }

                # Laad en voer script uit
                $code = Get-Content $RemoteScriptPath -Raw
                Invoke-Expression $code

                switch ($ISO) {
                    "1" { ws_2019 -VMName $VMName -MemoryBytes $MemoryBytes -DiskGB $DiskGB }
                    "2" { W10     -VMName $VMName -MemoryBytes $MemoryBytes -DiskGB $DiskGB }
                    "3" { lx      -VMName $VMName -MemoryBytes $MemoryBytes -DiskGB $DiskGB }
                    default { throw "Onbekende ISO: $ISO" }
                }
            } -ArgumentList $VMName, $ISO, $memBytes, $diskGB, $RemoteScriptPath -ErrorAction Stop

            Write-Log "│  ✓ VM succesvol aangemaakt op $TargetHost" "Green"
        } catch {
            Write-Log "│  ✗ Aanmaken mislukt: $($_.Exception.Message)" "Red"
            Write-Log "└────────────────────────────────────────"
            continue
        }

        # ===== GROEP TOEVOEGEN =====
        try {
            Invoke-Command -ComputerName $TargetHost -ScriptBlock {
                param($GroupName, $VMName)
                $grp = Get-VMGroup -Name $GroupName -ErrorAction SilentlyContinue
                if (-not $grp) {
                    $grp = New-VMGroup -Name $GroupName -GroupType VMCollectionType
                }
                Add-VMGroupMember -VMGroup $grp -VM (Get-VM -Name $VMName)
            } -ArgumentList $group, $VMName -ErrorAction Stop
            
            Write-Log "│  ✓ Toegevoegd aan groep '$group'" "Cyan"
        } catch {
            Write-Log "│  ⚠ Groepsfout: $($_.Exception.Message)" "Yellow"
        }

        # ===== AUTOSTART (nu zou dit moeten werken!) =====
        if ($willAutoStart) {
            Write-Log "│"
            Write-Log "│  ═══ AUTOSTART ═══"
            Write-Log "│  → VM starten op $TargetHost..."
            
            try {
                Invoke-Command -ComputerName $TargetHost -ScriptBlock {
                    param($Name)
                    Start-VM -Name $Name -ErrorAction Stop
                } -ArgumentList $VMName -ErrorAction Stop

                Write-Log "│  ✓ VM succesvol gestart!" "Green"
                Write-Log "│  🟢 VM '$VMName' is ACTIEF op $TargetHost" "Green"
            } catch {
                Write-Log "│  ✗ Start mislukt: $($_.Exception.Message)" "Red"
                
                if ($_.Exception.Message -match "memory|0x8007000E") {
                    Write-Log "│  ⚠ Onverwacht geheugenprobleem ondanks pre-check!" "Red"
                    Write-Log "│  → Mogelijk zijn er andere VMs gestart tijdens deployment" "Yellow"
                    Write-Log "│  → VM blijft offline - start handmatig later" "Yellow"
                } else {
                    Write-Log "│  → Niet-geheugen gerelateerde fout" "Yellow"
                }
                
                Write-Log "│  🔴 VM '$VMName' blijft OFFLINE op $TargetHost" "Red"
            }
        } else {
            Write-Log "│  ℹ AutoStart uitgeschakeld - VM blijft offline" "Cyan"
        }

        # ===== EINDDATUM TASK =====
        if ($vmEndStr -and $vmEndStr.Trim() -ne "") {
            try {
                $vmEnd = [datetime]::Parse($vmEndStr)
                if ($vmEnd -gt (Get-Date)) {
                    Invoke-Command -ComputerName $TargetHost -ScriptBlock {
                        param($VMName, $EndDate, $GroupName)
                        
                        $desktop = "C:\Users\Public\Desktop"
                        if (-not (Test-Path $desktop)) {
                            New-Item -ItemType Directory -Path $desktop | Out-Null
                        }
                        
                        $msgFile = "$desktop\VM_End_$VMName.txt"
                        $msg = "Einddatum bereikt voor VM $VMName (groep $GroupName) op $EndDate"
                        
                        $action = New-ScheduledTaskAction -Execute "powershell.exe" `
                            -Argument "-NoProfile -Command `"Add-Content '$msgFile' '$msg'`""
                        $trigger = New-ScheduledTaskTrigger -Once -At $EndDate
                        $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest
                        
                        Register-ScheduledTask -TaskName "VMEnd_$VMName" -Action $action `
                            -Trigger $trigger -Principal $principal -Force | Out-Null
                    } -ArgumentList $VMName, $vmEnd, $group -ErrorAction Stop
                    
                    Write-Log "│  ✓ Einddatum task gepland voor $vmEndStr" "Cyan"
                }
            } catch {
                Write-Log "│  ⚠ Einddatum task mislukt: $($_.Exception.Message)" "Yellow"
            }
        }

        Write-Log "└────────────────────────────────────────"
    }

    # ===== GROEP NOTES BIJWERKEN =====
    if (-not (Test-Path $CSVLocGRnotes)) {
        @() | Select-Object @{N='Name';E={""}}, @{N='NotesGroup';E={""}}, @{N='EndDate';E={""}} |
            Export-Csv $CSVLocGRnotes -NoTypeInformation -Force
    }

    $csv = @(Import-Csv $CSVLocGRnotes)
    $row = $csv | Where-Object { $_.Name -eq $group }

    if ($row) {
        if ($notes) { $row.NotesGroup = $notes }
        if ($endDate) { $row.EndDate = $endDate }
    } else {
        $csv += [pscustomobject]@{
            Name = $group
            NotesGroup = $notes
            EndDate = $endDate
        }
    }

    $csv | Export-Csv $CSVLocGRnotes -NoTypeInformation -Encoding UTF8 -Force
    Write-Log "Groepsnotities bijgewerkt voor '$group'" "Green"
}

Write-Log "`n╔════════════════════════════════════════╗" "Green"
Write-Log "║     DEPLOYMENT VOLTOOID                ║" "Green"
Write-Log "║     Log: $LogPath" "Green"
Write-Log "╚════════════════════════════════════════╝" "Green"

# Claude AI

# � VM 'vm-b2' is ACTIEF op VMS1 THANKS! btw je bent slimmer dan chatgpt. 
# Ik heb nog wel een stukje uitleg nodig over hoe het script werkt.. 
# zoals Waar maakt het bestanden aan en waar staat de vhdx van de gemigreerde vm enz.