$fileId = "1xxASbjTXkFWIGRwJe3zxgCqRXH4Kg_MD"
$baseUrl = "https://drive.google.com/uc?export=download&id=$fileId"

$rimworldPath = Join-Path $env:USERPROFILE "AppData\LocalLow\Ludeon Studios\RimWorld by Ludeon Studios"
$rimworldConfigPath = Join-Path $rimworldPath "Config\ModsConfig.xml"

$response = Invoke-WebRequest -Uri $baseUrl -SessionVariable session

$form = $response.Forms | Where-Object { $_.Id -eq "download-form" }
$queryParams = @{}
foreach ($field in $form.Fields.GetEnumerator()) {
	$queryParams[$field.Key] = $field.Value
}

$uriBuilder = New-Object System.UriBuilder $form.Action
$queryString = ($queryParams.GetEnumerator() | ForEach-Object { "$($_.Key)=$($_.Value)" }) -join "&"
$uriBuilder.Query = $queryString
$downloadUrl = $uriBuilder.Uri.AbsoluteUri

Write-Host "[INFO] Downloading ModsConfig.xml..."
Invoke-WebRequest -Uri $downloadUrl -WebSession $session -OutFile $rimworldConfigPath

Write-Host "[INFO] ModsConfig.xml was successfully downloaded." -ForegroundColor Green