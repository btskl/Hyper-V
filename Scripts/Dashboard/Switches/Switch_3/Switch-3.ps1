function Show_Menu3{    
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor Starten [Start-VM]”
    Write-Host "B: Druk op 'B' voor Stoppen [Stop-VM] (d.m.v. CSV-bestand)"
    Write-Host "C: Druk op 'C' voor Pauzeren [Suspend-VM]"
    Write-Host "D: Druk op 'D' voor Verwijderen [Remove-VM]"
    Write-Host "E: Druk op 'E' voor Hervatten [Resume-VM]"
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}

Write-Host "U heeft optie 3 gekozen"

do{
Show_Menu3
$status = Read-Host "Kies een status"
    Switch($status) {
        'A' 
        {
            & Scripts\Dashboard\Switches\Switch_3\Subswitch-3-A\Switch-3A.ps1
        }
            
        'B' 
        {
            & Scripts\Dashboard\Switches\Switch_3\Subswitch-3-B\Switch-3B.ps1
        }

        'C' 
        {
            & Scripts\Dashboard\Switches\Switch_3\Subswitch-3-C\Switch-3C.ps1
        }
        
        'D' 
        {
            & Scripts\Dashboard\Switches\Switch_3\Subswitch-3-D\Switch-3D.ps1
        }


        'E' 
        {
            & Scripts\Dashboard\Switches\Switch_3\Subswitch-3-E\Switch-3E.ps1
        }
    'Q'
        {
            Write-Host "U kiest voor de hoofdmenu"
        }
    }
}
until ($status -eq 'q')