# Pad naar de SMB-share
$sourcePath = "\\MANAGEMENTPC\niksnutw7\Installers"

# Lokaal tijdelijk pad
$tempPath = "C:\Temp\OfflineInstall"
New-Item -ItemType Directory -Path $tempPath -Force

# Kopieer installatiemedia naar lokaal
Write-Output "Kopieer bestanden naar $tempPath..."
Copy-Item "$sourcePath\*" -Destination $tempPath -Recurse -Force

# Installeer OpenSSH
Write-Output "Installeer OpenSSH..."
Start-Process msiexec.exe -ArgumentList "/i "$tempPath\OpenSSH-Win64-v9.8.3.0.msi" /qn /norestart" -Wait
Set-Service sshd -StartupType 'Automatic'