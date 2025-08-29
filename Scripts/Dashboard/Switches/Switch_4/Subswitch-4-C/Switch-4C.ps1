Show_Menu4C
                        Write-Host "U heeft Optie C gekozen"
                        $CSVLocGR = 'C:\Temp\Group.CSV'
                        $CSVlocGRnotes = 'C:\Temp\GroupNotes.csv'
                        $settingsGroup = Read-Host "Kies een instelling"
                            Switch($settingsGroup) {

                                'A' # probleem, nieuwe maken werkt niet
                                {
                                & Scripts\Dashboard\Switches\Switch_4\Subswitch-4-C\Switch-4C1.ps1
                                }
                                
                                'B'
                                    {
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
                                    }

                                        '2' {
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
                                        Show_MenuH
                                        }
                                    }
                                }
                                        
                                'C'
                                    {
                                        Show_Menu4CC
                                        Write-Host "hernoemen"
                                    }
                                'D' 
                                    {
                                    Show_Menu4CC
                                    $leden = Read-host "Wat wilt u doen?"
                                    
                                    switch ($leden) {
                                        'A' {
                                            Show_Menu4CDa
                                                Write-Host "U heeft optie A gekozen"
                                                $memberA = Read-Host "Druk 1 voor VM of 2 voor VMGroup"
                                                    switch ($members) {
                                                        '1' 
                                                            {
                                                            $naamvmmemberA = Read-Host "Hoe heet de VM?"
                                                            $getvmvoorlidA = Get-VM -Name $naamvmmemberA -ErrorAction Stop
                                                            # $getvmgroupvoorlidA = Get-VMGroup -Name $naamvmgroupmemberA -ErrorAction Stop
                                                            $addmembertogroupA = Add-VMGroupMember -VMGroup $getvmgroupvoorlidA -VM $getvmvoorlidA -Confirm:$false
                                                            Show_MenuH
                                                            }
                                                            
                                                        '2' 
                                                            {
                                                            $naamvmgroupmemberA = Read-Host "Hoe heet de VMGroup?"
                                                            $getvmgroupvoorlidA = Get-VMGroup -Name $naamvmgroupmemberA -ErrorAction Stop
                                                            #als de groep in een groep zit
                                                            if ($naamvmgroupmemberA -eq $getvmgroupvoorlidA.Name) {$naamvmmemberA = Read-Host "Hoe heet de VM?"}
                                                                $getvmvoorlidA = Get-VM -Name $naamvmmemberA -ErrorAction Stop
                                                                $addmembertogroupA = Add-VMGroupMember -VMGroup $getvmgroupvoorlidA -VMGroupMember $getvmvoorlidA -Confirm:$false
                                                            #voeg vm toe aan groep...
                                                            # if ($naamvmgroupmemberA -eq $getvmvoorlidA.Name) {$naamvmgroupmemberA = }
                                                            Show_MenuH
                                                            }
                                                # toevoegen
                                                }
                                                Show_MenuH
                                            }
 
                                        'B' {

                                        Write-Host "U heeft optie B gekozen"
                                        $memberB = Read-Host "Wilt u een VM of VMGroup verwijderen van een groep?"

                                            if ($memberB -eq "VM") {
                                                $naamvmmemberB = Read-Host "Hoe heet de VM?" 
                                                $getvmvoorlidB = Get-VM -Name $naamvmmemberB -ErrorAction Stop
                                                $getvmgroupvoorlidB = Get-VMGroup -Name $naamvmgroupmemberB -ErrorAction Stop
                                                $removemembertogroupB = Remove-VMGroupMember -VMGroup $getvmgroupvoorlidB -VM $getvmvoorlidB -Confirm:$false
                                                }
                                            if ($memberB -eq "VMGroup") {
                                                $naamvmgroupmemberB = Read-Host "Hoe heet de VMGroup?"
                                                # $getvmvoorlidB = Get-VM -Name $naamvmmemberB -ErrorAction Stop
                                                $getvmgroupvoorlidB = Get-VMGroup -Name $naamvmgroupmemberB -ErrorAction Stop
                                                $removemembertogroupB = Remove-VMGroupMember -VMGroup $getvmgroupvoorlidB -VMGroupMember $getvmvoorlidB -Confirm:$false
                                            # verwijderen
                                                }
                                                Show_MenuH
                                            }
                                        }
                                    }
                                
                                'F'
                                    {
                                        Write-Host "U heeft optie F gekozen"
                                        # power settings voor groepen
                                        Snapshots
                                    }
                            }
                        }