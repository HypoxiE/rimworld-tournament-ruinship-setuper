$fileId = "1ThXqgIWADSV9Lwx0NJRIotjiLHWe0mdm"
$baseUrl = "https://drive.google.com/uc?export=download&id=$fileId"
$outputFile = "$env:TEMP\ruinship_mods.zip"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$rimworldMods = Resolve-Path (Join-Path $scriptDir "..")

if (-not($rimworldMods -like "*Mods")) {
	Write-Host "[WARNING] The program is not located in the Mods folder of the RimWorld game. The game will now be searched in the steam library." -ForegroundColor Yellow

	Write-Host "[INFO] Search for a game on steam..."
	
	$rimworldMods = "C:\Program Files (x86)\Steam\steamapps\common\RimWorld\Mods"

	if (-not(Test-Path $rimworldMods)) {
		Write-Host "[ERROR] Place this program in the Mods folder of the RimWorld game" -ForegroundColor Red
		Pause
		exit
	}
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

	Write-Host "[INFO] Downloading mods (~50 000 000 bytes)..."
	Invoke-WebRequest -Uri $downloadUrl -WebSession $session -OutFile $outputFile
	Write-Host "[INFO] The file was successfully downloaded with confirmation."
}
else {
	Write-Host "[INFO] Downloading mods..."
	Invoke-WebRequest -Uri $baseUrl -OutFile $outputFile
	Write-Host "[INFO] The file was successfully downloaded directly."
}

Expand-Archive -Path $outputFile -DestinationPath $rimworldMods -Force

Write-Host "[INFO] Cleaning up..."
Remove-Item $outputFile

Write-Host "[INFO] Mods have been successfully installed to the path $rimworldMods!" -ForegroundColor Green
