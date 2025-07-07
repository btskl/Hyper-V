. .\Hyper-V_enk.ps1
Enable-VMResourceMetering -VMName $VMName
Measure-VM -Name $VMName