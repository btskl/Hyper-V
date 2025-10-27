# Wegschrijfbaar in CSV-bestanden, CSV-bestandsnaam wordt gegenereerd op statische naam op basis van de naam van de CMDlet
function Show_Menu1{
    Write-Host "==================================================" 
    Write-Host "A: Druk op 'A' voor overzicht met alle VM's" # Haal overzicht op voor alle VM's
    Write-Host "B: Druk op 'B' voor overzicht Get-VMMemory met OS-versie" # Haal overzicht op voor alle VM's, incl. Host waarop het script draait
    Write-Host "C: Druk op 'C' voor Get-VMGroup" # Haal groepen op in het overzicht
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}

Write-Host "U heeft optie 1 gekozen"

do{
    Show_Menu1
    $overzicht = Read-Host "Kies Overzicht"
    $CSVLocation = 'C:\Temp\GuestInfo.CSV'
    $CSVLocMem = 'C:\Temp\Memory.CSV'
    $CSVLocGRnotes = 'C:\Temp\GroupNotes.CSV'
    switch ($overzicht) {
        'A' {
            Write-Host "U heeft optie A gekozen"
            & C:\Users\Administrator\Desktop\Scripts\Dashboard\Switches\Switch_1\Subswitch_1-A\Switch-1A.ps1
        }

        'B'{
            Write-Host "U heeft optie B gekozen"
            & C:\Users\Administrator\Desktop\Scripts\Dashboard\Switches\Switch_1\Subswitch_1-B\Switch-1B.ps1
        }

        'C'{
            Write-Host "U heeft optie C gekozen"
            & C:\Users\Administrator\Desktop\Scripts\Dashboard\Switches\Switch_1\Subswitch_1-C\Switch_1C.ps1
        }

        'Q'{
            Write-Host "U kiest voor de hoofdmenu"
            & C:\Users\Administrator\Desktop\Scripts\Dashboard\Main\HM.ps1
        }
    }
}
until ($overzicht -eq 'q')