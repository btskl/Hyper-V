# Geef CSV-locatie op in een variabele
$CSVLocation = 'C:\Temp\GuestInfo.CSV'

# Check of CSV bestaat
if (-Not (Test-Path $CSVLocation)) {
    Write-Host "Geen bestaande configuraties gevonden."
    break}

# Lijst met VMs ophalen
$vmList = Import-Csv $CSVLocation
Write-Host "`nBeschikbare VMs:"
$vmList | ForEach-Object { Write-Host "- $($_.Name)" }

# Vraag meerdere namen (komma gescheiden)
$kiesVM = Read-Host "`nVoer de naam van de VMs in die u wilt stoppen (bijv. VM1,VM2,VM3)"
$kiesVMArray = $kiesVM -split '\s*,\s*'   # Splits op komma's, verwijdert spaties

# Vind VMs die in CSV staan
$vindVMs = $vmList | Where-Object { $_.Name -in $kiesVMArray }

if ($vindVMs.Count -gt 0) { # als het aantal doorgegeven minder dan nul is, geef VM's door die eerder gestopt zijn
    Write-Host "`nVM's gevonden in CSV en worden gestopt:" -ForegroundColor Yellow
    $vindVMs | ForEach-Object {
        Write-Host "Stopping VM: $($_.Name)"
        Stop-VM -Name $_.Name -Force
    }

    # CSV updaten (verwijder gestopte VMs)
    $updatedList = $vmList | Where-Object { $_.Name -notin $kiesVMArray }
    $updatedList | Export-Csv -Path $CSVLocation -NoTypeInformation

    # Scheid tabellen met een komma
    Write-Host "`nCSV is bijgewerkt. Gestopte VMs: $($vindVMs.Name -join ', ')" -ForegroundColor Green
}
    # Anders geef door dat er niets is gevonden
else {
    Write-Host "`nGeen van de opgegeven VM-namen zijn gevonden in de CSV." -ForegroundColor Red
}