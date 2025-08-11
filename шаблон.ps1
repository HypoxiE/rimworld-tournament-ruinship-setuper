# Указываем ссылки и пути
$repoUrl = "https://github.com/HypoxiE/rimworld-add-my-music-mod/archive/refs/heads/main.zip"
$zipPath = "$env:TEMP\custom_music.zip"
$extractPath = "$env:TEMP\custom_music_temp"

# Путь к папке Mods
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$steamappsPath = Resolve-Path (Join-Path $scriptDir "..\..\..\..")
if (-not($steamappsPath -like "*steamapps")){
	Write-Host "[ERROR] The download is not possible because the mod is not located in the steamapps\workshop\content\294100\3523549667 folder" -ForegroundColor Red
	Write-Host "[INFO]  You can download the mod manually from the page https://github.com/HypoxiE/rimworld-add-my-music-mod if you are using an unlicensed version of the game"
	Pause
	exit
}
$rimworldMods = Join-Path $steamappsPath "common\RimWorld\Mods"
if (-not(Test-Path $rimworldMods)) {
	Write-Host "[ERROR] The download is not possible because the game is not detected on the steamapps\common\RimWorld path" -ForegroundColor Red
	Write-Host "[INFO]  You can download the mod manually from the page https://github.com/HypoxiE/rimworld-add-my-music-mod if you are using an unlicensed version of the game"
	Pause
	exit
}
$instalationPath = Join-Path $rimworldMods "add_my_music_mod"
Write-Host "[DEBUG] Detected Steamapps: $steamappsPath"
Write-Host "[DEBUG] RimWorld Mods folder: $rimworldMods"

# Скачиваем и распаковываем архив
Write-Host "[INFO] Downloading mod from GitHub..."
Invoke-WebRequest -Uri $repoUrl -OutFile $zipPath
Write-Host "[INFO] Extracting..."
Expand-Archive -Path $zipPath -DestinationPath $extractPath -Force

# Удаляем старую папку мода, если есть
if (Test-Path $instalationPath) {
    Write-Host "[INFO] Removing old mod files..."
    Remove-Item -Recurse -Force $instalationPath
}

# Переносим файлы в Mods
Write-Host "[INFO] Installing mod..."
$sourceFolder = Get-ChildItem $extractPath | Select-Object -First 1
Move-Item -Path $sourceFolder.FullName -Destination $instalationPath

# Создаём нужные папки
New-Item -ItemType Directory -Path (Join-Path $instalationPath "Defs\SongDefs") -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $instalationPath "Sounds\Gameplay") -Force | Out-Null

# Удаляем временные файлы
Write-Host "[INFO] Cleaning up..."
Remove-Item $zipPath
Remove-Item $extractPath -Recurse -Force

Write-Host "[INFO] Done! Mod installed to $instalationPath"
Write-Host "The installation is complete and the window can be closed. If you want to copy the path to the mod folder, press Enter" -ForegroundColor Green
Pause
Set-Clipboard -Value "$instalationPath"
Write-Host "[INFO] The path is copied"
Pause