# # # # Laad de notities door de CSV te importeren
# # # $notes = Import-Csv $CSVLocGRnotes

# # # # Combineer groepen en notities
# # # $merge = foreach ($group in (Get-VMGroup)) {
# # #     $note = ($notes | Where-Object { $_.Name -eq $group.Name }).NotesGroup
# # #     [PSCustomObject]@{
# # #         Name       = $group.Name
# # #         VMMembers  = ($group.VMMembers.Name -join ", ")
# # #         NotesGroup = ($note -join " ")
# # #     }
# # # }

# # #     $merge | Export-Csv -Path $CSVLocGRnotes -NoTypeInformation -Force
# # #     $merge | Format-Table -AutoSize
# # #     Write-Host "Overzicht geëxporteerd naar $CSVLocGRnotes"

# # ####################################################################################

# # # # Laad de notities door de CSV te importeren
# # # $notes = @()
# # # if (Test-Path $CSVLocGRnotes) { $notes = Import-Csv $CSVLocGRnotes }

# # # # Vraag om export
# # # $vraag = Read-Host "CSV Genereren, Y/N?"
# # `
# # # # Combineer groepen en notities
# # # $merge = foreach ($group in Get-VMGroup) {
# # #     $note = ($notes | Where-Object { $_.Name -eq $group.Name }).NotesGroup
# # #     [PSCustomObject]@{
# # #         Name       = $group.Name
# # #         GroupType  = $group.GroupType
# # #         VMMembers  = ($group.VMMembers.Name -join ", ")
# # #         NotesGroup = ($note -join "; ")
# # #     }
# # # }

# # # # Toon of exporteer overzicht
# # # if ($vraag -eq "Y") {
# # #     $merge | Export-Csv -Path $CSVLocGRnotes -NoTypeInformation -Force
# # #     $merge | Format-Table -AutoSize
# # #     Write-Host "Overzicht geëxporteerd naar $CSVLocGRnotes"
# # # } elseif ($vraag -eq "N") {
# # #     $merge | Format-Table -AutoSize
# # # }

# # # # Interactief submenu voor groepsbeheer
# # # foreach ($grp in $merge) {
# # #     Write-Host "`nGroep: $($grp.Name) (Type: $($grp.GroupType))" -ForegroundColor Cyan
# # #     Write-Host "Notities: $($grp.NotesGroup)"
# # #     Write-Host "VM's in groep: $($grp.VMMembers)`n"

# # #     $action = Read-Host "Kies actie voor deze groep: (1=Start VM, 2=Stop VM, 3=VM verwijderen, 4=VM notitie, Enter=volgende groep)"
# # #     switch ($action) {
# # #         '1' {
# # #             $vmToStart = Read-Host "Naam van VM om te starten"
# # #             try { Start-VM -Name $vmToStart -ErrorAction Stop; Write-Host "✅ VM $vmToStart gestart" }
# # #             catch { Write-Host "❌ Fout bij starten van ${vmToStart}: $_" }
# # #         }
# # #         '2' {
# # #             $vmToStop = Read-Host "Naam van VM om te stoppen"
# # #             try { Stop-VM -Name $vmToStop -Force -ErrorAction Stop; Write-Host "✅ VM $vmToStop gestopt" }
# # #             catch { Write-Host "❌ Fout bij stoppen van ${vmToStop}: $_" }
# # #         }
# # #         '3' {
# # #             $vmToRemove = Read-Host "Naam van VM om te verwijderen"
# # #             try { Remove-VM -Name $vmToRemove -Force -ErrorAction Stop; Write-Host "✅ VM $vmToRemove verwijderd" }
# # #             catch { Write-Host "❌ Fout bij verwijderen van ${vmToRemove}: $_" }
# # #         }
# # #         '4' {
# # #             $vmNote = Read-Host "Voer notitie in voor deze VM"
# # #             $noteEntry = [PSCustomObject]@{ Name=$vmToStart; VMNotes=$vmNote }
# # #             $notes += $noteEntry
# # #             $notes | Export-Csv $CSVLocGRnotes -NoTypeInformation -Force
# # #             Write-Host "✅ Notitie toegevoegd"
# # #         }
# # #         default { Write-Host "Volgende groep..." }
# # #     }
# # # }
# # #########################################################################################

# # $CSVProjects = 'C:\Temp\Projects.csv'
# # $projects = Import-Csv $CSVProjects

# # foreach ($group in ($projects.GroupName | Sort-Object -Unique)) {
# #     Write-Host "=====================================================" -ForegroundColor DarkGray
# #     Write-Host "Groepnaam : $group" -ForegroundColor Cyan

# #     # Notities en einddatum ophalen uit projects.csv
# #     $notes   = ($projects | Where-Object { $_.GroupName -eq $group } | Select-Object -ExpandProperty Notes -Unique) -join "; "
# #     $endDate = ($projects | Where-Object { $_.GroupName -eq $group } | Select-Object -ExpandProperty EndDate -Unique)

# #     Write-Host "Notities  : $notes"
# #     Write-Host "Einddatum : $endDate" -ForegroundColor Yellow

# #     # Haal de groep op
# #     $grp = Get-VMGroup -Name $group -ErrorAction SilentlyContinue
# #     if ($grp) {
# #         if ($grp.GroupMembers) {
# #             foreach ($member in $grp.GroupMembers) {
# #                 try {
# #                     # Hier zit de naam van de VM in $member.Name
# #                     $vmInfo = Get-VM -Name $member.Name -ErrorAction Stop
# #                     $vmInfo | Select-Object Name, State, CPUUsage, MemoryAssigned, Uptime |
# #                         Format-Table -AutoSize
# #                 }
# #                 catch {
# #                     Write-Host "❌ VM '$($member.Name)' niet gevonden." -ForegroundColor Red
# #                 }
# #             }
# #         }
# #         else {
# #             Write-Host "⚠️ Geen leden gevonden in groep $group" -ForegroundColor Yellow
# #         }
# #     }
# #     else {
# #         Write-Host "⚠️ Geen VM-groep gevonden voor $group" -ForegroundColor Red
# #     }
# # }

# }
#########################################################################################

$CSVProjects = 'C:\Temp\Projects.csv'
$projects = Import-Csv $CSVProjects

foreach ($group in ($projects.GroupName | Sort-Object -Unique)) {
    Write-Host "`n=====================================================" -ForegroundColor DarkGray
    Write-Host "Groepnaam : $group" -ForegroundColor Cyan

    $groupProjects = $projects | Where-Object { $_.GroupName -eq $group }
    
    $notes   = ($groupProjects | Select-Object -ExpandProperty Notes -Unique) -join "; "
    $endDate = ($groupProjects | Select-Object -ExpandProperty EndDate -Unique)

    Write-Host "Notities  : $notes"
    Write-Host "Einddatum : $endDate" -ForegroundColor Yellow
    Write-Host ""

    $groupVMs = $groupProjects.VMName
    
    if ($groupVMs) {
        $vmList = @()
        foreach ($vm in $groupVMs) {
            try {
                $vmInfo = Get-VM -Name $vm -ErrorAction Stop
                $vmList += $vmInfo | Select-Object Name, State, CPUUsage, MemoryAssigned, Uptime
            }
            catch {
                Write-Host "  VM '$vm' niet gevonden." -ForegroundColor Red
            }
        }
        
        if ($vmList.Count -gt 0) {
            $vmList | Format-Table -AutoSize
        }
    } else {
        Write-Host "  Geen VM's in deze groep." -ForegroundColor DarkGray
    }
}