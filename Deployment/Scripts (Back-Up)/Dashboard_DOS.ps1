. .\Hyper-V_enk.ps1
# Enable-VMResourceMetering -VMName $VMName
# Measure-VM -Name $VMName

function Show_Menu
{
    param(
        [string]$title = "ABB VM_beheer"
    )
    
    Write-Host "===============$title==============="
    Write-Host "1: Press '1' to deploy a bald VM”
	#if done with ga verder naar RAM allocation
    Write-Host "2: Press '2' to do sumthn else"
    Write-Host "3: summary"
    Write-Host "Q: Press 'Q' to exit"
}

function Show_RAM
{
	param(
		[string]$title = "ABB VM_beheer"
	)

		Clear-Host
		Write-Host "===============$title==============="
		Write-Host "Hoeveel RAM wilt u in de nieuwe VM?"
		Write-Host "1: Press '1' to allocate 8GB RAM”
		#if done with ga verder naar RAM allocation
		Write-Host "2: Press '2' to allocate 16GB RAM"
		Write-Host "3: Press '3' to allocate 32GB RAM"
		Write-Host "Q: Press 'Q' to exit"
}

Show_Menu

    function optie1{
		While($true) {
			$input = Read-Host "`nKies een optie"
				Switch($input) {
					'1'	{Write-Host "U heeft Windows 10 LTSC gekozen”}}
						W10{}
						Show_RAM{}
						#Vraag 2: Hoeveel RAM?
							$input = Read-Host "`nHoeveel RAM?"
							Switch($input) {

								'1'	{
									$VMMemory = 8GB
									Write-Host "$VMMemory is toegewezen";
										}
								#memorystartupbytes in variabele zetten in script - Hyper-V_enk
								# $Memory = Read-Host "Enter Memory (GB) [Default: 3]"
								# if ([string]::IsNullOrWhiteSpace($Memory)) { $Memory = 3 }
								# $MemoryBytes = [int64]$Memory * 1GB
								#geef me de installatie aanbevelingen voor 800xA 6.1.1 - vragen in ai van ABBlibrary
								'2' {
									$VMMemory = 16GB
									Write-Host "$VMMemory is toegewezen";
										}
								'3' {
									$VMMemory = 32GB
									Write-Host "$VMMemory is toegewezen";
										}
								'Q' {Write-Host "Tot ziens!";
										}
		}
		}
				}
								
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
	
	optie1