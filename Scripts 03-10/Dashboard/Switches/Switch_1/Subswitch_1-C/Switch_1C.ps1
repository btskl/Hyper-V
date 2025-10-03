# # Laad de notities door de CSV te importeren
# $notes = Import-Csv $CSVLocGRnotes

# # Combineer groepen en notities
# $merge = foreach ($group in (Get-VMGroup)) {
#     $note = ($notes | Where-Object { $_.Name -eq $group.Name }).NotesGroup
#     [PSCustomObject]@{
#         Name       = $group.Name
#         VMMembers  = ($group.VMMembers.Name -join ", ")
#         NotesGroup = ($note -join " ")
#     }
# }

#     $merge | Export-Csv -Path $CSVLocGRnotes -NoTypeInformation -Force
#     $merge | Format-Table -AutoSize
#     Write-Host "Overzicht geëxporteerd naar $CSVLocGRnotes"

####################################################################################

# # Laad de notities door de CSV te importeren
# $notes = @()
# if (Test-Path $CSVLocGRnotes) { $notes = Import-Csv $CSVLocGRnotes }

# # Vraag om export
# $vraag = Read-Host "CSV Genereren, Y/N?"

# # Combineer groepen en notities
# $merge = foreach ($group in Get-VMGroup) {
#     $note = ($notes | Where-Object { $_.Name -eq $group.Name }).NotesGroup
#     [PSCustomObject]@{
#         Name       = $group.Name
#         GroupType  = $group.GroupType
#         VMMembers  = ($group.VMMembers.Name -join ", ")
#         NotesGroup = ($note -join "; ")
#     }
# }

# # Toon of exporteer overzicht
# if ($vraag -eq "Y") {
#     $merge | Export-Csv -Path $CSVLocGRnotes -NoTypeInformation -Force
#     $merge | Format-Table -AutoSize
#     Write-Host "Overzicht geëxporteerd naar $CSVLocGRnotes"
# } elseif ($vraag -eq "N") {
#     $merge | Format-Table -AutoSize
# }

# # Interactief submenu voor groepsbeheer
# foreach ($grp in $merge) {
#     Write-Host "`nGroep: $($grp.Name) (Type: $($grp.GroupType))" -ForegroundColor Cyan
#     Write-Host "Notities: $($grp.NotesGroup)"
#     Write-Host "VM's in groep: $($grp.VMMembers)`n"

#     $action = Read-Host "Kies actie voor deze groep: (1=Start VM, 2=Stop VM, 3=VM verwijderen, 4=VM notitie, Enter=volgende groep)"
#     switch ($action) {
#         '1' {
#             $vmToStart = Read-Host "Naam van VM om te starten"
#             try { Start-VM -Name $vmToStart -ErrorAction Stop; Write-Host "✅ VM $vmToStart gestart" }
#             catch { Write-Host "❌ Fout bij starten van ${vmToStart}: $_" }
#         }
#         '2' {
#             $vmToStop = Read-Host "Naam van VM om te stoppen"
#             try { Stop-VM -Name $vmToStop -Force -ErrorAction Stop; Write-Host "✅ VM $vmToStop gestopt" }
#             catch { Write-Host "❌ Fout bij stoppen van ${vmToStop}: $_" }
#         }
#         '3' {
#             $vmToRemove = Read-Host "Naam van VM om te verwijderen"
#             try { Remove-VM -Name $vmToRemove -Force -ErrorAction Stop; Write-Host "✅ VM $vmToRemove verwijderd" }
#             catch { Write-Host "❌ Fout bij verwijderen van ${vmToRemove}: $_" }
#         }
#         '4' {
#             $vmNote = Read-Host "Voer notitie in voor deze VM"
#             $noteEntry = [PSCustomObject]@{ Name=$vmToStart; VMNotes=$vmNote }
#             $notes += $noteEntry
#             $notes | Export-Csv $CSVLocGRnotes -NoTypeInformation -Force
#             Write-Host "✅ Notitie toegevoegd"
#         }
#         default { Write-Host "Volgende groep..." }
#     }
# }
#########################################################################################

# Laad notities en metadata (groep + einddatum) uit CSV
$notes = Import-Csv $CSVLocGRnotes

# Haal VM-groepen op en voeg info samen
$merge = foreach ($group in (Get-VMGroup)) {
    $note     = ($notes | Where-Object { $_.Name -eq $group.Name }).NotesGroup -join "; "
    $endDate  = ($notes | Where-Object { $_.Name -eq $group.Name }).EndDate -join "; "


    [PSCustomObject]@{
        Name       = $group.Name
        NotesGroup = $note
        EndDate    = $endDate
        VMMembers  = $group.VMMembers
    }
}

# Export naar CSV (metadata blijft behouden)
$merge | Select-Object Name, NotesGroup, EndDate |
    Export-Csv -Path $CSVLocGRnotes -NoTypeInformation -Force

# Mooie weergave per groep
foreach ($grp in $merge) {
    Write-Host "=====================================================" -ForegroundColor DarkGray
    Write-Host "Groepnaam : $($grp.Name)" -ForegroundColor Cyan
    Write-Host "Notities  : $($grp.NotesGroup)"
    Write-Host "Einddatum : $($grp.EndDate)`n"

    if ($grp.VMMembers) {
        foreach ($vm in $grp.VMMembers) {
            try {
                $vmInfo = Get-VM -Name $vm.Name -ErrorAction Stop
                $vmInfo | Select-Object Name, State, CPUUsage, MemoryAssigned, Uptime |
                    Format-Table -AutoSize
            }
            catch {
                Write-Host "  VM '$($vm.Name)' niet gevonden." -ForegroundColor Red
            }
        }
    } else {
        Write-Host "Geen VM’s in deze groep." -ForegroundColor DarkGray
    }
}
