$fileId = "1FjXPGNAZLpm_rYxnsEDvAJWi3z2ycwk0"
$baseUrl = "https://drive.google.com/uc?export=download&id=$fileId"

$rimworldPath = Join-Path $env:USERPROFILE "AppData\LocalLow\Ludeon Studios\RimWorld by Ludeon Studios"
$rimworldScenarioPath = Join-Path $rimworldPath "Scenarios\RuinShip.rsc"

$response = Invoke-WebRequest -Uri $baseUrl -SessionVariable session

Write-Host "[INFO] Downloading scenario..."
Invoke-WebRequest -Uri $baseUrl -OutFile $rimworldScenarioPath

Write-Host "[INFO] RuinShip.rsc was successfully downloaded." -ForegroundColor Green