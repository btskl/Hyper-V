# ==========================================================
# Overdracht SSH-public key naar VMS3 met AD-integratie
# ==========================================================

$remoteHost   = "VMS3"
$remoteUser   = "Administrator"
$remoteSSHDir = "\\$remoteHost\C$\Users\$remoteUser\.ssh"
$localPubKey  = "$env:USERPROFILE\.ssh\id_rsa.pub"
$remoteAuth   = Join-Path $remoteSSHDir "authorized_keys"

# Controleer of de lokale public key bestaat
if (!(Test-Path $localPubKey)) {
    Write-Host "⚠️  Geen lokale public key gevonden — genereer eerst een sleutel met ssh-keygen."
    exit 1
}

# 1️⃣  Maak remote .ssh map aan als die niet bestaat
if (!(Test-Path $remoteSSHDir)) {
    Write-Host "📁  Maken van .ssh map op $remoteHost ..."
    New-Item -ItemType Directory -Force -Path $remoteSSHDir | Out-Null
}

# 2️⃣  Voeg lokale public key toe aan authorized_keys (zonder duplicaten)
$pubKey = Get-Content $localPubKey -Raw
if (Test-Path $remoteAuth) {
    $existingKeys = Get-Content $remoteAuth -Raw
    if ($existingKeys -notmatch [regex]::Escape($pubKey.Trim())) {
        Write-Host "➕  Nieuwe key toevoegen aan authorized_keys op $remoteHost ..."
        Add-Content -Path $remoteAuth -Value "`n$pubKey"
    } else {
        Write-Host "✅  Key bestaat al in authorized_keys."
    }
} else {
    Write-Host "🆕  Authorized_keys bestand aanmaken op $remoteHost ..."
    Set-Content -Path $remoteAuth -Value $pubKey
}

# 3️⃣  Rechten instellen (via AD-account)
Invoke-Command -ComputerName $remoteHost -ScriptBlock {
    $user = "Administrator"
    $sshDir = "C:\Users\$user\.ssh"
    $authFile = "$sshDir\authorized_keys"

    if (Test-Path $sshDir) {
        icacls $sshDir /inheritance:r /grant "${user}:(OI)(CI)(F)" | Out-Null
    }
    if (Test-Path $authFile) {
        icacls $authFile /inheritance:r /grant "${user}:(R,W)" | Out-Null
    }
    Write-Host "🔐  Permissies zijn ingesteld voor ${user}."
}

Write-Host "✅  Public key succesvol overgezet naar $remoteHost."
