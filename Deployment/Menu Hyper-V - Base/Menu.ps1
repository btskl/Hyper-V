function w10_ltsc{
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
    }
    # comment als je aan het testen bent
    # Remove-VM 'test-vm'
    w10_ltsc

function Show-Menu
{
    param(
        [string]$title = "ABB VM_beheer"
    )
    
    Write-Host "===============$title==============="
    Write-Host "1: Press '1' to deploy a bald VM - Windows 10 LTSC.iso”
    Write-Host "2: Press '2' to deploy mhurp"
    Write-Host "3: Press '3' to deploy derp"
    Write-Host "Q: Press 'Q' to exit"
}

    function keuze{
    Show-Menu
        While($true) {
            $input = Read-Host "Maak een keuze"
            Switch ($input) {
                if {($input)} -eq {('1')}
                w10_ltsc{}
                # ontwikkelen naar meerdere VM's tegelijk.
            '2' {Write-Host "Kies voor huppeldepup"}
            # ontwikkelen naar meerdere keuzes, denk aan hardware
            '3' {Write-Host "Kies voor nogeenkeerhuppeldepup"}
            # denk aan wat er in zo'n vm moet komen
            'Q' {Write-Host "Kies voor exit"}
            }
        }
    }
    keuze