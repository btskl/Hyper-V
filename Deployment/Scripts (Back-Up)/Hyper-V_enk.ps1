. .\Dashboard_DOS.ps1
function W10{
$VMName = "test-vm"

    $VMMemory = Read-Host "Geef het geheugen in GB (bijv. 8, 16, 32)"
    if ($VMMemory -match '^\d+$') {
        $memoryBytes = [int64]$VMMemory * 1GB
        
        Write-Host "Geheugen ingesteld op $($VMMemory)GB ($memoryBytes bytes)"

    New-VM -Name $VMName -MemoryStartupBytes $VMMemory -SwitchName "vSwitch" -Generation 1

    # haal ip van server op zodat je iso kan ophalen via SSH/SCP voor het uitrollen van een vm
    $DefaultGW = (Get-NetRoute "0.0.0.0/0").NextHop

    # controleer pad naar ISO-map, haal overeenkomende bestanden weg
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
    New-VHD -Path $vhdPath -SizeBytes 20GB
    Add-VMHardDiskDrive -VMName $VMName -Path $vhdPath 

    #stel boot volgorde in en starten
    Set-VMBios "$VMName" -StartupOrder @("CD", "IDE", "LegacyNetworkAdapter", "Floppy")
    Stop-VM -Name $VMName -Force

    # comment als je aan het testen bent
    # Remove-VM 'test-vm'
}}