$fileId = "13im-l6X2j-s5scZZlBvt2DCjYBbk2qI8"
$baseUrl = "https://drive.google.com/uc?export=download&id=$fileId"
$outputFile = "$env:TEMP\ruinship_mods.rar"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$rimworldMods = Resolve-Path (Join-Path $scriptDir "..")

if (-not($rimworldMods -like "*Mods")) {
	Write-Host "[Error] Place this program in the Mods folder of the RimWorld game" -ForegroundColor Red
	Pause
	exit
}

$ruinship_mod = Join-Path $rimworldMods "\ruinship_mods.rar"

if (Test-Path $rimworldMods) {
	Write-Host "[WARNING] The archive ruinship_mods.rar already exists" -ForegroundColor Yellow
	Write-Host "[INFO] Deleting the archive..."
	Remove-Item -Recurse -Force $ruinship_mod
}

Write-Host "[INFO] Sending a request to google disk..."
$response = Invoke-WebRequest -Uri $baseUrl -SessionVariable session

$form = $response.Forms | Where-Object { $_.Id -eq "download-form" }

if ($form) {
	$queryParams = @{}
	foreach ($field in $form.Fields.GetEnumerator()) {
		$queryParams[$field.Key] = $field.Value
	}

	$uriBuilder = New-Object System.UriBuilder $form.Action
	$queryString = ($queryParams.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&"
	$uriBuilder.Query = $queryString
	$downloadUrl = $uriBuilder.Uri.AbsoluteUri

	Write-Host "[INFO] Downloading mods..."
	Invoke-WebRequest -Uri $downloadUrl -WebSession $session -OutFile $outputFile
	Write-Host "[INFO] The file was successfully downloaded with confirmation."
}
else {
	Write-Host "[INFO] Downloading mods..."
	Invoke-WebRequest -Uri $baseUrl -OutFile $outputFile
	Write-Host "[INFO] The file was successfully downloaded directly."
}

$sourceFolder = Get-ChildItem $outputFile | Select-Object -First 1
Copy-Item -Path $sourceFolder.FullName -Destination $rimworldMods

Write-Host "[INFO] Cleaning up..."
Remove-Item $outputFile

Write-Host "The ruinship_mods.rar file has been installed to the path $rimworldMods. Please extract it to install all the necessary mods." -ForegroundColor Green
