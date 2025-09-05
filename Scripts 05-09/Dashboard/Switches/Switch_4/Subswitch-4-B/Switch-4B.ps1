Write-Host "U heeft optie B gekozen"

# Geef in te plannen tijd door
$time = Read-Host "Geef de tijd in HH:MM (bijv. 08:30)"

# Pad naar script
$scriptPath = "C:\Users\Administrator\Desktop\Scripts\Dashboard\Switches\Switch_1\Subswitch_1-A\Switch-1A.ps1"

# Actie
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""

# Trigger (bijvoorbeeld dagelijks om 08:00)
$trigger = New-ScheduledTaskTrigger -Daily -At $time

# SYSTEM account gebruiken
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Taaknaam
$TaskName = Read-Host "Geef een naam door"

# Taak registreren
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $TaskName -Description "Genereert dagelijks overzicht van VMs" -Principal $principal