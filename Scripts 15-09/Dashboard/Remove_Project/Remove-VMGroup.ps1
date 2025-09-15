& C:\Users\Administrator\Desktop\Scripts\Dashboard\Remove_Project\Overzicht.ps1
# Pad naar CSV (pas aan indien nodig)
$CSVLocGRnotes = "C:\Temp\GroupNotes.csv"

$grpName = Read-Host "Geef de naam van de groep die verwijderd moet worden"
$grp = Get-VMGroup -Name $grpName -ErrorAction SilentlyContinue

if (-not $grp) {
    Write-Host "❌ Groep '$grpName' niet gevonden." -ForegroundColor Red
    return
}

Write-Host "`n--- Start verwijderen van groep '$grpName' ---`n" -ForegroundColor Cyan

if ($grp.VMMembers.Count -eq 0) {
    Write-Host "ℹ️ Groep '$grpName' bevat geen VM's." -ForegroundColor Yellow
} else {
    foreach ($vm in $grp.VMMembers) {
        $vmName = $vm.Name
        Write-Host "➡️ Verwerken VM: $vmName" -ForegroundColor White

        try {
            # VM stoppen indien actief
            $vmState = (Get-VM -Name $vmName -ErrorAction SilentlyContinue).State
            if ($vmState -eq 'Running') {
                Stop-VM -Name $vmName -Force -Confirm:$false
                Write-Host "  ⏹️ VM '$vmName' gestopt." -ForegroundColor Yellow
            }

            # VM verwijderen uit Hyper-V
            Remove-VM -Name $vmName -Force -Confirm:$false
            Write-Host "  ✅ VM '$vmName' verwijderd." -ForegroundColor Green

            # Pad naar de VHD
            $vhdPathloc = "C:\ProgramData\Microsoft\Windows\Hyper-V\Virtual Hard Disks\$vmName.vhdx"

            # VHD verwijderen
            if (Test-Path $vhdPathloc) {
                Remove-Item -Path $vhdPathloc -Recurse -Force -Confirm:$false
                Write-Host "  🗑️ VHD verwijderd: $vhdPathloc" -ForegroundColor Green
            } else {
                Write-Host "  ⚠️ Geen VHD gevonden voor $vmName" -ForegroundColor Yellow
            }
        }
        catch {
            Write-Host "❌ Fout bij verwerken van VM '$vmName': $_" -ForegroundColor Red
        }
    }
}

# Verwijder de groep zelf
try {
    Remove-VMGroup -Name $grp.Name -Force -Confirm:$false
    Write-Host "✅ Groep '$($grp.Name)' verwijderd." -ForegroundColor Green
}
catch {
    Write-Host "❌ Fout bij verwijderen van groep '$($grp.Name)': $_" -ForegroundColor Red
}

# Verwijder notities uit CSV
if (Test-Path $CSVLocGRnotes) {
    try {
        $notes = Import-Csv $CSVLocGRnotes
        $updatedNotes = $notes | Where-Object { $_.Name -ne $grp.Name }
        $updatedNotes | Export-Csv $CSVLocGRnotes -NoTypeInformation -Force -Encoding UTF8
        Write-Host "✅ Notities voor '$($grp.Name)' verwijderd uit CSV." -ForegroundColor Green
    }
    catch {
        Write-Host "❌ Fout bij opschonen van CSV: $_" -ForegroundColor Red
    }
} else {
    Write-Host "⚠️ CSV-bestand met notities niet gevonden: $CSVLocGRnotes" -ForegroundColor Yellow
}

Write-Host "`n--- Verwijderen voltooid ---`n" -ForegroundColor Green
