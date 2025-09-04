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

Write-Host "U heeft optie 2 gekozen"

do{
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

                        # Verzin een naam
                        $VMName = Read-Host "Geef de naam van de nieuwe VM"
                        if (-not $VMName) { Write-Host "❌ Geen VM-naam ingevoerd. Stop."; break }

                        & Scripts\Dashboard\Main\New_VM.ps1
                        # Quick-Start instellingen
                        $memoryBytes   = 2GB
                        $VHDiskBytes   = 60GB
                        # Geef het aantal door
                        $Aantal = Read-Host "Geef een aantal door (bijv. 2)" 
                        Write-Host "Zoveel VM's worden gemaakt: $Aantal" 
                            for ($i = 1; $i -le $Aantal; $i++) {                        # zet een {integer+-1} bij elke iteratie (bv. bij 4 iteratie's = test-1 +-2 +-3 +-4)
                                $VMName = "$VMName-$i"
                                ws_2019 -VMName $VMName -MemoryGB $memoryBytes -DiskGB $VHDisk -VMDvdDrive $diskPath
                            }

                    }

                    '2'
                    {
                        Write-Host "U heeft gekozen voor W10"
                        $VMName = Read-Host "Geef de naam van de nieuwe VM"
                        if (-not $VMName) { Write-Host "❌ Geen VM-naam ingevoerd. Stop."; break }

                        # Standaard instellingen
                        $memoryBytes   = 2GB
                        $VHDiskBytes   = 60GB
                        $diskPathw10   = "C:\Users\Administrator\Desktop\ISOs\W10_LTSC.iso"
                        $vhdPath       = "C:\ProgramData\Microsoft\Windows\Hyper-V\Virtual Hard Disks\$VMName.vhdx"
                        & Scripts\Dashboard\Main\New_VM.ps1
                        W10
                    }
                }
            }
        'B'    
            {
                Write-Host "`nU heeft Custom gekozen"

                Switch ($custom) {
                    '1' {
                        Write-Host "U heeft gekozen voor WS2019"
                        & Scripts\Dashboard\Switches\Switch_2\Subswitch_2-B\Switch-2B.ps1
                    }

                    '2' {
                        Write-Host "U heeft gekozen voor W10_LTSC"
                        & Scripts\Dashboard\Switches\Switch_2\Subswitch_2-B\Switch-2B.ps1
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