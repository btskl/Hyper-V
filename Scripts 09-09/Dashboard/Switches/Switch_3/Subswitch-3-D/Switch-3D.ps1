$CSVLocation = 'C:\Temp\GuestInfo.CSV'

# Check of CSV bestaat
if (-Not (Test-Path $CSVLocation)) {
    Write-Host "Geen bestaande configuraties gevonden."
    break
}

# Lijst met VMs ophalen
$vmList = Import-Csv $CSVLocation
Write-Host "`nBeschikbare VMs:"
$vmList | ForEach-Object { Write-Host "- $($_.Name)" }

# Vraag meerdere namen (komma gescheiden)
$kiesVM = Read-Host "`nVoer de naam/namen in van de VMs die u wilt verwijderen (bijv. VM1,VM2,VM3)"
$kiesVMArray = $kiesVM -split '\s*,\s*'

# Vind de VMs in CSV
$vindVM = $vmList | Where-Object { $_.Name -in $kiesVMArray }

if ($vindVM.Count -gt 0) {
    Write-Host "`nDe volgende VM's worden verwijderd:" -ForegroundColor Yellow
    $vindVM | ForEach-Object {
        $vmName = $_.Name
        Write-Host "Verwijderen van VM: $vmName" -ForegroundColor Red

        try {
            # VM stoppen
            if ((Get-VM -Name $vmName -ErrorAction SilentlyContinue).State -ne 'Off') {
                Stop-VM -Name $vmName -Force -ErrorAction SilentlyContinue
            }

            # VHD verwijderen
            $vhdPathloc = "C:\ProgramData\Microsoft\Windows\Hyper-V\Virtual Hard Disks\$vmName.vhdx"
            if (Test-Path $vhdPathloc) {
                Remove-Item -Path $vhdPathloc -Recurse -Force -Confirm:$False
                Write-Host "  VHD verwijderd: $vhdPathloc"
            }

            # VM verwijderen
            Remove-VM -Name $vmName -Force -ErrorAction SilentlyContinue
            Write-Host "  VM verwijderd: $vmName" -ForegroundColor Green
        }
        catch {
            Write-Host ("  Fout bij verwijderen van {0}: {1}" -f $vmName, $_) -ForegroundColor Red
        }
    }

    # CSV updaten
    $updatedList = $vmList | Where-Object { $_.Name -notin $kiesVMArray }
    $updatedList | Export-Csv -Path $CSVLocation -NoTypeInformation

    Write-Host "`nCSV is bijgewerkt. Verwijderde VMs: $($vindVM.Name -join ', ')" -ForegroundColor Green
}
else {
    Write-Host "`nGeen van de opgegeven VM-namen zijn gevonden in de CSV." -ForegroundColor Red
}
Show_MenuH