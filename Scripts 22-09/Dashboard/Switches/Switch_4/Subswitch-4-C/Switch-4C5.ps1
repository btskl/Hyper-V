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
    Show_MenuH
    }
}