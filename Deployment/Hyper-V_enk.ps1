New-VM -Name "test-vm" -MemoryStartupBytes 3GB -SwitchName "vSwitch" -Generation 1

# controleer pad naar ISO-map
$scpPath = "C:\Users\Administrator\Desktop\ISO's\Windows_10_LTSC.iso"
if (Test-Path $scpPath) {
    Remove-Item $scpPath -Force
}

scp -r -O "localabb@192.168.200.98:C:\Users\localabb\niksnutw7\vm\Windows_10_LTSC.iso" "C:\Users\Administrator\Desktop\ISO's\Windows_10_LTSC.iso"
# ipadressen kan hier een variabelen van gemaakt worden...

$BootDiskPath = "C:\Users\Administrator\Desktop\ISO's\Windows_10_LTSC.iso"
$BootDisk = Add-VMDvdDrive 'test-vm' -Path $BootDiskPath

# verwijder vhdx als het bestaat
$vhdPath = 'C:\Users\Public\Documents\Hyper-V\Virtual hard disks\test-vm.vhdx'
if (Test-Path $vhdPath) {
    Remove-Item $vhdPath -Force
}

#maak nieuwe vhdx aan
New-VHD -Path $vhdPath -SizeBytes 20GB -Dynamic

#stel boot volgorde in
Set-VMBios 'test-vm' -StartupOrder @("CD", "IDE", "LegacyNetworkAdapter", "Floppy")

Start-VM -Name 'test-vm'

# comment als je aan het testen bent
# Remove-VM 'test-vm'