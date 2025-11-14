# ==========================================
# CONFIG
# ==========================================
$HyperVHosts     = @("VMS1","VMS3")
$CSVLocGRnotes   = "C:\Temp\GroupNotes.csv"
$CSVProjectsPath = "C:\Temp\Projects.csv"

Write-Host "`n================ HYPER-V PROJECT OVERZICHT ================" -ForegroundColor Cyan


# ==========================================
# 1. Projects.csv inlezen voor VM-einddatums
# ==========================================
$ProjectVMEndDates = @{}

if (Test-Path $CSVProjectsPath) {
    (Import-Csv $CSVProjectsPath) | ForEach-Object {
        $ProjectVMEndDates[$_.VMName] = $_.EndDate
    }
}


# ==========================================
# 2. Groepen ophalen van ALLE Hyper-V hosts
# ==========================================
$AllGroups = @()

foreach ($HVHost in $HyperVHosts) {
    try {
        $groups = Invoke-Command -ComputerName $HVHost -ScriptBlock {
            Get-VMGroup | Select-Object Name, GroupType
        }

        foreach ($g in $groups) {
            $AllGroups += [PSCustomObject]@{
                Host      = $HVHost
                Name      = $g.Name
                GroupType = $g.GroupType
            }
        }
    }
    catch {
        Write-Host "❌ Kan geen groepen ophalen op host $HVHost" -ForegroundColor Red
    }
}

if ($AllGroups.Count -eq 0) {
    Write-Host "⚠ Geen projectgroepen gevonden op de Hyper-V hosts." -ForegroundColor Yellow
    Write-Host "`n================ EINDE OVERZICHT ================"
    exit
}


# ==========================================
# 3. GroupNotes.csv inlezen
# ==========================================
$GroupNotes = @{}
if (Test-Path $CSVLocGRnotes) {
    (Import-Csv $CSVLocGRnotes) | ForEach-Object {
        $GroupNotes[$_.Name] = $_
    }
}


# ==========================================
# 4. Per projectgroep overzicht printen
# ==========================================
foreach ($grp in $AllGroups) {

    Write-Host "`n=====================================================" -ForegroundColor Gray
    Write-Host "Projectgroep : $($grp.Name)" -ForegroundColor Cyan
    Write-Host "Host         : $($grp.Host)" -ForegroundColor Cyan
    Write-Host ""

    # NOTES / END DATE FROM GroupNotes.csv
    $notes    = $GroupNotes[$grp.Name].NotesGroup
    $endGroup = $GroupNotes[$grp.Name].EndDate

    Write-Host "Notitie : $notes"
    Write-Host "Project-einddatum : $endGroup"
    Write-Host ""

    # VM's ophalen via VMMembers
    try {
        $vmMembers = Invoke-Command -ComputerName $grp.Host -ScriptBlock {
            param($GroupName)
            (Get-VMGroup -Name $GroupName).VMMembers | Select-Object VMName
        } -ArgumentList $grp.Name
    }
    catch {
        Write-Host "❌ Kan VM's niet ophalen voor groep $($grp.Name)" -ForegroundColor Red
        continue
    }

    if (-not $vmMembers) {
        Write-Host "Geen VM's gevonden in deze projectgroep."
        continue
    }

    # Tabel kop
    "{0,-12} {1,-12} {2,-10} {3,-12} {4,-15} {5,-28}" -f `
        "VMNaam","Staat","CPU%","MemoryGB","Uptime","Einddatum VM"
    Write-Host ("-" * 100)

    foreach ($vm in $vmMembers) {

        try {
            $info = Invoke-Command -ComputerName $grp.Host -ScriptBlock {
                param($VMName)
                Get-VM -Name $VMName | Select-Object Name, State, CPUUsage, MemoryAssigned, Uptime
            } -ArgumentList $vm.VMName

            $memGB = [Math]::Round($info.MemoryAssigned / 1GB, 2)

            # Einddatum ophalen uit Projects.csv
            $vmEndDateRaw = $ProjectVMEndDates[$vm.VMName]
            $vmEndDisplay = ""

            if ($vmEndDateRaw -and $vmEndDateRaw.Trim() -ne "") {
                try {
                    $vmEnd = [datetime]::Parse($vmEndDateRaw)
                    $now   = Get-Date

                    if ($vmEnd -lt $now) {
                        $vmEndDisplay = "$vmEndDateRaw (VERSTREKEN)"
                    }
                    else {
                        $daysLeft = [math]::Round(($vmEnd - $now).TotalDays, 1)
                        $vmEndDisplay = "$vmEndDateRaw (nog $daysLeft dagen)"
                    }
                }
                catch {
                    $vmEndDisplay = $vmEndDateRaw
                }
            }

            "{0,-12} {1,-12} {2,-10} {3,-12} {4,-15} {5,-28}" -f `
                $info.Name,
                $info.State,
                $info.CPUUsage,
                $memGB,
                $info.Uptime,
                $vmEndDisplay
        }
        catch {
            Write-Host "❌ Kan info niet ophalen voor VM '$($vm.VMName)'" -ForegroundColor Red
        }
    }

}

Write-Host "`n================ EINDE OVERZICHT ================" -ForegroundColor Green
