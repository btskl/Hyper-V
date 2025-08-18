. C:\Users\Administrator\Desktop\Scripts\Dashboard-CFG\Dashboard_DOS.ps1
. C:\Users\Administrator\Desktop\Scripts\Dashboard-CFG\Hyper-V_enk.ps1

$getvm = Get-VM | Select-Object Name,CreationTime,ComputerName
$now = Get-Date
Read-Host "adsf"
if ($now -ge $startTime -and $now -lt $stopTime) {
    Start-VM -Name $getvm -ErrorAction SilentlyContinue
} 
    elseif ($now -ge $stopTime) {
        Stop-VM -Name $getvm -Force -ErrorAction SilentlyContinue
        break
}

Start-Sleep -Seconds 60