# Maak of ververs de basislijst van groepen (zonder notities)
Get-VMGroup | Select-Object Name, GroupType |
    Export-Csv -Path 'C:\Temp\GroupNotes.csv' -NoTypeInformation -Force
$notes = Read-Host "Voer uw notitie in"
$csv = Import-Csv $CSVLocGRnotes

# Voeg kolom toe als die niet bestaat
if (-not ($csv | Get-Member -Name "NotesGroup" -MemberType NoteProperty)) {
    foreach ($row in $csv) {
        $row | Add-Member -NotePropertyName 'NotesGroup' -NotePropertyValue '' -Force
    }
}

# Beschikbare groepen tonen
Write-Host "`nBeschikbare groepen:"
$csv | ForEach-Object { Write-Host "- $($_.Name)" }
$chosenGroup = Read-Host "Voer de naam van de groep in"

# Notitie toevoegen
foreach ($row in $csv) {
    if ($row.Name -eq $chosenGroup) {
        $row.NotesGroup = $notes -join "; "
    }
}

# Wegschrijven
$csv | Export-Csv $CSVLocGRnotes -NoTypeInformation -Encoding UTF8
Write-Host "Notitie '$notes' toegevoegd aan groep '$chosenGroup'"

# Direct resultaat tonen
$notes | Format-Table -AutoSize
