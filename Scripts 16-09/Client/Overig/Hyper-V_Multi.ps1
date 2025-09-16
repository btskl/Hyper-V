. .\Hyper-V_enk.ps1
$vmLijst = @(
    @{ Name = "VM01"; MemoryGB = 4; DiskGB = 50 },
    @{ Name = "VM02"; MemoryGB = 2; DiskGB = 30 },
    @{ Name = "VM03"; MemoryGB = 8; DiskGB = 100 }
)

foreach ($vm in $vmLijst) {
    $name = $vm.Name
    $memoryBytes = $vm.MemoryGB * 1GB
    $vhdPath = "C:\VMs\$name\$name.vhdx"
    $vmPath = "C:\VMs\$name"

    # Maak VM-map
    New-Item -ItemType Directory -Path $vmPath -Force | Out-Null

    # Maak virtuele harde schijf
    New-VHD -Path $vhdPath -SizeBytes ($vm.DiskGB * 1GB) -Dynamic

    # Maak de VM aan
    New-VM -Name $name -MemoryStartupBytes $memoryBytes -Generation 2 -VHDPath $vhdPath -Path $vmPath

    Write-Host "VM $name is uitgerold."
}