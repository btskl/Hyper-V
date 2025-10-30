$CSVProjects = 'C:\Temp\Projects.csv'

if (-not (Test-Path $CSVProjects)) {
    Write-Host "❌ Projects.csv niet gevonden op $CSVProjects" -ForegroundColor Red
    exit
}

$projects = Import-Csv $CSVProjects

Write-Host "`n================ VM Overzicht ================" -ForegroundColor Cyan

# Haal info over hostgeheugen op (éénmalig)
try {
    $osInfo = Get-CimInstance -ClassName Win32_OperatingSystem
    $totalRAMGB = [math]::Round($osInfo.TotalVisibleMemorySize / 1MB, 1)
    $freeRAMGB  = [math]::Round($osInfo.FreePhysicalMemory / 1MB, 1)
    $usedRAMGB  = [math]::Round($totalRAMGB - $freeRAMGB, 1)
}
catch {
    Write-Host "⚠️ Kon hostgeheugen niet ophalen: $_" -ForegroundColor Yellow
    $totalRAMGB = 0
    $freeRAMGB = 0
    $usedRAMGB = 0
}

Write-Host "Hostgeheugen totaal: $totalRAMGB GB (Gebruikt: $usedRAMGB GB / Vrij: $freeRAMGB GB)" -ForegroundColor Cyan

# Loop door elke groep
foreach ($group in ($projects.GroupName | Sort-Object -Unique)) {
    Write-Host "`n=====================================================" -ForegroundColor DarkGray
    Write-Host "Projectgroep : $group" -ForegroundColor Cyan

    # Haal alle VM's binnen deze groep
    $vmsInGroup = $projects | Where-Object { $_.GroupName -eq $group }

    # Projectnotities en einddatum tonen
    $groupNotes = ($vmsInGroup | Select-Object -ExpandProperty Notes -Unique) -join "; "
    $projectEnd = ($vmsInGroup | Select-Object -ExpandProperty EndDate -Unique | Select-Object -First 1)
    Write-Host "Notitie : $groupNotes"
    Write-Host "Project-einddatum : $projectEnd" -ForegroundColor Yellow
    Write-Host ""

    # Info per VM
    $vmTable = @()
    foreach ($entry in $vmsInGroup) {
        $VMName  = $entry.VMName
        $vmNotes = $entry.Notes
        $vmEnd   = $entry.EndDate

        try {
            $vm = Get-VM -Name $VMName -ErrorAction Stop
            $memUsedGB = [math]::Round($vm.MemoryAssigned / 1GB, 1)
            $memLeftGB = [math]::Round($freeRAMGB - $memUsedGB, 1)

            $vmTable += [PSCustomObject]@{
                VMNaam            = $VMName
                Staat             = $vm.State
                CPUUsage          = "$($vm.CPUUsage)%"
                MemoryGebruiktGB  = $memUsedGB
                MemoryVrijGBHost  = if ($memLeftGB -lt 0) { 0 } else { $memLeftGB }
                Uptime            = $vm.Uptime
                Notities          = $vmNotes
                EindDatumVM       = $vmEnd
            }
        }
        catch {
            $vmTable += [PSCustomObject]@{
                VMNaam            = $VMName
                Staat             = "❌ Niet gevonden"
                CPUUsage          = "-"
                MemoryGebruiktGB  = "-"
                MemoryVrijGBHost  = "-"
                Uptime            = "-"
                Notities          = $vmNotes
                EindDatumVM       = $vmEnd
            }
        }
    }

    # Toon tabel
    if ($vmTable.Count -gt 0) {
        $vmTable | Format-Table -AutoSize
    } else {
        Write-Host "  (Geen VM's gevonden in deze groep)" -ForegroundColor DarkGray
    }
}
