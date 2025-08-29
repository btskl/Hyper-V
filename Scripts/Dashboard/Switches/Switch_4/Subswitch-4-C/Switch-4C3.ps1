Show_Menu4CC
$leden = Read-host "Wat wilt u doen?"

switch ($leden) {
    'A' {
            Write-Host "U heeft optie A gekozen"
            $memberA = Read-Host "Druk 1 voor VM of 2 voor VMGroup"
                switch ($members) {
                    '1' 
                        {
                        $naamvmmemberA = Read-Host "Hoe heet de VM?"
                        $getvmvoorlidA = Get-VM -Name $naamvmmemberA -ErrorAction Stop
                        # $getvmgroupvoorlidA = Get-VMGroup -Name $naamvmgroupmemberA -ErrorAction Stop
                        $addmembertogroupA = Add-VMGroupMember -VMGroup $getvmgroupvoorlidA -VM $getvmvoorlidA -Confirm:$false
                        Show_MenuH
                        }
                        
                    '2' 
                        {
                        $naamvmgroupmemberA = Read-Host "Hoe heet de VMGroup?"
                        $getvmgroupvoorlidA = Get-VMGroup -Name $naamvmgroupmemberA -ErrorAction Stop
                        #als de groep in een groep zit
                        if ($naamvmgroupmemberA -eq $getvmgroupvoorlidA.Name) {$naamvmmemberA = Read-Host "Hoe heet de VM?"}
                            $getvmvoorlidA = Get-VM -Name $naamvmmemberA -ErrorAction Stop
                            $addmembertogroupA = Add-VMGroupMember -VMGroup $getvmgroupvoorlidA -VMGroupMember $getvmvoorlidA -Confirm:$false
                        #voeg vm toe aan groep...
                        # if ($naamvmgroupmemberA -eq $getvmvoorlidA.Name) {$naamvmgroupmemberA = }
                        Show_MenuH
                        }
            # toevoegen
            }
            Show_MenuH
    }
}