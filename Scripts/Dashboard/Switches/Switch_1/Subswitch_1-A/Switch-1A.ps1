# Algemene Get-VM met genodigde info over VMs
$hosts = Get-VM | Select-Object ComputerName,Name,State,Notes,CreationTime,MemoryAssigned
$vraag = Read-Host "Wilt u een CSV genereren? Y/N"

# Geef Get-VM met CSV
if ($vraag -eq "Y") {$hosts | Export-Csv -Path $CSVLocation -NoTypeInformation -Force
    if (Test-Path $CSVLocation) {
        Import-Csv -Path $CSVLocation | Format-Table
        Write-Host "Overzicht geëxporteerd naar $CSVLocation"
        } 

        else {
            Write-Host "Geen bestaande VM-data gevonden."
            }
        }

# Geef Get-VM zonder CSV
if ($vraag -eq "N") {$hosts | Format-Table -AutoSize}