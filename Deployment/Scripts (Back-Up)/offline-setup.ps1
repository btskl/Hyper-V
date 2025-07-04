# Set variables
$sharedPath = "\\MANAGEMENTPC\niksnutw7\Installers"
$openSshInstaller = "$sharedPath\OpenSSH-Win64-v9.8.3.0.msi"
$openSshInstallPath = "C:\Program Files\OpenSSH"

# Install OpenSSH
Write-Host "Installing OpenSSH..."
Start-Process "msiexec.exe" -ArgumentList "/i `"$openSshInstaller`" /quiet" -Wait

# Add OpenSSH to PATH
$env:Path += ";$openSshInstallPath"

# Install and start sshd service, en open de benodigde poorten.
Write-Host "Starting SSHD service and opening ports..."
Start-Service sshd
Set-Service sshd -StartupType Automatic

# Zet firewall open voor SSH
if (-not (Get-NetFirewallRule | Where-Object {$_.DisplayName -eq 'OpenSSH Server (sshd)'})) {
    New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
}

# Maak de VSCode-server directory aan
$vsCodeServerPath = "$env:USERPROFILE\.vscode-server"
if (-Not (Test-Path $vsCodeServerPath)) {
    New-Item -ItemType Directory -Path $vsCodeServerPath | Out-Null
}

# Zoek lokaal naar de laatste cli zip + done bestand in de RDP download folder
$localDownloadPath = "$sharedPath\VSC-server-W10"
$cliFile = Get-ChildItem -Path $localDownloadPath -Filter "vscode-cli*.zip" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
$serverFile = Get-ChildItem -Path $localDownloadPath -Filter "vscode-server*.zip" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
$doneFile = Get-ChildItem -Path $localDownloadPath -Filter "*.done" | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if (-Not $zipFile -or -Not $doneFile) {
    Write-Host "CLI-zip of server-zip, .done bestand niet gevonden in $localDownloadPath" -ForegroundColor Red
    exit 1
}

# Verplaats bestanden naar de .vscode-server directory
Copy-Item $cliFile.FullName -Destination $vsCodeServerPath -Force
Copy-Item $serverFile.FullName -Destination $vsCodeServerPath -Force
Copy-Item $doneFile.FullName -Destination $vsCodeServerPath -Force

# Extraheer de CLI en server-zip
Expand-Archive -Path "$vsCodeServerPath\$($cliFile.Name)" -DestinationPath $vsCodeServerPath -Force
Expand-Archive -Path "$vsCodeServerPath\$($serverFile.Name)" -DestinationPath $vsCodeServerPath -Force

# (Optioneel) Patch Java client-bestanden als ze bestaan
$javaClientPath = "C:\Program Files\JavaClient"
if (Test-Path $javaClientPath) {
    Get-ChildItem -Path $javaClientPath -Recurse -Include "*.properties","*.conf" | ForEach-Object {
        (Get-Content $_.FullName) -replace "OldValue", "NewValue" | Set-Content $_.FullName
    }
}

Write-Host "✅ VSCode-server CLI deployment + SSH config is voltooid." -ForegroundColor Green
