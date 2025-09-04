$CSVLocation = 'C:\Temp\GuestInfo.CSV'

# Als CSV niet bestaat geef het door
if (-Not (Test-Path $CSVLocation)) {
    Write-Host "Geen bestaande configuraties gevonden."
    break
}

# Lijst alle beschikbare VM's
$vmList = Import-Csv $CSVLocation
Write-Host "`nBeschikbare VMs:"
$vmList | ForEach-Object { Write-Host "- $($_.Name)" }

# Kies VM uit een array
$chosenVM = Read-Host "`nVoer de naam van de VM in waaraan je een notitie wilt toevoegen"
$foundVM  = $vmList | Where-Object { $_.Name -eq $chosenVM } | Select-Object -First 1 

# Als een Null niet gelijk is aan de VM dat in de Array staat, zet notitie in Hyper-V en update CSV-bestand 
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

    # Schrijf informatie weg in CSV-bestand
    $vmList | Export-Csv -Path $CSVLocation -NoTypeInformation
    Write-Host "CSV en Hyper-V notities zijn bijgewerkt."
}
else {
    Write-Host "Geen VM gevonden met naam $chosenVM"
}                      