Write-Host = "U heeft optie C gekozen`n"
$listpause = Get-VM | Where-Object { $_.State -eq 'Running' } |
Select-Object Name, State, Uptime, CreationTime
$listpause | Format-Table -AutoSize
Write-Host "U heeft optie C gekozen`n"

$chosenVMpause = Read-Host "`nVoer de naam van de VMs in die u wilt starten (bijv. VM1,VM2,VM3)"
$chosenVMArray = $chosenVMpause -split '\s*,\s*'
# start-vm indien beschikbaar, zo niet toon melding dat er geen VM's uitstaan en verlaat
foreach ($vm in $listpause) {
    if ($vm.Name -in $chosenVMArray) {
        Suspend-VM -Name $vm.Name
        Write-Host "VM '$($vm.Name)' gepauseerd."
        }
    }
Show_MenuH