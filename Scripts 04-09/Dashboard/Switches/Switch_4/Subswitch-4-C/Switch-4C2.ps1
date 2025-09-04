Show_Menu4CB
$grouptypec = Read-Host "Kies de GroupType"

switch ($grouptypec) {
'1' {
    Write-Host "U heeft Group Type - 'VMCollectionType' gekozen"
    
    $getvmtogroupremA = Get-VMGroup | Where-Object { $_.GroupType -eq 'VMCollectionType' } | Select-Object Name, VMMembers, GroupType                              
    $getvmtogroupremA | Format-Table -AutoSize 

    $groupRemA = Read-Host "Geef de te verwijderen VMGroup(s) op"
    $groupRemArrayA = $groupRemA -split '\s*,\s*'

    ForEach ($grA in $getvmtogroupremA){
        if ($grA.Name -in $groupRemArrayA) {
        Remove-VMGroup -Name $grA.Name -Force # als er leden in de groep zitten kan je het niet zo maar weghalen
        Write-Host "VMGroup(s) '$($grA)' wordt verwijderd."
            }
        }
}

'2'
{
    Write-Host "U heeft Group Type - 'ManagementCollectionType' gekozen"

    $getvmtogrouprem2 = Get-VMGroup | Where-Object { $_.GroupType -eq 'ManagementCollectionType' } | Select-Object Name, VMMembers, GroupType                              
    $getvmtogrouprem2 | Format-Table -AutoSize 

    $groupRem2 = Read-Host "Geef de te verwijderen VMGroup(s) op"
    $groupRemArray2 = $groupRem2 -split '\s*,\s*'

    ForEach ($gr2 in $getvmtogrouprem2){
        if ($gr2.Name -in $groupRemArray2) {
            Remove-VMGroup -Name $gr2.Name -Force # als er leden in de groep zitten kan je het niet zo maar weghalen
            Write-Host "VMGroup(s) '$($gr2)' wordt verwijderd."
            }
        }
    }
}