Write-Host "U heeft gekozen voor WS2019"

# Verzin een naam
$VMName = Read-Host "Geef de naam van de nieuwe VM"
if (-not $VMName) { Write-Host "❌ Geen VM-naam ingevoerd. Stop."; break }

& Scripts\Dashboard\Main\New_VM.ps1
# Quick-Start instellingen
$memoryBytes   = 2GB
$VHDiskBytes   = 60GB

# Geef het aantal door
$Aantal = Read-Host "Geef een aantal door (bijv. 2)" 
Write-Host "Zoveel VM's worden gemaakt: $Aantal" 
    for ($i = 1; $i -le $Aantal; $i++) {                        # zet een {integer+-1} bij elke iteratie (bv. bij 4 iteratie's = test-1 +-2 +-3 +-4)
        $VMName = "$VMName-$i"
        ws_2019 -VMName $VMName -MemoryGB $memoryBytes -DiskGB $VHDisk -VMDvdDrive $diskPath
    }