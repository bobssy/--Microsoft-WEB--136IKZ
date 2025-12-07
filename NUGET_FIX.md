# ⚠️ Решаване на NuGet грешка NU1100

## Проблем

При инсталация виждате грешки от типа:
```
error NU1100: Unable to resolve 'AutoMapper (>= 15.0.1)' for 'net8.0'. 
PackageSourceMapping is enabled, the following source(s) were not considered: nuget.org
```

## Причина

Visual Studio или NuGet конфигурацията има активирана `PackageSourceMapping`, която блокира изтеглянето на пакети от nuget.org.

## 🔧 Решение

### Метод 1: Автоматична поправка (ПРЕПОРЪЧИТЕЛНО)

**Двоен клик на:**
```
Fix-NuGet.bat
```

След това пуснете отново:
```
Install.bat
```

### Метод 2: Ръчна поправка

**Стъпка 1:** Отворете PowerShell като администратор

**Стъпка 2:** Изпълнете:
```powershell
# Намиране на конфигурационния файл
$nugetConfig = "$env:APPDATA\NuGet\NuGet.Config"

# Backup
Copy-Item $nugetConfig "$nugetConfig.backup"

# Редактиране
$content = Get-Content $nugetConfig -Raw
$content = $content -replace '(?s)<packageSourceMapping>.*?</packageSourceMapping>', ''
$content | Set-Content $nugetConfig

# Изчистване на кеш
dotnet nuget locals all --clear

# Добавяне на source
dotnet nuget add source https://api.nuget.org/v3/index.json -n nuget.org
```

**Стъпка 3:** Опитайте отново инсталацията

### Метод 3: Изтриване на NuGet.Config

**В PowerShell:**
```powershell
Remove-Item "$env:APPDATA\NuGet\NuGet.Config"
dotnet nuget add source https://api.nuget.org/v3/index.json -n nuget.org
```

### Метод 4: Директно от Visual Studio

1. Отворете **Visual Studio**
2. **Tools** → **Options**
3. **NuGet Package Manager** → **Package Sources**
4. Уверете се, че `nuget.org` е активиран ✅
5. Ако има секция **Package Source Mapping**, изтрийте я
6. Кликнете **OK**

## ✅ Проверка

След поправката, изпълнете:
```powershell
dotnet restore --force --no-cache
```

Трябва да видите:
```
Determining projects to restore...
Restored ...
```

## 🚀 Продължете с инсталацията

След успешна поправка:

```batch
Install.bat
```

или

```powershell
.\Install-LibrarySystem.ps1
```

## 📝 Алтернативно решение

Ако горното не работи, инсталирайте пакетите ръчно:

```powershell
# Отидете в папката на проекта
cd "c:\Users\bobss\OneDrive\Desktop\Библиотека"

# Инсталирайте всеки пакет поотделно
dotnet add LibraryManagementSystem package Microsoft.EntityFrameworkCore.Sqlite --version 8.0.11
dotnet add LibraryManagementSystem package Microsoft.EntityFrameworkCore.SqlServer --version 8.0.13
dotnet add LibraryManagementSystem package Microsoft.AspNetCore.Identity.EntityFrameworkCore --version 8.0.13
dotnet add LibraryManagementSystem package AutoMapper --version 15.0.1
dotnet add LibraryManagementSystem package cloudscribe.Web.Pagination --version 8.1.0

# След това restore
dotnet restore --force
```

## 🆘 Все още не работи?

### Проверка 1: .NET SDK версия
```powershell
dotnet --version
```
Трябва да видите `8.x.x`

### Проверка 2: NuGet sources
```powershell
dotnet nuget list source
```

Трябва да видите `nuget.org` в списъка:
```
Registered Sources:
  1.  nuget.org [Enabled]
      https://api.nuget.org/v3/index.json
```

### Проверка 3: Почистване и нов опит
```powershell
# Изтриване на bin и obj папки
Get-ChildItem -Path . -Include bin,obj -Recurse -Directory | Remove-Item -Recurse -Force

# Изчистване на всички кешове
dotnet nuget locals all --clear

# Нов опит
dotnet restore --force --no-cache
```

## 📞 Помощ

Ако проблемът продължава:

1. Изпратете screenshot на грешката
2. Копирайте съдържанието на `%APPDATA%\NuGet\NuGet.Config`
3. Свържете се: **136ikz@unibit.bg**

---

## 🔍 Техническа информация

**PackageSourceMapping** е функция на NuGet, която ограничава от кои източници могат да се изтеглят пакети. Понякога Visual Studio или други инструменти я активират автоматично.

**Локация на файла:**
```
Windows: %APPDATA%\NuGet\NuGet.Config
Linux/Mac: ~/.nuget/NuGet/NuGet.Config
```

**Проблемна секция:**
```xml
<packageSourceMapping>
  <packageSource key="nuget.org">
    <package pattern="Microsoft.*" />
  </packageSource>
</packageSourceMapping>
```

Тази секция трябва да бъде премахната или коментирана.

---

**Божидар Георгиев - 136ikz@unibit.bg**
