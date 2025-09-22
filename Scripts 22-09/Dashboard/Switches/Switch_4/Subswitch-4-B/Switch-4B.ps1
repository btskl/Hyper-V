Write-Host "U heeft optie B gekozen"

# Tijd vragen
$time = Read-Host "Geef tijd door (bijvoorbeeld 08:00)" 

# Pad naar script
$scriptPath = "C:\Users\Administrator\Desktop\Scripts\Dashboard\Remove_Project\Remove-VMGroup.ps1"

# Actie goed gequote
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$scriptPath`""

# Trigger (dagelijks op opgegeven tijd)
$trigger = New-ScheduledTaskTrigger -Daily -At $time

# SYSTEM account
$principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

# Naam taak
$TaskName = Read-Host "Geef een naam door"

# Registreren
Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $TaskName -Description "Genereert dagelijks overzicht van VMs" -Principal $principal

Write-Host "✅ Taak $TaskName ingepland om $Time."
