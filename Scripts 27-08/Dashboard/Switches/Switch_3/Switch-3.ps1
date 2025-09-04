function Show_Menu3{    
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor Starten [Start-VM]”
    Write-Host "B: Druk op 'B' voor Stoppen [Stop-VM] (d.m.v. CSV-bestand)"
    Write-Host "C: Druk op 'C' voor Pauzeren [Suspend-VM]"
    Write-Host "D: Druk op 'D' voor Verwijderen [Remove-VM]"
    Write-Host "E: Druk op 'E' voor Hervatten [Resume-VM]"
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}

do{

        Show_Menu3
        Write-Host "U heeft optie 3 gekozen`n"
        $status = Read-Host "`nKies een status"
            Switch($status) {
                'A' 
                {
                    $liststart = Get-VM | Where-Object { $_.State -eq 'Off' } |
                    Select-Object Name, State, Uptime, CreationTime
                    $liststart | Format-Table -AutoSize
                    Write-Host "U heeft optie A gekozen`n"
                    
                    $chosenVMstart = Read-Host "`nVoer de naam van de VMs in die u wilt starten (bijv. VM1,VM2,VM3)"
                    $chosenVMArray = $chosenVMstart -split '\s*,\s*'
                    # start-vm indien beschikbaar, zo niet toon melding dat er geen VM's uitstaan en verlaat
                    foreach ($vm in $liststart) {
                        if ($vm.Name -in $chosenVMArray) {
                            Start-VM -Name $vm.Name
                            Write-Host "VM '$($vm.Name)' gestart."
                            }
                        }
                    Show_MenuH
                }
                    
                'B' 
                {
                    $CSVLocation = 'C:\Temp\GuestInfo.CSV'

                    # Check of CSV bestaat
                    if (-Not (Test-Path $CSVLocation)) {
                        Write-Host "Geen bestaande configuraties gevonden."
                        break}

                    # Lijst met VMs ophalen
                    $vmList = Import-Csv $CSVLocation
                    Write-Host "`nBeschikbare VMs:"
                    $vmList | ForEach-Object { Write-Host "- $($_.Name)" }

                    # Vraag meerdere namen (komma gescheiden)
                    $kiesVM = Read-Host "`nVoer de naam van de VMs in die u wilt stoppen (bijv. VM1,VM2,VM3)"
                    $kiesVMArray = $kiesVM -split '\s*,\s*'   # Splits op komma's, verwijdert spaties

                    # Vind VMs die in CSV staan
                    $vindVMs = $vmList | Where-Object { $_.Name -in $kiesVMArray }

                    if ($vindVMs.Count -gt 0) {
                        Write-Host "`nVM's gevonden in CSV en worden gestopt:" -ForegroundColor Yellow
                        $vindVMs | ForEach-Object {
                            Write-Host "Stopping VM: $($_.Name)"
                            Stop-VM -Name $_.Name -Force
                        }

                        # CSV updaten (verwijder gestopte VMs)
                        $updatedList = $vmList | Where-Object { $_.Name -notin $kiesVMArray }
                        $updatedList | Export-Csv -Path $CSVLocation -NoTypeInformation

                        Write-Host "`nCSV is bijgewerkt. Gestopte VMs: $($vindVMs.Name -join ', ')" -ForegroundColor Green
                    }
                    else {
                        Write-Host "`nGeen van de opgegeven VM-namen zijn gevonden in de CSV." -ForegroundColor Red
                    }
                    Show_MenuH
                }

                'C' 
                {
                    Write-Host = "U heeft optie C gekozen`n"
                    $listpause = Get-VM | Where-Object { $_.State -eq 'Running' } |
                    Select-Object Name, State, Uptime, CreationTime
                    $listpause | Format-Table -AutoSize
                    Write-Host "U heeft optie C gekozen`n"
                    
                    $chosenVMpause = Read-Host "`nVoer de naam van de VMs in die u wilt starten (bijv. VM1,VM2,VM3)"
                    $chosenVMArray = $chosenVMpause -split '\s*,\s*'
                    # start-vm indien beschikbaar, zo niet toon melding dat er geen VM's uitstaan en verlaat
                    foreach ($vm in $listpause) {
                        if ($vm.Name -in $chosenVMArray) {
                            Suspend-VM -Name $vm.Name
                            Write-Host "VM '$($vm.Name)' gepauseerd."
                            }
                        }
                    Show_MenuH
                    }
                
                'D' {
                    $CSVLocation = 'C:\Temp\GuestInfo.CSV'

                    # Check of CSV bestaat
                    if (-Not (Test-Path $CSVLocation)) {
                        Write-Host "Geen bestaande configuraties gevonden."
                        break
                    }

                    # Lijst met VMs ophalen
                    $vmList = Import-Csv $CSVLocation
                    Write-Host "`nBeschikbare VMs:"
                    $vmList | ForEach-Object { Write-Host "- $($_.Name)" }

                    # Vraag meerdere namen (komma gescheiden)
                    $kiesVM = Read-Host "`nVoer de naam/namen in van de VMs die u wilt verwijderen (bijv. VM1,VM2,VM3)"
                    $kiesVMArray = $kiesVM -split '\s*,\s*'

                    # Vind de VMs in CSV
                    $vindVM = $vmList | Where-Object { $_.Name -in $kiesVMArray }

                    if ($vindVM.Count -gt 0) {
                        Write-Host "`nDe volgende VM's worden verwijderd:" -ForegroundColor Yellow
                        $vindVM | ForEach-Object {
                            $vmName = $_.Name
                            Write-Host "Verwijderen van VM: $vmName" -ForegroundColor Red

                            try {
                                # VM stoppen
                                if ((Get-VM -Name $vmName -ErrorAction SilentlyContinue).State -ne 'Off') {
                                    Stop-VM -Name $vmName -Force -ErrorAction SilentlyContinue
                                }

                                # VHD verwijderen
                                $vhdPathloc = "C:\ProgramData\Microsoft\Windows\Hyper-V\Virtual Hard Disks\$vmName.vhdx"
                                if (Test-Path $vhdPathloc) {
                                    Remove-Item -Path $vhdPathloc -Recurse -Force -Confirm:$False
                                    Write-Host "  VHD verwijderd: $vhdPathloc"
                                }

                                # VM verwijderen
                                Remove-VM -Name $vmName -Force -ErrorAction SilentlyContinue
                                Write-Host "  VM verwijderd: $vmName" -ForegroundColor Green
                            }
                            catch {
                                Write-Host ("  Fout bij verwijderen van {0}: {1}" -f $vmName, $_) -ForegroundColor Red
                            }
                        }

                        # CSV updaten
                        $updatedList = $vmList | Where-Object { $_.Name -notin $kiesVMArray }
                        $updatedList | Export-Csv -Path $CSVLocation -NoTypeInformation

                        Write-Host "`nCSV is bijgewerkt. Verwijderde VMs: $($vindVM.Name -join ', ')" -ForegroundColor Green
                    }
                    else {
                        Write-Host "`nGeen van de opgegeven VM-namen zijn gevonden in de CSV." -ForegroundColor Red
                    }

                    Show_MenuH
                }


                'E' 
                {
                    $listresume = Get-VM | Where-Object { $_.State -eq 'Paused' } |
                    Select-Object Name, State, Uptime, CreationTime
                    $listresume | Format-Table -AutoSize
                    Write-Host "U heeft optie E gekozen`n"
                    
                    $chosenVMresume = Read-Host "`nVoer de naam van de VMs in die u wilt starten (bijv. VM1,VM2,VM3)"
                    $chosenVMArray = $chosenVMresume -split '\s*,\s*'
                    # start-vm indien beschikbaar, zo niet toon melding dat er geen VM's uitstaan en verlaat
                    foreach ($vm in $listresume) {
                        if ($vm.Name -in $chosenVMArray) {
                            Resume-VM -Name $vm.Name
                            Write-Host "VM '$($vm.Name)' wordt hervat."}
                            }
                        Show_MenuH
                        }
            'Q'
                {
                    Write-Host "U kiest voor de hoofdmenu"
                }
    }
}
until ($status -eq 'q')