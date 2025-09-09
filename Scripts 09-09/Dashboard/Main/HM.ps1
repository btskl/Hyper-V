function Show_MenuH{
    $title = "ABB VM_beheer"
        
    Write-Host "=========================$title========================="
    Write-Host "1: Druk op '1' om overzichten te tonen [Get-VM]" # Haal een overzicht op en schrijf het weg naar een CSV-bestand.
    Write-Host "2: Druk op '2' om VM's te maken [New-VM]" # Maak een nieuwe Virtuele Machine
    Write-Host "3: Druk op '3' voor VM power-settings [VM-Status]" # Geef status door voor VM, bijv. Starten of stoppen
    Write-Host "4: Druk op '4' voor Project-instellingen" # wijs naam toe van verzoeker/eindgebruiker 
    Write-Host "Q: Press 'Q' to exit" 
}

do{
    Show_MenuH
    $Hoofdmenu = Read-Host "Maak een keuze"
    Switch($Hoofdmenu) {
        
        # Get-VM
        '1' { 
        & Scripts\Dashboard\Switches\Switch_1\Switch-1.ps1
        }

        # Maak VM
        '2' { 
        & Scripts\Dashboard\Switches\Switch_2\Switch-2.ps1
        }
        
        # Power-settings VM
        '3' { 
        & Scripts\Dashboard\Switches\Switch_3\Switch-3.ps1
        }

        # Project-instellingen
        '4' { 
        & Scripts\Dashboard\Switches\Switch_4\Switch-4.ps1
        }

        # EXIT
        'Q' { 
        Write-Host "`nTot ziens!`n"
        }
    }
}
until ($Hoofdmenu -eq 'q')