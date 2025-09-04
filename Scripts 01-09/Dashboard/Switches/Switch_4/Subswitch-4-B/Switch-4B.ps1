Write-Host "U heeft optie 1 gekozen"
Show_Menu4Ba
$new = Read-Host "Maak een keuze voor New"

Switch($new) {
    '1' # newtask
    {
        Write-Host "U heeft optie 1 gekozen"
        & Scripts\Dashboard\Switches\Switch_4\Subswitch-4-B\Switch-4B1.ps1
        Show_Menu4Ba
    }

    '2' # newaction
    {
        Write-Host "U heeft optie 2 gekozen"
        & Scripts\Dashboard\Switches\Switch_4\Subswitch-4-B\Switch-4B1.ps1
        Show_Menu4B
    }

    '3' # newprincipal
    {
        Write-Host "U heeft optie 3 gekozen"
        & Scripts\Dashboard\Switches\Switch_4\Subswitch-4-B\Switch-4B3.ps1
        Show_Menu4B
    }

    '4' # newtasksetting
    {
        Write-Host "U heeft optie 4 gekozen"
        & Scripts\Dashboard\Switches\Switch_4\Subswitch-4-B\Switch-4B4.ps1
        Show_Menu4B
    }

    '5' # newtrigger
    {
        Write-Host "U heeft optie 5 gekozen"
        & Scripts\Dashboard\Switches\Switch_4\Subswitch-4-B\Switch-4B5.ps1
        Show_Menu4B
    }
}