# maak groep aan
$newgroup = Read-Host "Geef naam van nieuwe groep"

        #schrijf weg
        $NewCSVdataA = New-VMGroup -Name $newgroup -GroupType VMCollectionType | ForEach-Object {Write-Host "- $($_.Name)"} | Export-CSV -Path 'C:\Temp\Group.CSV' -NoTypeInformation
            Write-Host "`nGroep $newgroup is aangemaakt!"
            Write-Host "Overzicht geëxporteerd naar $CSVlocGR"

# voeg lid toe
& C:\Users\Administrator\Desktop\Scripts\Dashboard\Project-X\VirtualM.ps1

# notities
& C:\Users\Administrator\Desktop\Scripts\Dashboard\Project-X\Notes.ps1