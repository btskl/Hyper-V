# Alle groepen ophalen
$groups = Get-VMGroup
if (-not $groups) {
    Write-Host "❌ Geen VM groepen gevonden."
    exit
}

Write-Host "`nBeschikbare groepen:"
$groups | ForEach-Object { Write-Host "- $($_.Name) (Type: $($_.GroupType))" }

# Groep kiezen
$chosenGroup = Read-Host "`nVoer de naam van de groep in"
$groupObj = Get-VMGroup -Name $chosenGroup -ErrorAction SilentlyContinue

if ($null -eq $groupObj) {
    Write-Host "❌ Groep '$chosenGroup' niet gevonden."
    exit
}

# VMs binnen groep ophalen
$vmMembers = $groupObj.VMMembers
if (-not $vmMembers -or $vmMembers.Count -eq 0) {
    Write-Host "ℹ️ Geen VMs gevonden in groep '$chosenGroup'."
    exit
}

Write-Host "`nVMs in groep '$chosenGroup':"
$vmMembers | Format-Table Name, State, Uptime -AutoSize

# Actie kiezen
$action = Read-Host "`nWat wilt u doen met de hele groep '$chosenGroup'? (1=Start alle VMs, 2=Stop alle VMs, Q=Afbreken)"

switch ($action) {
    '1' { # starten-groepvm
        foreach ($vm in $vmMembers) {
            try {
                if ($vm.State -ne "Running") {
                    Start-VM -Name $vm.Name -ErrorAction Stop
                    Write-Host "✅ VM '$($vm.Name)' gestart."
                } else {
                    Write-Host "ℹ️ VM '$($vm.Name)' draait al."
                }
            } catch {
                Write-Host "❌ Fout bij starten van '$($vm.Name)': $_"
            }
        }
    }

    '2' { # stoppen-groepvm
        foreach ($vm in $vmMembers) {
            try {
                if ($vm.State -ne "Off") {
                    Stop-VM -Name $vm.Name -Force -ErrorAction Stop
                    Write-Host "✅ VM '$($vm.Name)' gestopt."
                } else {
                    Write-Host "ℹ️ VM '$($vm.Name)' staat al uit."
                }
            } catch {
                Write-Host "❌ Fout bij stoppen van '$($vm.Name)': $_"
            }
        }
    }

    'Q' {
        Write-Host "⏭️ Geen actie uitgevoerd. Script afgesloten."
    }
}