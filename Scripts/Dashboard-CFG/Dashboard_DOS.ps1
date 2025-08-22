. C:\Users\Administrator\Desktop\Scripts\Dashboard-CFG\Hyper-V_enk.ps1
# # Enable-VMResourceMetering -VMName $VMName
# # Measure-VM -Name $VMName

function Show_MenuH{ # Hoofdmenu
    $title = "ABB VM_beheer"
        
    Write-Host "=========================$title========================="
    Write-Host "1: Druk op '1' om overzichten te tonen [Get-VM]"
    Write-Host "2: Druk op '2' om VM's te maken [New-VM]"
    Write-Host "3: Druk op '3' voor VM power-settings [VM-Status]" # wijs naam toe van verzoeker/eindgebruiker 
    Write-Host "4: Druk op '4' voor Project-instellingen" 
    Write-Host "Q: Press 'Q' to exit"
}
function Show_Menu1{
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor Get-VM"
    Write-Host "B: Druk op 'B' voor Get-VMMemory"
    Write-Host "C: Druk op 'C' voor Get-VMGroup"
    Write-Host "Q: Press 'Q' to exit"
}

function Show_Menu2{
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor Quick-Start VM [Pre-Defined]”
    Write-Host "B: Druk op 'B' voor Aangepaste VM"
    Write-Host "Q: Press 'Q' to exit"
}

function Show_Menu2B{
    Write-Host "=================================================="
    Write-Host "1: Druk op '1' voor WS2019”
    Write-Host "2: Druk op '2' voor W10"
    Write-Host "Q: Press 'Q' to exit"
}

function Show_Menu3{    
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor Starten [Start-VM]”
    Write-Host "B: Druk op 'B' voor Stoppen [Stop-VM] (d.m.v. CSV-bestand)"
    Write-Host "C: Druk op 'C' voor Pauzeren [Suspend-VM]"
    Write-Host "D: Druk op 'D' voor Verwijderen [Remove-VM]"
    Write-Host "E: Druk op 'E' voor Hervatten [Resume-VM]"
    Write-Host "Q: Press 'Q' to exit"
}

function Show_Menu4{ # menu project
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor Notes”
    Write-Host "B: Druk op 'B' om start-/einddatum in te stellen"
    Write-Host "C: Druk op 'C' voor groeps-instellingen"
    Write-Host "D: Druk op 'D' om Snapshot te maken"
    Write-Host "Q: Press 'Q' to exit"
}

function Show_Menu4A{ # menu notes
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' om Notes toe te voegen aan VM”
    Write-Host "B: Druk op 'B' om Notes toe te voegen aan VMGroup"
    Write-Host "C: Druk op 'C' om Notes te verwijderen van een VM"
    Write-Host "D: Druk op 'D' om Notes te verwijderen van een VMGroup"
    Write-Host "Q: Press 'Q' to exit"
}

function Show_Menu4C{ # hoofdmenu groep
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor overzichten [Get-VMGroup]"
    Write-Host "B: Druk op 'B' voor een nieuwe groep [New-VMGroup]”
    Write-Host "C: Druk op 'C' voor verwijderen groep [Remove-VMGroup]"
    Write-Host "D: Druk op 'D' voor hernoemen groep [Rename-VMGroup] "
    Write-Host "E: Druk op 'E' voor aanpassen ledenstructuur"
    Write-Host "F: Druk op 'F' voor power-settings groepen"
    Write-Host "Q: Press 'Q' to exit"
}
	
function Show_Menu4CA{
    Write-Host "=================================================="
    Write-Host "A: Druk op '1' voor een eenvoudige lijst [Get-VMGroup]"
    Write-Host "B: Druk op '2' voor een aparte CSV-bestand [Import-CSV]”
    Write-Host "Q: Press 'Q' to exit"
}

function Show_Menu4CB{
    Write-Host "=================================================="
    Write-Host "A: Druk op '1' voor Group Type - 'VMCollectionType' []"
    Write-Host "B: Druk op '2' voor Group Type - 'ManagementCollectionType' []”
    Write-Host "Q: Press 'Q' to exit"
}

function Show_Menu4CC{
    Write-Host "=================================================="
    Write-Host "A: Druk op '3C1' voor Group Type - 'VMCollectionType' []"
    Write-Host "B: Druk op '3C2' voor Group Type - 'ManagementCollectionType' []”
    Write-Host "Q: Press 'Q' to exit"
# etc. etc.
}

function Show_Menu4CD{ 
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor leden toevoegen [Add-VMGroupMembers]"
    Write-Host "B: Druk op 'B' voor leden verwijderen [Remove-VMGroupMembers]”
    Write-Host "Q: Press 'Q' to exit"
}

function Show_Menu4CE{ 
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor leden toevoegen [Add-VMGroupMembers]"
    Write-Host "B: Druk op 'B' voor leden verwijderen [Remove-VMGroupMembers]”
    Write-Host "Q: Press 'Q' to exit"
}

function Show_Menu4CEa{ 
    Write-Host "=================================================="
    Write-Host "1: Druk op '1' voor VM leden [VMMembers]"
    Write-Host "2: Druk op '2' voor VMGroup leden [VMGroupMembers]”
    Write-Host "Q: Press 'Q' to exit"
}



# Roep Hoofdmenu Aan
Show_MenuH
do {  
        $input = Read-Host "Maak een keuze"
        switch ($input) { 
            '1' 
            {   
                Show_Menu1
                Write-Host "U heeft optie 1 gekozen"
                $overzicht = Read-Host "Kies schema"
                $CSVLocation = 'C:\Temp\GuestInfo.CSV'
                $CSVLocMem = 'C:\Temp\Memory.CSV'
                $CSVLocGRnotes = 'C:\Temp\GroupNotes.CSV'
                    switch ($overzicht) {
                        'A'
                        {
                            Write-Host "U heeft optie A gekozen"
                            $hosts = Get-VM | Select-Object ComputerName,Name,State,Notes,CreationTime,MemoryAssigned

                            $vraag = Read-Host "Wilt u een CSV genereren? Y/N"

                            # Geef Get-VM met CSV
                            if ($vraag -eq "Y") {$hosts | Export-Csv -Path $CSVLocation -NoTypeInformation -Force
                                if (Test-Path $CSVLocation) {
                                    Import-Csv -Path $CSVLocation | Format-Table
                                    Write-Host "Overzicht geëxporteerd naar $CSVLocation"} 

                                    else {Write-Host "Geen bestaande VM-data gevonden."}}
                            
                            # Geef Get-VM zonder CSV
                            if ($vraag -eq "N") {$hosts | Format-Table -AutoSize}
                            Show_MenuH
                                }
                                
                        'B'
                        {
                            # Haal host info op
                            $hostInfo = Get-CimInstance -ClassName Win32_ComputerSystem
                            $osInfo   = Get-CimInstance -ClassName Win32_OperatingSystem

                            $hostSummary = [PSCustomObject]@{
                                HostName          = $hostInfo.Name
                                TotalMemoryGB     = [math]::Round($osInfo.TotalVisibleMemorySize / 1MB,2)
                                FreeMemoryGB      = [math]::Round($osInfo.FreePhysicalMemory / 1MB,2)
                                UsedMemoryGB      = [math]::Round(($osInfo.TotalVisibleMemorySize - $osInfo.FreePhysicalMemory) / 1MB,2)
                            }

                            # Haal VM info op
                            $vmInfo = Get-VM | ForEach-Object {
                                $vm = $_
                                $mem = Get-VMMemory -VMName $vm.Name
                                [PSCustomObject]@{
                                    VMName         = $vm.Name
                                    VMState        = $vm.State
                                    AssignedMemory = [math]::Round($vm.MemoryAssigned / 1MB,2)
                                }
                            }
                            
                            $hostSummary | Format-Table -AutoSize
                            $vmInfo | Format-Table -AutoSize
                            Show_MenuH
                            }
                    
                    
                        'C'
                            {
                            Write-Host "U heeft optie C gekozen"
                        
                                                    #werk switchcclause weg morgen, let op voor de foutmelding van vandaag
                                # Laad de notities
                                $notes = Import-Csv $CSVLocGRnotes                                    
                                $groups = Get-VMGroup | Select-Object Name, GroupType

                                if (Test-Path $CSVLocGRnotes) {
                                }

                                $vraag = Read-host "CSV Genereren, Y/N?"
                                
                                # Haal VM groepen op en voeg notities toe
                                $merge = foreach ($group in (Get-VMGroup)) {
                                    $note = ($notes | Where-Object { $_.Name -eq $group.Name }).NotesGroup
                                    [PSCustomObject]@{
                                        Name       = $group.Name
                                        GroupType  = $group.GroupType
                                        NotesGroup = ($note -join "; ")
                                    }
                                }

                                if ($vraag -eq "Y") {
                                    $merge | Format-Table -AutoSize    
                                    $merge | Export-Csv -Path $CSVlocGRnotes -NoTypeInformation -Force
                                    Write-Host "Overzicht geëxporteerd naar $CSVLocGRnotes"}                                
                                if ($vraag -eq "N") {$merge | Format-Table -AutoSize}
                                                }
                        }
            }
        '2' 
            {   
                Write-Host "U heeft optie 2 gekozen"
                Show_Menu2
                # Vraag 1: Welke ISO?
                $choice = Read-Host "Quick-Start of Custom?"
                    Switch($choice) {
                        'A'
                            {
                                Write-Host "U heeft Quick-Start gekozen"
                            }
                        'B'    
                            {
                                Write-Host "`nU heeft Custom gekozen"
                                Show_Menu2B
                                $isovm = Read-Host "`nWelke ISO wilt u gebruiken voor een nieuwe aangepaste VM?"
                                Switch ($isovm) {
                                    '1' {
                                        Write-Host "U heeft gekozen voor WS2019"
                                        #er moet nog dingen bijkomen. bv CPU, IP's/Netwerkadapters etc.
                                        #Vraag 2: Naam van de VM?
                                        $VMName = Read-Host "Geef een naam door (bijv. Servernaam@Hostnaam.local)"
                                        if ($VMName -match '^\d+$') { $VMName = [string]$VMName }
                                        Write-Host "Naam van de Virtuele Machine: $VMName"

                                        #Vraag 3: Hoeveel RAM?
                                        $VMMemory = Read-Host "Geef het geheugen in GB (bijv. 8, 16, 32)"
                                        if ($VMMemory -match '^\d+$') { $memoryBytes = [int64]$VMMemory * 1GB }
                                        Write-Host "Geheugen ingesteld op $VMMemory GB ($memoryBytes bytes)"

                                        #Vraag 4: Hoeveel Opslag?
                                        $VHDisk = Read-Host "Geef het opslagcapaciteit in GB (bijv. 8, 16, 32)"
                                        if ($VHDisk -match '^\d+$') { $VHDiskBytes = [int64]$VHDisk * 1GB }
                                        Write-Host "Opslagcapaciteit ingesteld op $VHDisk GB ($VHDiskBytes bytes)"

                                        #Vraag 5: Hoeveel VM's wilt u uitrollen?
                                        $Aantal = Read-Host "Geef een aantal door (bijv. 2)" 
                                        Write-Host "Zoveel VM's worden gemaakt: $Aantal" 
                                        for ($i = 1; $i -le $Aantal; $i++) {                        # zet een {integer+-1} bij elke iteratie (bv. bij 4 iteratie's = test-1 +-2 +-3 +-4)
                                            $VMName = "$VMName-$i"
                                            ws_2019 -VMName $VMName -MemoryGB $VMMemory -DiskGB $VHDisk -VMDvdDrive $diskPath
                                        }
                                    }

                                    '2' {
                                        Write-Host "U heeft gekozen voor W10_LTSC"
                                        
                                        #Vraag 2: Naam van de VM?
                                        $VMName = Read-Host "Geef een naam door (bijv. Servernaam@Hostnaam.local)"
                                        if ($VMName -match '^\d+$') { $VMName = [string]$VMName }
                                        Write-Host "Naam van de Virtuele Machine: $VMName"

                                        #Vraag 3: Hoeveel RAM?
                                        $VMMemory = Read-Host "Geef het geheugen in GB (bijv. 8, 16, 32)"
                                        if ($VMMemory -match '^\d+$') { $memoryBytes = [int64]$VMMemory * 1GB }
                                        Write-Host "Geheugen ingesteld op $VMMemory GB ($memoryBytes bytes)"

                                        #Vraag 4: Hoeveel Opslag?
                                        $VHDisk = Read-Host "Geef het opslagcapaciteit in GB (bijv. 8, 16, 32)"
                                        if ($VHDisk -match '^\d+$') { $VHDiskBytes = [int64]$VHDisk * 1GB }
                                        Write-Host "Opslagcapaciteit ingesteld op $VHDisk GB ($VHDiskBytes bytes)"

                                        #Vraag 5: Hoeveel VM's wilt u uitrollen?
                                        $Aantal = Read-Host "Geef een aantal door (bijv. 2)" 
                                        Write-Host "Zoveel VM's worden gemaakt: $Aantal" 
                                        for ($i = 1; $i -le $Aantal; $i++) {                        # zet een {integer+-1} bij elke iteratie (bv. bij 4 iteratie's = test-1 +-2 +-3 +-4)
                                            $VMName = "$VMName-$i"
                                            W10 -VMName $VMName -MemoryGB $VMMemory -DiskGB $VHDisk -VMDvdDrive $diskPath
                                        }
                                    }
                                }
                            }
                        }
                    }

            '3'
                {
                Write-Host = "U heeft optie 3 gekozen`n"
                Show_Menu3
                $status = Read-Host "`nKies een status"
                    Switch($status) {
                        'A' 
                        {
                            $liststart = Get-VM | Where-Object { $_.State -eq 'Off' } |
                            Select-Object Name, State, Uptime, CreationTime
                            $liststart | Format-Table -AutoSize
                            Write-Host "U heeft optie A gekozen`n"
                            
                            $chosenVMstart = Read-Host "`nVoer de naam van de VMs in die u wilt starten (bijv. VM1,VM2,VM3)"
                            $chosenVMArray = $chosenVMstart -split '\s*,\s*'
                            # start-vm indien beschikbaar, zo niet toon melding dat er geen VM's uitstaan en verlaat
                            foreach ($vm in $liststart) {
                                if ($vm.Name -in $chosenVMArray) {
                                    Start-VM -Name $vm.Name
                                    Write-Host "VM '$($vm.Name)' gestart."
                                    }}
                        }
                            
                        'B' 
                        {
                            $CSVLocation = 'C:\Temp\GuestInfo.CSV'

                            # Check of CSV bestaat
                            if (-Not (Test-Path $CSVLocation)) {
                                Write-Host "Geen bestaande configuraties gevonden."
                                break}

                            # Lijst met VMs ophalen
                            $vmList = Import-Csv $CSVLocation
                            Write-Host "`nBeschikbare VMs:"
                            $vmList | ForEach-Object { Write-Host "- $($_.Name)" }

                            # Vraag meerdere namen (komma gescheiden)
                            $kiesVM = Read-Host "`nVoer de naam van de VMs in die u wilt stoppen (bijv. VM1,VM2,VM3)"
                            $kiesVMArray = $kiesVM -split '\s*,\s*'   # Splits op komma's, verwijdert spaties

                            # Vind VMs die in CSV staan
                            $vindVMs = $vmList | Where-Object { $_.Name -in $kiesVMArray }

                            if ($vindVMs.Count -gt 0) {
                                Write-Host "`nVM's gevonden in CSV en worden gestopt:" -ForegroundColor Yellow
                                $vindVMs | ForEach-Object {
                                    Write-Host "Stopping VM: $($_.Name)"
                                    Stop-VM -Name $_.Name -Force
                                }

                                # CSV updaten (verwijder gestopte VMs)
                                $updatedList = $vmList | Where-Object { $_.Name -notin $kiesVMArray }
                                $updatedList | Export-Csv -Path $CSVLocation -NoTypeInformation

                                Write-Host "`nCSV is bijgewerkt. Gestopte VMs: $($vindVMs.Name -join ', ')" -ForegroundColor Green
                            }
                            else {
                                Write-Host "`nGeen van de opgegeven VM-namen zijn gevonden in de CSV." -ForegroundColor Red
                            }
                        }

                        'C' 
                        {
                            Write-Host = "U heeft optie C gekozen`n"
                            $listpause = Get-VM | Where-Object { $_.State -eq 'Running' } |
                            Select-Object Name, State, Uptime, CreationTime
                            $listpause | Format-Table -AutoSize
                            Write-Host "U heeft optie C gekozen`n"
                            
                            $chosenVMpause = Read-Host "`nVoer de naam van de VMs in die u wilt starten (bijv. VM1,VM2,VM3)"
                            $chosenVMArray = $chosenVMpause -split '\s*,\s*'
                            # start-vm indien beschikbaar, zo niet toon melding dat er geen VM's uitstaan en verlaat
                            foreach ($vm in $listpause) {
                                if ($vm.Name -in $chosenVMArray) {
                                    Suspend-VM -Name $vm.Name
                                    Write-Host "VM '$($vm.Name)' gepauseerd."
                                    }
                                }
                            }
                        
                        'D'
                        {
                            $CSVLocation = 'C:\Temp\GuestInfo.CSV'
                            # Vraag lijst VM's op m.b.v. CSV
                            if (-Not (Test-Path $CSVLocation)) {Write-Host "Geen bestaande configuraties gevonden."; break}

                            $vmList = Import-Csv $CSVLocation
                            Write-Host "`nBeschikbare VMs:"
                            $vmList | ForEach-Object { Write-Host "- $($_.Name)" }

                            # Geef naam van de te verwijderen VM's door
                            $kiesVM = Read-Host "`nVoer de naam van de VMs in dat u wilt verwijderen"
                            $vindVM = $vmList | Where-Object { $_.Name -eq $kiesVM } | Select-Object -First 1

                                # Als gebruiker zover komt, wilt hij het verwijderen. Dus stel vraag...
                                if ($vindVM.Name -eq $kiesVM) {
                                    $vindVM | Format-List # kopieer voor optie 6
                                    Stop-VM -Name $vindVM.Name -Force 
                                    
                                    # Verwijder HDD
                                    $vhdPathloc = "C:\ProgramData\Microsoft\Windows\Hyper-V\Virtual Hard Disks\$($vindVM.Name).vhdx"
                                    Remove-Item -Path $vhdPathloc -Recurse -Force -Confirm:$False
                                    
                                    # Verwijder VM
                                    Remove-VM $vindVM.name -Force ; Write-Host "Remove $($vindVM.Name) succes!" # Verwijderd alle VM's met de doorgegeven naam

                                    # Update CSV
                                    $updatedList = $vmList | Where-Object { $_.Name -ne $kiesVM }
                                    $updatedList | Export-Csv -Path $CSVLocation -NoTypeInformation
                                    Write-Host "CSV is bijgewerkt, VM '$kiesVM' is verwijderd uit de lijst."
                                }
                            }

                        'E' 
                        {
                            $listresume = Get-VM | Where-Object { $_.State -eq 'Paused' } |
                            Select-Object Name, State, Uptime, CreationTime
                            $listresume | Format-Table -AutoSize
                            Write-Host "U heeft optie E gekozen`n"
                            
                            $chosenVMresume = Read-Host "`nVoer de naam van de VMs in die u wilt starten (bijv. VM1,VM2,VM3)"
                            $chosenVMArray = $chosenVMresume -split '\s*,\s*'
                            # start-vm indien beschikbaar, zo niet toon melding dat er geen VM's uitstaan en verlaat
                            foreach ($vm in $listresume) {
                                if ($vm.Name -in $chosenVMArray) {
                                    Resume-VM -Name $vm.Name
                                    Write-Host "VM '$($vm.Name)' wordt hervat."}
                                    }
                                }
                            }
                        }
        '4' 
        {
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
                                        }}}

                                        #einde $menuKeuze-switchclause

                    #verder met de $project-switchclause
                    'B'
                    {
                        Write-Host "U heeft optie B gekozen"
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
                                        }
                                        '2' 
                                        {
                                            Write-Host "U heeft Group Type - 'ManagementCollectionType' gekozen"
                                            if ($grouptypeb -eq '2') {$NewCSVdataB = New-VMGroup -Name $newgroup -GroupType ManagementCollectionType | ForEach-Object {Write-Host "- $($_.Name)"} | Export-CSV -Path 'C:\Temp\Group.CSV' -NoTypeInformation}
                                                Write-Host "`nGroep $newgroup is aangemaakt!"
                                            #grouptype
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
                                                            }
                                                # toevoegen
                                                }}
 
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
                                        }
                                        }
                                    }
                                
                                'F'
                                    {
                                        Write-Host "U heeft optie F gekozen"
                                        # power settings voor groepen
                                    }
                            }
                            }
                    'D' 
                    {
                            #Snapshots maken etc.
                        }                
                    }
                }
        '4'
            {
            Write-Host = "U heeft optie 4 gekozen`n"
            Show_Menu4
            $status = Read-Host "`nKies een status"
                Switch($status) {
                    'A' 
                    {
                        $liststart = Get-VM | Where-Object { $_.State -eq 'Off' } |
                        Select-Object Name, State, Uptime, CreationTime
                        $liststart | Format-Table -AutoSize
                        Write-Host "U heeft optie A gekozen`n"
                        
                        $chosenVMstart = Read-Host "`nVoer de naam van de VMs in die u wilt starten (bijv. VM1,VM2,VM3)"
                        $chosenVMArray = $chosenVMstart -split '\s*,\s*'
                        # start-vm indien beschikbaar, zo niet toon melding dat er geen VM's uitstaan en verlaat
                        foreach ($vm in $liststart) {
                            if ($vm.Name -in $chosenVMArray) {
                                Start-VM -Name $vm.Name
                                Write-Host "VM '$($vm.Name)' gestart."
                                }}
                    }
                        
                    'B' 
                    {
                        $CSVLocation = 'C:\Temp\GuestInfo.CSV'

                        # Check of CSV bestaat
                        if (-Not (Test-Path $CSVLocation)) {
                            Write-Host "Geen bestaande configuraties gevonden."
                            break}

                        # Lijst met VMs ophalen
                        $vmList = Import-Csv $CSVLocation
                        Write-Host "`nBeschikbare VMs:"
                        $vmList | ForEach-Object { Write-Host "- $($_.Name)" }

                        # Vraag meerdere namen (komma gescheiden)
                        $kiesVM = Read-Host "`nVoer de naam van de VMs in die u wilt stoppen (bijv. VM1,VM2,VM3)"
                        $kiesVMArray = $kiesVM -split '\s*,\s*'   # Splits op komma's, verwijdert spaties

                        # Vind VMs die in CSV staan
                        $vindVMs = $vmList | Where-Object { $_.Name -in $kiesVMArray }

                        if ($vindVMs.Count -gt 0) {
                            Write-Host "`nVM's gevonden in CSV en worden gestopt:" -ForegroundColor Yellow
                            $vindVMs | ForEach-Object {
                                Write-Host "Stopping VM: $($_.Name)"
                                Stop-VM -Name $_.Name -Force
                            }

                            # CSV updaten (verwijder gestopte VMs)
                            $updatedList = $vmList | Where-Object { $_.Name -notin $kiesVMArray }
                            $updatedList | Export-Csv -Path $CSVLocation -NoTypeInformation

                            Write-Host "`nCSV is bijgewerkt. Gestopte VMs: $($vindVMs.Name -join ', ')" -ForegroundColor Green
                        }
                        else {
                            Write-Host "`nGeen van de opgegeven VM-namen zijn gevonden in de CSV." -ForegroundColor Red
                        }
                    }

                    'C' 
                    {
                        Write-Host = "U heeft optie C gekozen`n"
                        $listpause = Get-VM | Where-Object { $_.State -eq 'Running' } |
                        Select-Object Name, State, Uptime, CreationTime
                        $listpause | Format-Table -AutoSize
                        Write-Host "U heeft optie C gekozen`n"
                        
                        $chosenVMpause = Read-Host "`nVoer de naam van de VMs in die u wilt starten (bijv. VM1,VM2,VM3)"
                        $chosenVMArray = $chosenVMpause -split '\s*,\s*'
                        # start-vm indien beschikbaar, zo niet toon melding dat er geen VM's uitstaan en verlaat
                        foreach ($vm in $listpause) {
                            if ($vm.Name -in $chosenVMArray) {
                                Suspend-VM -Name $vm.Name
                                Write-Host "VM '$($vm.Name)' gepauseerd."
                                }
                            }
                        }
                    
                    'D'
                    {
                        $CSVLocation = 'C:\Temp\GuestInfo.CSV'
                        # Vraag lijst VM's op m.b.v. CSV
                        if (-Not (Test-Path $CSVLocation)) {Write-Host "Geen bestaande configuraties gevonden."; break}

                        $vmList = Import-Csv $CSVLocation
                        Write-Host "`nBeschikbare VMs:"
                        $vmList | ForEach-Object { Write-Host "- $($_.Name)" }

                        # Geef naam van de te verwijderen VM's door
                        $kiesVM = Read-Host "`nVoer de naam van de VMs in dat u wilt verwijderen"
                        $vindVM = $vmList | Where-Object { $_.Name -eq $kiesVM } | Select-Object -First 1

                            # Als gebruiker zover komt, wilt hij het verwijderen. Dus stel vraag...
                            if ($vindVM.Name -eq $kiesVM) {
                                $vindVM | Format-List # kopieer voor optie 6
                                Stop-VM -Name $vindVM.Name -Force 
                                
                                # Verwijder HDD
                                $vhdPathloc = "C:\ProgramData\Microsoft\Windows\Hyper-V\Virtual Hard Disks\$($vindVM.Name).vhdx"
                                Remove-Item -Path $vhdPathloc -Recurse -Force -Confirm:$False
                                
                                # Verwijder VM
                                Remove-VM $vindVM.name -Force ; Write-Host "Remove $($vindVM.Name) succes!" # Verwijderd alle VM's met de doorgegeven naam

                                # Update CSV
                                $updatedList = $vmList | Where-Object { $_.Name -ne $kiesVM }
                                $updatedList | Export-Csv -Path $CSVLocation -NoTypeInformation
                                Write-Host "CSV is bijgewerkt, VM '$kiesVM' is verwijderd uit de lijst."
                            }
                        }

                    'E' 
                    {
                        $listresume = Get-VM | Where-Object { $_.State -eq 'Paused' } |
                        Select-Object Name, State, Uptime, CreationTime
                        $listresume | Format-Table -AutoSize
                        Write-Host "U heeft optie E gekozen`n"
                        
                        $chosenVMresume = Read-Host "`nVoer de naam van de VMs in die u wilt starten (bijv. VM1,VM2,VM3)"
                        $chosenVMArray = $chosenVMresume -split '\s*,\s*'
                        # start-vm indien beschikbaar, zo niet toon melding dat er geen VM's uitstaan en verlaat
                        foreach ($vm in $listresume) {
                            if ($vm.Name -in $chosenVMArray) {
                                Resume-VM -Name $vm.Name
                                Write-Host "VM '$($vm.Name)' wordt hervat."}
                                }
                            }
                        }
                    }
                }
}
until ($input -eq 'q')

# Set-VM -Notes -AutomaticStopAction - aan de hand van een specifiek tijd/datum
# VMGroup New, Remove, Rename, Get.. Trace, 

# To assign a static IP address to a virtual machine (VM) in Hyper-V using PowerShell, you need to use the Set-VMNetworkAdapter cmdlet and potentially other cmdlets like New-NetIPAddress depending on your needs. First, you should identify the VM's network adapter name or interface alias. Then, you can use the Set-VMNetworkAdapter cmdlet to configure the IP address, subnet mask, default gateway, and DNS server settings within the VM. 
# Here's a breakdown of the process and example commands:
# 1. Identify the VM and its network adapter:
# Get the VM name:
# You'll need the name of your virtual machine, which you can find in Hyper-V Manager or by using the Get-VM cmdlet in PowerShell.
# Get the network adapter:
# Use the Get-VMNetworkAdapter cmdlet along with the VM name to find the network adapter you want to configure. You can also use Get-NetAdapter on the host OS to find the network adapter corresponding to the virtual switch. 
# 2. Configure the IP address, subnet, and gateway (if needed):
# Set-VMNetworkAdapter: This cmdlet is used to modify network adapter settings for a VM.
# -VMName: Specifies the name of the VM.
# -Name: Specifies the name of the network adapter within the VM.
# -StaticIPAddress: Sets the static IP address.
# -StaticSubnetMask: Sets the subnet mask.
# -StaticDefaultGateway: Sets the default gateway.
# -StaticAddressFamily: Specifies IPv4 or IPv6.
# -DHCP: Use this with a switch to enable or disable DHCP. 
# Code

#     # Example:
#     Set-VMNetworkAdapter -VMName MyVM -Name "Network Adapter" -StaticIPAddress 192.168.1.100 -StaticSubnetMask 255.255.255.0 -StaticDefaultGateway 192.168.1.1
# New-NetIPAddress: If you need to configure DNS servers, you can use this cmdlet. 
# -InterfaceAlias: Specifies the network adapter alias (obtained from Get-NetAdapter). 
# -IPAddress: Sets the IP address. 
# -PrefixLength: Sets the subnet mask. 
# -DefaultGateway: Sets the default gateway. 
# -AddressFamily: Specifies IPv4 or IPv6. 
# Code

#     # Example:
#     New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress 192.168.1.100 -PrefixLength 24 -DefaultGateway 192.168.1.1
# 3. Configure DNS servers:
# Set-DnsClientServerAddress: This cmdlet configures the DNS server addresses.
# -InterfaceAlias: Specifies the network adapter alias.
# -ServerAddresses: Specifies an array of DNS server addresses. 
# Code

#     # Example:
#     Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses 8.8.8.8, 8.8.4.4
# Important Considerations:
# Virtual Switch:
# Ensure that your VM is connected to a virtual switch (External, Internal, or Private) that allows network communication. 
# Guest OS:
# You may need to configure the IP address settings within the guest operating system as well, especially if you are not using DHCP. 
# Firewall:
# Make sure that the firewall on the host and guest OS is configured to allow network traffic. 
# Remote Management:
# For managing Hyper-V hosts remotely, ensure that remote management is enabled on both the host and the remote computer, according to Learn Microsoft. 
# PowerShell Remoting:
# If you're managing the VM remotely, you might need to use PowerShell remoting to execute the commands inside the VM. 