Show_Menu4CC
$leden = Read-host "Wat wilt u doen?"

$naamvmgroup = Read-Host "Voer de naam van de groep in"
$vmGroup = Get-VMGroup -Name $naamvmgroup -ErrorAction SilentlyContinue | Select-Object -First 1

if (-not $vmGroup) {
    Write-Host "❌ Groep '$naamvmgroup' niet gevonden."
}

switch ($leden) {
    'A' 
    {
        $naamvm = Read-Host "Voer de naam van de VM in die je wilt toevoegen"
        $vm = Get-VM -Name $naamvm -ErrorAction SilentlyContinue

        if (-not $vm) {
            Write-Host "❌ VM '$naamvm' niet gevonden."
        }
        elseif ($vmGroup.VMMembers.Name -contains $vm.Name) {
            Write-Host "ℹ️ VM '$naamvm' zit al in groep '$naamvmgroup'."
        }
        else {
            try {
                Add-VMGroupMember -VMGroup $vmGroup -VM $vm -Confirm:$false
                Write-Host "✅ VM '$naamvm' toegevoegd aan groep '$naamvmgroup'."
            } catch {
                Write-Host "❌ Fout bij toevoegen: $_"
            }
        }
    }

    'B' 
    {
                Write-Host "`nHuidige leden in groep '$naamvmgroup':"
        $vmGroup.VMMembers | Select-Object Name | Format-Table -AutoSize

        $naamvm = Read-Host "Voer de naam van de VM in die je wilt verwijderen"
        $vm = $vmGroup.VMMembers | Where-Object { $_.Name -eq $naamvm }

        if (-not $vm) {
            Write-Host "❌ VM '$naamvm' zit niet in groep '$naamvmgroup'."
        }
        else {
            try {
                Remove-VMGroupMember -VMGroup $vmGroup -VM $vm -Confirm:$false
                Write-Host "✅ VM '$naamvm' verwijderd uit groep '$naamvmgroup'."
            } catch {
                Write-Host "❌ Fout bij verwijderen: $_"
            }
        }
    }
}
    Show_MenuH