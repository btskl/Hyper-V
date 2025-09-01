Write-Host = "U heeft optie C gekozen"

# Voer VM's door die draaien
$listpause = Get-VM | Where-Object { $_.State -eq 'Running' } |

# Schrijf VM's uit op de terminal in table-format
Select-Object Name, State, Uptime, CreationTime
$listpause | Format-Table -AutoSize

# Geef VM's door die gepauseerd moeten worden
$chosenVMpause = Read-Host "`nVoer de naam van de VMs in die u wilt starten (bijv. VM1,VM2,VM3)"
$chosenVMArray = $chosenVMpause -split '\s*,\s*'

# Start-VM indien beschikbaar, zo niet toon melding dat er geen VM's uitstaan en verlaat
foreach ($vm in $listpause) {
    if ($vm.Name -in $chosenVMArray) {
        Suspend-VM -Name $vm.Name
        Write-Host "VM '$($vm.Name)' gepauseerd."
        }
    }