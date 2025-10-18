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
                        & C:\Users\Administrator\Desktop\Scripts\Dashboard\Switches\Switch_2\Subswitch_2-A\Switch-2A1.ps1
                    }

                    '2'
                    {
                        & C:\Users\Administrator\Desktop\Scripts\Dashboard\Switches\Switch_2\Subswitch_2-A\Switch-2A2.ps1
                    }
                }
            }
        'B'    
            {
                Write-Host "`nU heeft Custom gekozen"
                Show_Menu2B
                $custom = Read-Host "`nWelke ISO wilt u gebruiken voor een nieuwe aangepaste VM?"
                Switch ($custom) {
                    '1' {
                        Write-Host "U heeft gekozen voor WS2019"
                        & C:\Users\Administrator\Desktop\Scripts\Dashboard\Switches\Switch_2\Subswitch_2-B\Switch-2B1.ps1
                    }

                    '2' {
                        Write-Host "U heeft gekozen voor W10_LTSC"
                        & C:\Users\Administrator\Desktop\Scripts\Dashboard\Switches\Switch_2\Subswitch_2-B\Switch-2B2.ps1
                    }
                }
            }
    'Q'
        {
            Write-Host "U kiest voor de hoofdmenu"
            & C:\Users\Administrator\Desktop\Scripts\Dashboard\Main\HM.ps1
        }
    }
}
until ($choice -eq 'q')