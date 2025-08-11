$fileId = "13im-l6X2j-s5scZZlBvt2DCjYBbk2qI8"
$baseUrl = "https://drive.google.com/uc?export=download&id=$fileId"
$outputFile = "$env:TEMP\ruinship_mods.rar"

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

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$rimworldMods = Resolve-Path (Join-Path $scriptDir "..")

$sourceFolder = Get-ChildItem $outputFile | Select-Object -First 1
Copy-Item -Path $sourceFolder.FullName -Destination $rimworldMods

Write-Host "[INFO] Cleaning up..."
Remove-Item $outputFile

Write-Host "[INFO] The ruinship_mods.rar file has been installed to the path $rimworldMods. Please extract it to install all the necessary mods." -ForegroundColor Green
