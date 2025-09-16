Write-Host "U heeft gekozen voor W10"
$VMName = Read-Host "Geef de naam van de nieuwe VM"
if (-not $VMName) { Write-Host "❌ Geen VM-naam ingevoerd. Stop."; break }

# Standaard instellingen
$memoryBytes   = 2GB
$VHDiskBytes   = 60GB

$Aantal = Read-Host "Geef een aantal"

Write-Host "Zoveel VM's worden gemaakt: $Aantal" 
    for ($i = 1; $i -le $Aantal; $i++) {                        # zet een {integer+-1} bij elke iteratie (bv. bij 4 iteratie's = test-1 +-2 +-3 +-4)
        $VMName = "$VMName-$i"
        W10 -VMName $VMName -MemoryGB $memoryBytes -DiskGB $VHDisk -VMDvdDrive $diskPath
    }