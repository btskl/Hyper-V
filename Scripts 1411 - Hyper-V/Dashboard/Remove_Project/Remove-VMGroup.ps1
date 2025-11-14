$CSVProjects   = 'C:\Temp\Projects.csv'
$CSVLocGRnotes = 'C:\Temp\GroupNotes.csv'
$HyperVHosts   = @("VMS1","VMS3")

Write-Host "`n=== Hyper-V Project Verwijderaar ===" -ForegroundColor Cyan

if (-not (Test-Path $CSVProjects)) {
    Write-Host " Projects.csv niet gevonden" -ForegroundColor Red
    exit
}

$projects = Import-Csv $CSVProjects
if (-not $projects) {
    Write-Host " Projects.csv is leeg" -ForegroundColor Red
    exit
}

$allGroups = $projects.GroupName | Sort-Object -Unique
Write-Host "Beschikbare projectgroepen:`n"
$allGroups | ForEach-Object { Write-Host " - $_" }

Write-Host "`nVoer de namen in van de groepen die je wilt verwijderen (komma gescheiden):"
$input = Read-Host
$toRemove = $input -split "," | ForEach-Object { $_.Trim() }

Write-Host "`n Wil je ook ALLE VM’s en VHDX’en verwijderen?"
$removeVMs = Read-Host "(Y/N)"
$DeleteVMs = ($removeVMs -match '^[Yy]$')

foreach ($grp in $toRemove) {

    if (-not ($allGroups -contains $grp)) {
        Write-Host " Groep '$grp' staat niet in Projects.csv" -ForegroundColor Yellow
        continue
    }

    Write-Host "`n Verwerken project '$grp'" -ForegroundColor Cyan

    $vmsForGroup = $projects | Where-Object { $_.GroupName -eq $grp }

    foreach (${HVHost} in $HyperVHosts) {

        $vmNames = $vmsForGroup.VMName | Sort-Object -Unique

        if ($DeleteVMs -and $vmNames) {
            foreach ($vmName in $vmNames) {
                try {
                    Invoke-Command -ComputerName ${HVHost} -ScriptBlock {
                        param($vmName)

                        $vm = Get-VM -Name $vmName -ErrorAction SilentlyContinue
                        if (-not $vm) { return }

                        # VHDX-paden ophalen
                        $vhdPaths = (Get-VMHardDiskDrive -VMName $vmName -ErrorAction SilentlyContinue).Path

                        if ($vm.State -eq 'Running') {
                            Stop-VM -Name $vmName -Force -TurnOff -Confirm:$false
                        }

                        Remove-VM -Name $vmName -Force

                        foreach ($vhd in $vhdPaths) {
                            if ($vhd -and (Test-Path $vhd)) {
                                Remove-Item -Path $vhd -Force -ErrorAction SilentlyContinue
                            }
                        }

                    } -ArgumentList $vmName -ErrorAction Stop

                    Write-Host "   VM '$vmName' + VHDX op ${HVHost} verwijderd" -ForegroundColor Green
                }
                catch {
                    Write-Host "   Fout bij verwijderen van VM '$vmName' op ${HVHost}: $($_.Exception.Message)" -ForegroundColor Red
                }
            }
        }

        # Groep op die host verwijderen
        try {
            Invoke-Command -ComputerName ${HVHost} -ScriptBlock {
                param($grpName)
                $g = Get-VMGroup -Name $grpName -ErrorAction SilentlyContinue
                if ($g) {
                    Remove-VMGroup -Name $grpName -Force
                }
            } -ArgumentList $grp -ErrorAction Stop

            Write-Host "   Groep '$grp' verwijderd op host ${HVHost}" -ForegroundColor Green
        }
        catch {
            Write-Host "   Kon groep '$grp' niet verwijderen op ${HVHost}: $($_.Exception.Message)" -ForegroundColor Red
        }
    }

    # Regels uit Projects.csv verwijderen
    $projects = $projects | Where-Object { $_.GroupName -ne $grp }
    $projects | Export-Csv $CSVProjects -NoTypeInformation -Force

    # Regels uit GroupNotes.csv verwijderen
    if (Test-Path $CSVLocGRnotes) {
        $gn = Import-Csv $CSVLocGRnotes
        $gn = $gn | Where-Object { $_.Name -ne $grp }
        $gn | Export-Csv $CSVLocGRnotes -NoTypeInformation -Force
    }

    Write-Host "   CSV's opgeschoond voor project '$grp'" -ForegroundColor Cyan
}

Write-Host "`n VERWIJDEREN VOLTOOID!" -ForegroundColor Green
