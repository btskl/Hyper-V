
#Vraag 2: Naam van de VM?
$VMName = Read-Host "Geef een naam door (bijv. Servernaam@Hostnaam.local)"
    if ($VMName -match '^\d+$') { $VMName = [string]$VMName }
    Write-Host "Naam van de Virtuele Machine: $VMName"

#Vraag 3: Hoeveel RAM?
$VMMemory = Read-Host "Geef het geheugen in GB (bijv. 8, 16, 32)"
    if ($VMMemory -match '^\d+$') { $memoryBytes = [int64]$VMMemory * 1GB }
    Write-Host "Geheugen ingesteld op $VMMemory GB ($memoryBytes bytes)"

#Vraag 4: Hoeveel Opslag?
$VHDisk = Read-Host "Geef het opslagcapaciteit in GB (bijv. 8, 16, 32)"
    if ($VHDisk -match '^\d+$') { $VHDiskBytes = [int64]$VHDisk * 1GB }
    Write-Host "Opslagcapaciteit ingesteld op $VHDisk GB ($VHDiskBytes bytes)"

#Vraag 5: Hoeveel VM's wilt u uitrollen?
$Aantal = Read-Host "Geef een aantal door (bijv. 2)" 
Write-Host "Zoveel VM's worden gemaakt: $Aantal" 
    for ($i = 1; $i -le $Aantal; $i++) {                        # zet een {integer+-1} bij elke iteratie (bv. bij 4 iteratie's = test-1 +-2 +-3 +-4)
        $VMName = "$VMName-$i"
        ws_2019 -VMName $VMName -MemoryGB $VMMemory -DiskGB $VHDisk -VMDvdDrive $diskPath
    }