function Show_MenuH{ # Hoofdmenu
    $title = "ABB VM_beheer"
        
    Write-Host "=========================$title========================="
    Write-Host "1: Druk op '1' om overzichten te tonen [Get-VM]"
    Write-Host "2: Druk op '2' om VM's te maken [New-VM]"
    Write-Host "3: Druk op '3' voor VM power-settings [VM-Status]" # wijs naam toe van verzoeker/eindgebruiker 
    Write-Host "4: Druk op '4' voor Project-instellingen" 
    Write-Host "Q: Press 'Q' to exit"
}

do{
    Show_MenuH
    $Hoofdmenu = Read-Host "Maak een keuze"
    Switch($Hoofdmenu) {
        '1' { # Get-VM
            Write-Host "U heeft optie 1 gekozen"
            & Scripts\Dashboard\Switches\Switch_1\Switch-1.ps1
        }

        '2' { # Maak VM
            Write-Host "U heeft optie 2 gekozen"
            & Scripts\Dashboard\Switches\Switch_2\Switch-2.ps1
        }
        
        '3' { # Power-settings VM
            Write-Host "U heeft optie 3 gekozen"
            & Scripts\Dashboard\Switches\Switch_3\Switch-3.ps1
        }

        '4' { # Project instellingen VM
            Write-Host "U heeft optie 4 gekozen"
            & Scripts\Dashboard\Switches\Switch_4\Switch-4.ps1

        }

        'Q' {
            Write-Host "`nTot ziens!`n"
        }
    }
}
until ($Hoofdmenu -eq 'q')