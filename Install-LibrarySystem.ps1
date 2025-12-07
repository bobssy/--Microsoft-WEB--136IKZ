<#
.SYNOPSIS
    Автоматична инсталация на Library Management System

.DESCRIPTION
    Този скрипт автоматично инсталира и конфигурира системата за управление на библиотека.
    
    Автор: Божидар Георгиев
    Email: 136ikz@unibit.bg
    Дата: 11 ноември 2025

.EXAMPLE
    .\Install-LibrarySystem.ps1
#>

# ========================================================================================================
# НАСТРОЙКИ
# ========================================================================================================
$ErrorActionPreference = "Stop"
$ProjectPath = $PSScriptRoot
$WebProjectPath = Join-Path $ProjectPath "LibraryManagementSystem"
$DatabaseName = "LibrarySystem.db"

# ========================================================================================================
# ФУНКЦИИ
# ========================================================================================================

function Write-ColorOutput {
    param(
        [string]$Message,
        [string]$Color = "White"
    )
    Write-Host $Message -ForegroundColor $Color
}

function Write-Step {
    param([string]$Message)
    Write-ColorOutput "`n========================================" "Cyan"
    Write-ColorOutput $Message "Cyan"
    Write-ColorOutput "========================================`n" "Cyan"
}

function Test-DotNetInstalled {
    try {
        $dotnetVersion = dotnet --version
        Write-ColorOutput "✓ .NET SDK $dotnetVersion е инсталиран" "Green"
        return $true
    }
    catch {
        Write-ColorOutput "✗ .NET SDK не е намерен!" "Red"
        Write-ColorOutput "Моля, инсталирайте .NET 8 SDK от: https://dotnet.microsoft.com/download" "Yellow"
        return $false
    }
}

function Update-ConnectionString {
    $appsettingsPath = Join-Path $WebProjectPath "appsettings.json"
    
    Write-ColorOutput "Конфигуриране на база данни (SQLite)..." "Yellow"
    
    if (Test-Path $appsettingsPath) {
        $appsettings = Get-Content $appsettingsPath -Raw | ConvertFrom-Json
        
        # Използваме SQLite за лесна инсталация
        $appsettings.ConnectionStrings.DefaultConnection = "Data Source=$DatabaseName"
        
        $appsettings | ConvertTo-Json -Depth 10 | Set-Content $appsettingsPath
        Write-ColorOutput "✓ Connection string конфигуриран за SQLite" "Green"
    }
    else {
        Write-ColorOutput "✗ appsettings.json не е намерен!" "Red"
        throw "Файлът appsettings.json липсва"
    }
}

function Install-Dependencies {
    Write-Step "СТЪПКА 1: Конфигуриране на NuGet"
    
    # Поправка на PackageSourceMapping проблем
    $nugetConfig = Join-Path $env:APPDATA "NuGet\NuGet.Config"
    
    if (Test-Path $nugetConfig) {
        Write-ColorOutput "Намерен NuGet.Config, проверка за PackageSourceMapping..." "Yellow"
        
        $content = Get-Content $nugetConfig -Raw
        if ($content -match "<packageSourceMapping>") {
            Write-ColorOutput "Деактивиране на PackageSourceMapping..." "Yellow"
            
            # Backup
            Copy-Item $nugetConfig "$nugetConfig.backup" -Force
            Write-ColorOutput "✓ Backup създаден: $nugetConfig.backup" "Green"
            
            # Премахване на packageSourceMapping секцията
            $content = $content -replace '(?s)<packageSourceMapping>.*?</packageSourceMapping>', ''
            $content | Set-Content $nugetConfig
            
            Write-ColorOutput "✓ PackageSourceMapping деактивиран" "Green"
        }
    }
    
    # Добавяне на nuget.org source ако липсва
    Write-ColorOutput "Добавяне на nuget.org source..." "Yellow"
    dotnet nuget add source https://api.nuget.org/v3/index.json -n nuget.org 2>$null
    
    # Изчистване на кеш
    Write-ColorOutput "Изчистване на NuGet кеш..." "Yellow"
    dotnet nuget locals all --clear | Out-Null
    Write-ColorOutput "✓ NuGet кеш изчистен" "Green"
    
    Write-Step "СТЪПКА 2: Инсталиране на зависимости"
    
    Set-Location $ProjectPath
    
    Write-ColorOutput "Възстановяване на NuGet пакети..." "Yellow"
    dotnet restore --force --no-cache
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput "✓ Зависимостите са инсталирани успешно" "Green"
    }
    else {
        throw "Грешка при инсталиране на зависимости. Опитайте: 1) Пуснете Fix-NuGet.bat първо 2) Затворете и отворете отново PowerShell"
    }
}

function Add-SqliteSupport {
    Write-ColorOutput "Добавяне на SQLite поддръжка..." "Yellow"
    
    Set-Location $WebProjectPath
    
    # Проверка дали SQLite пакетът е инсталиран
    $csprojContent = Get-Content "LibraryManagementSystem.csproj" -Raw
    
    if ($csprojContent -notmatch "Microsoft.EntityFrameworkCore.Sqlite") {
        Write-ColorOutput "Инсталиране на EntityFrameworkCore.Sqlite пакет..." "Yellow"
        dotnet add package Microsoft.EntityFrameworkCore.Sqlite --version 8.0.0
        Write-ColorOutput "✓ SQLite пакет добавен" "Green"
    }
    else {
        Write-ColorOutput "✓ SQLite пакет вече е инсталиран" "Green"
    }
}

function Update-DbContext {
    Write-ColorOutput "Обновяване на DbContext за SQLite..." "Yellow"
    
    $dbContextPath = Join-Path $ProjectPath "Library.Repositories\ApplicationDbContext.cs"
    
    if (Test-Path $dbContextPath) {
        Write-ColorOutput "✓ ApplicationDbContext намерен" "Green"
    }
}

function Install-EFTools {
    # Проверка дали EF Core Tools са инсталирани
    $efCheck = dotnet tool list --global | Select-String "dotnet-ef"
    
    if (-not $efCheck) {
        Write-ColorOutput "Инсталиране на Entity Framework Core Tools..." "Yellow"
        dotnet tool install --global dotnet-ef --version 8.0.0
        
        if ($LASTEXITCODE -eq 0) {
            Write-ColorOutput "✓ EF Core Tools инсталирани" "Green"
        }
        else {
            Write-ColorOutput "✗ Грешка при инсталиране на EF Core Tools" "Red"
            throw "EF Core Tools инсталацията е неуспешна"
        }
    }
    else {
        Write-ColorOutput "✓ EF Core Tools вече са инсталирани" "Green"
    }
}

function Initialize-Database {
    Write-Step "СТЪПКА 2: Инициализация на база данни"
    
    Set-Location $WebProjectPath
    
    # Изтриване на стара база ако съществува
    if (Test-Path $DatabaseName) {
        Write-ColorOutput "Изтриване на стара база данни..." "Yellow"
        Remove-Item $DatabaseName -Force
    }
    
    Write-ColorOutput "Създаване на нова база данни..." "Yellow"
    dotnet ef database update
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput "✓ Базата данни е създадена успешно" "Green"
    }
    else {
        throw "Грешка при създаване на база данни"
    }
}

function Build-Project {
    Write-Step "СТЪПКА 3: Компилиране на проекта"
    
    Set-Location $ProjectPath
    
    Write-ColorOutput "Компилиране..." "Yellow"
    dotnet build --configuration Release
    
    if ($LASTEXITCODE -eq 0) {
        Write-ColorOutput "✓ Проектът е компилиран успешно" "Green"
    }
    else {
        throw "Грешка при компилиране"
    }
}

function Show-Completion {
    Write-Step "ИНСТАЛАЦИЯТА ЗАВЪРШИ УСПЕШНО!"
    
    Write-ColorOutput @"

╔════════════════════════════════════════════════════════════════╗
║         СИСТЕМАТА ЗА УПРАВЛЕНИЕ НА БИБЛИОТЕКА                  ║
║                   Е ГОТОВА ЗА ИЗПОЛЗВАНЕ!                      ║
╚════════════════════════════════════════════════════════════════╝

📚 Проект: Library Management System
👨‍💻 Автор: Божидар Георгиев
📧 Email: 136ikz@unibit.bg

"@ "Green"

    Write-ColorOutput "За да стартирате приложението:" "Cyan"
    Write-ColorOutput "  1. cd LibraryManagementSystem" "White"
    Write-ColorOutput "  2. dotnet run" "White"
    Write-ColorOutput "  3. Отворете браузър на: https://localhost:5001" "White"
    Write-ColorOutput ""
    
    Write-ColorOutput "Първоначални данни за вход:" "Cyan"
    Write-ColorOutput "  Администратор:" "Yellow"
    Write-ColorOutput "    Email: admin@library.bg" "White"
    Write-ColorOutput "    Парола: Admin123!" "White"
    Write-ColorOutput ""
    Write-ColorOutput "  Библиотекар:" "Yellow"
    Write-ColorOutput "    Email: librarian@library.bg" "White"
    Write-ColorOutput "    Парола: Librarian123!" "White"
    Write-ColorOutput ""
    Write-ColorOutput "  Член:" "Yellow"
    Write-ColorOutput "    Email: member@library.bg" "White"
    Write-ColorOutput "    Парола: Member123!" "White"
    Write-ColorOutput ""
    
    Write-ColorOutput "За повече информация вижте README.md" "Cyan"
    Write-ColorOutput ""
}

function Start-Application {
    $response = Read-Host "Искате ли да стартирате приложението сега? (Y/N)"
    
    if ($response -eq "Y" -or $response -eq "y") {
        Write-ColorOutput "`nСтартиране на приложението..." "Green"
        Set-Location $WebProjectPath
        
        Write-ColorOutput "`nПриложението се стартира на:" "Cyan"
        Write-ColorOutput "  https://localhost:5001" "Yellow"
        Write-ColorOutput "  http://localhost:5000" "Yellow"
        Write-ColorOutput "`nНатиснете Ctrl+C за спиране на приложението`n" "Gray"
        
        # Стартиране в нов прозорец за да не блокира конзолата
        Start-Process powershell -ArgumentList "-NoExit", "-Command", "cd '$WebProjectPath'; dotnet run"
        
        Start-Sleep -Seconds 3
        Start-Process "https://localhost:5001"
    }
}

# ========================================================================================================
# ГЛАВНА ЛОГИКА
# ========================================================================================================

try {
    Clear-Host
    
    Write-ColorOutput @"
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║     ИНСТАЛАЦИЯ НА СИСТЕМА ЗА УПРАВЛЕНИЕ НА БИБЛИОТЕКА         ║
║                                                                ║
║     Автор: Божидар Георгиев                                    ║
║     Email: 136ikz@unibit.bg                                    ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
"@ "Cyan"

    Write-ColorOutput "`nНачало на инсталация...`n" "Yellow"
    
    # Проверка за .NET
    Write-Step "ПРОВЕРКА НА СИСТЕМАТА"
    if (-not (Test-DotNetInstalled)) {
        exit 1
    }
    
    # Стъпка 1: Инсталиране на зависимости
    Install-Dependencies
    
    # Добавяне на SQLite поддръжка
    Write-Step "СТЪПКА 3: Добавяне на SQLite поддръжка"
    Add-SqliteSupport
    
    # Конфигуриране на connection string
    Update-ConnectionString
    
    # Инсталиране на EF Core Tools
    Write-Step "СТЪПКА 4: Инсталиране на Entity Framework инструменти"
    Install-EFTools
    
    # Стъпка 2: Инициализация на база данни
    Write-Step "СТЪПКА 5: Инициализация на база данни"
    Initialize-Database
    
    # Стъпка 3: Компилиране
    Write-Step "СТЪПКА 6: Компилиране на проекта"
    Build-Project
    
    # Завършване
    Show-Completion
    
    # Опция за стартиране
    Start-Application
}
catch {
    Write-ColorOutput "`n✗ ГРЕШКА ПРИ ИНСТАЛАЦИЯ: $_" "Red"
    Write-ColorOutput "`nЗа помощ, вижте README.md или се свържете с автора." "Yellow"
    exit 1
}
finally {
    Set-Location $ProjectPath
}
