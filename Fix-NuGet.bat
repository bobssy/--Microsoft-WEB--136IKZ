@echo off
chcp 65001 >nul
REM ========================================================================================================
REM ПОПРАВКА НА NUGET КОНФИГУРАЦИЯ
REM ========================================================================================================
REM Автор: Божидар Георгиев
REM Email: 136ikz@unibit.bg
REM ========================================================================================================

color 0E
echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║                                                                ║
echo ║              ПОПРАВКА НА NUGET КОНФИГУРАЦИЯ                    ║
echo ║                                                                ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

echo Този скрипт ще поправи проблема с PackageSourceMapping
echo.

REM Намиране на NuGet.Config файл
set "NUGET_CONFIG=%APPDATA%\NuGet\NuGet.Config"

if not exist "%NUGET_CONFIG%" (
    echo NuGet.Config не е намерен. Създаване на нов...
    mkdir "%APPDATA%\NuGet" 2>nul
    (
        echo ^<?xml version="1.0" encoding="utf-8"?^>
        echo ^<configuration^>
        echo   ^<packageSources^>
        echo     ^<add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" /^>
        echo   ^</packageSources^>
        echo ^</configuration^>
    ) > "%NUGET_CONFIG%"
    echo ✓ Нов NuGet.Config създаден
) else (
    echo Намерен: %NUGET_CONFIG%
    echo Правене на резервно копие...
    copy "%NUGET_CONFIG%" "%NUGET_CONFIG%.backup" >nul
    echo ✓ Резервно копие: %NUGET_CONFIG%.backup
    echo.
    
    echo Премахване на PackageSourceMapping...
    powershell -Command "$content = Get-Content '%NUGET_CONFIG%' -Raw; $content = $content -replace '(?s)<packageSourceMapping>.*?</packageSourceMapping>', ''; $content | Set-Content '%NUGET_CONFIG%'"
    
    echo ✓ PackageSourceMapping премахнат
)

echo.
echo Добавяне на nuget.org като source...
dotnet nuget add source https://api.nuget.org/v3/index.json -n nuget.org 2>nul
echo ✓ nuget.org добавен
echo.

echo Изчистване на NuGet кеш...
dotnet nuget locals all --clear
echo ✓ Кеш изчистен
echo.

color 0A
echo ╔════════════════════════════════════════════════════════════════╗
echo ║              ПОПРАВКАТА ЗАВЪРШИ УСПЕШНО!                       ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.
echo Сега пуснете отново Install.bat
echo.

pause
