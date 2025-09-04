 # Laad CSV
$data = Import-Csv "C:\Temp\GroupNotes.csv"

# Toon huidige inhoud
$data | Format-Table -AutoSize

# Vraag welke groep je wilt aanpassen
$chosen = Read-Host "Geef de naam van de groep waarvan je de notitie wilt verwijderen"

# Zoek de rij en maak de notitie leeg
foreach ($row in $data) {
    if ($row.Name -eq $chosen) {
        $row.NotesGroup = ""   # Alleen de notitie wissen
    }d
}

# Schrijf de aangepaste data terug naar CSV
$data | Export-Csv "C:\Temp\GroupNotes.csv" -NoTypeInformation -Encoding UTF8

Write-Host "Notitie bij groep '$chosen' verwijderd!"
