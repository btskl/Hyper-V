$listresume = Get-VM | Where-Object { $_.State -eq 'Paused' } |
Select-Object Name, State, Uptime, CreationTime
$listresume | Format-Table -AutoSize
Write-Host "U heeft optie E gekozen`n"

$chosenVMresume = Read-Host "`nVoer de naam van de VMs in die u wilt starten (bijv. VM1,VM2,VM3)"
$chosenVMArray = $chosenVMresume -split '\s*,\s*'
# start-vm indien beschikbaar, zo niet toon melding dat er geen VM's uitstaan en verlaat
foreach ($vm in $listresume) {
    if ($vm.Name -in $chosenVMArray) {
        Resume-VM -Name $vm.Name
        Write-Host "VM '$($vm.Name)' wordt hervat."}
        }
    Show_MenuH