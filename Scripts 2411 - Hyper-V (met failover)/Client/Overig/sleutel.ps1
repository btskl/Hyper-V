# 1. Basisvariabelen
$localUser = $env:USERNAME
$sshDir    = Join-Path $env:USERPROFILE ".ssh"
$keyPath   = Join-Path $sshDir "id_rsa"
$remoteUser = "Administrator.TEST"
$remoteHost = "192.168.200.78"
$remoteSSHDir = "C:\Users\$remoteUser\.ssh"
$remoteAuthKeys = "$remoteSSHDir\authorized_keys"

# 2. Zorg dat lokale .ssh map bestaat
if (!(Test-Path $sshDir)) {
    New-Item -ItemType Directory -Force -Path $sshDir | Out-Null
}

# 3. Genereer keypair (indien niet aanwezig)
if (!(Test-Path $keyPath)) {
    ssh-keygen -t rsa -b 4096 -f $keyPath -N "" | Out-Null
    Write-Host "Keypair aangemaakt in $keyPath"
}

# 4. Lees public key in
$pubKey = Get-Content "$keyPath.pub" -Raw

# 5. Voeg public key toe op de remote server via SMB share (als je admin toegang hebt)
$remoteShare = "\\$remoteHost\C$\Users\$remoteUser\.ssh"
if (!(Test-Path $remoteShare)) {
    New-Item -ItemType Directory -Force -Path $remoteShare | Out-Null
}

$remoteAuthFile = Join-Path $remoteShare "authorized_keys"
if (!(Test-Path $remoteAuthFile)) {
    New-Item -ItemType File -Force -Path $remoteAuthFile | Out-Null
}
Add-Content -Path $remoteAuthFile -Value $pubKey

# 6. Zet permissies (remote kant, via WinRM of handmatig runnen)

    icacls $sshDir /inheritance:r /grant "$env:USERNAME:(OI)(CI)(F)" /grant "NT SERVICE\SSHD:(R)"
    icacls $authFile /inheritance:r /grant "$env:USERNAME:(R,W)" /grant "NT SERVICE\SSHD:(R)"
    Restart-Service sshd

Write-Host "Public key is toegevoegd en rechten zijn gezet."
Write-Host "Je kunt nu inloggen met: ssh -i $keyPath $remoteUser@$remoteHost"