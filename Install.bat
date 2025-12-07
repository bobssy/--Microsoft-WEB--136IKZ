@echo off
chcp 65001 >nul
REM ========================================================================================================
REM ИНСТАЛАЦИОНЕН СКРИПТ ЗА LIBRARY MANAGEMENT SYSTEM
REM ========================================================================================================
REM Автор: Божидар Георгиев
REM Email: 136ikz@unibit.bg
REM ========================================================================================================

color 0B
echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║                                                                ║
echo ║     ИНСТАЛАЦИЯ НА СИСТЕМА ЗА УПРАВЛЕНИЕ НА БИБЛИОТЕКА         ║
echo ║                                                                ║
echo ║     Автор: Божидар Георгиев                                    ║
echo ║     Email: 136ikz@unibit.bg                                    ║
echo ║                                                                ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.

REM Проверка за .NET
echo [СТЪПКА 1] Проверка за .NET SDK...
dotnet --version >nul 2>&1
if errorlevel 1 (
    color 0C
    echo ✗ .NET SDK не е намерен!
    echo Моля, инсталирайте .NET 8 SDK от: https://dotnet.microsoft.com/download
    pause
    exit /b 1
)
echo ✓ .NET SDK е инсталиран
echo.

REM Проверка и деактивиране на PackageSourceMapping ако е необходимо
echo [СТЪПКА 2] Конфигуриране на NuGet...
if exist "%APPDATA%\NuGet\NuGet.Config" (
    echo Деактивиране на PackageSourceMapping...
    powershell -Command "(Get-Content '%APPDATA%\NuGet\NuGet.Config') -replace '<packageSourceMapping>', '<!--<packageSourceMapping>' -replace '</packageSourceMapping>', '</packageSourceMapping>-->' | Set-Content '%APPDATA%\NuGet\NuGet.Config'"
)
echo ✓ NuGet конфигуриран
echo.

REM Изчистване на NuGet кеш
echo [СТЪПКА 3] Изчистване на NuGet кеш...
dotnet nuget locals all --clear
echo ✓ Кеш изчистен
echo.

REM Възстановяване на пакети с --force
echo [СТЪПКА 4] Инсталиране на зависимости...
dotnet restore --force --no-cache
if errorlevel 1 (
    color 0C
    echo ✗ Грешка при инсталиране на зависимости
    echo.
    echo Опит за ръчно инсталиране на пакети...
    dotnet nuget add source https://api.nuget.org/v3/index.json -n nuget.org
    dotnet restore --force --no-cache
    if errorlevel 1 (
        echo ✗ Все още има грешка. Вижте инструкциите по-долу.
        pause
        exit /b 1
    )
)
echo ✓ Зависимостите са инсталирани
echo.

REM Добавяне на SQLite пакет
echo [СТЪПКА 5] Добавяне на SQLite поддръжка...
cd LibraryManagementSystem
dotnet add package Microsoft.EntityFrameworkCore.Sqlite --version 8.0.0
echo ✓ SQLite пакет добавен
echo.

REM Конфигуриране на базата данни
echo [СТЪПКА 6] Конфигуриране на база данни...
powershell -Command "(Get-Content appsettings.json) -replace 'Server=.*?;', 'Data Source=LibrarySystem.db' | Set-Content appsettings.json"
echo ✓ База данни конфигурирана за SQLite
echo.

REM Инсталиране на EF Core Tools
echo [СТЪПКА 7] Инсталиране на Entity Framework инструменти...
dotnet tool list --global | findstr /C:"dotnet-ef" >nul
if errorlevel 1 (
    echo Инсталиране на EF Core Tools...
    dotnet tool install --global dotnet-ef --version 8.0.0
    if errorlevel 1 (
        color 0C
        echo ✗ Грешка при инсталиране на EF Core Tools
        pause
        exit /b 1
    )
) else (
    echo EF Core Tools вече са инсталирани
)
echo ✓ EF Core Tools готови
echo.

REM Създаване на база данни
echo [СТЪПКА 8] Създаване на база данни...
if exist LibrarySystem.db del /f LibrarySystem.db
dotnet ef database update
if errorlevel 1 (
    color 0C
    echo ✗ Грешка при създаване на база данни
    pause
    exit /b 1
)
echo ✓ Базата данни е създадена успешно
echo.

REM Компилиране
echo [СТЪПКА 9] Компилиране на проекта...
cd..
dotnet build --configuration Release
if errorlevel 1 (
    color 0C
    echo ✗ Грешка при компилиране
    pause
    exit /b 1
)
echo ✓ Проектът е компилиран успешно
echo.

REM Завършване
color 0A
echo.
echo ╔════════════════════════════════════════════════════════════════╗
echo ║         ИНСТАЛАЦИЯТА ЗАВЪРШИ УСПЕШНО!                          ║
echo ╚════════════════════════════════════════════════════════════════╝
echo.
echo За да стартирате приложението:
echo   1. cd LibraryManagementSystem
echo   2. dotnet run
echo   3. Отворете браузър на: https://localhost:5001
echo.
echo Първоначални данни за вход:
echo   Администратор:
echo     Email: admin@library.bg
echo     Парола: Admin123!
echo.
echo   Библиотекар:
echo     Email: librarian@library.bg
echo     Парола: Librarian123!
echo.
echo   Член:
echo     Email: member@library.bg
echo     Парола: Member123!
echo.
echo За повече информация вижте README.md
echo.

REM Въпрос за стартиране
set /p start="Искате ли да стартирате приложението сега? (Y/N): "
if /i "%start%"=="Y" (
    echo.
    echo Стартиране на приложението...
    cd LibraryManagementSystem
    start cmd /k "dotnet run"
    timeout /t 3 >nul
    start https://localhost:5001
)

pause
