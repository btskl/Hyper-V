# Haal alle VM's op die niet aan staan, met de doorgegeven objecten
$liststart = Get-VM | Where-Object { $_.State -eq 'Off' } |
Select-Object Name, State, Uptime, CreationTime

# schrijf alle data uit in terminal.
$liststart | Format-Table -AutoSize
Write-Host "U heeft optie A gekozen`n"

# Kies de doorgegeven VM's en voeg ze door naar de Array-variabele
$chosenVMstart = Read-Host "`nVoer de naam van de VMs in die u wilt starten (bijv. VM1,VM2,VM3)"
$chosenVMArray = $chosenVMstart -split '\s*,\s*'

# Start-vm indien beschikbaar, zo niet toon melding dat er geen VM's uitstaan en verlaat
foreach ($vm in $liststart) {
    if ($vm.Name -in $chosenVMArray) {
        Start-VM -Name $vm.Name
        Write-Host "VM '$($vm.Name)' gestart."
        }
    }