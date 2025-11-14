# ==============================
# CONFIG
# ==============================
$CSVProjects   = 'C:\Temp\Projects.csv'
$CSVLocGRnotes = 'C:\Temp\GroupNotes.csv'

# Hyper-V hosts die VM's draaien
$HyperVHosts   = @("VMS1","VMS3")

# Minimale vrije RAM buffer (in GB) op een host
$MinFreeGB     = 1

# Pad van New_VM.ps1 lokaal (op VMS1) en remote (op alle Hyper-V hosts)
$LocalScriptPath  = "C:\Users\Administrator\Desktop\Scripts\Dashboard\Main\New_VM.ps1"
$RemoteScriptPath = "C:\HyperV-Scripts\New_VM.ps1"

Write-Host "`n================ PROJECT UITROL (REMOTE HOSTS + LOAD BALANCING) ================" -ForegroundColor Cyan


# ==============================
# CSV INLEZEN + BACKUP MAKEN
# ==============================
if (-not (Test-Path $CSVProjects)) {
    Write-Host " Projects.csv niet gevonden op $CSVProjects" -ForegroundColor Red
    exit
}

# >>> VEILIGHEID: altijd eerst een backup aanmaken <<<
try {
    $timestamp      = Get-Date -Format "yyyyMMdd_HHmmss"
    $ProjectsBackup = [System.IO.Path]::Combine(
        [System.IO.Path]::GetDirectoryName($CSVProjects),
        "Projects_backup_$timestamp.csv"
    )
    Copy-Item -Path $CSVProjects -Destination $ProjectsBackup -Force
    Write-Host " Backup van Projects.csv gemaakt: $ProjectsBackup" -ForegroundColor DarkCyan
}
catch {
    Write-Host " Kon geen backup maken van Projects.csv: $($_.Exception.Message)" -ForegroundColor Yellow
    # desnoods hier exit als je heel streng wilt zijn
    # exit
}

# BELANGRIJK: vanaf hier wordt Projects.csv ALLEEN gelezen
$projects = Import-Csv $CSVProjects

if (-not $projects) {
    Write-Host " Projects.csv bevat geen regels" -ForegroundColor Red
    exit
}


# ==============================
# SYNC New_VM.ps1 naar alle Hyper-V hosts
# ==============================
function Sync-NewVMFile {
    param([string[]]$AllHosts)

    foreach (${HVHost} in $AllHosts) {
        try {
            # Zorg dat map bestaat op remote host
            Invoke-Command -ComputerName ${HVHost} -ScriptBlock {
                if (-not (Test-Path "C:\HyperV-Scripts")) {
                    New-Item -Path "C:\HyperV-Scripts" -ItemType Directory | Out-Null
                }
            }

            # Kopieer New_VM.ps1
            Copy-Item -Path $LocalScriptPath -Destination "\\${HVHost}\C$\HyperV-Scripts\New_VM.ps1" -Force

            Write-Host " New_VM.ps1 gesynchroniseerd naar ${HVHost}" -ForegroundColor Green
        }
        catch {
            Write-Host " Kon New_VM.ps1 niet kopiëren naar ${HVHost}: $_" -ForegroundColor Red
        }
    }
}

Sync-NewVMFile -AllHosts $HyperVHosts


# ==============================
# REMOTE HOST INFO (Memory)
# ==============================
function Get-RemoteHostInfo {
    param([string[]]$Hosts)

    $result = @()

    foreach (${HVHost} in $Hosts) {
        try {
            $info = Invoke-Command -ComputerName ${HVHost} -ScriptBlock {
                Get-VMHost | Select-Object Name, MemoryCapacity, MemoryUsage
            } -ErrorAction Stop

            $result += $info
        }
        catch {
            Write-Host " Kon host ${HVHost} niet bereiken" -ForegroundColor Red
        }
    }

    return $result
}


# ==============================
# LOAD BALANCER (op basis van RAM)
# ==============================
function Get-BestHost {
    param(
        [string]$PreferredHost,
        [int64]$RequiredMemoryBytes
    )

    $RequiredGB = [math]::Round($RequiredMemoryBytes / 1GB, 1)

    $raw = Get-RemoteHostInfo -Hosts $HyperVHosts

    $hosts = foreach ($h in $raw) {
        $freeBytes = $h.MemoryCapacity - $h.MemoryUsage

        [PSCustomObject]@{
            Name      = $h.Name
            FreeGB    = [math]::Round($freeBytes / 1GB, 1)
            FreeBytes = $freeBytes
        }
    }

    if (-not $hosts) {
        Write-Host " Geen hostinformatie beschikbaar" -ForegroundColor Red
        return $null
    }

    # 1) Preferred host proberen
    if ($PreferredHost) {
        $pref = $hosts | Where-Object { $_.Name -eq $PreferredHost }

        if ($pref) {
            if ($pref.FreeGB -ge ($RequiredGB + $MinFreeGB)) {
                Write-Host "      Preferred host $PreferredHost gekozen (vrij: $($pref.FreeGB)GB)" -ForegroundColor Green
                return $PreferredHost
            }
            else {
                Write-Host "      Preferred host $PreferredHost te weinig RAM (vrij: $($pref.FreeGB)GB / vereist: $RequiredGB GB)" -ForegroundColor Yellow
            }
        }
        else {
            Write-Host "      Preferred host $PreferredHost niet gevonden in HyperVHosts-lijst." -ForegroundColor Yellow
        }
    }

    # 2) Beste andere host zoeken
    $candidates = $hosts | Where-Object { $_.FreeGB -ge ($RequiredGB + $MinFreeGB) }

    if ($candidates.Count -eq 0) {
        Write-Host "      Geen enkele host heeft genoeg RAM voor deze VM." -ForegroundColor Red
        return $null
    }

    $best = $candidates | Sort-Object FreeGB -Descending | Select-Object -First 1
    Write-Host "      Host-switch: preferred = $PreferredHost → gekozen = $($best.Name) (vrij: $($best.FreeGB)GB)" -ForegroundColor Cyan

    return $best.Name
}


# ==============================
# PROJECTEN VERWERKEN
# ==============================
foreach ($group in ($projects.GroupName | Sort-Object -Unique)) {

    Write-Host "`n Verwerken groep: $group" -ForegroundColor Cyan
    $vmsInGroup = $projects | Where-Object { $_.GroupName -eq $group }

    # Notities + einddatum op groepsniveau
    $notes   = ($vmsInGroup.Notes   | Where-Object { $_ -and $_.Trim() -ne "" }) -join "; "
    $endDate = ($vmsInGroup.EndDate | Where-Object { $_ -and $_.Trim() -ne "" } | Select-Object -First 1)

    foreach ($entry in $vmsInGroup) {

        $VMName        = $entry.VMName
        $ISO           = $entry.ISO
        $PreferredHost = $entry.PreferredHost
        $memoryBytes   = [int]$entry.MemoryGB * 1GB
        $diskGB        = [int]$entry.DiskGB
        $autoStart     = $entry.AutoStart
        $vmEndDateStr  = $entry.EndDate

        Write-Host "`n   Start uitrol: $VMName (RAM=$($entry.MemoryGB)GB, preferred=$PreferredHost)" -ForegroundColor Yellow

        # Host selecteren
        ${TargetHost} = Get-BestHost -PreferredHost $PreferredHost -RequiredMemoryBytes $memoryBytes

        if (-not ${TargetHost}) {
            Write-Host "      Geen geschikte host → VM wordt overgeslagen." -ForegroundColor Red
            continue
        }

        Write-Host "      Host gekozen: ${TargetHost}" -ForegroundColor Green

        # --- VM AANMAKEN OP REMOTE HOST VIA New_VM.ps1 ---
        try {
            Invoke-Command -ComputerName ${TargetHost} -ScriptBlock {
                param($VMName, $ISO, $MemoryBytes, $DiskGB, $RemoteScriptPath)

                . $RemoteScriptPath

                try {
                    switch ($ISO) {
                        "1" {
                            ws_2019 -VMName $VMName -MemoryGB $MemoryBytes -DiskGB $DiskGB -VMDvdDrive "C:\ISOs\WS2019.iso"
                        }
                        "2" {
                            W10 -VMName $VMName -MemoryGB $MemoryBytes -DiskGB $DiskGB -VMDvdDrive "C:\ISOs\Windows_10_LTSC.iso"
                        }
                        default {
                            throw "Onbekende ISO-code: $ISO"
                        }
                    }
                }
                catch {
                    if ($_.Exception.Message -like "*Not enough memory*" -or $_.Exception.Message -like "*failed to start*") {
                        Write-Host "      VM '$VMName' aangemaakt maar kon niet starten: $($_.Exception.Message)"
                    }
                    else {
                        throw
                    }
                }

            } -ArgumentList $VMName, $ISO, $memoryBytes, $diskGB, $RemoteScriptPath -ErrorAction Stop

            Write-Host "      VM $VMName aangemaakt op ${TargetHost}" -ForegroundColor Green
        }
        catch {
            Write-Host "      VM-aanmaak fout: $($_.Exception.Message)" -ForegroundColor Red
            continue
        }

        # --- VM AAN PROJECTGROEP TOEVOEGEN ---
        try {
            Invoke-Command -ComputerName ${TargetHost} -ScriptBlock {
                param($GroupName, $VMName)

                $grp = Get-VMGroup -Name $GroupName -ErrorAction SilentlyContinue
                if (-not $grp) {
                    $grp = New-VMGroup -Name $GroupName -GroupType VMCollectionType
                }

                $vm = Get-VM -Name $VMName -ErrorAction Stop
                Add-VMGroupMember -VMGroup $grp -VM $vm -Confirm:$false

            } -ArgumentList $group, $VMName -ErrorAction Stop

            Write-Host "      VM '$VMName' toegevoegd aan groep '$group' op ${TargetHost}" -ForegroundColor Cyan
        }
        catch {
            Write-Host "      Kon VM '$VMName' niet aan groep '$group' toevoegen op ${TargetHost}: $($_.Exception.Message)" -ForegroundColor Red
        }

        # --- VM STARTEN ALS AutoStart = Y ---
        if ($autoStart -and $autoStart.ToUpper() -eq "Y") {
            try {
                Invoke-Command -ComputerName ${TargetHost} -ScriptBlock {
                    param($VMName)
                    Start-VM -Name $VMName -ErrorAction Stop
                } -ArgumentList $VMName

                Write-Host "      VM '$VMName' gestart op ${TargetHost}" -ForegroundColor Green
            }
            catch {
                Write-Host "      VM '$VMName' kon niet worden gestart: $($_.Exception.Message)" -ForegroundColor Yellow
            }
        }

        # --- SCHEDULED TASK VOOR VM-EINDDATUM ---
        if ($vmEndDateStr -and $vmEndDateStr.Trim() -ne "") {
            try {
                # probeer einddatum te parsen (formaat: yyyy-MM-dd HH:mm)
                $vmEndDate = [datetime]::ParseExact($vmEndDateStr, "yyyy-MM-dd HH:mm", $null)

                if ($vmEndDate -lt (Get-Date)) {
                    Write-Host "      Einddatum voor VM '$VMName' ligt al in het verleden ($vmEndDateStr) → geen task aangemaakt." -ForegroundColor Yellow
                }
                else {
                    Invoke-Command -ComputerName ${TargetHost} -ScriptBlock {
                        param($VMName, $EndDate, $GroupName)

                        $desktopPath = [Environment]::GetFolderPath("Desktop")
                        if (-not $desktopPath -or $desktopPath -eq "") {
                            # fallback voor SYSTEM of ontbrekende desktop
                            $desktopPath = "C:\Users\Public\Desktop"
                        }

                        $notifFile  = Join-Path $desktopPath ("VM_End_{0}.txt" -f $VMName)
                        $msg        = "Einddatum bereikt voor VM $VMName (groep $GroupName) op $EndDate"

                        $action = New-ScheduledTaskAction -Execute "powershell.exe" `
                            -Argument "-NoProfile -ExecutionPolicy Bypass -Command `"Add-Content -Path '$notifFile' -Value '$msg'`""

                        $trigger   = New-ScheduledTaskTrigger -Once -At $EndDate
                        $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -RunLevel Highest
                        $taskName  = "VMEnd_$VMName"

                        Register-ScheduledTask -TaskName $taskName -Action $action -Trigger $trigger -Principal $principal -Force | Out-Null

                    } -ArgumentList $VMName, $vmEndDate, $group

                    Write-Host "      Scheduled Task 'VMEnd_$VMName' ingepland voor $vmEndDateStr (notificatie op desktop)" -ForegroundColor DarkCyan
                }
            }
            catch {
                Write-Host "      Kon einddatum-task niet aanmaken voor VM '$VMName': $($_.Exception.Message)" -ForegroundColor Yellow
            }
        }

    } # einde VM-loop


    # ==============================
    # GROEP CSV (notities + einddatum) BIJWERKEN
    # ==============================
    if (-not (Test-Path $CSVLocGRnotes)) {
        @() | Select-Object @{Name='Name';Expression={""}},
                        @{Name='NotesGroup';Expression={""}},
                        @{Name='EndDate';Expression={""}} |
        Export-Csv $CSVLocGRnotes -NoTypeInformation -Force
    }

    $csv = @(Import-Csv $CSVLocGRnotes)
    $row = $csv | Where-Object { $_.Name -eq $group }

    if ($row) {
        if ($notes)   { $row.NotesGroup = $notes }
        if ($endDate) { $row.EndDate    = $endDate }
    }
    else {
        $csv += [pscustomobject]@{
            Name       = $group
            NotesGroup = $notes
            EndDate    = $endDate
        }
    }

    $csv | Export-Csv $CSVLocGRnotes -NoTypeInformation -Force -Encoding UTF8

    Write-Host " Notities/einddatum bijgewerkt voor '$group'" -ForegroundColor Green

} # einde groep-loop

Write-Host "`nUITROL VOLTOOID!" -ForegroundColor Green
