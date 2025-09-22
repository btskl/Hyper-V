# maak groep aan
$newgroup = Read-Host "Geef naam van nieuwe groep"

# einddatum vragen
$endDate = Read-Host "Geef een einddatum (bijv. 2025-09-30 18:00)"

# controleer of datum geldig is
try {
    $endDateParsed = [datetime]::ParseExact($endDate, "yyyy-MM-dd HH:mm", $null)
} catch {
    Write-Host "⚠️ Ongeldige datum/tijd, einddatum blijft leeg." -ForegroundColor Yellow
    $endDateParsed = $null
}

# schrijf weg
$NewCSVdataA = New-VMGroup -Name $newgroup -GroupType VMCollectionType |
    ForEach-Object { Write-Host "- $($_.Name)" } |
    Export-CSV -Path 'C:\Temp\Group.CSV' -NoTypeInformation
Write-Host "`nGroep $newgroup is aangemaakt!"

# Pad naar CSV
$CSVlocGRnotes = 'C:\Temp\GroupNotes.csv'

# Controleer of de CSV al bestaat
if (-not (Test-Path $CSVlocGRnotes)) {
    # CSV aanmaken met kolommen
    Get-VMGroup | Select-Object Name, GroupType,
        @{Name='NotesGroup'; Expression={''}},
        @{Name='EndDate'; Expression={''}} |
        Export-Csv -Path $CSVlocGRnotes -NoTypeInformation -Force -Encoding UTF8
}

# Voeg de nieuw aangemaakte groep toe aan de CSV (append)
$newRow = [PSCustomObject]@{
    Name       = $newgroup
    NotesGroup = ""
    EndDate    = if ($endDateParsed) { $endDateParsed.ToString("yyyy-MM-dd HH:mm") } else { "" }
}
$newRow | Export-Csv $CSVlocGRnotes -NoTypeInformation -Append -Encoding UTF8

# ----------------------------------------------------===
# Scheduled Task aanmaken die waarschuwingsbestand maakt|
# ----------------------------------------------------===
if ($endDateParsed) {
    $desktopPath = [Environment]::GetFolderPath("Desktop")
    $warningFile = Join-Path $desktopPath "Waarschuwing_$newgroup.txt"

    # Script dat uitgevoerd wordt door de taak
    $taskScript = @"
`"Groep $newgroup heeft zijn einddatum bereikt op $endDateParsed.`" |
    Out-File -FilePath `"$warningFile`" -Encoding UTF8 -Force
"@

    # Tijdelijk pad voor scriptje
    $tempScriptPath = "C:\Temp\Warn_$newgroup.ps1"
    $taskScript | Out-File -FilePath $tempScriptPath -Encoding UTF8 -Force

    # Actie
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$tempScriptPath`""

    # Trigger (eenmalig op einddatum)
    $trigger = New-ScheduledTaskTrigger -Once -At $endDateParsed

    # Principal (SYSTEM account)
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

    # Taaknaam
    $taskName = "Warn_$newgroup"

    # Registreer taak
    Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $taskName -Description "Waarschuwt dat groep $newgroup klaarstaat voor opruiming" -Principal $principal

    Write-Host "⚡ Taak $taskName ingepland voor $endDateParsed. Er wordt dan een waarschuwing aangemaakt op het bureaublad."
}
else {
    Write-Host "⚠️ Geen geldige einddatum opgegeven, er wordt geen taak aangemaakt."
}

# voeg lid toe
& C:\Users\Administrator\Desktop\Scripts\Dashboard\Create_Project\VirtualM.ps1

# notities
& C:\Users\Administrator\Desktop\Scripts\Dashboard\Create_Project\Notes.ps1

# laat overzicht zien
& C:\Users\Administrator\Desktop\Scripts\Dashboard\Create_Project\Overzicht.ps1
