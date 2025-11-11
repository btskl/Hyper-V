Show_Menu4C
Write-Host "U heeft Optie C gekozen"
$CSVLocGR = 'C:\Temp\Group.CSV'
$CSVlocGRnotes = 'C:\Temp\GroupNotes.csv'
$settingsGroup = Read-Host "Kies een instelling"
    Switch($settingsGroup) {

        'A'
        {
        & C:\Users\Administrator.TEST\Desktop\Scripts\Dashboard\Switches\Switch_4\Subswitch-4-C\Switch-4C1.ps1
        }
        
        'B'
        {
        & C:\Users\Administrator.TEST\Desktop\Scripts\Dashboard\Switches\Switch_4\Subswitch-4-C\Switch-4C2.ps1
        }

        'C'
        {
        & C:\Users\Administrator.TEST\Desktop\Scripts\Dashboard\Switches\Switch_4\Subswitch-4-C\Switch-4C3.ps1
        }
        
        'D' 
        {
        & C:\Users\Administrator.TEST\Scripts\Dashboard\Switches\Switch_4\Subswitch-4-C\Switch-4C4.ps1
        }
        
        'F'
            {
                Write-Host "U heeft optie F gekozen"
                # power settings voor groepen
            }
    }