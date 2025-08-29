# Laad de notities door de CSV te importeren
$notes = Import-Csv $CSVLocGRnotes

# Haal groepen op uit de geimporteerde CSV
$groups = Get-VMGroup | Select-Object Name, GroupType

# Stel ja/nee vraag
$vraag = Read-host "CSV Genereren, Y/N?"

# Haal VM groepen op en voeg notities toe
$merge = foreach ($group in (Get-VMGroup)) {
    $note = ($notes | Where-Object { $_.Name -eq $group.Name }).NotesGroup
    [PSCustomObject]@{
        Name       = $group.Name
        GroupType  = $group.GroupType
        NotesGroup = ($note -join "; ")
    }
}

if ($vraag -eq "Y") {
    $merge | Format-Table -AutoSize    
    $merge | Export-Csv -Path $CSVlocGRnotes -NoTypeInformation -Force
    Write-Host "Overzicht geëxporteerd naar $CSVLocGRnotes"}                                
# if ($vraag -eq "N") {$merge | Format-Table -AutoSize}