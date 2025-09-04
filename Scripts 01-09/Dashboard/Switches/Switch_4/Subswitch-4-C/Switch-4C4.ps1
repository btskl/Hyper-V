Show_Menu4CD
Write-Host "U heeft optie B gekozen"
$memberB = Read-Host "Wilt u een VM of VMGroup verwijderen van een groep?"
Switch ($memberB) {

    '1' 
    {
        if ($memberB -eq "VM") {
            $naamvmmemberB = Read-Host "Hoe heet de VM?" 
            $getvmvoorlidB = Get-VM -Name $naamvmmemberB -ErrorAction Stop
            $getvmgroupvoorlidB = Get-VMGroup -Name $naamvmgroupmemberB -ErrorAction Stop
            $removemembertogroupB = Remove-VMGroupMember -VMGroup $getvmgroupvoorlidB -VM $getvmvoorlidB -Confirm:$false
            }
    }

    '2'
    {
        elseif ($memberB -eq "VMGroup") {
            $naamvmgroupmemberB = Read-Host "Hoe heet de VMGroup?"
            # $getvmvoorlidB = Get-VM -Name $naamvmmemberB -ErrorAction Stop
            $getvmgroupvoorlidB = Get-VMGroup -Name $naamvmgroupmemberB -ErrorAction Stop
            $removemembertogroupB = Remove-VMGroupMember -VMGroup $getvmgroupvoorlidB -VMGroupMember $getvmvoorlidB -Confirm:$false
        # verwijderen
            }
        }
    }