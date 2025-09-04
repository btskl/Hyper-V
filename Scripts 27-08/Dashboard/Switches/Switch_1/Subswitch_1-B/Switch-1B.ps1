    # Haal host info op
    
    $hostInfo = Get-CimInstance -ClassName Win32_ComputerSystem
    $osInfo   = Get-CimInstance -ClassName Win32_OperatingSystem
    $hosts = Get-CimInstance -ClassName Win32_ComputerSystem #-ComputerName Enable PSremoting

    $hostSummary = [PSCustomObject]@{
        HostName          = $hostInfo.Name
        OperatingSystem   = Get-ADComputer -Filter * -Property OperatingSystem | Select-Object OperatingSystem
        TotalMemoryGB     = [math]::Round($osInfo.TotalVisibleMemorySize / 1MB,2)
        FreeMemoryGB      = [math]::Round($osInfo.FreePhysicalMemory / 1MB,2)
        UsedMemoryGB      = [math]::Round(($osInfo.TotalVisibleMemorySize - $osInfo.FreePhysicalMemory) / 1MB,2)
    }

    Get-ADComputer -Filter {OperatingSystem -like "*Hyper-V*"} -Property OperatingSystem | 
    Select-Object Name, OperatingSystem

    # Probeer OS op te halen via PowerShell Direct
    # Credentials vereist voor het opvragen van OS-versie, in verband met Invoke-Command.
        try {
            $vm = $_
            $os = $AD
        }
        catch {
            $os = "Onbekend"
        }

    # Haal VM info op
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
    
    $hostSummary | Format-Table -AutoSize
    $vmInfo | Format-Table -AutoSize
    Show_MenuH