$liststart = Get-VM | Where-Object { $_.State -eq 'Off' } |
Select-Object Name, State, Uptime, CreationTime
$liststart | Format-Table -AutoSize
Write-Host "U heeft optie A gekozen`n"

$chosenVMstart = Read-Host "`nVoer de naam van de VMs in die u wilt starten (bijv. VM1,VM2,VM3)"
$chosenVMArray = $chosenVMstart -split '\s*,\s*'
# start-vm indien beschikbaar, zo niet toon melding dat er geen VM's uitstaan en verlaat
foreach ($vm in $liststart) {
    if ($vm.Name -in $chosenVMArray) {
        Start-VM -Name $vm.Name
        Write-Host "VM '$($vm.Name)' gestart."
        }
    }
Show_MenuH