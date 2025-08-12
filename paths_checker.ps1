$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$rimworldMods = Resolve-Path (Join-Path $scriptDir "..")

$rimworldPath = Join-Path $env:USERPROFILE "AppData\LocalLow\Ludeon Studios\RimWorld by Ludeon Studios"
$rimworldScenarioPath = Join-Path $rimworldPath "Scenarios"
$rimworldConfigPath = Join-Path $rimworldPath "Config"

Write-Host "[INFO] Checking game dirs..."
if (-not(Test-Path $rimworldPath)) {
	exit 1
}

Write-Host "[INFO] Checking scenario dir..."
if (-not(Test-Path $rimworldScenarioPath)) {
	exit 2
}

Write-Host "[INFO] Checking config dir..."
if (-not(Test-Path $rimworldConfigPath)) {
	exit 3
}

exit 0