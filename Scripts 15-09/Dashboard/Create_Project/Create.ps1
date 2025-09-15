# maak groep aan
$newgroup = Read-Host "Geef naam van nieuwe groep"

        #schrijf weg
        $NewCSVdataA = New-VMGroup -Name $newgroup -GroupType VMCollectionType | ForEach-Object {Write-Host "- $($_.Name)"} | Export-CSV -Path 'C:\Temp\Group.CSV' -NoTypeInformation
            Write-Host "`nGroep $newgroup is aangemaakt!"
            Write-Host "Overzicht geëxporteerd naar $CSVlocGR"

# Pad naar CSV
$CSVlocGRnotes = 'C:\Temp\GroupNotes.csv'

# Controleer of de CSV al bestaat
if (-not (Test-Path $CSVlocGRnotes)) {
    # CSV aanmaken met kolommen
    Get-VMGroup | Select-Object Name, GroupType,
        @{Name='NotesGroup'; Expression={''}},
        @{Name='EndDate'; Expression={''}} |
        Export-Csv -Path $CSVlocGRnotes -NoTypeInformation -Force -Encoding UTF8
}

# Voeg de nieuw aangemaakte groep toe aan de CSV (append)
$newRow = [PSCustomObject]@{
    Name       = $newgroup
    NotesGroup = ""
    EndDate    = ""
}
$newRow | Export-Csv $CSVlocGRnotes -NoTypeInformation -Append -Encoding UTF8


# voeg lid toe
& C:\Users\Administrator\Desktop\Scripts\Dashboard\Create_Project\VirtualM.ps1

# notities
& C:\Users\Administrator\Desktop\Scripts\Dashboard\Create_Project\Notes.ps1

# laat overzicht zien
& C:\Users\Administrator\Desktop\Scripts\Dashboard\Create_Project\Overzicht.ps1