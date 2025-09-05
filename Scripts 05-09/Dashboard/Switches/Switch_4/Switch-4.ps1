function Show_Menu4{ # menu project
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor Notes”
    Write-Host "B: Druk op 'B' om start-/einddatum in te stellen"
    Write-Host "C: Druk op 'C' voor groeps-instellingen"
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}

function Show_Menu4A{ # menu notes
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' om Notes toe te voegen aan VM”
    Write-Host "B: Druk op 'B' om Notes toe te voegen aan VMGroup"
    Write-Host "C: Druk op 'C' om Notes te verwijderen van een VM"
    Write-Host "D: Druk op 'D' om Notes te verwijderen van een VMGroup"
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}

function Show_Menu4B{
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' om een nieuwe schedule te maken”
    Write-Host "B: Druk op 'B' om een schedule te starten"
    Write-Host "C: Druk op 'C' om een schedule te stoppen"
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}

function Show_Menu4Ba{
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor een dagelijkse"
    Write-Host "B: Druk op 'B' voor een wekelijkse"
    Write-Host "C: Druk op 'C' voor een eenmalige"
    Write-Host "D: Druk op 'D' voor wanneer een inlogactie plaatsvindt"
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}

function Show_Menu4C{ # hoofdmenu groep
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor een nieuwe groep [New-VMGroup]”
    Write-Host "B: Druk op 'B' voor verwijderen groep [Remove-VMGroup]"
    Write-Host "C: Druk op 'C' voor aanpassen ledenstructuur"
    Write-Host "D: Druk op 'D' voor power-settings groepen"
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}

function Show_Menu4CA{
    Write-Host "=================================================="
    Write-Host "A: Druk op '1' voor Group Type - 'VMCollectionType' []"
    Write-Host "B: Druk op '2' voor Group Type - 'ManagementCollectionType' []”
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}

function Show_Menu4CB{
    Write-Host "=================================================="
    Write-Host "A: Druk op '1' voor Group Type - 'VMCollectionType' []"
    Write-Host "B: Druk op '2' voor Group Type - 'ManagementCollectionType' []”
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
# etc. etc.
}

function Show_Menu4CC{ 
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor leden toevoegen [Add-VMGroupMembers]"
    Write-Host "B: Druk op 'B' voor leden verwijderen [Remove-VMGroupMembers]”
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}

function Show_Menu4CCa{ 
    Write-Host "=================================================="
    Write-Host "1: Druk op '1' voor VM leden [VMMembers]"
    Write-Host "2: Druk op '2' voor VMGroup leden [VMGroupMembers]”
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}

function Show_Menu4CD{    
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor Starten [Start-VM]"
    Write-Host "B: Druk op 'B' voor Stoppen [Stop-VM]"
    Write-Host "C: Druk op 'C' voor Pauzeren [Suspend-VM]"
    Write-Host "D: Druk op 'D' voor Verwijderen [Remove-VM]"
    Write-Host "E: Druk op 'E' voor Hervatten [Resume-VM]"
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}

Write-Host "U heeft optie 4 gekozen"

do{
Show_Menu4
$project = Read-host "Kies optie"
    switch($project){
        'A'
        {
        & Scripts\Dashboard\Switches\Switch_4\Subswitch-4-A\Switch-4A.ps1
        }

        'B' #date and time
        {
        & Scripts\Dashboard\Switches\Switch_4\Subswitch-4-B\Switch-4B.ps1
        }

        'C'
        {
        & Scripts\Dashboard\Switches\Switch_4\Subswitch-4-C\Switch-4C.ps1
        }
                    
    'Q'
        {
            Write-Host "U kiest voor de hoofdmenu"
            & Scripts\Dashboard\Main\HM.ps1
        }

    }
}
until ($project -eq 'q')