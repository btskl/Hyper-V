
$CSVlocGRnotes = 'C:\Temp\GroupNotes.csv'

# Vraag notitie
$notes = Read-Host "Voer uw notitie in"

# 1. Maak CSV aan als die er niet is
if (-not (Test-Path $CSVlocGRnotes)) {
    Get-VMGroup | Select-Object Name, GroupType,
        @{Name='NotesGroup'; Expression={''}} |
        Export-Csv -Path $CSVlocGRnotes -NoTypeInformation -Force -Encoding UTF8
    Write-Host "CSV aangemaakt: $CSVlocGRnotes"
}

# 2. Laad CSV
$csv = Import-Csv $CSVlocGRnotes

# 3. Notitie toevoegen
$found = $false
foreach ($row in $csv) {
    if ($row.Name -eq $newgroup) {
        $found = $true
        if ([string]::IsNullOrEmpty($row.NotesGroup)) {
            $row.NotesGroup = $notes
        }
        else {
            $row.NotesGroup = "$($row.NotesGroup); $notes"
        }
    }
}

if ($found) {
    # 4. Wegschrijven
    $csv | Export-Csv $CSVlocGRnotes -NoTypeInformation -Encoding UTF8
    Write-Host "✅ Notitie '$notes' toegevoegd aan groep '$newgroup'"
}
else {
    Write-Host "❌ Groep '$newgroup' niet gevonden in CSV."
}

# 5. Overzicht tonen
Import-Csv $CSVlocGRnotes | Format-Table -AutoSize
