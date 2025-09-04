# Haal host info op door commando's door te sturen via PowerShell naar de VM 
$hostInfo = Get-CimInstance -ClassName Win32_ComputerSystem
$osInfo   = Get-CimInstance -ClassName Win32_OperatingSystem
$hosts = Get-CimInstance -ClassName Win32_ComputerSystem #-ComputerName Enable PSremoting

# Prop alle genodigde informatie in een tabel door het volgende mede dankzij de module voor Active Directory te gebruiken 
$hostSummary = [PSCustomObject]@{
    HostName          = $hostInfo.Name
    OperatingSystem   = Get-ADComputer -Filter * -Property OperatingSystem | Select-Object OperatingSystem
    TotalMemoryGB     = [math]::Round($osInfo.TotalVisibleMemorySize / 1MB,2)
    FreeMemoryGB      = [math]::Round($osInfo.FreePhysicalMemory / 1MB,2)
    UsedMemoryGB      = [math]::Round(($osInfo.TotalVisibleMemorySize - $osInfo.FreePhysicalMemory) / 1MB,2)
}

#Haal OS op door gebruik te maken van Get-ADComputer, en filter de OS eruit
Get-ADComputer -Filter {OperatingSystem -like "*Hyper-V*"} -Property OperatingSystem | 
Select-Object Name, OperatingSystem

# Haal per VM info op
$vmInfo = Get-VM | ForEach-Object {
    $vm = $_
    $mem = Get-VMMemory -VMName $vm.Name
    [PSCustomObject]@{
        VMName         = $vm.Name
        VMState        = $vm.State
        AssignedMemory = [math]::Round($vm.MemoryAssigned / 1MB,2)
        OperatingSystem = (Get-ComputerInfo).WindowsProductName
    }
}

# Algemene Get-VM met genodigde info over VMs
$vraag = Read-Host "Wilt u een CSV genereren? Y/N"

# Geef Get-VM met CSV
if ($vraag -eq "Y") {
        $hostSummary | Export-Csv -Path $CSVLocMem -NoTypeInformation -Force
        $vmInfo | Export-Csv -Path $CSVLocMem -NoTypeInformation -Force
    if (Test-Path $CSVLocMem) {
        Import-Csv -Path $CSVLocMem | Format-Table
        Write-Host "Overzicht geëxporteerd naar $CSVLocMem"
        } 

        else {
            Write-Host "Geen bestaande VM-data gevonden."
            }
        }

# Geef Get-VM zonder CSV
if ($vraag -eq "N") {
    $vmInfo | Format-Table -AutoSize
    }

# Zet info netjes in een tabel
$hostSummary | Format-Table -AutoSize
$vmInfo | Format-Table -AutoSize
    