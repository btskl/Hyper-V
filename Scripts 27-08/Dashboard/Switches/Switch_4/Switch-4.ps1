function Show_Menu4{ # menu project
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor Notes”
    Write-Host "B: Druk op 'B' om start-/einddatum in te stellen"
    Write-Host "C: Druk op 'C' voor groeps-instellingen"
    Write-Host "D: Druk op 'D' om Snapshot te maken"
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
    Write-Host "A: Druk op 'A' om "
    Write-Host "B: Druk op 'B' om "
    Write-Host "C: Druk op 'C' om "
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}

function Show_Menu4C{ # hoofdmenu groep
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor overzichten [Get-VMGroup]"
    Write-Host "B: Druk op 'B' voor een nieuwe groep [New-VMGroup]”
    Write-Host "C: Druk op 'C' voor verwijderen groep [Remove-VMGroup]"
    Write-Host "D: Druk op 'D' voor hernoemen groep [Rename-VMGroup] "
    Write-Host "E: Druk op 'E' voor aanpassen ledenstructuur"
    Write-Host "F: Druk op 'F' voor power-settings groepen"
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}
	
function Show_Menu4CA{
    Write-Host "=================================================="
    Write-Host "A: Druk op '1' voor een eenvoudige lijst [Get-VMGroup]"
    Write-Host "B: Druk op '2' voor een aparte CSV-bestand [Import-CSV]”
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}

function Show_Menu4CB{
    Write-Host "=================================================="
    Write-Host "A: Druk op '1' voor Group Type - 'VMCollectionType' []"
    Write-Host "B: Druk op '2' voor Group Type - 'ManagementCollectionType' []”
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}

function Show_Menu4CC{
    Write-Host "=================================================="
    Write-Host "A: Druk op '3C1' voor Group Type - 'VMCollectionType' []"
    Write-Host "B: Druk op '3C2' voor Group Type - 'ManagementCollectionType' []”
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
# etc. etc.
}

function Show_Menu4CD{ 
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor leden toevoegen [Add-VMGroupMembers]"
    Write-Host "B: Druk op 'B' voor leden verwijderen [Remove-VMGroupMembers]”
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}

function Show_Menu4CE{ 
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor leden toevoegen [Add-VMGroupMembers]"
    Write-Host "B: Druk op 'B' voor leden verwijderen [Remove-VMGroupMembers]”
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}

function Show_Menu4CEa{ 
    Write-Host "=================================================="
    Write-Host "1: Druk op '1' voor VM leden [VMMembers]"
    Write-Host "2: Druk op '2' voor VMGroup leden [VMGroupMembers]”
    Write-Host "Q: Druk op 'Q' voor de hoofdmenu"
}
do{
            Write-Host "U heeft optie 4 gekozen"
            Show_Menu4
            $project = Read-host "Kies optie"
                switch($project){
                    'A'
                    {
                        Write-Host "U heeft optie A gekozen"
                        Show_Menu4A
                        $menuKeuze = Read-Host "Maak Keuze"
                        $CSVLocGRnotes = 'C:\Temp\GroupNotes.csv'
                        switch ($menuKeuze) {
                                        'A' {
                                            $CSVLocation = 'C:\Temp\GuestInfo.CSV'

                                            if (-Not (Test-Path $CSVLocation)) {
                                                Write-Host "Geen bestaande configuraties gevonden."
                                                break
                                            }

                                            $vmList = Import-Csv $CSVLocation
                                            Write-Host "`nBeschikbare VMs:"
                                            $vmList | ForEach-Object { Write-Host "- $($_.Name)" }

                                            # Kies VM
                                            $chosenVM = Read-Host "`nVoer de naam van de VM in waaraan je een notitie wilt toevoegen"
                                            $foundVM  = $vmList | Where-Object { $_.Name -eq $chosenVM } | Select-Object -First 1 

                                            if ($null -ne $foundVM) {
                                                $noteText = Read-Host "Voer de notitie in voor VM '$($foundVM.Name)'"

                                                # Zet de notitie in Hyper-V
                                                Set-VM -Name $foundVM.Name -Notes $noteText

                                                # Update CSV met nieuwe notitie
                                                foreach ($vm in $vmList) {
                                                    if ($vm.Name -eq $chosenVM) {
                                                        $vm.Notes = $noteText
                                                    }
                                                }

                                                $vmList | Export-Csv -Path $CSVLocation -NoTypeInformation
                                                Write-Host "CSV en Hyper-V notities zijn bijgewerkt."
                                            }
                                            else {
                                                Write-Host "Geen VM gevonden met naam $chosenVM"
                                            }
                                            Show_MenuH
                                        }                              

                                        'B' 
                                        {
                                            # Maak of ververs de basislijst van groepen (zonder notities)
                                            Get-VMGroup | Select-Object Name, GroupType |
                                                Export-Csv -Path 'C:\Temp\GroupNotes.csv' -NoTypeInformation -Force
                                            $notes = Read-Host "Voer uw notitie in"
                                            $CSVLocGRnotes = 'C:\Temp\GroupNotes.csv'
                                            $csv = Import-Csv $CSVLocGRnotes

                                            # Voeg kolom toe als die niet bestaat
                                            if (-not ($csv | Get-Member -Name "NotesGroup" -MemberType NoteProperty)) {
                                                foreach ($row in $csv) {
                                                    $row | Add-Member -NotePropertyName 'NotesGroup' -NotePropertyValue ''
                                                }
                                            }

                                            # Beschikbare groepen tonen
                                            Write-Host "`nBeschikbare groepen:"
                                            $csv | ForEach-Object { Write-Host "- $($_.Name)" }
                                            $chosenGroup = Read-Host "Voer de naam van de groep in"

                                            # Notitie toevoegen
                                            foreach ($row in $csv) {
                                                if ($row.Name -eq $chosenGroup) {
                                                    $row.NotesGroup = $notes -join "; "
                                                }
                                            }

                                            # Wegschrijven
                                            $csv | Export-Csv $CSVLocGRnotes -NoTypeInformation -Encoding UTF8
                                            Write-Host "Notitie '$notes' toegevoegd aan groep '$chosenGroup'"

                                            # Direct resultaat tonen
                                            $notes | Format-Table -AutoSize
                                            Show_MenuH
                                            }
                                            

                                        'C'
                                        {
                                            # Laad CSV
                                            $data = Import-Csv "C:\Temp\GroupNotes.csv"

                                            # Toon huidige inhoud
                                            $data | Format-Table -AutoSize

                                            # Vraag welke groep je wilt aanpassen
                                            $chosen = Read-Host "Geef de naam van de groep waarvan je de notitie wilt verwijderen"

                                            # Zoek de rij en maak de notitie leeg
                                            foreach ($row in $data) {
                                                if ($row.Name -eq $chosen) {
                                                    $row.NotesGroup = ""   # Alleen de notitie wissen
                                                }
                                            }

                                            # Schrijf de aangepaste data terug naar CSV
                                            $data | Export-Csv "C:\Temp\GroupNotes.csv" -NoTypeInformation -Encoding UTF8

                                            Write-Host "Notitie bij groep '$chosen' verwijderd!"
                                            Show_MenuH
                                        }

                                        'D'
                                        {
                                            Write-Host "U heeft optie D gekozen"
                                    
                                            # Laad CSV
                                            $data = Import-Csv "C:\Temp\GroupNotes.csv"

                                            # Toon huidige inhoud
                                            $data | Format-Table -AutoSize

                                            # Vraag welke groep je wilt aanpassen
                                            $chosen = Read-Host "Geef de naam van de groep waarvan je de notitie wilt verwijderen"

                                            # Zoek de rij en maak de notitie leeg
                                            foreach ($row in $data) {
                                                if ($row.Name -eq $chosen) {
                                                    $row.NotesGroup = ""   # Alleen de notitie wissen
                                                }
                                            }

                                            # Schrijf de aangepaste data terug naar CSV
                                            $data | Export-Csv "C:\Temp\GroupNotes.csv" -NoTypeInformation -Encoding UTF8

                                            Write-Host "Notitie bij groep '$chosen' verwijderd!"
                                            Show_MenuH
                                            }
                                        }    
                                    }
                                        #einde $menuKeuze-switchclause

                    #verder met de $project-switchclause
                    'B' #date and time
                    {
                        Write-Host "U heeft optie B gekozen"
                        Show_Menu4B
                        $schedule = Read-Host "Maak een keuze"
                            Switch ($schedule) {
                                'A' # new-Schedule
                                {
                                    Write-Host "U heeft optie 1 gekozen"
                                    Show_Menu4Ba
                                    $new = Read-Host "Maak een keuze voor de schedule-options"
                                    Switch ($new) {
                                        '1' # newtask
                                        {
                                            Write-Host "U heeft optie 1 gekozen"
                                            Show_Menu4Ba
                                        }

                                        '2' # newaction
                                        {
                                            Write-Host "U heeft optie 2 gekozen"
                                            Show_Menu4Ba
                                        }

                                        '3' # newprincipal
                                        {
                                            Write-Host "U heeft optie 3 gekozen"
                                            Show_Menu4Ba
                                        }

                                        '4' # newtasksetting
                                        {
                                            Write-Host "U heeft optie 4 gekozen"
                                            Show_Menu4Ba
                                        }

                                        '5' # newtrigger
                                        {
                                            Write-Host "U heeft optie 5 gekozen"
                                            Show_Menu4Ba
                                        }
                                    }
                                            Switch ($newtrigger) {
                                                    '1' #daily
                                                    {
                                                        # je kan zeggen once,dagelijks,wekelijks,startup,logon
                                                        $time = Read-Host "Enter Time (bv. 10.00AM)"

                                                        # als je zegt weekly moet je ook de dagen doorgeven wanneer    
                                                        $trigger = New-ScheduledTaskTrigger -Daily -At $time
                                                    }


                                                    '2' #weekly
                                                    {

                                                    }   

                                                    '3' #once
                                                    {

                                                    }   

                                                    '4' #logon
                                                    {

                                                    }
                                                }
                                            }
                                

                                'B' #start-schedule
                                {
                                    Write-Host "U heeft optie 2 gekozen"
                                    $startschedule = Read-Host "do smthn"

                                }

                                'C' #stop-schedule
                                {
                                    Write-Host "U heeft optie 3 gekozen"
                                    $stopschedule = Read-Host "do smthn"
                                }
                            }
                        }                  
                        

                    'C'
                    {
                        Show_Menu4C
                        Write-Host "U heeft Optie C gekozen"
                        $CSVLocGR = 'C:\Temp\Group.CSV'
                        $CSVlocGRnotes = 'C:\Temp\GroupNotes.csv'
                        $settingsGroup = Read-Host "Kies een instelling"
                            Switch($settingsGroup) {
                                'A'
                                    {
                                        Show_Menu4CA
                                        $clauseCSV = Read-host "Maak keuze"
                                        Switch($clauseCSV) {
                                            '1' 
                                            {
                                                # Laad de notities
                                                $notes = Import-Csv $CSVLocGRnotes

                                                # Haal VM groepen op en voeg notities toe
                                                $merged = foreach ($group in (Get-VMGroup)) {
                                                    $note = ($notes | Where-Object { $_.Name -eq $group.Name }).NotesGroup
                                                    [PSCustomObject]@{
                                                        Name       = $group.Name
                                                        GroupType  = $group.GroupType
                                                        NotesGroup = $note
                                                    }
                                                }

                                                # Laat het zien
                                                $merged | Format-Table -AutoSize
                                                Show_MenuH
                                            }

                                            '2'
                                            {
                                                    if (Test-Path $CSVLocGRnotes) {
                                                        Write-Host "`nInhoud van $CSVLocGRnotes`n" -ForegroundColor Yellow
                                                        Import-CSV $CSVlocGRnotes | Format-Table -AutoSize
                                                    }
                                                        else {
                                                        Write-Host "Geen notitie-CSV gevonden op $CSVLocGRnotes" -ForegroundColor Red
                                                        }
                                                Get-VMGroup | Select-Object Name, GroupType, NotesGroup |
                                                Export-Csv -Path 'C:\Temp\GroupNotes.csv' -NoTypeInformation -Force
                                                Show_MenuH
                                            }
                                        }

                                        # hoe list je vm's afhankelijk van de groep, welke behoort tot welke. maak een keuzemenu
                
                                                                
                                        # Vraag lijst VM's op m.b.v. CSV
                                        # if (-Not (Test-Path $getgroep)) {Write-Host "Geen bestaande configuraties gevonden."; break}/

                                        # Geef naam van de toe te wijzen VM door
                                        # $foundVMlist = $lijstvm | Where-Object {$_.Name -eq $ChosenGroup} | Select-Object -First 1

                                    }

                                'B' # probleem, nieuwe maken werkt niet
                                {
                                    Write-Host "U heeft optie B gekozen"
                                    Show_Menu4CB
                                    $grouptypeb = Read-Host "Kies GroupType"
                                    $newgroup = Read-Host "Geef naam van nieuwe groep"
                                        switch ($grouptypeb) {
                                        '1' 
                                        {
                                            Write-Host "U heeft Group Type - 'VMCollectionType' gekozen"
                                            $NewCSVdataA = New-VMGroup -Name $newgroup -GroupType VMCollectionType | Select-Object Name, GroupType

                                            #schrijf weg
                                            $NewCSVdataA | Format-Table Name, GroupType
                                            Export-CSV -Path $CSVLocGR -NoTypeInformation
                                                Write-Host "`nGroep $newgroup is aangemaakt!"
                                            Show_MenuH
                                        }
                                        '2' 
                                        {
                                            Write-Host "U heeft Group Type - 'ManagementCollectionType' gekozen"
                                            if ($grouptypeb -eq '2') {$NewCSVdataB = New-VMGroup -Name $newgroup -GroupType ManagementCollectionType | ForEach-Object {Write-Host "- $($_.Name)"} | Export-CSV -Path 'C:\Temp\Group.CSV' -NoTypeInformation}
                                                Write-Host "`nGroep $newgroup is aangemaakt!"
                                            Show_MenuH
                                        }
                                    }
                                                                
                                    Write-Host "Overzicht geëxporteerd naar $CSVlocGR"
                                                                                                        
                                    Show_MenuH    
                                }
                                
                                'C'
                                    {
                                        Show_Menu4CC
                                        $grouptypec = Read-Host "Kies de GroupType"
                                        switch ($grouptypec) {
                                        '1' {
                                            Write-Host "U heeft Group Type - 'VMCollectionType' gekozen"
                                            
                                            $getvmtogroupremA = Get-VMGroup | Where-Object { $_.GroupType -eq 'VMCollectionType' } | Select-Object Name, VMMembers, GroupType                              
                                            $getvmtogroupremA | Format-Table -AutoSize 

                                            $groupRemA = Read-Host "Geef de te verwijderen VMGroup(s) op"
                                            $groupRemArrayA = $groupRemA -split '\s*,\s*'

                                            ForEach ($grA in $getvmtogroupremA){
                                                if ($grA.Name -in $groupRemArrayA) {
                                                Remove-VMGroup -Name $grA.Name -Force # als er leden in de groep zitten kan je het niet zo maar weghalen
                                                Write-Host "VMGroup(s) '$($grA)' wordt verwijderd."
                                                }
                                            }
                                            Show_MenuH
                                        }

                                        '2' {
                                            Write-Host "U heeft Group Type - 'ManagementCollectionType' gekozen"
                                        
                                            $getvmtogrouprem2 = Get-VMGroup | Where-Object { $_.GroupType -eq 'ManagementCollectionType' } | Select-Object Name, VMMembers, GroupType                              
                                            $getvmtogrouprem2 | Format-Table -AutoSize 

                                            $groupRem2 = Read-Host "Geef de te verwijderen VMGroup(s) op"
                                            $groupRemArray2 = $groupRem2 -split '\s*,\s*'

                                            ForEach ($gr2 in $getvmtogrouprem2){
                                                if ($gr2.Name -in $groupRemArray2) {
                                                Remove-VMGroup -Name $gr2.Name -Force # als er leden in de groep zitten kan je het niet zo maar weghalen
                                                Write-Host "VMGroup(s) '$($gr2)' wordt verwijderd."
                                                }
                                            }
                                        Show_MenuH
                                        }
                                    }
                                }
                                        
                                'D'
                                    {

                                    }
                                'E' 
                                    {
                                    Show_Menu4CE
                                    $leden = Read-host "Wat wilt u doen?"
                                    
                                    switch ($leden) {
                                        'A' {
                                            Show_Menu4CEa
                                                Write-Host "U heeft optie A gekozen"
                                                $memberA = Read-Host "Druk 1 voor VM of 2 voor VMGroup"
                                                    switch ($members) {
                                                        '1' 
                                                            {
                                                            $naamvmmemberA = Read-Host "Hoe heet de VM?"
                                                            $getvmvoorlidA = Get-VM -Name $naamvmmemberA -ErrorAction Stop
                                                            # $getvmgroupvoorlidA = Get-VMGroup -Name $naamvmgroupmemberA -ErrorAction Stop
                                                            $addmembertogroupA = Add-VMGroupMember -VMGroup $getvmgroupvoorlidA -VM $getvmvoorlidA -Confirm:$false
                                                            Show_MenuH
                                                            }
                                                            
                                                        '2' 
                                                            {
                                                            $naamvmgroupmemberA = Read-Host "Hoe heet de VMGroup?"
                                                            $getvmgroupvoorlidA = Get-VMGroup -Name $naamvmgroupmemberA -ErrorAction Stop
                                                            #als de groep in een groep zit
                                                            if ($naamvmgroupmemberA -eq $getvmgroupvoorlidA.Name) {$naamvmmemberA = Read-Host "Hoe heet de VM?"}
                                                                $getvmvoorlidA = Get-VM -Name $naamvmmemberA -ErrorAction Stop
                                                                $addmembertogroupA = Add-VMGroupMember -VMGroup $getvmgroupvoorlidA -VMGroupMember $getvmvoorlidA -Confirm:$false
                                                            #voeg vm toe aan groep...
                                                            # if ($naamvmgroupmemberA -eq $getvmvoorlidA.Name) {$naamvmgroupmemberA = }
                                                            Show_MenuH
                                                            }
                                                # toevoegen
                                                }
                                                Show_MenuH
                                            }
 
                                        'B' {

                                        Write-Host "U heeft optie B gekozen"
                                        $memberB = Read-Host "Wilt u een VM of VMGroup verwijderen van een groep?"

                                            if ($memberB -eq "VM") {
                                                $naamvmmemberB = Read-Host "Hoe heet de VM?" 
                                                $getvmvoorlidB = Get-VM -Name $naamvmmemberB -ErrorAction Stop
                                                $getvmgroupvoorlidB = Get-VMGroup -Name $naamvmgroupmemberB -ErrorAction Stop
                                                $removemembertogroupB = Remove-VMGroupMember -VMGroup $getvmgroupvoorlidB -VM $getvmvoorlidB -Confirm:$false
                                                }
                                            if ($memberB -eq "VMGroup") {
                                                $naamvmgroupmemberB = Read-Host "Hoe heet de VMGroup?"
                                                # $getvmvoorlidB = Get-VM -Name $naamvmmemberB -ErrorAction Stop
                                                $getvmgroupvoorlidB = Get-VMGroup -Name $naamvmgroupmemberB -ErrorAction Stop
                                                $removemembertogroupB = Remove-VMGroupMember -VMGroup $getvmgroupvoorlidB -VMGroupMember $getvmvoorlidB -Confirm:$false
                                            # verwijderen
                                                }
                                                Show_MenuH
                                            }
                                        }
                                    }
                                
                                'F'
                                    {
                                        Write-Host "U heeft optie F gekozen"
                                        # power settings voor groepen
                                        Snapshots
                                    }
                            }
                        }
                    }

                    'D' 
                    {
                            #Snapshots maken etc.
                        }
                               
                'Q'
                    {
                        Write-Host "U kiest voor de hoofdmenu"
                    }
}
until ($project -eq 'q')