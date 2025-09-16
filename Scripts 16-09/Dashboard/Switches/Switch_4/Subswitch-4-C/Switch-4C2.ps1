
$getvmtogroupremA = Get-VMGroup | Select-Object Name, VMMembers, NotesGroup                           
$getvmtogroupremA | Format-Table -AutoSize 

$groupRemA = Read-Host "Geef de te verwijderen VMGroup(s) op"
$groupRemArrayA = $groupRemA -split '\s*,\s*'

    ForEach ($grA in $getvmtogroupremA){
        if ($grA.Name -in $groupRemArrayA) {
        Remove-VMGroup -Name $grA.Name -Force # als er leden in de groep zitten kan je het niet zo maar weghalen
        Write-Host "VMGroup(s) '$($grA)' wordt verwijderd."
            }
        }