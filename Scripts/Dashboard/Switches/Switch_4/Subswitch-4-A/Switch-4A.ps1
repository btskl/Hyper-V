$project = Read-host "Kies optie"
                switch($project){
                    'A'
                    {
                        Show_Menu4A
                        $menuKeuze = Read-Host "Maak Keuze"
                        $CSVLocGRnotes = 'C:\Temp\GroupNotes.csv'
                        switch ($menuKeuze) {
                                        'A' {
                                            & Scripts\Dashboard\Switches\Switch_4\Subswitch-4-A\Switch-4A1.ps1
                                            # $CSVLocation = 'C:\Temp\GuestInfo.CSV'

                                            # if (-Not (Test-Path $CSVLocation)) {
                                            #     Write-Host "Geen bestaande configuraties gevonden."
                                            #     break
                                            # }

                                            # $vmList = Import-Csv $CSVLocation
                                            # Write-Host "`nBeschikbare VMs:"
                                            # $vmList | ForEach-Object { Write-Host "- $($_.Name)" }

                                            # # Kies VM
                                            # $chosenVM = Read-Host "`nVoer de naam van de VM in waaraan je een notitie wilt toevoegen"
                                            # $foundVM  = $vmList | Where-Object { $_.Name -eq $chosenVM } | Select-Object -First 1 

                                            # if ($null -ne $foundVM) {
                                            #     $noteText = Read-Host "Voer de notitie in voor VM '$($foundVM.Name)'"

                                            #     # Zet de notitie in Hyper-V
                                            #     Set-VM -Name $foundVM.Name -Notes $noteText

                                            #     # Update CSV met nieuwe notitie
                                            #     foreach ($vm in $vmList) {
                                            #         if ($vm.Name -eq $chosenVM) {
                                            #             $vm.Notes = $noteText
                                            #         }
                                            #     }

                                            #     $vmList | Export-Csv -Path $CSVLocation -NoTypeInformation
                                            #     Write-Host "CSV en Hyper-V notities zijn bijgewerkt."
                                            # }
                                            # else {
                                            #     Write-Host "Geen VM gevonden met naam $chosenVM"
                                            # }
                                            # Show_MenuH
                                        }                              

                                        'B' 
                                        {
                                            & Scripts\Dashboard\Switches\Switch_4\Subswitch-4-A\Switch-4A2.ps1
                                            # # Maak of ververs de basislijst van groepen (zonder notities)
                                            # Get-VMGroup | Select-Object Name, GroupType |
                                            #     Export-Csv -Path 'C:\Temp\GroupNotes.csv' -NoTypeInformation -Force
                                            # $notes = Read-Host "Voer uw notitie in"
                                            # $CSVLocGRnotes = 'C:\Temp\GroupNotes.csv'
                                            # $csv = Import-Csv $CSVLocGRnotes

                                            # # Voeg kolom toe als die niet bestaat
                                            # if (-not ($csv | Get-Member -Name "NotesGroup" -MemberType NoteProperty)) {
                                            #     foreach ($row in $csv) {
                                            #         $row | Add-Member -NotePropertyName 'NotesGroup' -NotePropertyValue ''
                                            #     }
                                            # }

                                            # # Beschikbare groepen tonen
                                            # Write-Host "`nBeschikbare groepen:"
                                            # $csv | ForEach-Object { Write-Host "- $($_.Name)" }
                                            # $chosenGroup = Read-Host "Voer de naam van de groep in"

                                            # # Notitie toevoegen
                                            # foreach ($row in $csv) {
                                            #     if ($row.Name -eq $chosenGroup) {
                                            #         $row.NotesGroup = $notes -join "; "
                                            #     }
                                            # }

                                            # # Wegschrijven
                                            # $csv | Export-Csv $CSVLocGRnotes -NoTypeInformation -Encoding UTF8
                                            # Write-Host "Notitie '$notes' toegevoegd aan groep '$chosenGroup'"

                                            # # Direct resultaat tonen
                                            # $notes | Format-Table -AutoSize
                                            # Show_MenuH
                                            }
                                            

                                        'C'
                                        {
                                            & Scripts\Dashboard\Switches\Switch_4\Subswitch-4-A\Switch-4A3.ps1
                                            # # Laad CSV
                                            # $data = Import-Csv "C:\Temp\GroupNotes.csv"

                                            # # Toon huidige inhoud
                                            # $data | Format-Table -AutoSize

                                            # # Vraag welke groep je wilt aanpassen
                                            # $chosen = Read-Host "Geef de naam van de groep waarvan je de notitie wilt verwijderen"

                                            # # Zoek de rij en maak de notitie leeg
                                            # foreach ($row in $data) {
                                            #     if ($row.Name -eq $chosen) {
                                            #         $row.NotesGroup = ""   # Alleen de notitie wissen
                                            #     }
                                            # }

                                            # # Schrijf de aangepaste data terug naar CSV
                                            # $data | Export-Csv "C:\Temp\GroupNotes.csv" -NoTypeInformation -Encoding UTF8

                                            # Write-Host "Notitie bij groep '$chosen' verwijderd!"
                                            # Show_MenuH
                                        }

                                        'D'
                                        {   
                                            & Scripts\Dashboard\Switches\Switch_4\Subswitch-4-A\Switch-4A4.ps1
                                            # Write-Host "U heeft optie D gekozen"
                                    
                                            # # Laad CSV
                                            # $data = Import-Csv "C:\Temp\GroupNotes.csv"

                                            # # Toon huidige inhoud
                                            # $data | Format-Table -AutoSize

                                            # # Vraag welke groep je wilt aanpassen
                                            # $chosen = Read-Host "Geef de naam van de groep waarvan je de notitie wilt verwijderen"

                                            # # Zoek de rij en maak de notitie leeg
                                            # foreach ($row in $data) {
                                            #     if ($row.Name -eq $chosen) {
                                            #         $row.NotesGroup = ""   # Alleen de notitie wissen
                                            #     }
                                            # }

                                            # # Schrijf de aangepaste data terug naar CSV
                                            # $data | Export-Csv "C:\Temp\GroupNotes.csv" -NoTypeInformation -Encoding UTF8

                                            # Write-Host "Notitie bij groep '$chosen' verwijderd!"
                                            # Show_MenuH
                                            }
                                        }    
                                    }
                }
                                        #einde $menuKeuze-switchclause