$hostnameRDP = (Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Where-Object { $_.DefaultIPGateway }).DefaultIPGateway | Select-Object -First 1
$diskPathws2019 = "${env:USERPROFILE}\Desktop\ISOs\WS2019.iso"
$diskPathw10 = "${env:USERPROFILE}\Desktop\ISOs\Windows_10_LTSC.iso"
$diskPathlx = "${env:USERPROFILE}\Desktop\ISOs\cd1_v7.50.0.iso"
$CSVProjects = 'C:\Temp\Projects.csv'

function ws_2019{
    New-VM -Name $VMName -MemoryStartupBytes $memoryBytes -Generation 1

    # haal ip van server op zodat je iso kan ophalen via SSH/SCP voor het uitrollen van een vm
    # Gebruik $_ als PSItem, het is een variabele wat default configurated is in powershell.
    # $HyperV_IP = Get-NetIPConfiguration|Where-Object {$_.ipv4defaultgateway -ne $null} ; $ip.IPv4Address.ipaddress

    #stel de variabelen in die genodigd zijn voor het configureren van de virtuele machines: zoals IP-adressen, hostnamen, computernamen
    #op deze manier is het makkelijker gebruik te maken van de script en zal de script vereenvoudigen.
    # Definieer hostnaam RDP
    Write-Host "hostnameRDP: $hostnameRDP"

    # Geef locatie ISO op

    # stuur ISO-Bestand door naar variabele, d.m.v. private key.
    # Pas op dat je geen resursief flag geeft -r
    # start-process 'icacls.exe' -ArgumentList "${diskPath}" /grant "$env:USERNAME:""F" voor de rechten
    $diskPathws2019 = "${env:USERPROFILE}\Desktop\ISOs\"

    # Controleer of het ISO-bestand al lokaal aanwezig is
    $isoFile = Join-Path $diskPathws2019 "WS2019.iso"

    if (Test-Path $isoFile) {
        Write-Host "ℹ️  Lokaal ISO-bestand al aanwezig: $isoFile – overslaan van SCP." -ForegroundColor Yellow
    }
    else {
        Write-Host "⬇️  ISO niet gevonden, downloaden vanaf $hostnameRDP..." -ForegroundColor Cyan
        scp -i "${env:USERPROFILE}\.ssh\id_rsa" `
            "Administrator@${hostnameRDP}:C:\Users\Administrator\Desktop\ISOs\WS2019.iso" `
            "$diskPathws2019"

        if ($LASTEXITCODE -ne 0 -or -not (Test-Path $isoFile)) {
            Write-Warning "❌ Overdracht mislukt (exitcode: $LASTEXITCODE). Bestand niet gevonden op $isoFile."
            return
        }

        Write-Host "✅ ISO-bestand is succesvol overgezet naar $isoFile" -ForegroundColor Green
    }

    # Gebruik het ISO-bestand voor de VM
    Add-VMDvdDrive -VMName $VMName -Path $isoFile


    # $BootDisk = Add-VMDvdDrive $VMName -Path $testISO
    #     if (Test-Path $testISO) {Add-VMDvdDrive $VMName -Path $diskPath}
    #         else {$testISO}

    # # verwijder vhdx als het bestaat
    $vhdPath = "C:\ProgramData\Microsoft\Windows\Hyper-V\Virtual Hard Disks\$VMName.vhdx"

    # maak nieuwe vhd aan
    $VHDiskBytes = $diskGB * 1GB
    New-VHD -Path $vhdPath -SizeBytes $VHDiskBytes
    Add-VMHardDiskDrive -VMName $VMName -Path $vhdPath 

    #stel boot volgorde in en starten
    Set-VMBios "$VMName" -StartupOrder @("CD", "IDE", "LegacyNetworkAdapter", "Floppy")
    Start-VM -Name "$VMName"

    # comment als je aan het testen bent
    # Remove-VM 'test-vm'
}   

function W10{
    New-VM -Name $VMName -MemoryStartupBytes $memoryBytes -Generation 1

    # haal ip van server op zodat je iso kan ophalen via SSH/SCP voor het uitrollen van een vm
    # Gebruik $_ als PSItem, het is een variabele wat default configurated is in powershell.
    # $HyperV_IP = Get-NetIPConfiguration|Where-Object {$_.ipv4defaultgateway -ne $null} ; $ip.IPv4Address.ipaddress

    #stel de variabelen in die genodigd zijn voor het configureren van de virtuele machines: zoals IP-adressen, hostnamen, computernamen
    #op deze manier is het makkelijker gebruik te maken van de script en zal de script vereenvoudigen.
    # Definieer hostnaam RDP
    Write-Host "hostnameRDP: $hostnameRDP"

    $diskPathw10 = "${env:USERPROFILE}\Desktop\ISOs\"

    # Controleer of het ISO-bestand al lokaal aanwezig is
    $isoFilew10 = Join-Path $diskPathw10 "Windows_10_LTSC.iso"
    # Geef locatie ISO op

    # stuur ISO-Bestand door naar variabele, d.m.v. private key.
    # Pas op dat je geen resursief flag geeft -r
    # start-process 'icacls.exe' -ArgumentList "${diskPath}" /grant "$env:USERNAME:""F" voor de rechten
    
    if (Test-Path $isoFilew10) {
        Write-Host "ℹ️  Lokaal ISO-bestand al aanwezig: $isoFilew10 – overslaan van SCP." -ForegroundColor Yellow
    }
    else {
        Write-Host "⬇️  ISO niet gevonden, downloaden vanaf $hostnameRDP..." -ForegroundColor Cyan
        scp -i "${env:USERPROFILE}\.ssh\id_rsa" `
            "Administrator@${hostnameRDP}:C:\Users\Administrator\Desktop\ISOs\Windows_10_LTSC.iso" `
            "$diskPathw10"

        if ($LASTEXITCODE -ne 0 -or -not (Test-Path $isoFilew10)) {
            Write-Warning "❌ Overdracht mislukt (exitcode: $LASTEXITCODE). Bestand niet gevonden op $isoFilew10."
            return
        }

        Write-Host "✅ ISO-bestand is succesvol overgezet naar $isoFilew10" -ForegroundColor Green
    }
    # $BootDisk = Add-VMDvdDrive $VMName -Path $testISO
    #     if (Test-Path $testISO) {Add-VMDvdDrive $VMName -Path $diskPath}
    #         else {$testISO}
    
    # Gebruik het ISO-bestand voor de VM
    Add-VMDvdDrive -VMName $VMName -Path $isoFilew10
    # # verwijder vhdx als het bestaat
    $vhdPath = "C:\ProgramData\Microsoft\Windows\Hyper-V\Virtual Hard Disks\$VMName.vhdx"

    # maak nieuwe vhd aan
    $VHDiskBytes = $diskGB * 1GB
    New-VHD -Path $vhdPath -SizeBytes $VHDiskBytes
    Add-VMHardDiskDrive -VMName $VMName -Path $vhdPath 

    #stel boot volgorde in en starten
    Set-VMBios "$VMName" -StartupOrder @("CD", "IDE", "LegacyNetworkAdapter", "Floppy")
    Start-VM -Name "$VMName"



    # comment als je aan het testen bent
    # Remove-VM 'test-vm'
}

function lx{
    New-VM -Name $VMName -MemoryStartupBytes $memoryBytes -Generation 1

    # haal ip van server op zodat je iso kan ophalen via SSH/SCP voor het uitrollen van een vm
    # Gebruik $_ als PSItem, het is een variabele wat default configurated is in powershell.
    # $HyperV_IP = Get-NetIPConfiguration|Where-Object {$_.ipv4defaultgateway -ne $null} ; $ip.IPv4Address.ipaddress

    #stel de variabelen in die genodigd zijn voor het configureren van de virtuele machines: zoals IP-adressen, hostnamen, computernamen
    #op deze manier is het makkelijker gebruik te maken van de script en zal de script vereenvoudigen.
    # Definieer hostnaam RDP
    Write-Host "hostnameRDP: $hostnameRDP"

    # Geef locatie ISO op

    # stuur ISO-Bestand door naar variabele, d.m.v. private key.
    # Pas op dat je geen resursief flag geeft -r
    # start-process 'icacls.exe' -ArgumentList "${diskPath}" /grant "$env:USERNAME:""F" voor de rechten
    
    # geef hier aan of het bestand succesvol is overgezet of niet..
        if (Test-Path $diskPathlx) {Add-VMDvdDrive $VMName -Path $diskPathlx ; Write-Host "`n✅ ISO-bestand is succesvol overgezet naar $diskPathlx" -ForegroundColor Green} 
            else {scp -i "${env:USERPROFILE}\.ssh\keypair" "localabb@${hostnameRDP}:\Users\localabb\Desktop\VMs\Windows_10_LTSC.iso" "$diskPathlx" ; Write-Warning "`n❌ 1ste overdracht mislukt. Bestand niet gevonden op $diskPathlx, zet ISO bestand over!"}

    # $BootDisk = Add-VMDvdDrive $VMName -Path $testISO
    #     if (Test-Path $testISO) {Add-VMDvdDrive $VMName -Path $diskPath}
    #         else {$testISO}

    # # verwijder vhdx als het bestaat
    $vhdPath = "C:\ProgramData\Microsoft\Windows\Hyper-V\Virtual Hard Disks\$VMName.vhdx"

    # maak nieuwe vhd aan
    $VHDiskBytes = $diskGB * 1GB
    New-VHD -Path $vhdPath -SizeBytes $VHDiskBytes
    Add-VMHardDiskDrive -VMName $VMName -Path $vhdPath 

    #stel boot volgorde in en starten
    Set-VMBios "$VMName" -StartupOrder @("CD", "IDE", "LegacyNetworkAdapter", "Floppy")
    Start-VM -Name "$VMName"

    # comment als je aan het testen bent
    # Remove-VM 'test-vm'
}   