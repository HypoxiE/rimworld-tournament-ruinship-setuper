$fileId = "1eEBGmfh7Gu2g_KQoCiVg8XsRM9m_-DZB"
$baseUrl = "https://drive.google.com/uc?export=download&id=$fileId"

$rimworldPath = Join-Path $env:USERPROFILE "AppData\LocalLow\Ludeon Studios\RimWorld by Ludeon Studios"
$rimworldConfigPath = Join-Path $rimworldPath "Scenarios\RuinShip.rsc"

$response = Invoke-WebRequest -Uri $baseUrl -SessionVariable session

Write-Host "[INFO] Downloading scenario..."
Invoke-WebRequest -Uri $baseUrl -OutFile $rimworldConfigPath

Write-Host "[INFO] RuinShip.rsc was successfully downloaded." -ForegroundColor Green