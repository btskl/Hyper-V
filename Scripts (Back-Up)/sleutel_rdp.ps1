$hostnameHV = $ENV:Computername                                                                                                                                        #hostnaam Hyper-V Server
$hostnameRDP = (Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | Where-Object {$_.DefaultIPGateway }).DefaultIPGateway | Select-Object -First 1    #hostnaam Remote Desktop PC
Write-Host "hostnameRDP: $hostnameRDP"


# haal bestandspaden ssh op
$HVsshPath = "$ENV:USERPROFILE/.ssh/keypair.pub"

# Geef het pad van de ISO-bestand aan op de Hyper-V
Write-Host $RDPsshPath
# $env:USERPROFILE = <pad naar>\.ssh

# # Combineren tot één string
# $scpCommand = "scp `"$sourceFile`" ${remoteUser}@${remoteHost}:$remoteDest"
$HVsshLines = Get-Content -Path "$HVsshPath"
$RDPsshPath = "C:\Users\localabb\.ssh\keypair.pub"
foreach ($HVsshLine in $HVsshLines)
{$HVsshLine | Out-File -FilePath "$RDPsshPath" -Append
"*$($HVsshLine)" | Out-File -FilePath "$RDPsshPath" -Append}

# Private key (id_rsa of id_ed25519): bewaar je veilig op je eigen computer.
# Public key (id_rsa.pub of id_ed25519.pub): kopieer je naar de server waarop je wilt inloggen.
# scp -i ~/.ssh/mytest.key root@192.168.1.1:/<filepath on host> <path on client>

ssh-keygen -t ed25519 -f C:\Users\Administrator\.ssh\keypair -N "" # maak keypair aan op Hyper-V


# Maak een SSH-key aan op de RDP Server en gebruik deze om de verbinding automatisch tot stand te brengen, voor een transactie van de ISO-file
# Je genereert een sleutelpaar: scp  < source path of the file >  < destination path of the file >, zet het over van RDP server naar de Hyper-V.
#geef juiste permissies met icacls aan Hyper-V voor ssh
icacls "$HVsshPath" /inheritance:r /grant:r "Administrator:F"

# zet met scp de public key over naar RDP
scp -i C:\Users\Administrator\.ssh\keypair C:\Users\Administrator\.ssh\keypair.pub localabb@192.168.200.98:\Users\localabb\.ssh\authorized_keys

#stuur eenmalig een remote script naar de rdp server om sleutelpaar aan te maken en rechten aan te passen
# $remoteScript = @"
# icacls C:\Users\localabb\.ssh /inheritance:r
# icacls C:\Users\localabb\.ssh /grant localabb:F
# icacls C:\Users\localabb\.ssh\authorized_keys /inheritance:r
# icacls C:\Users\localabb\.ssh\authorized_keys /grant localabb:R
# "@

# Get-Content "C:\Users\Administrator\.ssh\authorized_keys" | ssh -i "C:\Users\localabb\.ssh\keypair" localabb@$hostnameRDP 'powershell -Command "Add-Content -Path "C:\Users\localabb\.ssh\authorized_keys\" -Value ([Console]::In.ReadToEnd())"'

# ssh localabb@${hostnameRDP} "C:\Users\Administrator\.ssh\keypair" "Add-Content -Path C:\Users\localabb\.ssh\authorized_keys -Value ([Console]::In.ReadToEnd())"

# # geef juiste permissies met icacls op rdp
# icacls "$env:USERPROFILE\.ssh" /inheritance:r /grant:r "$env:USERNAME:F"
# icacls "$env:USERPROFILE\.ssh\authorized_keys" /inheritance:r /grant:r "$env:USERNAME:F"

# gebruik vervolgens de sleutel om een sessie te starten voor een overdracht van 
# scp "$HVsshPath\keypair.pub" "localabb@${hostnameRDP}:/c/Users/localabb/.ssh/authorized_keys"

