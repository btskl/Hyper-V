$CSVLocGR = 'C:\Temp\Group.CSV'
$CSVlocGRnotes = 'C:\Temp\GroupNotes.csv'

# Controleer of CSV al bestaat
if (-Not (Test-Path $CSVLocGRnotes)) {
    # Maak CSV eenmalig aan (zonder notities)
    Get-VMGroup | Select-Object Name, GroupType |
        Export-Csv -Path $CSVLocGRnotes -NoTypeInformation -Force
    Write-Host "CSV aangemaakt: $CSVLocGRnotes"
}

$notes = Read-Host "Voer uw notitie in"
$csv   = Import-Csv $CSVLocGRnotes

# Voeg kolom toe als die niet bestaat
if (-not ($csv | Get-Member -Name "NotesGroup" -MemberType NoteProperty)) {
    foreach ($row in $csv) {
        $row | Add-Member -NotePropertyName 'NotesGroup' -NotePropertyValue '' -Force
    }
}

$csv | ForEach-Object { Write-Host "- $($_.Name)" }

# Notitie toevoegen (append i.p.v. overschrijven)
foreach ($row in $csv) {
    if ($row.Name -eq $newgroup) {
        if ([string]::IsNullOrEmpty($row.NotesGroup)) {
            $row.NotesGroup = $notes
        }
        else {
            $row.NotesGroup = "$($row.NotesGroup); $notes"
        }
    }
}

# Wegschrijven
$csv | Export-Csv $CSVLocGRnotes -NoTypeInformation -Encoding UTF8
Write-Host "✅ Notitie '$notes' toegevoegd aan groep '$chosenGroup'"

# Direct resultaat tonen
$csv | Format-Table -AutoSize
