. C:\Users\Administrator\Desktop\Scripts\Dashboard\Main\New_VM.ps1

function Show_Menu2{
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor Quick-Start VM [Pre-Defined]”
    Write-Host "B: Druk op 'B' voor Aangepaste VM"
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}

function Show_Menu2A{
    Write-Host "=================================================="
    Write-Host "1: Druk op '1' voor WS2019”
    Write-Host "2: Druk op '2' voor W10"
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}

function Show_Menu2B{
    Write-Host "=================================================="
    Write-Host "1: Druk op '1' voor WS2019”
    Write-Host "2: Druk op '2' voor W10"
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}

do{
                Write-Host "U heeft optie 2 gekozen"
                Show_Menu2
                # Vraag 1: Welke ISO?
                $choice = Read-Host "Quick-Start of Custom?"
                    Switch($choice) {
                        'A'
                            {
                                Write-Host "U heeft Quick-Start gekozen"
                                Show_Menu2A
                                $quickstart = Read-Host "`nWelke ISO wilt u gebruiken voor een nieuwe Quick Start-VM?"
                                Switch ($quickstart) {
                                    '1'
                                    {
                                    Write-Host "U heeft gekozen voor WS2019"
                                    Show_MenuH
                                    }

                                    '2'
                                    {
                                        Write-Host "U heeft gekozen voor W10"
                                    Show_MenuH
                                    }
                                }
                            Show_MenuH
                            }
                        'B'    
                            {
                                Write-Host "`nU heeft Custom gekozen"
                                Show_Menu2B
                                $custom = Read-Host "`nWelke ISO wilt u gebruiken voor een nieuwe aangepaste VM?"
                                Switch ($custom) {
                                    '1' {
                                        Write-Host "U heeft gekozen voor WS2019"
                                        #er moet nog dingen bijkomen. bv CPU, IP's/Netwerkadapters etc.
                                        #Vraag 2: Naam van de VM?
                                        $VMName = Read-Host "Geef een naam door (bijv. Servernaam@Hostnaam.local)"
                                        if ($VMName -match '^\d+$') { $VMName = [string]$VMName }
                                        Write-Host "Naam van de Virtuele Machine: $VMName"

                                        #Vraag 3: Hoeveel RAM?
                                        $VMMemory = Read-Host "Geef het geheugen in GB (bijv. 8, 16, 32)"
                                        if ($VMMemory -match '^\d+$') { $memoryBytes = [int64]$VMMemory * 1GB }
                                        Write-Host "Geheugen ingesteld op $VMMemory GB ($memoryBytes bytes)"

                                        #Vraag 4: Hoeveel Opslag?
                                        $VHDisk = Read-Host "Geef het opslagcapaciteit in GB (bijv. 8, 16, 32)"
                                        if ($VHDisk -match '^\d+$') { $VHDiskBytes = [int64]$VHDisk * 1GB }
                                        Write-Host "Opslagcapaciteit ingesteld op $VHDisk GB ($VHDiskBytes bytes)"

                                        #Vraag 5: Hoeveel VM's wilt u uitrollen?
                                        $Aantal = Read-Host "Geef een aantal door (bijv. 2)" 
                                        Write-Host "Zoveel VM's worden gemaakt: $Aantal" 
                                        for ($i = 1; $i -le $Aantal; $i++) {                        # zet een {integer+-1} bij elke iteratie (bv. bij 4 iteratie's = test-1 +-2 +-3 +-4)
                                            $VMName = "$VMName-$i"
                                            ws_2019 -VMName $VMName -MemoryGB $VMMemory -DiskGB $VHDisk -VMDvdDrive $diskPath
                                        }
                                        Show_MenuH
                                    }

                                    '2' {
                                        Write-Host "U heeft gekozen voor W10_LTSC"
                                        
                                        #Vraag 2: Naam van de VM?
                                        $VMName = Read-Host "Geef een naam door (bijv. Servernaam@Hostnaam.local)"
                                        if ($VMName -match '^\d+$') { $VMName = [string]$VMName }
                                        Write-Host "Naam van de Virtuele Machine: $VMName"

                                        #Vraag 3: Hoeveel RAM?
                                        $VMMemory = Read-Host "Geef het geheugen in GB (bijv. 8, 16, 32)"
                                        if ($VMMemory -match '^\d+$') { $memoryBytes = [int64]$VMMemory * 1GB }
                                        Write-Host "Geheugen ingesteld op $VMMemory GB ($memoryBytes bytes)"

                                        #Vraag 4: Hoeveel Opslag?
                                        $VHDisk = Read-Host "Geef het opslagcapaciteit in GB (bijv. 8, 16, 32)"
                                        if ($VHDisk -match '^\d+$') { $VHDiskBytes = [int64]$VHDisk * 1GB }
                                        Write-Host "Opslagcapaciteit ingesteld op $VHDisk GB ($VHDiskBytes bytes)"

                                        #Vraag 5: Hoeveel VM's wilt u uitrollen?
                                        $Aantal = Read-Host "Geef een aantal door (bijv. 2)" 
                                        Write-Host "Zoveel VM's worden gemaakt: $Aantal" 
                                        for ($i = 1; $i -le $Aantal; $i++) {                        # zet een {integer+-1} bij elke iteratie (bv. bij 4 iteratie's = test-1 +-2 +-3 +-4)
                                            $VMName = "$VMName-$i"
                                            W10 -VMName $VMName -MemoryGB $VMMemory -DiskGB $VHDisk -VMDvdDrive $diskPath
                                        }
                                        Show_MenuH
                                    }
                                }
                            }
                    'Q'
                        {
                            Write-Host "U kiest voor de hoofdmenu"
                        }
                    }
}
until ($choice -eq 'q')