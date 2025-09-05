# Set variables
$sharedPath = "C:\Users\localabb\niksnutw7"
$openSshInstaller = "$sharedPath\OpenSSH-Win64.msi"

# Check if the installer exists
if (Test-Path $openSshInstaller) {
    Write-Host "Found OpenSSH installer at: $openSshInstaller"
    
    # Install OpenSSH silently
    Write-Host "Installing OpenSSH..."
    $installResult = Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$openSshInstaller`" /quiet /norestart" -Wait -PassThru

    Write-Host "Installation process exited with code: $($installResult.ExitCode)"
} else {
    Write-Host "ERROR: OpenSSH installer not found at $openSshInstaller"
}

# Remove and recreate vscode-scp-done.flag
Write-Host "Setting vscode-scp-done flag..."
Remove-Item -Path "C:\Users\Administrator\.vscode-server\bin\e4503b30fc78200f846c62cf8091b76ff5547662\vscode-server-win32-x64\vscode-scp-done.flag" -Force -ErrorAction SilentlyContinue
New-Item -Path "C:\Users\Administrator\.vscode-server\bin\e4503b30fc78200f846c62cf8091b76ff5547662\vscode-server-win32-x64\vscode-scp-done.flag" -Force

icacls "C:\Users\Administrator\.vscode-server" /grant Administrator:(F)

Our hack workaround is to replace $commitId = '${r}' with $commitId = '${r}-${require("os").userInfo().username}' in extension.js

C:\Users\Administrator\.vscode-server\bin\<commitId>\vscode-server.zip

# Check of de task al bestaat en verwijder 'm als dat zo is
if (Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName $taskname -Confirm:$false
}

# Nu opnieuw registreren
Register-ScheduledTask -TaskName $taskname -Action $action -Trigger $trigger -Principal $principal

Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux -Source D:\sources\sxs -LimitAccess -NoRestart
Enable-WindowsOptionalFeature -Online -FeatureName VirtualMachinePlatform -Source D:\sources\sxs -LimitAccess -NoRestart

https://update.code.visualstudio.com/commit:258e40fedc6cb8edf399a463ce3a9d32e7e1f6f3/cli-win32-x64/stable


vscode-cli-258e40fedc6cb8edf399a463ce3a9d32e7e1f6f3.zip.done 
vscode-cli-258e40fedc6cb8edf399a463ce3a9d32e7e1f6f3.zip

> Trigger local server download
[15:52:14.433] > 
> 9ac9ecd74b1c:trigger_server_download
> artifact==cli-win32-x64==
> destFolder==C:\Users\Administrator\.vscode-server==
> destFolder2==/vscode-cli-258e40fedc6cb8edf399a463ce3a9d32e7e1f6f3.zip==
> 9ac9ecd74b1c:trigger_server_download_end
> Waiting for client to transfer server archive...
> Waiting for C:\Users\Administrator\.vscode-server\vscode-cli-258e40fedc6cb8edf39
> 9a463ce3a9d32e7e1f6f3.zip.done and vscode-cli-258e40fedc6cb8edf399a463ce3a9d32e7
> e1f6f3.zip to exist
[15:52:14.435] Got request to download on client for {"artifact":"cli-win32-x64","destPath":"C:\\Users\\Administrator\\.vscode-server/vscode-cli-258e40fedc6cb8edf399a463ce3a9d32e7e1f6f3.zip"}
[15:52:14.436] server download URL: https://update.code.visualstudio.com/commit:258e40fedc6cb8edf399a463ce3a9d32e7e1f6f3/cli-win32-x64/stable
[15:52:14.437] Downloading VS Code server locally...
[15:52:14.457] Resolver error: Error: Failed to download VS Code Server (Failed to fetch)


const{artifact:n,destFolder:i,destFolder2:s}=e;

const{artifact:n,destFolder:iRaw,destFolder2:sRaw}=e;
const i = iRaw.replace(/\\/g, "/");
const s = sRaw.replace(/\\/g, "/");
t.info("Adjusted destFolder: " + i);

https://update.code.visualstudio.com/commit:258e40fedc6cb8edf399a463ce3a9d32e7e1f6f3/cli-win32-x64/stable

# Set variables
$sharedPath = "\\MANAGEMENTPC\niksnutw7"
$openSshInstaller = "$sharedPath\OpenSSH-Win64-v9.8.3.0.msi"
$openSshInstallPath = "C:\Program Files\OpenSSH"

# Install OpenSSH
Write-Host "Installing OpenSSH..."
Start-Process msiexec.exe -ArgumentList "/i `"$openSshInstaller`" /quiet /norestart" -Wait

# Controleer of install-sshd.ps1 bestaat en voer uit om de sshd-service te registreren
$installScript = Join-Path $openSshInstallPath 'install-sshd.ps1'
if (Test-Path $installScript) {
    Write-Host "Running install-sshd.ps1..."
    & $installScript
} else {
    Write-Host "install-sshd.ps1 niet gevonden. Controleer installatiepad." -ForegroundColor Red
    exit 1
}

# Start en zet de sshd-service op Automatic
Write-Host "Starting SSHD service..."
Start-Service sshd
Set-Service sshd -StartupType Automatic

# Zet firewall open voor SSH
if (-not (Get-NetFirewallRule | Where-Object {$_.DisplayName -like '*sshd*'})) {
    New-NetFirewallRule -Name "OpenSSH-Server-In-TCP" -DisplayName "OpenSSH Server (sshd)" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
}

# VSCode-server directory aanmaken
$vsCodeServerPath = "$env:USERPROFILE\.vscode-server"
if (-Not (Test-Path $vsCodeServerPath)) {
    New-Item -ItemType Directory -Path $vsCodeServerPath | Out-Null
}

# Zoek lokaal naar de laatste cli zip + done bestand
$localDownloadPath = "C:\Installers\VSCodeServer"
$zipFile = Get-ChildItem -Path $localDownloadPath -Filter "vscode-cli-*.zip" | Sort-Object LastWriteTime -Descending | Select-Object -First 1
$doneFile = Get-ChildItem -Path $localDownloadPath -Filter "*.done" | Sort-Object LastWriteTime -Descending | Select-Object -First 1

if (-Not $zipFile -or -Not $doneFile) {
    Write-Host "CLI-zip of .done bestand niet gevonden in $localDownloadPath" -ForegroundColor Red
    exit 1
}

# Verplaats bestanden naar de VSCode-server directory
Copy-Item $zipFile.FullName -Destination $vsCodeServerPath -Force
Copy-Item $doneFile.FullName -Destination $vsCodeServerPath -Force

# Extraheer de CLI-zip
Expand-Archive -Path "$vsCodeServerPath\$($zipFile.Name)" -DestinationPath $vsCodeServerPath -Force

# (Optioneel) Patch Java client-bestanden
$javaClientPath = "C:\Program Files\JavaClient"
if (Test-Path $javaClientPath) {
    Get-ChildItem -Path $javaClientPath -Recurse -Include "*.properties","*.conf" | ForEach-Object {
        (Get-Content $_.FullName) -replace "OldValue", "NewValue" | Set-Content $_.FullName
    }
}

# Cleanup zip en done-bestanden
Remove-Item "$vsCodeServerPath\$($zipFile.Name)" -Force
Remove-Item "$vsCodeServerPath\$($doneFile.Name)" -Force

Write-Host "✅ VSCode-server CLI deployment + SSH config is voltooid." -ForegroundColor Green

# Pad naar de VS Code user settings.json
$settingsPath = "$env:APPDATA\Code\User\settings.json"

# Controleer of settings.json bestaat
if (-Not (Test-Path $settingsPath)) {
    Write-Host "VS Code settings.json niet gevonden op $settingsPath, maken..."
    New-Item -Path $settingsPath -ItemType File -Force | Out-Null
    Set-Content -Path $settingsPath -Value "{}"
}

# 16-06-2025

# Pad naar de VS Code user settings.json
$settingsPath = "$env:APPDATA\Code\User\settings.json"

# Controleer of settings.json bestaat
if (-Not (Test-Path $settingsPath)) {
    Write-Host "VS Code settings.json niet gevonden op $settingsPath, maken..."
    New-Item -Path $settingsPath -ItemType File -Force | Out-Null
    Set-Content -Path $settingsPath -Value "{}"
}

# Lees de bestaande settings
$json = Get-Content -Path $settingsPath -Raw | ConvertFrom-Json

# Zet remote.useExecServer op false
$json.'remote.useExecServer' = $false

# Schrijf het terug naar settings.json met nette opmaak
$json | ConvertTo-Json -Depth 10 | Set-Content -Path $settingsPath -Encoding UTF8

Write-Host "✅ VS Code setting 'remote.useExecServer' is uitgeschakeld in $settingsPath" -ForegroundColor Green

{@{remote.SSH.enableExecServer=False; remote.SSH.preconnect=; remote.SSH.useCurlAndWgetConfigurationFiles=True; security.workspace.trust.untrustedFiles=open}.'remote.useExecServer' = False}

#pas hashtable aan
$settings = @{
    "remote.SSH.enableExecServer" = $false
    "remote.SSH.preconnect" = ""
    "remote.SSH.useCurlAndWgetConfigurationFiles" = $true
    "security.workspace.trust.untrustedFiles" = "open"
    "remote.useExecServer" = $false
}

# Schrijf naar JSON bestand
$settings | ConvertTo-Json | Set-Content -Path "C:\config\vscode-remote-settings.json"

Commit-ID WS-2016-1:
https://update.code.visualstudio.com/commit:258e40fedc6cb8edf399a463ce3a9d32e7e1f6f3/cli-win32-x64/stable

Set-Service : Service sshd was not found on computer '.'.
At C:\Users\User1\Desktop\Scripts\OpenSSH.ps1:18 char:1
+ Set-Service sshd -StartupType 'Automatic'
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (.:String) [Set-Service], InvalidOperationException
    + FullyQualifiedErrorId : InvalidOperationException,Microsoft.PowerShell.Commands.SetServiceCommand
 

vEthernet (Intel(R) 82574L Gigabit Network Connection - Virtual Switch)
