. .\Hyper-V_enk.ps1
# Enable-VMResourceMetering -VMName $VMName
# Measure-VM -Name $VMName

function Show_Menu
{	
    param(
        [string]$title = "ABB VM_beheer"
    )
    
    Write-Host "===============$title==============="
    Write-Host "1: Druk op '1' voor een standaard VM”
	#if done with ga verder naar RAM allocation
    Write-Host "2: Druk op '2' om een overzicht te tonen"
    Write-Host "3: Druk op '3' om een VMGroup te maken"
    Write-Host "Q: Press 'Q' to exit"
	}

	function optie1{
		do
		{
			$input = Read-Host "Maak een keuze"
			switch($input) {
					'1'	{Write-Host "U heeft Windows 10 LTSC gekozen”}}
						if ($input -eq '1'){
							#Vraag 1: Naam van de VM?
							$VMName = Read-Host "Geef een naam door (bijv. Servernaam@Hostnaam.local)"
								if ($VMName -match '^/d+$') {$VMName = [string]$VMName}
									Write-Host "Naam van de Virtuele Machine: $VMName"
							#Vraag 3: Hoeveel RAM?			
							$VMMemory = Read-Host "Geef het geheugen in GB (bijv. 8, 16, 32)"
								if 	($VMMemory -match '^\d+$') {$memoryBytes = [int64]$VMMemory * 1GB}
									Write-Host "Geheugen ingesteld op $($VMMemory)GB ($memoryBytes bytes)"
							#Vraag 4: Hoeveel Opslag?
							$VHDisk = Read-Host "Geef het opslagcapaciteit in GB (bijv. 8, 16 ,32)"
								if	($VHDisk -match '^\d+$') {$VHDiskBytes = [int64]$VHDisk * 1GB}
									Write-Host "Opslagcapaciteit ingesteld op ($VHDisk) ($VHDisk GB)"
									Clear-Host
									W10
									Write-Host "VM Deployed"
									break}
					'2' {Write-Host "U heeft gekozen"}
					'q'
						if ($input -eq 'q') {Write-Host "Tot ziens!" ; break}
		}
			until ($input -eq 'q') break
	}
						# '2' {Write-Host "2: Press '2' to do sumthn else"; break}
						# '3' {Write-Host "3: summary"; break}
						# 'Q' {Write-Host "Q: Press 'Q' to exit"; break
Show_Menu
optie1
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