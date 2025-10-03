$CSVProjects   = 'C:\Temp\Projects.csv'
$CSVLocGRnotes = 'C:\Temp\GroupNotes.csv'

# CSV inlezen
$projects = Import-Csv $CSVProjects

# Loop per unieke groep
foreach ($group in ($projects.GroupName | Sort-Object -Unique)) {
    Write-Host "`n➡️ Verwerken groep: $group" -ForegroundColor Cyan

    # Groep aanmaken als die nog niet bestaat
    $grp = Get-VMGroup -Name $group -ErrorAction SilentlyContinue
    if (-not $grp) {
        $grp = New-VMGroup -Name $group -GroupType VMCollectionType
        Write-Host "✅ Groep '$group' aangemaakt."
    }
    else {
        Write-Host "ℹ️ Groep '$group' bestaat al."
    }

    # Filter VM's die bij deze groep horen
    $vmsInGroup = $projects | Where-Object { $_.GroupName -eq $group }

    foreach ($entry in $vmsInGroup) {
        $VMName      = $entry.VMName
        $ISO         = $entry.ISO
        $memoryBytes = [int]$entry.MemoryGB * 1GB
        $diskGB      = [int]$entry.DiskGB

        Write-Host "  ➡️ Nieuwe VM aanmaken: $VMName ($ISO, $($entry.MemoryGB)GB RAM, $diskGB GB disk)"

        # Roep je bestaande functies aan
        . C:\Users\Administrator\Desktop\Scripts\Dashboard\Main\New_VM.ps1
        switch ($ISO) {
            "1" { ws_2019 -VMName $VMName -MemoryGB $memoryBytes -DiskGB $diskGB -VMDvdDrive "C:\ISOs\WS2019.iso" }
            "2" { W10 -VMName $VMName -MemoryGB $memoryBytes -DiskGB $diskGB -VMDvdDrive "C:\ISOs\Windows_10_LTSC.iso" }
            default { Write-Host "❌ Onbekende ISO: $ISO"; continue }
        }

        # VM ophalen en toevoegen aan groep
        $vm = Get-VM -Name $VMName -ErrorAction SilentlyContinue
        if ($vm) {
            Add-VMGroupMember -VMGroup $grp -VM $vm -ErrorAction SilentlyContinue -Confirm:$false
            Write-Host "  ✅ VM '$VMName' toegevoegd aan groep '$group'."
        }
    }

    # Notities en einddatum uit CSV
    $notes   = ($vmsInGroup.Notes   | Where-Object { $_ -ne "" }) -join "; "
    $endDate = ($vmsInGroup.EndDate | Where-Object { $_ -ne "" } | Select-Object -First 1)

    # Zorg dat CSV-bestand bestaat
    if (-Not (Test-Path $CSVLocGRnotes)) {
        @() | Select-Object @{Name='Name';Expression={""}},
                        @{Name='NotesGroup';Expression={""}},
                        @{Name='EndDate';Expression={""}} |
        Export-Csv $CSVLocGRnotes -NoTypeInformation -Force
    }

    $csv = Import-Csv $CSVLocGRnotes
    $row = $csv | Where-Object { $_.Name -eq $group }

    if ($row) {
        # werk bestaande rij bij
        if ($notes)   { $row.NotesGroup = $notes }
        if ($endDate) { $row.EndDate    = $endDate }
    }
    else {
        $csv = @(Import-Csv $CSVLocGRnotes)
        # voeg nieuwe rij toe
        $csv += [pscustomobject]@{ Name=$group; NotesGroup=$notes; EndDate=$endDate }
    }

    $csv | Export-Csv $CSVLocGRnotes -NoTypeInformation -Force -Encoding UTF8

    if ($notes)   { Write-Host "  📝 Notities toegevoegd aan groep '$group': $notes" }
    if ($endDate) { Write-Host "  ⏰ Einddatum ingesteld: $endDate" }

    # === Scheduled Task maken ===
    if ($endDate) {
        try {
            $endDateParsed = [datetime]::ParseExact($endDate, "yyyy-MM-dd HH:mm", $null)
        }
        catch {
            Write-Host "⚠️ Ongeldige einddatum '$endDate' voor groep '$group', overslaan." -ForegroundColor Yellow
            continue
        }

        $desktopPath = [Environment]::GetFolderPath("Desktop")
        $notifScript = "$desktopPath\${group}_einddatum.txt"

        $action = New-ScheduledTaskAction -Execute "powershell.exe" `
            -Argument "-NoProfile -ExecutionPolicy Bypass -Command `"Add-Content -Path '$notifScript' -Value 'Einddatum bereikt voor projectgroep $group op $endDate'`""

        $trigger = New-ScheduledTaskTrigger -Once -At $endDateParsed

        $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest
        $taskName  = "ProjectEnd_$group"

        try {
            Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $taskName -Principal $principal -Force | Out-Null
            Write-Host "  📅 Taak '$taskName' ingepland voor $endDateParsed"
        }
        catch {
            Write-Host "❌ Kon taak voor einddatum niet inplannen: $_"
        }
    }
}

Write-Host "`n✅ Alle projecten uit CSV uitgerold!" -ForegroundColor Green

# Het maakt wel een taskscheduler aan, dus de melding krijg je. Maar hij geeft geen output in het overzicht voor einddatum, ga daarvoor nog op zoek komende week.
# ssh-key nogsteeds een probleem.