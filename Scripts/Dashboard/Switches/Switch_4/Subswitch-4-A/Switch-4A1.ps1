$CSVLocation = 'C:\Temp\GuestInfo.CSV'

if (-Not (Test-Path $CSVLocation)) {
    Write-Host "Geen bestaande configuraties gevonden."
    break
}

$vmList = Import-Csv $CSVLocation
Write-Host "`nBeschikbare VMs:"
$vmList | ForEach-Object { Write-Host "- $($_.Name)" }

# Kies VM
$chosenVM = Read-Host "`nVoer de naam van de VM in waaraan je een notitie wilt toevoegen"
$foundVM  = $vmList | Where-Object { $_.Name -eq $chosenVM } | Select-Object -First 1 

if ($null -ne $foundVM) {
    $noteText = Read-Host "Voer de notitie in voor VM '$($foundVM.Name)'"

    # Zet de notitie in Hyper-V
    Set-VM -Name $foundVM.Name -Notes $noteText

    # Update CSV met nieuwe notitie
    foreach ($vm in $vmList) {
        if ($vm.Name -eq $chosenVM) {
            $vm.Notes = $noteText
        }
    }

    $vmList | Export-Csv -Path $CSVLocation -NoTypeInformation
    Write-Host "CSV en Hyper-V notities zijn bijgewerkt."
}
else {
    Write-Host "Geen VM gevonden met naam $chosenVM"
}
Show_MenuH                       