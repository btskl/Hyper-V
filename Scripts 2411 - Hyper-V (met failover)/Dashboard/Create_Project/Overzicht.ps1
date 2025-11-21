Write-Host "`n================ VOLLEDIG PROJECTOVERZICHT ================" -ForegroundColor Cyan

# ============================
# CONFIG
# ============================
$CSVProjects   = "C:\Temp\Projects.csv"
$CSVLocGRnotes = "C:\Temp\GroupNotes.csv"
$HyperVHosts   = @("VMS1","VMS2","VMS3")

# ============================
# Import CSV's
# ============================
if (-not (Test-Path $CSVProjects)) {
    Write-Host "❌ Projects.csv niet gevonden" -ForegroundColor Red
    exit
}

$projects = Import-Csv $CSVProjects
if (-not $projects) {
    Write-Host "❌ Projects.csv is leeg" -ForegroundColor Red
    exit
}

# Notes CSV
$groupNotes = @{}
if (Test-Path $CSVLocGRnotes) {
    foreach ($row in (Import-Csv $CSVLocGRnotes)) {
        $groupNotes[$row.Name] = $row
    }
}

# ============================
# Host Memory Info
# ============================
$hostInfo = foreach ($HVHost in $HyperVHosts) {
    try {
        Invoke-Command -ComputerName $HVHost -ScriptBlock {
            $h = Get-VMHost
            [PSCustomObject]@{
                Host    = $h.Name
                TotalGB = [math]::Round($h.MemoryCapacity / 1GB, 1)
                UsedGB  = [math]::Round($h.MemoryUsage / 1GB, 1)
                FreeGB  = [math]::Round(($h.MemoryCapacity - $h.MemoryUsage) / 1GB, 1)
            }
        }
    }
    catch {
        Write-Host "❌ Kan host $HVHost niet bereiken" -ForegroundColor Red
    }
}

Write-Host "`n--- HOST MEMORY OVERZICHT ---`n"
$hostInfo | Format-Table -AutoSize

# ============================
# Alle VM’s ophalen
# ============================
$allVMs = foreach ($HVHost in $HyperVHosts) {
    try {
        Invoke-Command -ComputerName $HVHost -ScriptBlock {
            Get-VM | Select-Object Name, State, CPUUsage, MemoryAssigned, Uptime, 
                @{n="Host";e={$env:COMPUTERNAME}}
        }
    }
    catch {}
}

# ============================
# Per projectgroep overzicht
# ============================
foreach ($group in ($projects.GroupName | Sort-Object -Unique)) {

    Write-Host "`n=====================================================" -ForegroundColor Cyan
    Write-Host "PROJECTGROEP : $group" -ForegroundColor Cyan
    Write-Host "====================================================="

    # Notes + EndDate ophalen
    if ($groupNotes.ContainsKey($group)) {
        $note     = $groupNotes[$group].NotesGroup
        $enddate  = $groupNotes[$group].EndDate
    }
    else {
        $note    = "-"
        $enddate = "-"
    }

    Write-Host "Notitie           : $note"
    Write-Host "Project-einddatum : $enddate"
    Write-Host ""

    # VM’s in deze groep
    $vmRows = @()
    foreach ($vmRow in ($projects | Where-Object { $_.GroupName -eq $group })) {

        $vmInfo = $allVMs | Where-Object { $_.Name -eq $vmRow.VMName }

        if ($vmInfo) {

            $hostStats = $hostInfo | Where-Object { $_.Host -eq $vmInfo.Host }

            $vmRows += [PSCustomObject]@{
                VMNaam           = $vmInfo.Name
                Host             = $vmInfo.Host
                Staat            = $vmInfo.State
                CPUUsage         = "$($vmInfo.CPUUsage)%"
                MemoryAssignedGB = [math]::Round(($vmInfo.MemoryAssigned / 1GB), 1)
                MemoryVrijHostGB = if ($hostStats) { $hostStats.FreeGB } else { "?" }
                Uptime           = $vmInfo.Uptime
                Notes            = $vmRow.Notes
                VMEndDate        = $vmRow.EndDate
            }
        }
        else {
            # VM niet gevonden
            $vmRows += [PSCustomObject]@{
                VMNaam           = $vmRow.VMName
                Host             = "-"
                Staat            = "❌ Niet gevonden"
                CPUUsage         = "-"
                MemoryAssignedGB = "-"
                MemoryVrijHostGB = "-"
                Uptime           = "-"
                Notes            = $vmRow.Notes
                VMEndDate        = $vmRow.EndDate
            }
        }
    }

    $vmRows | Format-Table -AutoSize
}

Write-Host "`n================ EINDE OVERZICHT ================" -ForegroundColor Green
