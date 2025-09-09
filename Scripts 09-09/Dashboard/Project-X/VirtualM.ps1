. .\Scripts\Dashboard\Project-X\Overzicht.ps1
$grp = Get-VMGroup -Name $newgroup -ErrorAction SilentlyContinue | Select-Object -First 1

if (-not $grp) {
    Write-Host "❌ Groep '$newgroup' niet gevonden."
}

Write-Host "U heeft gekozen voor WS2019"

# Verzin een naam
$VMName = Read-Host "Geef de naam van de nieuwe VM"
if (-not $VMName) { Write-Host "❌ Geen VM-naam ingevoerd. Stop."; break }

. C:\Users\Administrator\Desktop\Scripts\Dashboard\Main\New_VM.ps1
# Quick-Start instellingen
$memoryBytes   = 2GB
$VHDiskBytes   = 60GB

# Geef het aantal door
$Aantal = Read-Host "Geef een aantal door (bijv. 2)" 
Write-Host "Zoveel VM's worden gemaakt: $Aantal" 
    for ($i = 1; $i -le $Aantal; $i++) {                        # zet een {integer+-1} bij elke iteratie (bv. bij 4 iteratie's = test-1 +-2 +-3 +-4)
        $VMName = "$VMName-$i"
        ws_2019 -VMName $VMName -MemoryGB $memoryBytes -DiskGB $VHDisk -VMDvdDrive $diskPath

    # & C:\Users\Administrator\Desktop\Scripts\Dashboard\Switches\Switch_4\Subswitch-4-B\Switch-4B.ps1
    }

    

        $vm = Get-VM -Name $VMName -ErrorAction SilentlyContinue

        if (-not $vm) {
            Write-Host "❌ VM '$VMName' niet gevonden."
        }
        elseif ($grp.VMMembers.Name -contains $vm.Name) {
            Write-Host "ℹ️ VM '$VMName' zit al in groep '$newgroup'."
        }
        else {
            try {
                Add-VMGroupMember -VMGroup $grp -VM $vm -Confirm:$false
                Write-Host "✅ VM '$VMName' toegevoegd aan groep '$newgroup'."
            } catch {
                Write-Host "❌ Fout bij toevoegen: $_"
            }
        }