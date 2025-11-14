# Algemene Get-VM met genodigde info over VMs
$hosts = Get-VM | Select-Object ComputerName,Name,State,Notes,CreationTime,MemoryAssigned
 | Export-Csv -Path $CSVLocation -NoTypeInformation -Force
 
if (Test-Path $CSVLocation) {
    Import-Csv -Path $CSVLocation | Format-Table
    Write-Host "Overzicht geëxporteerd naar $CSVLocation"
    } 

    else {
        Write-Host "Geen bestaande VM-data gevonden."
        }
$hosts | Format-Table -AutoSize

# CSV locatie
$CSVLocation = "C:\Temp\VMInfo.csv"

# Haal VM info op
$vmList = Get-VM | Select-Object Name, ComputerName, State, Notes, MemoryAssigned, CPUUsage, Uptime
$vmCount = $vmList.Count

# Toon overzicht
Write-Host "`nBeschikbare VM's:"
for ($i=0; $i -lt $vmCount; $i++) {
    Write-Host "$($i+1). $($vmList[$i].Name) - Status: $($vmList[$i].State)"
}

$vmList | Export-Csv -Path $CSVLocation -NoTypeInformation -Force
Write-Host "`nCSV geëxporteerd naar $CSVLocation"


# Menu voor gedetailleerde info
Write-Host "`nDruk op het nummer van de VM voor gedetailleerde info, of 'Q' om te stoppen"
$selection = Read-Host "Maak uw keuze"

switch ($selection) {
    {$_ -match '^\d+$'} {
        $index = [int]$_ - 1
        if ($index -ge 0 -and $index -lt $vmCount) {
            $vm = $vmList[$index]
            Write-Host "`nDetails voor VM: $($vm.Name)" -ForegroundColor Yellow
            Write-Host "Host: $($vm.ComputerName)"
            Write-Host "Status: $($vm.State)"
            Write-Host "Notes: $($vm.Notes)"
            Write-Host "Geheugen (MB): $([math]::Round($vm.MemoryAssigned/1MB,2))"
            Write-Host "CPU Usage (%): $($vm.CPUUsage)"
            Write-Host "Uptime: $($vm.Uptime)"
        } else {
            Write-Host "Ongeldige keuze."
        }
    }
    'Q' { Write-Host "Afsluiten..."; break }
    Default { Write-Host "Ongeldige keuze." }
}