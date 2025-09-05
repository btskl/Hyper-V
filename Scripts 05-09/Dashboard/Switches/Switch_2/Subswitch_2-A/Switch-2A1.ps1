Write-Host "U heeft gekozen voor WS2019"

# Verzin een naam
$VMName = Read-Host "Geef de naam van de nieuwe VM"
if (-not $VMName) { Write-Host "❌ Geen VM-naam ingevoerd. Stop."; break }

& Scripts\Dashboard\Main\New_VM.ps1
# Quick-Start instellingen
$memoryBytes   = 2GB
$VHDiskBytes   = 60GB

# Geef het aantal door
$Aantal = Read-Host "Geef een aantal door (bijv. 2)" 
Write-Host "Zoveel VM's worden gemaakt: $Aantal" 
    for ($i = 1; $i -le $Aantal; $i++) {                        # zet een {integer+-1} bij elke iteratie (bv. bij 4 iteratie's = test-1 +-2 +-3 +-4)
        $VMName = "$VMName-$i"
        ws_2019 -VMName $VMName -MemoryGB $memoryBytes -DiskGB $VHDisk -VMDvdDrive $diskPath
        # Tijd opvragen
        $timeInput = Read-Host "Geef de tijd in HH:MM (bijv. 08:30)"

        # Omzetten naar datetime (vandaag om dat tijdstip)
        try {
            $time = [DateTime]::ParseExact($timeInput, "HH:mm", $null)
        } catch {
            Write-Error "Ongeldige tijd. Gebruik het formaat HH:MM, bijvoorbeeld 08:30"
            exit
        }

        # Pad naar script
        $scriptPath = C:\Users\Administrator\Desktop\Scripts\Dashboard\Switches\Switch_3\Subswitch-3-B\Switch-3B.ps1 #stop-script

        # Actie
        $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""

        # Trigger (dagelijks op opgegeven tijd)
        $trigger = New-ScheduledTaskTrigger -Daily -At $time

        # SYSTEM account gebruiken
        $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

        # Taaknaam
        $TaskName = Read-Host "Geef een naam door voor de Stop-task"

        # Taak registreren
        Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $TaskName -Description "Stopt VMs" -Principal $principal -Force

        Write-Host "Taak $TaskName is aangemaakt en wordt dagelijks uitgevoerd om $($time.ToString("HH:mm"))."

    }

    