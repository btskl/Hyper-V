function ws_2019{
    New-VM -Name $VMName -MemoryStartupBytes $memoryBytes -SwitchName "vSwitch" -Generation 1

    # haal ip van server op zodat je iso kan ophalen via SSH/SCP voor het uitrollen van een vm
    # Gebruik $_ als PSItem, het is een variabele wat default configurated is in powershell.
    # $HyperV_IP = Get-NetIPConfiguration|Where-Object {$_.ipv4defaultgateway -ne $null} ; $ip.IPv4Address.ipaddress

    #stel de variabelen in die genodigd zijn voor het configureren van de virtuele machines: zoals IP-adressen, hostnamen, computernamen
    #op deze manier is het makkelijker gebruik te maken van de script en zal de script vereenvoudigen.
    # Definieer hostnaam RDP
    $hostnameRDP = (Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Where-Object { $_.DefaultIPGateway }).DefaultIPGateway | Select-Object -First 1
    Write-Host "hostnameRDP: $hostnameRDP"

    # Geef locatie ISO op
    $diskPath = "${env:USERPROFILE}\Desktop\ISOs\WS2019.iso"
        if (Test-Path $diskPath) {Remove-Item $diskPath -Force -ErrorAction SilentlyContinue}

    #stuur ISO-Bestand door naar variabele, d.m.v. private key.
    scp -i "${env:USERPROFILE}\.ssh\keypair" "localabb@${hostnameRDP}:\Users\localabb\Desktop\VMs\WS2019.iso" "$diskPath" 
    
    # geef hier aan of het bestand succesvol is overgezet of niet..
        if (Test-Path $diskPath) {Write-Host "`n✅ ISO-bestand is succesvol overgezet naar $diskPath" -ForegroundColor Green} 
            else {Write-Warning "`n❌ Overdracht mislukt. Bestand niet gevonden op $diskPath"}

    $BootDisk = Add-VMDvdDrive $VMName -Path $diskPath

    # # verwijder vhdx als het bestaat
    $vhdPath = "C:\Users\Public\Documents\Hyper-V\Virtual hard disks\$VMName.vhdx"
    if (Test-Path $vhdPath) {
        Remove-Item $vhdPath -Force
    }

    #maak nieuwe vhdx aan
    New-VHD -Path $vhdPath -SizeBytes $VHDiskBytes
    Add-VMHardDiskDrive -VMName $VMName -Path $vhdPath 

    #stel boot volgorde in en starten
    Set-VMBios "$VMName" -StartupOrder @("CD", "IDE", "LegacyNetworkAdapter", "Floppy")
    Start-VM -Name "$VMName"

    # comment als je aan het testen bent
    # Remove-VM 'test-vm'
}

function W10{
    New-VM -Name $VMName -MemoryStartupBytes $memoryBytes -SwitchName "vSwitch" -Generation 1

    # haal ip van server op zodat je iso kan ophalen via SSH/SCP voor het uitrollen van een vm
    $DefaultGW = Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Where-Object { $_.DefaultIPGateway } | Select-Object -ExpandProperty DefaultIPGateway

    #controleer pad naar ISO-map, haal overeenkomende bestanden weg
    $diskPath = "C:\Users\Administrator\Desktop\ISOs\Windows_10_LTSC.iso"
        if (Test-Path $diskPath) {
            Remove-Item $diskPath -Force -ErrorAction SilentlyContinue
        }

    scp -r -O localabb@"$DefaultGW":C:\Users\localabb\Desktop\VMs\Windows_10_LTSC.iso "$diskPath" #of de variabele scpPath
    # ipadressen kan hier een variabelen van gemaakt worden...

    $BootDisk = Add-VMDvdDrive $VMName -Path $diskPath

    # # verwijder vhdx als het bestaat
    $vhdPath = "C:\Users\Public\Documents\Hyper-V\Virtual hard disks\$VMName.vhdx"
    if (Test-Path $vhdPath) {
        Remove-Item $vhdPath -Force
    }

    #maak nieuwe vhdx aan
    New-VHD -Path $vhdPath -SizeBytes $VHDiskBytes
    Add-VMHardDiskDrive -VMName $VMName -Path $vhdPath 

    #stel boot volgorde in en starten
    Set-VMBios "$VMName" -StartupOrder @("CD", "IDE", "LegacyNetworkAdapter", "Floppy")
    Start-VM -Name "$VMName"

    # comment als je aan het testen bent
    # Remove-VM 'test-vm'
}