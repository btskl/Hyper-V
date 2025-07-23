. .\Hyper-V_enk.ps1
# # Enable-VMResourceMetering -VMName $VMName
# # Measure-VM -Name $VMName

function Show_Menu{
    $title = "ABB VM_beheer"
        
    Write-Host "=========================$title========================="
    Write-Host "1: Druk op '1' voor een standaard VM (Quick-Start)”
	#
    Write-Host "2: Druk op '2' om een overzicht te tonen"
	#get-vm
    Write-Host "3: Druk op '3' om een IP-adres toe te wijzen"
	#newvmgroup
    Write-Host "Q: Press 'Q' to exit"
}

function Show_Menu1{
    Write-Host "========================================="
    Write-Host "1: Druk op '1' voor Windows Server 2019”
	#
    Write-Host "2: Druk op '2' voor Windows 10 LTSC"
	#get-vm
    Write-Host "3: Druk op '3' om een VMGroup te maken"
	#newvmgroup
    Write-Host "Q: Press 'Q' to exit"
}
	
# 		do
# 		{	Show_Menu
# 			$input = Read-Host "Maak een keuze"
# 				switch($input) {
# 					'1'	{{Write-Host "U heeft optie 1 gekozen”}
# 						#Vraag 1: Welke ISO?
# 						Show_Menu1
# 						$isovm = Read-Host "Welke ISO wilt u gebruiken voor de nieuwe VM?"
# 							switch ($isovm) {
# 								'1' {Write-Host "WS2019"
# 									#Vraag 2: Naam van de VM?
# 										$VMName = Read-Host "Geef een naam door (bijv. Servernaam@Hostnaam.local)"
# 											if  ($VMName -match '^/d+$') {$VMName = [string]$VMName}
# 												Write-Host "Naam van de Virtuele Machine: $VMName"
# 											#Vraag 3: Hoeveel RAM?			
# 											$VMMemory = Read-Host "Geef het geheugen in GB (bijv. 8, 16, 32)"
# 												if 	($VMMemory -match '^\d+$') {$memoryBytes = [int64]$VMMemory * 1GB}
# 													Write-Host "Geheugen ingesteld op $($VMMemory)GB ($memoryBytes bytes)"
# 												#Vraag 4: Hoeveel Opslag?
# 												$VHDisk = Read-Host "Geef het opslagcapaciteit in GB (bijv. 8, 16, 32)"
# 													if	($VHDisk -match '^\d+$') {$VHDiskBytes = [int64]$VHDisk * 1GB}
# 														Write-Host "Opslagcapaciteit ingesteld op ($VHDisk) ($VHDisk GB)"
# 															ws_2019
# 																Write-Host "VM Deployed"}
# 													#Vraag 5: IP-adres?
# 								'2' {Write-Host "W10"
# 										$VMName = Read-Host "Geef een naam door (bijv. Servernaam@Hostnaam.local)"
# 											if  ($VMName -match '^/d+$') {$VMName = [string]$VMName}
# 												Write-Host "Naam van de Virtuele Machine: $VMName"
# 											#Vraag 3: Hoeveel RAM?			
# 											$VMMemory = Read-Host "Geef het geheugen in GB (bijv. 8, 16, 32)"
# 												if 	($VMMemory -match '^\d+$') {$memoryBytes = [int64]$VMMemory * 1GB}
# 													Write-Host "Geheugen ingesteld op $VMMemoryGB ($memoryBytes bytes)"
# 												#Vraag 4: Hoeveel Opslag?
# 												$VHDisk = Read-Host "Geef het opslagcapaciteit in GB (bijv. 8, 16, 32)"
# 													if	($VHDisk -match '^\d+$') {$VHDiskBytes = [int64]$VHDisk * 1GB}
# 														Write-Host "Opslagcapaciteit ingesteld op $VHDisk ($VHDisk GB)"
# 															W10
# 															Write-Host "VM Deployed"}}
					
# 					'2'
# 						{{if ($input -eq '2') {Get-VM | Select-Object Name,State,NetworkAdapters,Status | Format-Table}}}

# 					'q'
# 						{{if ($input -eq 'q') {Write-Host "Tot ziens!"}}}}}
# 		}
# 		until ($input -eq 'q') exit
	
# 	# function optie2{
	# 	do
	# 	{
	# 		$input = Read-Host "Maak een keuze"
	# 		switch($input) {
	# 			'2' {Write-Host "Hier een overzicht"}}
	# 				if ($input -eq '2') {Write-Host "rrstd" ; break}
	# 			'q' 
	# 				if ($input -eq 'q') {Write-Host "Tot ziens!" ; break}}
	# 	until ($input -eq 'q') break
	# 	}
	
						# '2' {Write-Host "2: Press '2' to do sumthn else"; break}
						# '3' {Write-Host "3: summary"; break}
						# 'Q' {Write-Host "Q: Press 'Q' to exit"; break

			# 	'2' {Write-Host "U heeft 2 gekozen"}
			# 		if ($input -eq '2')
			# 			Show-Menu
			# #script voor optie 2
			# 	'3' {Write-Host "U heeft 3 gekozen"}
			# 		if ($input -eq '3')
			# 			Show-Menu
			# #script voor optie 3
			# 	'Q' {Write-Host "Tot ziens!"}
			# }
			# 		if ($input -eq 'q')
			# 			{exit}
		
			
		
					
				# w10_ltsc{}
				# ontwikkelen naar meerdere VM's tegelijk.
				# '2' {Write-Host "Kies voor huppeldepup"}
				# # ontwikkelen naar meerdere keuzes, denk aan hardware
				# '3' {Write-Host "Kies voor nogeenkeerhuppeldepup"}
				# # denk aan wat er in zo'n vm moet komen
				# 'Q' {Write-Host "Kies voor exit"}

$CSVPath = "C:\Temp\VMDeployment.csv"

do {
    Show_Menu
    $input = Read-Host "Maak een keuze"

    switch ($input) {

        '1' {
            Write-Host "`n=== Nieuwe VM Configuratie ==="

            $VMName = Read-Host "Geef de naam van de VM"
            if (-not $VMName) { Write-Host "Naam is verplicht."; break }

            $Processors = Read-Host "Aantal CPU's voor deze VM (bijv. 2)"
            if ($Processors -notmatch '^\d+$') { Write-Host "Ongeldig getal."; break }

            $MemoryGB = Read-Host "Geheugen in GB (bijv. 4)"
            if ($MemoryGB -notmatch '^\d+$') { Write-Host "Ongeldig getal."; break }
            $MemoryBytes = [int64]$MemoryGB * 1GB

            $HostName = Read-Host "Voer de naam van de Hyper-V host in"

            $DiskSizeGB = Read-Host "Opslagcapaciteit in GB (bijv. 40)"
            if ($DiskSizeGB -notmatch '^\d+$') { Write-Host "Ongeldig getal."; break }

            $DiskPath = Read-Host "Pad voor de virtuele harde schijf (bijv. C:\VMs\$VMName.vhdx)"

            $VMObject = [PSCustomObject]@{
                Guest        = $VMName
                Processors   = $Processors
                Memory       = $MemoryGB
                Host         = $HostName
                IPs          = "n.v.t."
                DiskLocation = $DiskPath
                DiskSize     = $DiskSizeGB
            }

            $VMObject | Export-Csv -Path $CSVPath -NoTypeInformation -Append
            Write-Host "`nVM informatie opgeslagen in: $CSVPath"
        }

        '2' {
            if (Test-Path $CSVPath) {
                Import-Csv -Path $CSVPath | Format-Table -AutoSize
            } else {
                Write-Host "Geen bestaande VM-data gevonden."
            }
        }

        '3' {
            if (-Not (Test-Path $CSVPath)) {
                Write-Host "Geen bestaande configuraties gevonden."; break
            }

            $vmList = Import-Csv $CSVPath
            Write-Host "`nBeschikbare VMs:"
            $vmList | ForEach-Object { Write-Host "- $($_.Guest)" }

            $chosenVM = Read-Host "`nVoer de naam van de VM in waaraan je een IP wilt toewijzen"
            $foundVM = $vmList | Where-Object { $_.Guest -eq $chosenVM }

            if (-not $foundVM) {
                Write-Host "VM '$chosenVM' niet gevonden."; break
            }

            $newIP = Read-Host "Voer het gewenste IP-adres in voor deze VM"
            if ($newIP -notmatch '^\d{1,3}(\.\d{1,3}){3}$') {
                Write-Host "Ongeldig IP-formaat."; break
            }

            # Update IP
            foreach ($vm in $vmList) {
                if ($vm.Guest -eq $chosenVM) {
                    $vm.IPs = $newIP
                }
            }

            # Overschrijf CSV
            $vmList | Export-Csv -Path $CSVPath -NoTypeInformation
            Write-Host "`nIP-adres '$newIP' succesvol toegewezen aan VM '$chosenVM'."
        }

        'q' {
            Write-Host "Tot ziens!"
        }

        default {
            Write-Host "Ongeldige keuze, probeer opnieuw."
        }
    }

    Pause
} until ($input -eq 'q')