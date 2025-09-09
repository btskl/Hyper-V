Show_Menu4A
    $menuKeuze = Read-Host "Maak Keuze"
        switch ($menuKeuze) {
        'A' {
            & Scripts\Dashboard\Switches\Switch_4\Subswitch-4-A\Switch-4A1.ps1
        }                              

        'B' 
        {
            & Scripts\Dashboard\Switches\Switch_4\Subswitch-4-A\Switch-4A2.ps1
        }
            

        'C'
        {
            & Scripts\Dashboard\Switches\Switch_4\Subswitch-4-A\Switch-4A3.ps1
        }

        'D'
        {   
            & Scripts\Dashboard\Switches\Switch_4\Subswitch-4-A\Switch-4A4.ps1
            }
        }