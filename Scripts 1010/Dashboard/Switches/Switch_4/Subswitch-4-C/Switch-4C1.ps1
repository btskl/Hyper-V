Write-Host "U heeft optie A gekozen"
Show_Menu4CA
$grouptypeb = Read-Host "Kies GroupType"
$newgroup = Read-Host "Geef naam van nieuwe groep"
    switch ($grouptypeb) {
    '1' 
    {
        Write-Host "U heeft Group Type - 'VMCollectionType' gekozen"
        $NewCSVdataA = New-VMGroup -Name $newgroup -GroupType VMCollectionType | Select-Object Name, GroupType

        #schrijf weg
        if ($grouptypeb -eq '1') {$NewCSVdataA = New-VMGroup -Name $newgroup -GroupType VMCollectionType | ForEach-Object {Write-Host "- $($_.Name)"} | Export-CSV -Path 'C:\Temp\Group.CSV' -NoTypeInformation}
            Write-Host "`nGroep $newgroup is aangemaakt!"
            Write-Host "Overzicht geëxporteerd naar $CSVlocGR"
    }
 
    '2' 
    {
        Write-Host "U heeft Group Type - 'ManagementCollectionType' gekozen"
        if ($grouptypeb -eq '2') {$NewCSVdataB = New-VMGroup -Name $newgroup -GroupType ManagementCollectionType | ForEach-Object {Write-Host "- $($_.Name)"} | Export-CSV -Path 'C:\Temp\Group.CSV' -NoTypeInformation}
            Write-Host "`nGroep $newgroup is aangemaakt!"
            Write-Host "`nOverzicht geëxporteerd naar $CSVlocGR"
        
    }

}