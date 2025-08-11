@echo off
setlocal enabledelayedexpansion
chcp 65001

if "%1"=="-mode" (
	if "%2"=="" (
		echo Ошибка: Аргумент не передан
		exit /b 1
	)
	if "%2"=="mods" (
		call :modsInstall
		goto end
	)
	if "%2"=="config" (
		call :ModsConfigInstall
		goto end
	)
	if "%2"=="scenario" (
		call :ScenarioInstall
		goto end
	)
	if "%2"=="all" (
		call :installAll
		goto end
	)
	echo Ошибка: Режима %2 не существует
	goto end
)

echo Укажите, что вам нужно сделать:
:ask
echo 1) Установить моды (они будут только установлены в качестве архива и их надо будет вручную распаковать)
echo 2) Поставить сценарий
echo 3) Поставить ModsConfig
echo 4) Установить всё
echo 5) Выйти

set /p choice=Введите нужный пункт:

if /i "%choice%"=="1" (
	call :modsInstall
	echo Не забудьте распаковать моды из архива в папке Mods^^!
	echo Вам что-то ещё?
	goto ask
)
if /i "%choice%"=="2" (
	call :ModsConfigInstall
	echo Вам что-то ещё?
	goto ask
)
if /i "%choice%"=="3" (
	call :ScenarioInstall
	echo Вам что-то ещё?
	goto ask
)
if /i "%choice%"=="4" (
	call :installAll

	echo Всё готово^^! Осталось только распаковать моды из архива в папке Mods и можно начинать играть^^!
	pause
	goto end
)
if /i "%choice%"=="5" (
	echo Выхожу...
	goto end
)
echo Варианта %choice% не существует
goto ask

::	Функции
:modsInstall
powershell -ExecutionPolicy Bypass -File "%~dp0download_mods.ps1"
goto :eof

:ScenarioInstall
powershell -ExecutionPolicy Bypass -File "%~dp0install_scenario.ps1"
goto :eof

:ModsConfigInstall
powershell -ExecutionPolicy Bypass -File "%~dp0install_modsconfig.ps1"
goto :eof

:installAll
powershell -ExecutionPolicy Bypass -File "%~dp0install_modsconfig.ps1"
powershell -ExecutionPolicy Bypass -File "%~dp0install_scenario.ps1"
powershell -ExecutionPolicy Bypass -File "%~dp0download_mods.ps1"
goto :eof

:end