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

if (-not (Test-Path $CSVProjects)) {
    Write-Host "❌ Projects.csv niet gevonden op $CSVProjects" -ForegroundColor Red
    exit
}

$projects = Import-Csv $CSVProjects

Write-Host "`n================ VM Overzicht ================" -ForegroundColor Cyan

# Loop door elke groep
foreach ($group in ($projects.GroupName | Sort-Object -Unique)) {
    Write-Host "`n=====================================================" -ForegroundColor DarkGray
    Write-Host "Projectgroep : $group" -ForegroundColor Cyan

    # Haal alle VM's binnen deze groep
    $vmsInGroup = $projects | Where-Object { $_.GroupName -eq $group }

    # Projectnotities en einddatum tonen
    $groupNotes   = ($vmsInGroup | Select-Object -ExpandProperty Notes -Unique) -join "; "
    $projectEnd   = ($vmsInGroup | Select-Object -ExpandProperty EndDate -Unique | Select-Object -First 1)
    Write-Host "Notitie : $groupNotes"
    Write-Host "Project-einddatum : $projectEnd" -ForegroundColor Yellow
    Write-Host ""

    # Info per VM
    $vmTable = @()
    foreach ($entry in $vmsInGroup) {
        $VMName  = $entry.VMName
        $vmNotes = $entry.Notes
        $vmEnd   = $entry.EndDate

        try {
            $vm = Get-VM -Name $VMName -ErrorAction Stop
            $vmTable += [PSCustomObject]@{
                VMNaam           = $VMName
                Staat            = $vm.State
                CPUUsage         = "$($vm.CPUUsage)%"
                MemoryAssignedGB = [math]::Round($vm.MemoryAssigned / 1GB, 1)
                Uptime           = $vm.Uptime
                Notities         = $vmNotes
                EindDatumVM        = $vmEnd
            }
        }
        catch {
            $vmTable += [PSCustomObject]@{
                VMNaam           = $VMName
                Staat            = "❌ Niet gevonden"
                CPUUsage         = "-"
                MemoryAssignedGB = "-"
                Uptime           = "-"
                Notities         = $vmNotes
                EindDatumVM        = $vmEnd
            }
        }
    }

    # Toon tabel
    if ($vmTable.Count -gt 0) {
        $vmTable | Format-Table -AutoSize
    } else {
        Write-Host "  (Geen VM's gevonden in deze groep)" -ForegroundColor DarkGray
    }
}
