<#
.SYNOPSIS
  Verwijdert één of meerdere Hyper-V VM-groepen inclusief hun VM's, VHD's en notities uit CSV.

.DESCRIPTION
  Dit script vraagt de gebruiker om één of meerdere groepsnamen, toont het beschikbare geheugen,
  en verwerkt elke groep apart zonder de sessie te beëindigen.

  Auteur: ChatGPT (GPT-5)
  Versie: 2.1 – 2025-11-09
#>

# === Instellingen ===
$CSVLocGRnotes = "C:\Temp\GroupNotes.csv"

# === Functie: Toon systeeminfo ===
function Show-SystemMemory {
    $os = Get-CimInstance Win32_OperatingSystem
    $totalGB = [math]::Round($os.TotalVisibleMemorySize / 1MB, 1)
    $freeGB = [math]::Round($os.FreePhysicalMemory / 1MB, 1)
    Write-Host "`n🧠 Geheugen beschikbaar: $freeGB GB vrij van $totalGB GB totaal`n" -ForegroundColor Cyan
}

# === Functie: Verwijder één groep ===
function Remove-VMGroupAndContent {
    param (
        [Parameter(Mandatory=$true)]
        [string]$GroupName
    )

    $grp = Get-VMGroup -Name $GroupName -ErrorAction SilentlyContinue
    if (-not $grp) {
        Write-Host "❌ Groep '$GroupName' niet gevonden." -ForegroundColor Red
        return
    }

    Write-Host "`n--- Start verwijderen van groep '$GroupName' ---`n" -ForegroundColor Cyan

    # Verwerk alle VM's in de groep
    if ($grp.VMMembers.Count -eq 0) {
        Write-Host "ℹ️ Groep '$GroupName' bevat geen VM's." -ForegroundColor Yellow
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

                # Pad naar VHD
                $vhdPath = "C:\ProgramData\Microsoft\Windows\Hyper-V\Virtual Hard Disks\$vmName.vhdx"

                if (Test-Path $vhdPath) {
                    Remove-Item -Path $vhdPath -Force -Confirm:$false
                    Write-Host "  🗑️ VHD verwijderd: $vhdPath" -ForegroundColor Green
                } else {
                    Write-Host "  ⚠️ Geen VHD gevonden voor $vmName" -ForegroundColor Yellow
                }
            }
            catch {
                Write-Host "❌ Fout bij verwerken van VM '$vmName': $_" -ForegroundColor Red
            }
        }
    }

    # Verwijder groep zelf
    try {
        Remove-VMGroup -Name $grp.Name -Force
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
            Write-Host "🧹 Notities voor '$($grp.Name)' verwijderd uit CSV." -ForegroundColor Green
        }
        catch {
            Write-Host "❌ Fout bij opschonen van CSV: $_" -ForegroundColor Red
        }
    } else {
        Write-Host "⚠️ CSV-bestand met notities niet gevonden: $CSVLocGRnotes" -ForegroundColor Yellow
    }

    Write-Host "`n--- Verwijderen van '$GroupName' voltooid ---`n" -ForegroundColor Green
}

# === HOOFDLUS ===
Clear-Host
Write-Host "=== 🧰 Hyper-V Projectverwijderaar ===" -ForegroundColor Cyan
Show-SystemMemory

do {
    # Toon beschikbare groepen
    Write-Host "Beschikbare VM-groepen:" -ForegroundColor DarkCyan
    Get-VMGroup | Select-Object -ExpandProperty Name | ForEach-Object { Write-Host " - $_" -ForegroundColor Gray }

    $inputNames = Read-Host "`nVoer de namen in van de groepen die je wilt verwijderen (gescheiden door komma's)"
    $groupNames = $inputNames -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne "" }

    foreach ($name in $groupNames) {
        Remove-VMGroupAndContent -GroupName $name
    }

    Show-SystemMemory

} until ($again)

Write-Host "`n✅ Alle opgegeven groepen zijn verwerkt.`n" -ForegroundColor Green
