Show_Menu4CC
$leden = Read-host "Wat wilt u doen?"

switch ($leden) {
    'A' {
        Write-Host "U heeft optie A gekozen"
        $memberChoice = Read-Host "Druk 1 voor VM of 2 voor VMGroup"
        
        switch ($memberChoice) {
            '1' {
                # VM toevoegen aan groep
                $naamvmgroup = Read-Host "Hoe heet de doel-VMGroup?"
                if ([string]::IsNullOrWhiteSpace($naamvmgroup)) {
                    Write-Host "❌ Geen groepsnaam ingevoerd." -ForegroundColor Red
                    Show_MenuH
                    break
                }

                $naamvm = Read-Host "Hoe heet de VM?"
                if ([string]::IsNullOrWhiteSpace($naamvm)) {
                    Write-Host "❌ Geen VM naam ingevoerd." -ForegroundColor Red
                    Show_MenuH
                    break
                }

                try {
                    $vm = Get-VM -Name $naamvm -ErrorAction Stop
                    $vmGroup = Get-VMGroup -Name $naamvmgroup -ErrorAction Stop

                    Add-VMGroupMember -VMGroup $vmGroup -VM $vm -Confirm:$false
                    Write-Host "✅ VM '$naamvm' toegevoegd aan groep '$naamvmgroup'"
                }
                catch {
                    Write-Host "❌ Fout bij toevoegen van VM: $($_.Exception.Message)" -ForegroundColor Red
                }

                Show_MenuH
            }
            
            '2' {
                # Subgroep toevoegen aan groep
                $naamvmgroup = Read-Host "Hoe heet de doel-VMGroup?"
                if ([string]::IsNullOrWhiteSpace($naamvmgroup)) {
                    Write-Host "❌ Geen groepsnaam ingevoerd." -ForegroundColor Red
                    Show_MenuH
                    break
                }

                $naamsubgroup = Read-Host "Hoe heet de sub-VMGroup?"
                if ([string]::IsNullOrWhiteSpace($naamsubgroup)) {
                    Write-Host "❌ Geen subgroepnaam ingevoerd." -ForegroundColor Red
                    Show_MenuH
                    break
                }

                try {
                    $vmGroup = Get-VMGroup -Name $naamvmgroup -ErrorAction Stop
                    $subGroup = Get-VMGroup -Name $naamsubgroup -ErrorAction Stop

                    Add-VMGroupMember -VMGroup $vmGroup -VMGroupMember $subGroup -Confirm:$false
                    Write-Host "✅ Subgroep '$naamsubgroup' toegevoegd aan groep '$naamvmgroup'"
                }
                catch {
                    Write-Host "❌ Fout bij toevoegen van groep: $($_.Exception.Message)" -ForegroundColor Red
                }

                Show_MenuH
            }
        }
    }
        
        'B' 
        {
            $groepNaam = Read-Host "Welke groep wil je verwijderen?"

            try {
                $groep = Get-VMGroup -Name $groepNaam -ErrorAction Stop
            }
            catch {
                Write-Host "❌ Groep '$groepNaam' niet gevonden." -ForegroundColor Red
                Show_MenuH
                return
            }

            $bevestig = Read-Host "Weet je zeker dat je groep '$groepNaam' wilt verwijderen? (Y/N)"
            if ($bevestig -eq "Y") {
                try {
                    Remove-VMGroup -Name $groepNaam -ErrorAction Stop -ErrorVariable +err
                    Write-Host "✅ Groep '$groepNaam' verwijderd." -ForegroundColor Green
                }
                catch {
                    Write-Host "❌ Fout bij verwijderen: $($_.Exception.Message)" -ForegroundColor Red
                }
            }
            else {
                Write-Host "❎ Verwijderen geannuleerd." -ForegroundColor Yellow
            }

            Show_MenuH   # Stuur terug naar hoofdmenu
        }


            Default {
                Write-Host "❌ Ongeldige keuze, probeer opnieuw." -ForegroundColor Red
                Show_MenuH
            }
}