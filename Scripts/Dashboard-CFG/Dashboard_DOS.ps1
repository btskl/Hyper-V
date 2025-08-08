. C:\Users\Administrator\Desktop\Scripts\Dashboard-CFG\Hyper-V_enk.ps1
# # Enable-VMResourceMetering -VMName $VMName
# # Measure-VM -Name $VMName

function Show_MenuH{ # Hoofdmenu
    $title = "ABB VM_beheer"
        
    Write-Host "=========================$title========================="
    Write-Host "1: Druk op '1' om overzichten te tonen [Get-VM]"
    Write-Host "2: Druk op '2' om VM's te maken (bijv. 2) [New-VM]"
    Write-Host "3: Druk op '3' om Notes toe te voegen [VM-Notes]" # wijs naam toe van verzoeker/eindgebruiker 
    Write-Host "4: Druk op '4' voor VM power-settings [VM-Status]"
    Write-Host "5: Druk op '5' voor VM group-settings [VM-Group]" 
    Write-Host "Q: Press 'Q' to exit"
}

function Show_Menu2{
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor WS2019 [Windows Server 2019]”
    Write-Host "B: Druk op 'B' voor W10 [Windows 10 Enterprise LTSC]"
    Write-Host "Q: Press 'Q' to exit"
}
	
function Show_Menu4{
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor Starten [Start-VM]”
    Write-Host "B: Druk op 'B' voor Stoppen [Stop-VM]"
    Write-Host "C: Druk op 'C' voor Pauzeren [Suspend-VM]"
    Write-Host "D: Druk op 'D' voor Verwijderen [Remove-VM]"
    Write-Host "E: Druk op 'E' voor Hervatten [Resume-VM]"
    Write-Host "Q: Press 'Q' to exit"
}
              
function Show_Menu5{
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor overzichten [Get-VMGroup]"
    Write-Host "B: Druk op 'B' voor een nieuwe groep [New-VMGroup]”
    Write-Host "C: Druk op 'C' voor verwijderen groep [Remove-VMGroup]"
    Write-Host "D: Druk op 'D' voor hernoemen groep [Rename-VMGroup] "
    Write-Host "E: Druk op 'E' voor aanpassen ledenstructuur"
    Write-Host "Q: Press 'Q' to exit"
}

function Show_Menu5E{
    Write-Host "=================================================="
    Write-Host "A: Druk op 'A' voor leden toevoegen [Add-VMGroupMembers]"
    Write-Host "B: Druk op 'B' voor leden verwijderen [Remove-VMGroupMembers]”
    Write-Host "Q: Press 'Q' to exit"
}

function Show_Menu5B{
    Write-Host "=================================================="
    Write-Host "A: Druk op '5B1' voor Group Type - 'VMCollectionType' []"
    Write-Host "B: Druk op '5B2' voor Group Type - 'ManagementCollectionType' []”
    Write-Host "Q: Press 'Q' to exit"
}
# etc. etc.

# Roep Hoofdmenu Aan
Show_MenuH
do {
    $input = Read-Host "Maak een keuze"

    switch ($input) {
        '1' 
        {            
            Write-Host "U heeft optie 1 gekozen"
            $CSVLocation = 'C:\Temp\GuestInfo.CSV'
			$hosts = Get-VM | Select-Object VMID,ComputerName,Name,State,Uptime,Notes,CreationTime,GroupName
            # $hddrive = Get-VMHardDiskDrive | Select-Object Path,ControllerType,ControllerNumber,ControllerLocation

                # if ($isovm -eq '2') { 
                #     switch($input){
                #     'A' {$hostHDD = Get-VM | Select-Object ComputerName,Name,State,VMNetworkAdapter,SwitchName,ControllerType,ControllerNumber,ControllerLocation

                #         }
                #             'B' {$hostSNAP = Get-VM | Checkpoint-VM}
                #             'C' {$hostPAUSE = Suspend-VM -Name $($_.Guest)}
                # }}

            # schrijf naar voorkeur weg in CSV
			$hosts | Export-Csv -Path $CSVLocation -NoTypeInformation -Force
                if (Test-Path $CSVLocation) {
                    Import-Csv -Path $CSVLocation | Format-Table
                    Write-Host "Overzicht geëxporteerd naar $CSVLocation"} 
                    else {Write-Host "Geen bestaande VM-data gevonden."}
            Show_MenuH
	    }

        '2' 
            {   
                Write-Host "U heeft optie 2 gekozen"
                Show_Menu2
                # Vraag 1: Welke ISO?
                $isovm = Read-Host "Welke ISO wilt u gebruiken voor de nieuwe VM?"
                    Switch ($isovm) {
                        'A' {
                            Write-Host "U heeft gekozen voor WS2019"
                            
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

                        'B' {
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
                Show_MenuH
                        }
                }
            }

        '3' 
        { 
            Write-Host "U heeft optie 3 gekozen"

            $notes = Read-Host 'Voer notitie in' # of voeg CreationTime toe aan get-vm
            $CSVLocation = 'C:\Temp\GuestInfo.CSV'
            # Vraag lijst VM's op m.b.v. CSV
            if (-Not (Test-Path $CSVLocation)) {Write-Host "Geen bestaande configuraties gevonden."; break}

            $vmList = Import-Csv $CSVLocation
            Write-Host "`nBeschikbare VMs:"
            $vmList | ForEach-Object { Write-Host "- $($_.Name)" }

            # Geef naam van de te verwijderen VM door
            $chosenVM = Read-Host "`nVoer de naam van de VMs waaraan een tag toegewezen moet worden"
            $foundVM = $vmList | Where-Object { $_.Name -eq $chosenVM } | Select-Object -First 1 

            # Dus stel vraag...
            if ($foundVM.Name -eq $chosenVM) {
                $foundVM | Format-List # kopieer voor optie 6
            Set-VM -Name $foundVM.Name -Notes $notes
            
            # Update CSV
            $updatedList = $vmList | Where-Object { $_.Name -ne $chosenVM }
            $updatedList | Export-Csv -Path $CSVLocation -NoTypeInformation
            Write-Host "CSV is bijgewerkt."}
            Show_MenuH
        }

        '4'
        {
        Write-Host = "U heeft optie 4 gekozen`n"
        Show_Menu4
        $status = Read-Host "`nKies een status"
            Switch($status) {
                'A' {
                    $liststart = Get-VM | Where-Object { $_.State -eq 'Off' } | Select-Object Name, State, Uptime
                    Write-Host = "U heeft optie A gekozen`n"
                
                    Write-Host "`nGestopte VMs: $($liststart)"
                    
                    Read-Host "Kies een op te starten VM"
                    # start-vm indien beschikbaar, zo niet toon melding dat er geen VM's uitstaan en verlaat
                        if ($liststart.State -eq 'Off') {Start-VM -Name $($liststart.Name)}
                            else {break}

                    $updatedList = $getVMstart | Where-Object { $_.Name -ne $chosenVMstart }
                    $updatedList | Export-Csv -Path $CSVLocation -NoTypeInformation
                    Write-Host "CSV is bijgewerkt. VM ${liststart}"
                    }
                'B' {
                    $CSVLocation = 'C:\Temp\GuestInfo.CSV'
                    # Vraag lijst VM's op m.b.v. CSV
                    if (-Not (Test-Path $CSVLocation)) {Write-Host "Geen bestaande configuraties gevonden."; break}

                    $vmList = Import-Csv $CSVLocation
                    Write-Host "`nBeschikbare VMs:"
                    $vmList | ForEach-Object { Write-Host "- $($_.Name)" }

                    # Geef naam van de te verwijderen VM's door
                    $kiesVM = Read-Host "`nVoer de naam van de VMs in dat u wilt stoppem"
                    $vindVM = $vmList | Where-Object { $_.Name -eq $kiesVM } | Select-Object -First 1

                    # Als gebruiker zover komt, wilt hij het verwijderen. Dus stel vraag...
                    if ($vindVM.Name -eq $kiesVM) {
                        $vindVM | Format-List # kopieer voor optie 6
                        Stop-VM -Name $vindVM.Name -Force 

                        # Update CSV
                        $updatedList = $vmList | Where-Object { $_.Name -ne $kiesVM }
                        $updatedList | Export-Csv -Path $CSVLocation -NoTypeInformation
                        Write-Host "CSV is bijgewerkt, VM '$kiesVM' is gestopt"}
                }
                'C' {
                    Write-Host = "U heeft optie C gekozen`n"
                    $CSVLocation = 'C:\Temp\GuestInfo.CSV'
                    # Vraag lijst VM's op m.b.v. CSV
                    if (-Not (Test-Path $CSVLocation)) {Write-Host "Geen bestaande configuraties gevonden."; break}

                    $vmList = Import-Csv $CSVLocation
                    Write-Host "`nBeschikbare VMs:"
                    $vmList | ForEach-Object { Write-Host "- $($_.Name)" }

                    # Geef naam van de te verwijderen VM's door
                    $kiesVM = Read-Host "`nVoer de naam van de VMs in dat u wilt pauzeren"
                    $vindVM = $vmList | Where-Object { $_.Name -eq $kiesVM } | Select-Object -First 1

                    # Als gebruiker zover komt, wilt hij het verwijderen. Dus stel vraag...
                    if ($vindVM.Name -eq $kiesVM) {
                        $vindVM | Format-List # kopieer voor optie 6
                        Suspend-VM -Name $vindVM.Name 

                        # Update CSV
                        $updatedList = $vmList | Where-Object { $_.Name -ne $kiesVM }
                        $updatedList | Export-Csv -Path $CSVLocation -NoTypeInformation
                        Write-Host "CSV is bijgewerkt, VM '$kiesVM' is gepauzeerd."
                    }
                }
                
                'D' {
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
                'E' {
                    $CSVLocation = 'C:\Temp\GuestInfo.CSV'
                    # Vraag lijst VM's op m.b.v. CSV
                    if (-Not (Test-Path $CSVLocation)) {Write-Host "Geen bestaande configuraties gevonden."; break}

                    $vmList = Import-Csv $CSVLocation
                    Write-Host "`nBeschikbare VMs:"
                    $vmList | ForEach-Object { Write-Host "- $($_.Name)" }

                    # Geef naam van de te verwijderen VM's door
                    $kiesVM = Read-Host "`nVoer de naam van de VMs in dat u wilt hervatten"
                    $vindVM = $vmList | Where-Object { $_.Name -eq $kiesVM } | Select-Object -First 1

                    # Als gebruiker zover komt, wilt hij het verwijderen. Dus stel vraag...
                    if ($vindVM.Name -eq $kiesVM) {
                        $vindVM | Format-List # kopieer voor optie 6
                        Resume-VM -Name $vindVM.Name 
                        
                        # Update CSV
                        $updatedList = $vmList | Where-Object { $_.Name -ne $kiesVM }
                        $updatedList | Export-Csv -Path $CSVLocation -NoTypeInformation
                        Write-Host "CSV is bijgewerkt, VM '$kiesVM' wordt hervat."}
                }
            }
        Show_MenuH
        }
        
        '5' 
        {   Write-Host "U heeft optie 5 gekozen"
            Show_Menu5
            $CSVLocGR = 'C:\Temp\Group.CSV'
            $settingsGroup = Read-Host "Kies een instelling"
# # Geef naam van de te verwijderen VM's door
#                     $kiesVM = Read-Host "`nVoer de naam van de VMs in dat u wilt verwijderen"
#                     $vindVM = $vmList | Where-Object { $_.Name -eq $kiesVM } | Select-Object -First 1

#                     # Als gebruiker zover komt, wilt hij het verwijderen. Dus stel vraag...
#                     if ($vindVM.Name -eq $kiesVM) {
#                         $vindVM | Format-List # kopieer voor optie 6
#                         Stop-VM -Name $vindVM.Name -Force 

                Switch($settingsGroup) {
                    'A'
                        {
                            Write-Host "`nU heeft optie A gekozen"
                            Write-Host "`nDit zijn de aanwezige groepen:"

                            $getgroep = Get-VMGroup | Select-Object Name, VMMembers, GroupType
                            $getgroep | Format-Table -AutoSize
                            # Exporteer naar CSV
                            $getgroep | Export-Csv -Path "C:\Temp\Group.csv" -NoTypeInformation
                            
                            Show_MenuH 

                            # hoe list je vm's afhankelijk van de groep, welke behoort tot welke. maak een keuzemenu 5E
    
                                                    
                            # Vraag lijst VM's op m.b.v. CSV
                            # if (-Not (Test-Path $getgroep)) {Write-Host "Geen bestaande configuraties gevonden."; break}/

                            # Geef naam van de toe te wijzen VM door
                            # $foundVMlist = $lijstvm | Where-Object {$_.Name -eq $ChosenGroup} | Select-Object -First 1

                        }

                    'B' 
                    {
                        Write-Host "U heeft optie 5B gekozen"
                        Show_Menu5B
                        $grouptype = Read-Host "Kies GroupType"
                        $newgroup = Read-Host "Geef naam van nieuwe groep"
                        switch ($grouptype) {
                        '5B1' {
                            Write-Host "U heeft Group Type - 'VMCollectionType' gekozen"
                            if ($grouptype -eq '5B1') {$NewCSVdataA = New-VMGroup -Name $newgroup -GroupType VMCollectionType | ForEach-Object {Write-Host "- $($_.Name)"} | Export-CSV -Path 'C:\Temp\Group.CSV' -NoTypeInformation}
                                Write-Host "`nGroep $newgroup is aangemaakt!"
                        }
                        '5B2' {
                            Write-Host "U heeft Group Type - 'ManagementCollectionType' gekozen"
                            if ($grouptype -eq '5B2') {$NewCSVdataB = New-VMGroup -Name $newgroup -GroupType ManagementCollectionType | ForEach-Object {Write-Host "- $($_.Name)"} | Export-CSV -Path 'C:\Temp\Group.CSV' -NoTypeInformation}
                                Write-Host "`nGroep $newgroup is aangemaakt!"
                            #grouptype
                        }
                        }
                        $getvmtogroup = Get-VM | Where-Object { $_.State -eq 'Running' }
                        

                        Write-Host "Overzicht geëxporteerd naar $CSVLocGr"
                        Import-CSV -Path $CSVlocGR 
                        
                        Show_MenuH    
                    }
                    
                    'C'
                        {
                        $getvmtogrouprem = Get-VMGroup | ForEach-Object { $_.Name }
                        $groupRem = Read-Host = "Geef de te verwijderen VMGroup op"
                        Remove-VMGroup -Name $groupRem -Force # als er leden in de groep zitten kan je het niet zo maar weghalen

                        Show_MenuH
                        }
                    'D'
                        {

                        }
                    'E' 
                        {
                        Show_Menu5E
                        $leden = Read-host "Wat wilt u doen?"
                        
                        switch ($leden) 
                        {
                            'A' {
                            
                            Write-Host "U heeft optie A gekozen"
                            
                            $memberA = Read-Host "Wilt u een VM of VMGroup toevoegen als lid?"
                            $naamvmmemberA = Read-Host "Hoe heet de VM?" 
                            $naamvmgroupmemberA = Read-Host "Hoe heet de VMGroup?"
                                    
                                if ($memberA -eq "VM") {
                                    $getvmvoorlidA = Get-VM -Name $naamvmmemberA -ErrorAction Stop
                                    $getvmgroupvoorlidA = Get-VMGroup -Name $naamvmgroupmemberA -ErrorAction Stop
                                    $addmembertogroupA = Add-VMGroupMember -VMGroup $getvmgroupvoorlidA -VM $getvmvoorlidA -Confirm:$false
                                    }
                                if ($memberA -eq "VMGroup") {
                                    $getvmvoorlidA = Get-VM -Name $naamvmmemberA -ErrorAction Stop
                                    $getvmgroupvoorlidA = Get-VMGroup -Name $naamvmgroupmemberA -ErrorAction Stop
                                    $addmembertogroupA = Add-VMGroupMember -VMGroup $getvmgroupvoorlidA -VMGroupMember $getvmvoorlidA -Confirm:$false
                            }
                            # toevoegen
                            }
                            
                            'B' {

                            Write-Host "U heeft optie B gekozen"
                            $memberB = Read-Host "Wilt u een VM of VMGroup verwijderen van een groep?"
                            $naamvmmemberB = Read-Host "Hoe heet de VM?" 
                            $naamvmgroupmemberB = Read-Host "Hoe heet de VMGroup?"

                                if ($memberB -eq "VM") {
                                    $getvmvoorlidB = Get-VM -Name $naamvmmemberB -ErrorAction Stop
                                    $getvmgroupvoorlidB = Get-VMGroup -Name $naamvmgroupmemberB -ErrorAction Stop
                                    $removemembertogroupB = Remove-VMGroupMember -VMGroup $getvmgroupvoorlidB -VM $getvmvoorlidB -Confirm:$false
                                    }
                                if ($memberB -eq "VMGroup") {
                                    # $getvmvoorlidB = Get-VM -Name $naamvmmemberB -ErrorAction Stop
                                    $getvmgroupvoorlidB = Get-VMGroup -Name $naamvmgroupmemberB -ErrorAction Stop
                                    $removemembertogroupB = Remove-VMGroupMember -VMGroup $getvmgroupvoorlidB # -VMGroupMember $getvmvoorlidB -Confirm:$false
                                # verwijderen
                                }
                            }
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