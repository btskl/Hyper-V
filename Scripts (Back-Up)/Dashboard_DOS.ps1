. .\Hyper-V_enk.ps1
# # Enable-VMResourceMetering -VMName $VMName
# # Measure-VM -Name $VMName

function Show_Menu{
    $title = "ABB VM_beheer"
        
    Write-Host "=========================$title========================="
    Write-Host "1: Druk op '1' voor een standaard VM (Quick-Start)”
    Write-Host "2: Druk op '2' om een overzicht te tonen"
    Write-Host "3: Druk op '3' om een IP-adres toe te wijzen"
    Write-Host "4: Druk op '4' om VM's te verwijderen"
    Write-Host "Q: Press 'Q' to exit"
}

function Show_Menu1{
    Write-Host "========================================="
    Write-Host "1: Druk op '1' voor Windows Server 2019”
    Write-Host "2: Druk op '2' voor Windows 10 LTSC"
    Write-Host ""
    Write-Host "Q: Press 'Q' to exit"
}
	
do {
    Show_Menu
    $input = Read-Host "Maak een keuze"

    switch ($input) {
        '1' {
            Write-Host "U heeft optie 1 gekozen"

            # Vraag 1: Welke ISO?
            Show_Menu1
            $isovm = Read-Host "Welke ISO wilt u gebruiken voor de nieuwe VM?"

            switch ($isovm) {
                '1' {
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
                }

                '2' {
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
                }
            }
        }

        '2' {
            $CSVLocation = 'C:\Temp\GuestInfo.CSV'
			$hosts = Get-VM | Select-Object ComputerName,Name,State,VMNetworkAdapter,SwitchName
            # schrijf naar voorkeur weg in CSV
			$hosts | Export-Csv -Path $CSVLocation -NoTypeInformation -Force
                if (Test-Path $CSVLocation) {
                    Import-Csv -Path $CSVLocation | Format-Table
                    Write-Host "Overzicht geëxporteerd naar $CSVLocation"
                } else {
                    Write-Host "Geen bestaande VM-data gevonden."
                }
	}
    
        '3' {
            if (-Not (Test-Path $CSVLocation)) {
                Write-Host "Geen bestaande configuraties gevonden."; break
            }

            $vmList = Import-Csv $CSVLocation
            Write-Host "`nBeschikbare VMs:"
            $vmList | ForEach-Object { Write-Host "- $($_.Guest)" }

            $chosenVM = Read-Host "`nVoer de naam van de VM in waaraan je een IP wilt toewijzen"
            $foundVM = $vmList | Where-Object { $_.Guest -eq $chosenVM }

            if (-not $foundVM) {
                Write-Host "VM '$chosenVM' niet gevonden."; break
            }

            $newIP = Read-Host "Voer het gewenste IP-adres in voor deze VM"
            if ($newIP -notmatch '^\d{1,3}(\.\d{1,3}){3}$') {
                Write-Host "Ongeldig IP-formaat."; break
            }

            # Update IP
            foreach ($vm in $vmList) {
                if ($vm.Guest -eq $chosenVM) {
                    $vm.IPs = $newIP
                }
            }

            # Overschrijf CSV
            $vmList | Export-Csv -Path $CSVLocation -NoTypeInformation
            Write-Host "`nIP-adres '$newIP' succesvol toegewezen aan VM '$chosenVM'."
        }


        '4' {
            $CSVLocation = 'C:\Temp\GuestInfo.CSV'
            # Vraag lijst VM's op m.b.v. CSV
            if (-Not (Test-Path $CSVLocation)) {Write-Host "Geen bestaande configuraties gevonden."; break}

            $vmList = Import-Csv $CSVLocation
            Write-Host "`nBeschikbare VMs:"
            $vmList | ForEach-Object { Write-Host "- $($_.Name)" }

            # Geef naam van de te verwijderen VM door
            $chosenVM = Read-Host "`nVoer de naam van de VM in dat u wilt verwijderen"
            $foundVM = $vmList | Where-Object { $_.Name -eq $chosenVM.ToString() }

            # Als gebruiker zover komt, wilt hij het verwijderen. Dus stel vraag...
            if ($foundVM.Name -eq $chosenVM) {
                Stop-VM -Name $foundVM.Name -Force 
                # VM is gestopt, wilt u hem verwijderen?
                $akk = Read-Host "Remove Virtual Machine? (y/n)"
                if ($akk -eq 'y') {Remove-VM -Name $foundVM.Name -Force}
                    else{$akk -eq 'n' ; break}  #  Add-VMHardDiskDrive -VMName $VMName -Path $vhdPath
                # Verwijder HDD, als de VM verwijderd wordt..
                if ($akk -eq 'y') {Remove-VMHardDiskDrive -VMName $foundVM.Name} # (controllertype 0 location 1) 
                    else {Write-Host "Geannuleerd!" ; break}
            if (-not $foundVM) {
                Write-Host "VM '$chosenVM' niet gevonden."; break
            }}}

        'q' 
		{
            Write-Host "Tot ziens!"
        }
    }
	}
until ($input -eq 'q')

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