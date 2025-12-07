# Скрипт за поправка на ViewData ключове
Write-Host "Поправяне на ViewData ключове..." -ForegroundColor Cyan

$projectPath = "LibraryManagementSystem"

# Възстановяване на ViewData["Title"]
$cshtmlFiles = Get-ChildItem -Path $projectPath -Filter "*.cshtml" -Recurse

foreach ($file in $cshtmlFiles) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $originalContent = $content
    
    # Възстановяване на ViewData ключове
    $content = $content -replace 'ViewData\["Заглавие"\]', 'ViewData["Title"]'
    $content = $content -replace "ViewData\['Заглавие'\]", "ViewData['Title']"
    $content = $content -replace 'ViewBag\.Заглавие', 'ViewBag.Title'
    
    if ($content -ne $originalContent) {
        Set-Content $file.FullName -Value $content -Encoding UTF8 -NoNewline
        Write-Host "✓ Поправен: $($file.Name)" -ForegroundColor Green
    }
}

Write-Host "`nГотово!" -ForegroundColor Green
