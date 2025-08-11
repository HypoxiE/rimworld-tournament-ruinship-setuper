@echo off
setlocal enabledelayedexpansion
chcp 65001

echo Укажите, что вам нужно сделать:
:ask
echo 1) Установить моды (они будут только установлены в качестве архива и их надо будет вручную распаковать)
echo 2) Поставить сценарий
echo 3) Поставить ModsConfig
echo 4) Установить всё
echo 5) Выйти

set /p choice=Введите нужный пункт:

if /i "%choice%"=="1" (
	powershell -ExecutionPolicy Bypass -File "%~dp0download_mods.ps1"
	echo Вам что-то ещё?
	goto ask
)
if /i "%choice%"=="2" (

	echo Пока функция не готова. Вам что-то ещё?
	goto ask
)
if /i "%choice%"=="3" (

	echo Пока функция не готова. Вам что-то ещё?
	goto ask
)
if /i "%choice%"=="4" (
	powershell -ExecutionPolicy Bypass -File "%~dp0download_mods.ps1"

	echo Всё готово^^! Осталось только распаковать моды из архива в папке Mods и можно начинать играть^^!
	goto end
)
if /i "%choice%"=="5" (
	echo Выхожу...
	goto end
)
echo Варианта %choice% не существует
goto ask

:end