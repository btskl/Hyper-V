. .\Hyper-V_enk.ps1
# Enable-VMResourceMetering -VMName $VMName
# Measure-VM -Name $VMName

function Show_Menu{
    $title = "ABB VM_beheer"
        
    Write-Host "=========================$title========================="
    Write-Host "1: Druk op '1' voor een standaard VM (Quick-Start)”
	#
    Write-Host "2: Druk op '2' om een overzicht te tonen"
	#get-vm
    Write-Host "3: Druk op '3' om een VMGroup te maken"
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
	
		do
		{	Show_Menu
			$input = Read-Host "Maak een keuze"
				switch($input) {
					'1'	{{Write-Host "U heeft optie 1 gekozen”}}
						#Vraag 1: Welke ISO?
						Show_Menu1
						$isovm = Read-Host "Welke ISO wilt u gebruiken voor de nieuwe VM?"
							switch ($isovm) {
								'1' {Write-Host "WS2019"
									#Vraag 2: Naam van de VM?
										$VMName = Read-Host "Geef een naam door (bijv. Servernaam@Hostnaam.local)"
											if  ($VMName -match '^/d+$') {$VMName = [string]$VMName}
												Write-Host "Naam van de Virtuele Machine: $VMName"
											#Vraag 3: Hoeveel RAM?			
											$VMMemory = Read-Host "Geef het geheugen in GB (bijv. 8, 16, 32)"
												if 	($VMMemory -match '^\d+$') {$memoryBytes = [int64]$VMMemory * 1GB}
													Write-Host "Geheugen ingesteld op $($VMMemory)GB ($memoryBytes bytes)"
												#Vraag 4: Hoeveel Opslag?
												$VHDisk = Read-Host "Geef het opslagcapaciteit in GB (bijv. 8, 16, 32)"
													if	($VHDisk -match '^\d+$') {$VHDiskBytes = [int64]$VHDisk * 1GB}
														Write-Host "Opslagcapaciteit ingesteld op ($VHDisk) ($VHDisk GB)"
															ws_2019
																{Write-Host "VM Deployed"}}
													# #Vraag 5: IP-adres?
													# $IPadd = Read-host "Voer een IP-adres in (bijv. 192.168.1.1)"
													# 	if ($IPadd -match '^\d+$') {$IPadres = int64]}
								'2' {Write-Host "W10"
										$VMName = Read-Host "Geef een naam door (bijv. Servernaam@Hostnaam.local)"
											if  ($VMName -match '^/d+$') {$VMName = [string]$VMName}
												Write-Host "Naam van de Virtuele Machine: $VMName"
											#Vraag 3: Hoeveel RAM?			
											$VMMemory = Read-Host "Geef het geheugen in GB (bijv. 8, 16, 32)"
												if 	($VMMemory -match '^\d+$') {$memoryBytes = [int64]$VMMemory * 1GB}
													Write-Host "Geheugen ingesteld op $VMMemoryGB ($memoryBytes bytes)"
												#Vraag 4: Hoeveel Opslag?
												$VHDisk = Read-Host "Geef het opslagcapaciteit in GB (bijv. 8, 16, 32)"
													if	($VHDisk -match '^\d+$') {$VHDiskBytes = [int64]$VHDisk * 1GB}
														Write-Host "Opslagcapaciteit ingesteld op $VHDisk ($VHDisk GB)"
															W10
															Write-Host "VM Deployed"}}
					
					'2'
						$CSVLocation = "C:\Temp\GuestInfo.CSV"

						Get-Cluster | Get-ClusterResource | ? ResourceType -Like "Virtual Machine" | %{

						$VM = Get-VM -ComputerName $_.OwnerNode -Name $_.OwnerGroup

						$Basic = $VM | Select-Object VMName,ProcessorCount,@{label='Memory';expression={$_.MemoryAssigned/1gb -as [int]}},ComputerName

						$NIC = ($VM | Select-Object -ExpandProperty Networkadapters).IPAddresses -join ';'

						$Disks = $VM | Select-Object VMId | get-vhd -ComputerName $_.OwnerNode | Select-Object Path,@{label='DiskSize';expression={$_.Size/1gb -as [int]}}

						$DiskPath = $Disks.Path -join ';'

						$DiskSize = $Disks.DiskSize -join ';'

						$Info = [PScustomObject]@{Guest = $Basic.VMName; Processors = $Basic.ProcessorCount; Memory = $Basic.Memory; Host = $Basic.ComputerName; IPs = $NIC; DiskLocation = $DiskPath; DiskSize = $DiskSize}

						$Info | Export-CSV -Path $CSVLocation -NoTypeInformation -Append
						}

					'q'
						{{if ($input -eq 'q') {Write-Host "Tot ziens!"}}}
				}
				}
		until ($input -eq 'q') exit
	
	# function optie2{
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