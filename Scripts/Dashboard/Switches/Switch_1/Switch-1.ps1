function Show_Menu1{
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor Get-VM"
    Write-Host "B: Druk op 'B' voor Get-VMMemory met OS-versie"
    Write-Host "C: Druk op 'C' voor Get-VMGroup"
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}

do{
    Show_Menu1
    Write-Host "U heeft optie 1 gekozen"
    $overzicht = Read-Host "Kies schema"
    $CSVLocation = 'C:\Temp\GuestInfo.CSV'
    $CSVLocMem = 'C:\Temp\Memory.CSV'
    $CSVLocGRnotes = 'C:\Temp\GroupNotes.CSV'
    switch ($overzicht) {
        'A' {
            Write-Host "U heeft optie A gekozen"
            & Scripts\Dashboard\Switches\Switch_1\Subswitch_1-A\Switch-1A.ps1
        }

        'B'{
            Write-Host "U heeft optie B gekozen"
            & Scripts\Dashboard\Switches\Switch_1\Subswitch_1-B\Switch-1B.ps1
        }

        'C'{
            Write-Host "U heeft optie C gekozen"
            & Scripts\Dashboard\Switches\Switch_1\Subswitch_1-C\Switch_1C.ps1
        }

        'Q'{
            Write-Host "U kiest voor de hoofdmenu"
            & Scripts\Dashboard\Main\HM.ps1
        }
    }
}
until ($overzicht -eq 'q')