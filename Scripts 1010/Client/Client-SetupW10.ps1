# Pad naar de SMB-share
$sourcePath = "\\MANAGEMENTPC\niksnutw7\Installers"

# Lokaal tijdelijk pad
$tempPath = "C:\Temp\OfflineInstall"
New-Item -ItemType Directory -Path $tempPath -Force

# Kopieer installatiemedia naar lokaal
Write-Output "Kopieer bestanden naar $tempPath..."
Copy-Item "$sourcePath\*" -Destination $tempPath -Recurse -Force

# Installeer Visual Studio Code
Write-Output "Installeer Visual Studio Code..."
Start-Process -FilePath "$tempPath\VSCodeUserSetup-x64-1.100.3.exe" -ArgumentList "/VERYSILENT /NORESTART /mergetasks=!runcode" -Wait

# Check of bestanden bestaan
if (!(Test-Path "$tempPath\OpenSSH-Win64-v9.8.3.0.msi")) { Write-Error "OpenSSH installer ontbreekt!" ; return }
if (!(Test-Path "$tempPath\python-3.13.5-amd64-full.exe")) { Write-Error "Python installer ontbreekt!" ; return }

# Install OpenSSH
Write-Output "Installeer OpenSSH..."
Start-Process msiexec.exe -ArgumentList @("/i", "$tempPath\OpenSSH-Win64-v9.8.3.0.msi", "/qn", "/norestart") -Wait
Set-Service sshd -StartupType 'Automatic'

# Install Python
Write-Output "Installeer Python 3.13.5..."
Start-Process -FilePath "$tempPath\python-3.13.5-amd64.exe" -ArgumentList "/quiet", "InstallAllUsers=1", "PrependPath=1", "Include_test=0" -Wait

# Installeer VSCode extensie
Write-Output "Installeer VSCode SSH-extensie en voer wijzigingen door..."
$vsCodeCliPath = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd"

if (Test-Path $vsCodeCliPath) {
    Start-Process -FilePath $vsCodeCliPath -ArgumentList "--install-extension `"$tempPath\ms-vscode-remote.remote-ssh-0.120.0.vsix`"" -Wait
} else {
    Write-Warning "VSCode CLI niet gevonden. Extensie kan niet geïnstalleerd worden."
}

# Pad naar de VS Code user settings.json
$settingsPath = "$env:APPDATA\Code\User\settings.json"

# Controleer of settings.json bestaat
if (-Not (Test-Path $settingsPath)) {
    Write-Host "VS Code settings.json niet gevonden op $settingsPath, maken..."
    New-Item -Path $settingsPath -ItemType File -Force | Out-Null
}
    
# Lees de bestaande settings
$json = Get-Content -Path $settingsPath | ConvertFrom-Json 


#pas hashtable aan
$settings = @{
    "remote.SSH.enableExecServer" = $false
    "remote.SSH.useCurlAndWgetConfigurationFiles" = $true
    "security.workspace.trust.untrustedFiles" = "open"
    "remote.useExecServer" = $false
    "remote.SSH.localServerDownload" = "always"  
    "remote.SSH.useExecServer" = $false
}

# Schrijf naar JSON bestand
$settings | ConvertTo-Json | Set-Content -Path $settingsPath

Write-Host "✅ VS Code setting 'remote.SSH.useExecServer' is uitgeschakeld in $settingsPath" -ForegroundColor Green

$itemPath = $env:USERPROFILE
Copy-Item "$itemPath\.vscode\extensions\ms-vscode-remote.remote-ssh-0.120.0\out\extension.js" "$itemPath\.vscode\extensions\ms-vscode-remote.remote-ssh-0.120.0\out\extension.js.bak"
(Get-Content "$itemPath\.vscode\extensions\ms-vscode-remote.remote-ssh-0.120.0\out\extension.js") | ForEach-Object {
    $_
    if ($_ -match 'const{artifact:n,destFolder:iRaw,destFolder2:sRaw}=e;') {
        'const i = iRaw.replace(/\\/g, "/");'
        'const s = sRaw.replace(/\\/g, "/");'
    }
} | Set-Content "$itemPath\.vscode\extensions\ms-vscode-remote.remote-ssh-0.120.0\out\extension.js"


Write-Output "Installatie voltooid."
