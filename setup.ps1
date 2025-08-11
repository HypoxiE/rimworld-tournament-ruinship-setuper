$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$rimworldModsPath = Resolve-Path (Join-Path $scriptDir "..")
$tmpHtml   = "$env:TEMP\ruinship_tournament_gd.html"
$ModsFilesId = "13im-l6X2j-s5scZZlBvt2DCjYBbk2qI8"
$OutFile = "$env:TEMP\ruinship_tournament_mods.zip"

Invoke-WebRequest -Uri "https://drive.google.com/uc?export=download&id=$ModsFilesId" -OutFile $tmpHtml -SessionVariable session

$htmlContent = Get-Content $tmpHtml -Raw

if ($htmlContent -match 'confirm=([0-9A-Za-z_]+)') {
    $confirmToken = $matches[1]
    if ($htmlContent -match 'name="uuid" value="([0-9a-f-]+)"') {
        $uuid = $matches[1]
    } else {
        $uuid = ""
    }
    Write-Host "Found confirm-token: $confirmToken"
    Write-Host "Found uuid: $uuid"

    $downloadUrl = "https://drive.google.com/uc?export=download&confirm=$confirmToken&id=$ModsFilesId"
    if ($uuid) {
        $downloadUrl += "&uuid=$uuid"
    }
    Write-Host "Downloading from URL: $downloadUrl"
    Invoke-WebRequest -Uri $downloadUrl -WebSession $session -OutFile $OutFile
} else {
    Write-Host "No confirm token found, downloading directly..."
    Invoke-WebRequest -Uri "https://drive.google.com/uc?export=download&id=$ModsFilesId" -WebSession $session -OutFile $OutFile
}

Write-Host "Extracting archive..."
Expand-Archive -Path $OutFile -DestinationPath $rimworldModsPath -Force
