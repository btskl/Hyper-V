# Pad naar centrale SMB-share
$sharePath = "\\MANAGEMENTPC\niksnutw7\vscode-server"

# Pad naar VS Code CLI

$vsCodePath = "$env:USERPROFILE\AppData\Local\Programs\Microsoft VS Code\bin\code.cmd"

# Check of VS Code geïnstalleerd is
if (Test-Path $vsCodePath) {
    Write-Host "VS Code gevonden. Commit ID uitlezen..." -ForegroundColor Green

    # Haal de volledige versie-informatie op
    $versionInfo = & $vsCodePath --version

    # Commit ID staat op de tweede regel
    $commitId = $versionInfo | Select-Object -Index 1

    if ($commitId) {
        Write-Host "Commit ID: $commitId" -ForegroundColor Cyan

        # Hernoem de bestanden direct in de SMB-share op basis van de commit ID
        Get-ChildItem -Path $sharePath -Filter "vscode-cli-*" | ForEach-Object {
            #extensie ophalen
	    $fullExtension = $_.Name -replace '^[^\.]+', ''

            $newName = "vscode-cli-$commitId$fullExtension"
            Rename-Item -Path $_.FullName -NewName $newName -Force
            Write-Host "Bestand '$($_.Name)' hernoemd naar '$newName'" -ForegroundColor Green
        }
    }
    else {
        Write-Host "Geen commit ID gevonden in VS Code output." -ForegroundColor Yellow
    }
}
else {
    Write-Host "VS Code is niet geïnstalleerd op deze machine." -ForegroundColor Red
}
