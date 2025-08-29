Write-Host "`nU heeft Custom gekozen"
Show_Menu2B
$custom = Read-Host "`nWelke ISO wilt u gebruiken voor een nieuwe aangepaste VM?"
Switch ($custom) {
    '1'
    {
        Write-Host "U heeft gekozen voor WS2019"
        & Scripts\Dashboard\Switches\Switch_2\Subswitch_2-B\Switch-2B1.ps1
        ws_2019
    }

    '2' 
    {
        Write-Host "U heeft gekozen voor W10"
        & Scripts\Dashboard\Switches\Switch_2\Subswitch_2-B\Switch-2B2.ps1
        W10
    }
}