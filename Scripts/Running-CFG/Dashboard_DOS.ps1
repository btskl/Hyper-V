. C:\Users\Administrator\Desktop\Scripts\New-CFG\Hyper-V_enk.ps1
# # Enable-VMResourceMetering -VMName $VMName
# # Measure-VM -Name $VMName

function Show_MenuH{ # Hoofdmenu
    $title = "ABB VM_beheer"
        
    Write-Host "=========================$title========================="
    Write-Host "1: Druk op '1' voor een standaard VM (Quick-Start)”
    Write-Host "2: Druk op '2' om een overzicht te tonen"
    Write-Host "3: Druk op '3' om een IP-adres toe te wijzen"
    Write-Host "4: Druk op '4' om VM's te verwijderen"
    Write-Host "5: Druk op '5' om een aantal uit te rollen VM's door te geven (bijv. 2)"
    Write-Host "Q: Press 'Q' to exit"
}

function Show_Menu1{ # Menu voor na optie 1
    Write-Host "=================================================="
    Write-Host "1A: Druk op 'A' voor Windows Server 2019”
    Write-Host "1B: Druk op 'B' voor Windows 10 LTSC"
    Write-Host ""
    Write-Host "Q: Press 'Q' to exit"
}
	
function Show_Menu2{ # Menu voor na optie 2
    Write-Host "=================================================="
    Write-Host "2A: Druk op 'A' voor HDD-instellingen”
    Write-Host "2B: Druk op 'B' voor Checkpoint-VM"
    Write-Host ""
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
            Clear-Host
            Show_Menu1 # Roep menu 1 aan
            Write-Host "U heeft optie 1 gekozen"

            # Vraag 1: Welke ISO?
            $isovm = Read-Host "Welke ISO wilt u gebruiken voor de nieuwe VM?"

            switch ($isovm) {
                'A' 
                {
                    Write-Host "WS2019"

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

                    ws_2019
                    Write-Host "WS2019 Deployed"
                    Show_MenuH # Herroep Hoofdmenu
                }

                'B' 
                {
                    Write-Host "W10"

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

                    W10
                    Write-Host "W10_LTSC Deployed"
                    Show_MenuH # Herroep Hoofdmenu
                }
            }
        }

        '2' 
        {            
            Clear-Host
            Show_MenuH
            Show_Menu2 # Roep menu 2 aan
            Write-Host "U heeft optie 2 gekozen"
            $CSVLocation = 'C:\Temp\GuestInfo.CSV'
			$hosts = Get-VM | Select-Object VMID,ComputerName,Name,State,Uptime
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
	    }

        '3' 
        {
        #     if (-Not (Test-Path $CSVLocation)) {Write-Host "Geen bestaande configuraties gevonden."; break}

        #     $vmList = Import-Csv $CSVLocation
        #     Write-Host "`nBeschikbare VMs:"
        #     $vmList | ForEach-Object { Write-Host "- $($_.Guest)" }

        #     $chosenVM = Read-Host "`nVoer de naam van de VM in waaraan je een IP wilt toewijzen"
        #     $foundVM = $vmList | Where-Object { $_.Guest -eq $chosenVM } | Select-Object -First 1

        #     if (-not $foundVM) {Write-Host "VM '$chosenVM' niet gevonden."; break}

        #     $newIP = Read-Host "Voer het gewenste IP-adres in voor deze VM"
        #     if ($newIP -notmatch '^\d{1,3}(\.\d{1,3}){3}$') {Write-Host "Ongeldig IP-formaat."; break}

        #     # Update IP
        #     foreach ($vm in $vmList) {if ($vm.Guest -eq $chosenVM) {$vm.IPs = $newIP}}

        #     # Overschrijf CSV
        #     $vmList | Export-Csv -Path $CSVLocation -NoTypeInformation
        #     Write-Host "`nIP-adres '$newIP' succesvol toegewezen aan VM '$chosenVM'."
        }

        '4' 
        {                    
            $CSVLocation = 'C:\Temp\GuestInfo.CSV'
                # Vraag lijst VM's op m.b.v. CSV
                if (-Not (Test-Path $CSVLocation)) {Write-Host "Geen bestaande configuraties gevonden."; break}

                $vmList = Import-Csv $CSVLocation
                Write-Host "`nBeschikbare VMs:"
                $vmList | ForEach-Object { Write-Host "- $($_.Name)" }

                # Geef naam van de te verwijderen VM door
                $chosenVM = Read-Host "`nVoer de naam van de VMs in dat u wilt verwijderen"
                $foundVM = $vmList | Where-Object { $_.Name -eq $chosenVM } | Select-Object -First 1

                # Als gebruiker zover komt, wilt hij het verwijderen. Dus stel vraag...
                if ($foundVM.Name -eq $chosenVM) {
                    $foundVM | Format-List 
                    Stop-VM -Name $foundVM.Name -Force 
                    
                    # Verwijder HDD
                    $vhdPathloc = "C:\ProgramData\Microsoft\Windows\Hyper-V\Virtual Hard Disks\$($foundVM.Name).vhdx"
                    Remove-Item -Path $vhdPathloc -Recurse -Force -Confirm:$False
                    
                    # Verwijder VM
                    Remove-VM $foundVM.name -Force ; Write-Host "Remove $($foundVM.Name) succes!" # Verwijderd alle VM's met de doorgegeven naam

                    # Update CSV
                    $updatedList = $vmList | Where-Object { $_.Name -ne $chosenVM }
                    $updatedList | Export-Csv -Path $CSVLocation -NoTypeInformation
                    Write-Host "CSV is bijgewerkt, VM '$chosenVM' is verwijderd uit de lijst."
                }
            }

            '5' 
            {   
                Show_Menu1
                # Vraag 1: Welke ISO?
                $isovm = Read-Host "Welke ISO wilt u gebruiken voor de nieuwe VM?"

                    switch ($isovm) {
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
                        }
                }
            }
            'Q' 
            {
                # wijs naam toe van verzoeker/eindgebruiker

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