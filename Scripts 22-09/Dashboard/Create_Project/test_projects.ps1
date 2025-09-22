
$CSVProjects = 'C:\Temp\Projects.csv'
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
        $VMName = $entry.VMName
        $ISO = $entry.ISO
        $memoryBytes = [int]$entry.MemoryGB * 1GB
        $diskGB = [int]$entry.DiskGB

        Write-Host "  ➡️ Nieuwe VM aanmaken: $VMName ($ISO, $($entry.MemoryGB)GB RAM, $diskGB GB disk)"

        # Roep je bestaande functies aan, bv. ws_2019 of W10
        . C:\Users\Administrator\Desktop\Scripts\Dashboard\Main\New_VM.ps1
        switch ($ISO) {
            "1"   { ws_2019 -VMName $VMName -MemoryGB $memoryBytes -DiskGB $diskGB -VMDvdDrive "C:\ISOs\WS2019.iso" }
            "2" { W10 -VMName $VMName -MemoryGB $memoryBytes -DiskGB $diskGB -VMDvdDrive "C:\ISOs\Windows_10_LTSC.iso" }
            default    { Write-Host "❌ Onbekende ISO: $ISO"; continue }
        }

        # VM ophalen
        $vm = Get-VM -Name $VMName -ErrorAction SilentlyContinue
        if ($vm) {
            Add-VMGroupMember -VMGroup $grp -VM $vm -ErrorAction SilentlyContinue -Confirm:$false
            Write-Host "  ✅ VM '$VMName' toegevoegd aan groep '$group'."
        }
    }

    # Notities toevoegen aan GroupNotes.csv
    $notes = ($vmsInGroup.Notes | Where-Object { $_ -ne "" }) -join "; "

    if ($notes) {
        if (-Not (Test-Path $CSVLocGRnotes)) {
            # Eerste keer: lege structuur maken
            @() | Select-Object @{Name='Name';Expression={""}},
                            @{Name='NotesGroup';Expression={""}},
                            @{Name='EndDate';Expression={""}} |
            Export-Csv $CSVLocGRnotes -NoTypeInformation -Force
        }

        $csv = Import-Csv $CSVLocGRnotes
        $row = $csv | Where-Object { $_.Name -eq $group }

        if ($row) {
            $row.NotesGroup = $notes
        }
        else {
            $csv += [pscustomobject]@{ Name=$group; NotesGroup=$notes; EndDate="" }
        }

        $csv | Export-Csv $CSVLocGRnotes -NoTypeInformation -Force -Encoding UTF8
        Write-Host "  📝 Notities toegevoegd aan groep '$group': $notes"
    }
}

Write-Host "`n✅ Alle projecten uit CSV uitgerold!" -ForegroundColor Green
