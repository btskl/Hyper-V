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
        $NewCSVdataA | Format-Table Name, GroupType
        Export-CSV -Path $CSVLocGR -NoTypeInformation
            Write-Host "`nGroep $newgroup is aangemaakt!"
        Show_MenuH
    }
 
    '2' 
    {
        Write-Host "U heeft Group Type - 'ManagementCollectionType' gekozen"
        if ($grouptypeb -eq '2') {$NewCSVdataB = New-VMGroup -Name $newgroup -GroupType ManagementCollectionType | ForEach-Object {Write-Host "- $($_.Name)"} | Export-CSV -Path 'C:\Temp\Group.CSV' -NoTypeInformation}
            Write-Host "`nGroep $newgroup is aangemaakt!"
        Show_MenuH
    }
}