# Скрипт за поправка на файлове след превод
# Този скрипт връща обратно имената на класовете и namespace-овете

Write-Host "Възстановяване на C# файлове..." -ForegroundColor Cyan

$fixes = @{
    "Управление" = "Manage"
    "Вход" = "Login"
    "Регистрация" = "Register"
    "Изход" = "Logout"
}

# Намиране на всички .cshtml.cs файлове
$csFiles = Get-ChildItem -Path "LibraryManagementSystem" -Filter "*.cshtml.cs" -Recurse

foreach ($file in $csFiles) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $originalContent = $content
    
    foreach ($key in $fixes.Keys) {
        $value = $fixes[$key]
        $content = $content -replace $key, $value
    }
    
    if ($content -ne $originalContent) {
        Set-Content $file.FullName -Value $content -Encoding UTF8 -NoNewline
        Write-Host "✓ Поправен: $($file.FullName)" -ForegroundColor Green
    }
}

Write-Host "`nГотово!" -ForegroundColor Green
