# ================================================
# СКРИПТ ЗА ПРЕВОД НА ПОТРЕБИТЕЛСКИЯ ИНТЕРФЕЙС
# Автор: Божидар Георгиев (136ikz@unibit.bg)
# ================================================

Write-Host "Започване на превод на потребителския интерфейс..." -ForegroundColor Cyan

# Речник с преводи (Английски => Български)
$translations = @{
    # Общи термини
    "Home" = "Начало"
    "About Us" = "За Нас"
    "About" = "За Нас"
    "Collections" = "Колекции"
    "Books" = "Книги"
    "Book" = "Книга"
    "Newspapers" = "Вестници"
    "Newspaper" = "Вестник"
    "Journals" = "Списания"
    "Journal" = "Списание"
    "Periodicals" = "Периодични издания"
    "Periodical" = "Периодично издание"
    "Library Events" = "Библиотечни Събития"
    "Events" = "Събития"
    "Event" = "Събитие"
    
    # Навигация
    "Login" = "Вход"
    "Logout" = "Изход"
    "Register" = "Регистрация"
    "Manage" = "Управление"
    
    # Админ панел
    "Admin Panel" = "Админ Панел"
    "Dashboard" = "Табло"
    "Borrowing" = "Заемане"
    "Reports" = "Отчети"
    "User Management" = "Управление на потребители"
    "Admin Settings" = "Настройки"
    
    # Форми и бутони
    "Search" = "Търсене"
    "Add" = "Добави"
    "Edit" = "Редактирай"
    "Delete" = "Изтрий"
    "Save" = "Запази"
    "Cancel" = "Отказ"
    "Create" = "Създай"
    "Update" = "Обнови"
    "Submit" = "Изпрати"
    "Back" = "Назад"
    "Back to List" = "Назад към списъка"
    "Details" = "Детайли"
    "View" = "Преглед"
    "Actions" = "Действия"
    
    # Таблици
    "Title" = "Заглавие"
    "Author" = "Автор"
    "Authors" = "Автори"
    "Publisher" = "Издател"
    "Publishers" = "Издатели"
    "Category" = "Категория"
    "Categories" = "Категории"
    "Language" = "Език"
    "Languages" = "Езици"
    "Genre" = "Жанр"
    "Genres" = "Жанрове"
    "Country" = "Държава"
    "Countries" = "Държави"
    "Year" = "Година"
    "Published Year" = "Година на издаване"
    "ISBN" = "ISBN"
    "ISSN" = "ISSN"
    "Edition" = "Издание"
    "Description" = "Описание"
    "Status" = "Статус"
    "Available" = "Налична"
    "Borrowed" = "Заета"
    "Reserved" = "Резервирана"
    
    # Потребители
    "Username" = "Потребителско име"
    "Password" = "Парола"
    "Email" = "Имейл"
    "Full Name" = "Пълно име"
    "Address" = "Адрес"
    "Phone" = "Телефон"
    "Phone Number" = "Телефонен номер"
    "Member" = "Член"
    "Members" = "Членове"
    "Librarian" = "Библиотекар"
    "Admin" = "Администратор"
    
    # Съобщения
    "Success" = "Успех"
    "Error" = "Грешка"
    "Warning" = "Предупреждение"
    "Info" = "Информация"
    "Are you sure?" = "Сигурни ли сте?"
    "Confirm" = "Потвърди"
    "Yes" = "Да"
    "No" = "Не"
    
    # Заемане
    "Borrow" = "Заеми"
    "Return" = "Върни"
    "Due Date" = "Краен срок"
    "Borrowed Date" = "Дата на заемане"
    "Return Date" = "Дата на връщане"
    
    # Настройки
    "Library Information" = "Информация за библиотеката"
    "Languages of Catalogs" = "Езици на каталозите"
    "Fields - Journal" = "Области на изследване"
    "Field of Study" = "Област на изследване"
    
    # Отчети
    "Library Item Counts by Category" = "Брой артикули по категория"
    "Member Count by Event" = "Брой членове по събитие"
    
    # Страници
    "Log in" = "Вход в системата"
    "Remember me" = "Запомни ме"
    "Forgot your password?" = "Забравена парола?"
    "Register as a new user" = "Регистрирай се като нов потребител"
    "Access Denied" = "Достъпът отказан"
    "Privacy Policy" = "Политика за поверителност"
    
    # Месеци
    "January" = "Януари"
    "February" = "Февруари"
    "March" = "Март"
    "April" = "Април"
    "May" = "Май"
    "June" = "Юни"
    "July" = "Юли"
    "August" = "Август"
    "September" = "Септември"
    "October" = "Октомври"
    "November" = "Ноември"
    "December" = "Декември"
}

# Функция за замяна на текст във файл
function Replace-TextInFile {
    param(
        [string]$FilePath,
        [hashtable]$Replacements
    )
    
    if (-not (Test-Path $FilePath)) {
        return
    }
    
    $content = Get-Content $FilePath -Raw -Encoding UTF8
    $originalContent = $content
    
    foreach ($key in $Replacements.Keys) {
        $value = $Replacements[$key]
        # Замяна само ако английският текст е точно такъв (не част от друга дума)
        $content = $content -replace "\b$key\b", $value
        $content = $content -replace ">$key<", ">$value<"
        $content = $content -replace "`"$key`"", "`"$value`""
        $content = $content -replace "'$key'", "'$value'"
    }
    
    if ($content -ne $originalContent) {
        Set-Content $FilePath -Value $content -Encoding UTF8 -NoNewline
        Write-Host "✓ Преведен: $FilePath" -ForegroundColor Green
    }
}

# Намиране на всички .cshtml файлове
$cshtmlFiles = Get-ChildItem -Path "LibraryManagementSystem" -Filter "*.cshtml" -Recurse

Write-Host "`nНамерени $($cshtmlFiles.Count) .cshtml файла" -ForegroundColor Yellow
Write-Host "Стартиране на превод...`n" -ForegroundColor Yellow

$count = 0
foreach ($file in $cshtmlFiles) {
    Replace-TextInFile -FilePath $file.FullName -Replacements $translations
    $count++
    
    if ($count % 10 -eq 0) {
        Write-Host "Обработени $count от $($cshtmlFiles.Count) файла..." -ForegroundColor Cyan
    }
}

Write-Host "`n✓ Преводът завърши успешно!" -ForegroundColor Green
Write-Host "Обработени $count файла" -ForegroundColor Cyan
