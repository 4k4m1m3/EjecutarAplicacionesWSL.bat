@echo off
setlocal enabledelayedexpansion

where /q wsl.exe
if errorlevel 1 (
    echo Error: WSL no esta instalado en este sistema.
    pause
    exit /b 1
)

echo Listando aplicaciones disponibles...
wsl.exe -d ParrotOS -e bash -c "ls /usr/share/applications/*.desktop | xargs -n 1 basename | sed 's/.desktop//'" > temp_apps.txt

set /a appCount=0
for /f "tokens=*" %%a in (temp_apps.txt) do (
    set /a appCount+=1
    set "app[!appCount!]=%%a"
)

del temp_apps.txt

if %appCount% equ 0 (
    echo No se encontraron aplicaciones disponibles.
    pause
    exit /b 1
)

echo =============================================
echo       Lista de Aplicaciones Disponibles
echo =============================================
for /l %%i in (1,1,%appCount%) do (
    echo !app[%%i]!
)

echo.

echo.
echo .: Desarrollador :.
echo Version: 1.0
echo Autor: 4k4m1m3
echo Web: 4k4m4m3.com
echo LinkedIn: https://www.linkedin.com/in/4k4m1m3/
echo.

echo [0] Salir
echo.

:selectApp
set /p "userSelection=Ingrese el nombre de la aplicacion (0 para salir): "

if "%userSelection%"=="0" (
    echo Saliendo...
    pause
    exit /b 0
)

set appFound=false
for /l %%i in (1,1,%appCount%) do (
    if /i "!app[%%i]!"=="%userSelection%" (
        set "appToRun=!app[%%i]!"
        set appFound=true
    )
)

if not !appFound! == true (
    echo Aplicacion no encontrada. Por favor, intente de nuevo.
    goto selectApp
)

echo Ejecutando la aplicacion: %appToRun%
wsl.exe -d ParrotOS -e dbus-launch %appToRun%

if errorlevel 1 (
    echo Error al ejecutar la aplicacion: %appToRun%
) else (
    echo Aplicacion ejecutada correctamente.
)

pause
exit /b 0
