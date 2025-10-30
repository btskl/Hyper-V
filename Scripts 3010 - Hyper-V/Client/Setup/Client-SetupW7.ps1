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
Start-Process -FilePath "$tempPath\VSCodeUserSetup-x64-1.70.2.exe" -ArgumentList "/VERYSILENT /NORESTART /mergetasks=!runcode" -Wait

# Installeer OpenSSH
Write-Output "Installeer OpenSSH..."
Start-Process msiexec.exe -ArgumentList "/i `"$tempPath\OpenSSH-Win64-v9.8.3.0.msi`" /qn /norestart" -Wait
Set-Service sshd -StartupType 'Automatic'


# Installeer Python 3.8.10
Write-Output "Installeer PowerShell 7..."
Start-Process -FilePath "$tempPath\PowerShell-7.5.1-win-x64.msi" -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1 Include_test=0" -Wait

# Installeer VSCode extensie
Write-Output "Installeer VSCode SSH-extensie en voer wijzigingen door..."
$vsCodeCliPath = "$env:LOCALAPPDATA\Programs\Microsoft VS Code\bin\code.cmd"

if (Test-Path $vsCodeCliPath) {
    Start-Process -FilePath $vsCodeCliPath -ArgumentList "--install-extension `"$tempPath\ms-vscode-remote.remote-ssh-0.78.0.vsix`"" -Wait
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
    "remote.SSH.enableExecServer":  false,
    "remote.SSH.useExecServer":  false,
    "remote.SSH.localServerDownload":  "always",
    "security.workspace.trust.untrustedFiles":  "open",
    "editor.minimap.enabled": false,
    "files.autoSave": "afterDelay",}

# Schrijf naar JSON bestand
$settings | ConvertTo-Json | Set-Content -Path $settingsPath

Write-Host "✅ VS Code setting 'remote.SSH.useExecServer' is uitgeschakeld in $settingsPath" -ForegroundColor Green

$itemPath = $env:USERPROFILE
Copy-Item "$itemPath\.vscode\extensions\ms-vscode-remote.remote-ssh-0.78.0\out\extension.js" "$itemPath\.vscode\extensions\ms-vscode-remote.remote-ssh-0.78.0\out\extension.js.bak"
(Get-Content "$itemPath\.vscode\extensions\ms-vscode-remote.remote-ssh-0.78.0\out\extension.js") | ForEach-Object {
    $_
    if ($_ -match 'const{artifact:n,destFolder:iRaw,destFolder2:sRaw}=e;') {
        'const i = iRaw.replace(/\\/g, "/");'
        'const s = sRaw.replace(/\\/g, "/");'
    }
} | Set-Content "$itemPath\.vscode\extensions\ms-vscode-remote.remote-ssh-0.78.0\out\extension.js"


Write-Output "Installatie voltooid."
