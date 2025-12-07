-- ========================================================================================================
-- СКРИПТ ЗА ПОПЪЛВАНЕ НА БЪЛГАРСКИ КНИГИ В БИБЛИОТЕКАТА (SQLite версия)
-- ========================================================================================================
-- Базиран на класическа и съвременна българска литература
-- Включва автори, издатели, жанрове и книги
-- ========================================================================================================

-- 1. Добавяне на български автори
INSERT INTO Authors (FirstName, LastName, Biography, DateOfBirth, DateOfDeath, CountryId, PictureUrl) VALUES
('Иван', 'Вазов', 'Патриарх на българската литература, автор на "Под игото"', '1850-06-27', '1921-09-22', 1, NULL),
('Алеко', 'Константинов', 'Български писател и общественик, създател на Бай Ганьо', '1863-01-13', '1897-05-11', 1, NULL),
('Йордан', 'Йовков', 'Майстор на българския разказ', '1880-11-09', '1937-10-15', 1, NULL),
('Димитър', 'Талев', 'Автор на "Железният светилник" и "Илинден"', '1898-11-01', '1966-06-20', 1, NULL),
('Димитър', 'Димов', 'Автор на романа "Тютюн"', '1909-06-26', '1966-03-01', 1, NULL),
('Георги', 'Данаилов', 'Съвременен български писател', '1939-03-25', NULL, 1, NULL),
('Павел', 'Вежинов', 'Автор на "Нощем с белите коне" и "Бариерата"', '1914-03-24', '1983-06-22', 1, NULL),
('Елин', 'Пелин', 'Класик на българската литература', '1877-07-08', '1949-12-03', 1, NULL),
('Христо', 'Ботев', 'Поет и революционер', '1848-01-06', '1876-06-02', 1, NULL),
('Пенчо', 'Славейков', 'Български поет и общественик', '1866-04-27', '1912-05-28', 1, NULL),
('Георги', 'Господинов', 'Съвременен български писател, автор на "Времеубежище"', '1968-01-07', NULL, 1, NULL),
('Здравка', 'Евтимова', 'Съвременна българска писателка', '1959-07-16', NULL, 1, NULL),
('Захари', 'Стоянов', 'Български писател и революционер', '1850-08-20', '1889-09-02', 1, NULL),
('Любен', 'Каравелов', 'Писател и революционер', '1834-11-01', '1879-01-21', 1, NULL),
('Кирил', 'Христов', 'Български поет', '1875-05-12', '1944-12-08', 1, NULL);

-- 2. Добавяне на български издатели
INSERT INTO Publishers (Name, Address, Phone, Email, Website) VALUES
('Хермес', 'София, бул. Христо Ботев 34', '+359 2 987 6543', 'info@hermes.bg', 'https://hermes.bg'),
('Изток-Запад', 'София, ул. Граф Игнатиев 15', '+359 2 988 1234', 'office@iztok-zapad.bg', 'https://iztok-zapad.bg'),
('Сиела', 'София, ул. Граф Игнатиев 21', '+359 2 810 4719', 'info@ciela.com', 'https://www.ciela.com'),
('Колибри', 'София, бул. Цар Борис III 111', '+359 2 973 3380', 'info@colibri.bg', 'https://colibri.bg'),
('Жанет 45', 'Пловдив, ул. Найден Геров 2', '+359 32 623 456', 'info@janet45.com', 'https://janet45.com'),
('Bulgarian Bestseller', 'София, бул. Витоша 1', '+359 2 980 5432', 'office@bb.bg', 'https://bulgarianbest.com'),
('Народна култура', 'София, бул. Витоша 34', '+359 2 987 1234', 'nk@culture.bg', NULL);

-- 3. Добавяне на жанрове
INSERT INTO Genres (Name, Description) VALUES
('Историческа проза', 'Исторически романи и разкази'),
('Класическа литература', 'Златният фонд на българската литература'),
('Съвременна проза', 'Съвременни български романи'),
('Поезия', 'Поетически сборници'),
('Разкази', 'Сборници с разкази'),
('Мемоари', 'Автобиографични произведения'),
('Фантастика', 'Научна фантастика и фентъзи');

-- 4. Добавяне на категории за книги (ItemType = 0 за книга)
INSERT INTO Categories (Name, Description, ItemType) VALUES
('Българска класика', 'Класически произведения на българската литература', 0),
('Съвременна българска литература', 'Съвременни български автори', 0),
('Исторически романи', 'Романи на исторически теми', 0),
('Поезия и стихосбирки', 'Поетически творби', 0);

-- 5. Добавяне на български език (ако не съществува)
INSERT OR IGNORE INTO Languages (Code, Name) VALUES ('BG', 'Български');

-- 6. Добавяне на книги (ItemType = 0 за Book)
-- Под игото - Иван Вазов
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Под игото', 'BK-001-BG', 
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Българска класика' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Хермес' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Историческа проза' LIMIT 1),
    'Класически роман за българското Възраждане и борбата за свобода', 
    1889, '15-то издание', '978-954-26-0001-1', 420, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-001-BG');

-- Бай Ганьо - Алеко Константинов
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Бай Ганьо', 'BK-002-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Българска класика' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Изток-Запад' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Класическа литература' LIMIT 1),
    'Безсмъртният образ на българина в преход', 
    1895, '12-то издание', '978-954-26-0002-8', 180, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-002-BG');

-- Старопланински легенди - Йордан Йовков
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Старопланински легенди', 'BK-003-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Българска класика' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Колибри' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Разкази' LIMIT 1),
    'Сборник разкази от Балкана', 
    1927, '8-мо издание', '978-954-26-0003-5', 256, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-003-BG');

-- Железният светилник - Димитър Талев
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Железният светилник', 'BK-004-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Исторически романи' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Хермес' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Историческа проза' LIMIT 1),
    'Първа част от трилогията на Димитър Талев', 
    1952, '6-то издание', '978-954-26-0004-2', 380, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-004-BG');

-- Илинден - Димитър Талев
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Илинден', 'BK-005-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Исторически романи' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Хермес' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Историческа проза' LIMIT 1),
    'Втора част от трилогията на Димитър Талев', 
    1953, '6-то издание', '978-954-26-0005-9', 420, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-005-BG');

-- Тютюн - Димитър Димов
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Тютюн', 'BK-006-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Българска класика' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Сиела' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Класическа литература' LIMIT 1),
    'Епичен роман за живота в България между двете войни', 
    1951, '10-то издание', '978-954-26-0006-6', 650, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-006-BG');

-- Нощем с белите коне - Павел Вежинов
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Нощем с белите коне', 'BK-007-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Българска класика' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Колибри' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Класическа литература' LIMIT 1),
    'Поетична история за любовта и съдбата', 
    1965, '7-мо издание', '978-954-26-0007-3', 280, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-007-BG');

-- Бариерата - Павел Вежинов
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Бариерата', 'BK-008-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Българска класика' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Колибри' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Съвременна проза' LIMIT 1),
    'Философски роман на Павел Вежинов', 
    1976, '5-то издание', '978-954-26-0008-0', 320, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-008-BG');

-- Земя - Елин Пелин
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Земя', 'BK-009-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Българска класика' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Жанет 45' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Разкази' LIMIT 1),
    'Сборник разкази на Елин Пелин', 
    1922, '9-то издание', '978-954-26-0009-7', 240, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-009-BG');

-- Гераците - Елин Пелин
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Гераците', 'BK-010-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Българска класика' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Жанет 45' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Разкази' LIMIT 1),
    'Известният разказ на Елин Пелин', 
    1911, '11-то издание', '978-954-26-0010-3', 80, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-010-BG');

-- Стихотворения - Христо Ботев
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Стихотворения', 'BK-011-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Поезия и стихосбирки' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Хермес' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Поезия' LIMIT 1),
    'Пълно събрание на стихотворенията на Христо Ботев', 
    1875, '20-то издание', '978-954-26-0011-0', 150, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-011-BG');

-- На острова на блажените - Пенчо Славейков
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'На острова на блажените', 'BK-012-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Поезия и стихосбирки' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Изток-Запад' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Поезия' LIMIT 1),
    'Поезия на Пенчо Славейков', 
    1910, '8-мо издание', '978-954-26-0012-7', 200, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-012-BG');

-- Времеубежище - Георги Господинов
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Времеубежище', 'BK-013-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Съвременна българска литература' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Колибри' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Съвременна проза' LIMIT 1),
    'Най-новият роман на Георги Господинов, носител на международни награди', 
    2020, '1-во издание', '978-954-26-0013-4', 340, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-013-BG');

-- Естествен роман - Георги Господинов
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Естествен роман', 'BK-014-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Съвременна българска литература' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Колибри' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Съвременна проза' LIMIT 1),
    'Дебютен роман на Георги Господинов', 
    1999, '5-то издание', '978-954-26-0014-1', 280, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-014-BG');

-- Физика на тъгата - Георги Господинов
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Физика на тъгата', 'BK-015-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Съвременна българска литература' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Колибри' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Съвременна проза' LIMIT 1),
    'Роман на Георги Господинов', 
    2011, '4-то издание', '978-954-26-0015-8', 320, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-015-BG');

-- Записки по българските въстания - Захари Стоянов
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Записки по българските въстания', 'BK-016-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Исторически романи' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Хермес' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Историческа проза' LIMIT 1),
    'Исторически мемоари на Захари Стоянов', 
    1884, '7-мо издание', '978-954-26-0016-5', 450, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-016-BG');

-- Немили-недраги - Иван Вазов
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Немили-недраги', 'BK-017-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Българска класика' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Сиела' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Класическа литература' LIMIT 1),
    'Роман на Иван Вазов', 
    1883, '6-то издание', '978-954-26-0017-2', 380, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-017-BG');

-- Пепел от рози - Йордан Йовков
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Пепел от рози', 'BK-018-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Българска класика' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Жанет 45' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Разкази' LIMIT 1),
    'Разкази на Йордан Йовков', 
    1928, '7-мо издание', '978-954-26-0018-9', 220, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-018-BG');

-- Вечери в Антимовския хан - Йордан Йовков
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Вечери в Антимовския хан', 'BK-019-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Българска класика' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Жанет 45' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Разкази' LIMIT 1),
    'Сборник разкази на Йордан Йовков', 
    1928, '8-мо издание', '978-954-26-0019-6', 240, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-019-BG');

-- Хайдушки копнения - Иван Вазов
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Хайдушки копнения', 'BK-020-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Българска класика' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Хермес' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Класическа литература' LIMIT 1),
    'Разкази на Иван Вазов', 
    1894, '5-то издание', '978-954-26-0020-2', 280, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-020-BG');

-- Селяндия - Елин Пелин
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Селяндия', 'BK-021-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Българска класика' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Изток-Запад' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Разкази' LIMIT 1),
    'Разкази от селото на Елин Пелин', 
    1920, '8-мо издание', '978-954-26-0021-9', 300, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-021-BG');

-- Преспанските камбани - Димитър Талев
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Преспанските камбани', 'BK-022-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Исторически романи' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Хермес' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Историческа проза' LIMIT 1),
    'Трета част от трилогията на Димитър Талев', 
    1954, '5-то издание', '978-954-26-0022-6', 400, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-022-BG');

-- Момини сълзи - Елин Пелин
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Момини сълзи', 'BK-023-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Българска класика' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Жанет 45' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Разкази' LIMIT 1),
    'Разкази на Елин Пелин', 
    1924, '7-мо издание', '978-954-26-0023-3', 180, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-023-BG');

-- Завера - Фани Попова-Мутафова
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Завера', 'BK-024-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Исторически романи' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Хермес' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Историческа проза' LIMIT 1),
    'Исторически роман на Фани Попова-Мутафова', 
    1928, '4-то издание', '978-954-26-0024-0', 520, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-024-BG');

-- Ян Бибиян - Елин Пелин
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive)
SELECT 0, 'Ян Бибиян', 'BK-025-BG',
    (SELECT Id FROM Languages WHERE Code = 'BG' LIMIT 1),
    (SELECT Id FROM Categories WHERE Name = 'Българска класика' AND ItemType = 0 LIMIT 1),
    (SELECT Id FROM Publishers WHERE Name = 'Колибри' LIMIT 1),
    (SELECT Id FROM Genres WHERE Name = 'Класическа литература' LIMIT 1),
    'Вълшебната приказка на Елин Пелин', 
    1933, '12-то издание', '978-954-26-0025-7', 160, NULL, 1
WHERE NOT EXISTS (SELECT 1 FROM LibraryItems WHERE ItemCode = 'BK-025-BG');

-- 7. Свързване на автори с книги
-- Вазов
INSERT OR IGNORE INTO ItemAuthors (ItemId, AuthorId)
SELECT li.Id, a.Id FROM LibraryItems li, Authors a 
WHERE li.ItemCode IN ('BK-001-BG', 'BK-017-BG', 'BK-020-BG') 
AND a.LastName = 'Вазов';

-- Константинов
INSERT OR IGNORE INTO ItemAuthors (ItemId, AuthorId)
SELECT li.Id, a.Id FROM LibraryItems li, Authors a 
WHERE li.ItemCode = 'BK-002-BG' AND a.LastName = 'Константинов';

-- Йовков
INSERT OR IGNORE INTO ItemAuthors (ItemId, AuthorId)
SELECT li.Id, a.Id FROM LibraryItems li, Authors a 
WHERE li.ItemCode IN ('BK-003-BG', 'BK-018-BG', 'BK-019-BG') 
AND a.LastName = 'Йовков';

-- Талев
INSERT OR IGNORE INTO ItemAuthors (ItemId, AuthorId)
SELECT li.Id, a.Id FROM LibraryItems li, Authors a 
WHERE li.ItemCode IN ('BK-004-BG', 'BK-005-BG', 'BK-022-BG') 
AND a.LastName = 'Талев';

-- Димитър Димов
INSERT OR IGNORE INTO ItemAuthors (ItemId, AuthorId)
SELECT li.Id, a.Id FROM LibraryItems li, Authors a 
WHERE li.ItemCode = 'BK-006-BG' AND a.LastName = 'Димов' AND a.FirstName = 'Димитър';

-- Вежинов
INSERT OR IGNORE INTO ItemAuthors (ItemId, AuthorId)
SELECT li.Id, a.Id FROM LibraryItems li, Authors a 
WHERE li.ItemCode IN ('BK-007-BG', 'BK-008-BG') 
AND a.LastName = 'Вежинов';

-- Елин Пелин
INSERT OR IGNORE INTO ItemAuthors (ItemId, AuthorId)
SELECT li.Id, a.Id FROM LibraryItems li, Authors a 
WHERE li.ItemCode IN ('BK-009-BG', 'BK-010-BG', 'BK-021-BG', 'BK-023-BG', 'BK-025-BG') 
AND a.LastName = 'Пелин';

-- Ботев
INSERT OR IGNORE INTO ItemAuthors (ItemId, AuthorId)
SELECT li.Id, a.Id FROM LibraryItems li, Authors a 
WHERE li.ItemCode = 'BK-011-BG' AND a.LastName = 'Ботев';

-- Славейков
INSERT OR IGNORE INTO ItemAuthors (ItemId, AuthorId)
SELECT li.Id, a.Id FROM LibraryItems li, Authors a 
WHERE li.ItemCode = 'BK-012-BG' AND a.LastName = 'Славейков';

-- Господинов
INSERT OR IGNORE INTO ItemAuthors (ItemId, AuthorId)
SELECT li.Id, a.Id FROM LibraryItems li, Authors a 
WHERE li.ItemCode IN ('BK-013-BG', 'BK-014-BG', 'BK-015-BG') 
AND a.LastName = 'Господинов';

-- Стоянов
INSERT OR IGNORE INTO ItemAuthors (ItemId, AuthorId)
SELECT li.Id, a.Id FROM LibraryItems li, Authors a 
WHERE li.ItemCode = 'BK-016-BG' AND a.LastName = 'Стоянов' AND a.FirstName = 'Захари';

-- 8. Добавяне на копия от книгите (по 3-5 копия на книга)
-- За всяка книга добавяме 3 копия
INSERT OR IGNORE INTO ItemCopies (ItemId, CopyNumber, Condition, Location, AcquisitionDate, Status, Notes)
SELECT 
    li.Id,
    1,
    0, -- Excellent
    'Основна библиотека - Секция българска литература',
    date('now', '-' || (abs(random()) % 365) || ' days'),
    0, -- Available
    NULL
FROM LibraryItems li
WHERE li.ItemCode LIKE 'BK-%' AND li.ItemType = 0;

INSERT OR IGNORE INTO ItemCopies (ItemId, CopyNumber, Condition, Location, AcquisitionDate, Status, Notes)
SELECT 
    li.Id,
    2,
    0, -- Excellent
    'Основна библиотека - Секция българска литература',
    date('now', '-' || (abs(random()) % 365) || ' days'),
    0, -- Available
    NULL
FROM LibraryItems li
WHERE li.ItemCode LIKE 'BK-%' AND li.ItemType = 0;

INSERT OR IGNORE INTO ItemCopies (ItemId, CopyNumber, Condition, Location, AcquisitionDate, Status, Notes)
SELECT 
    li.Id,
    3,
    0, -- Excellent
    'Основна библиотека - Секция българска литература',
    date('now', '-' || (abs(random()) % 365) || ' days'),
    0, -- Available
    NULL
FROM LibraryItems li
WHERE li.ItemCode LIKE 'BK-%' AND li.ItemType = 0;

-- Проверка на резултати
SELECT '✅ Успешно добавени 25 български книги!' AS Status;
SELECT 'Общо книги: ' || COUNT(*) AS Info FROM LibraryItems WHERE ItemCode LIKE 'BK-%';
SELECT 'Общо автори: ' || COUNT(*) AS Info FROM Authors;
SELECT 'Общо издатели: ' || COUNT(*) AS Info FROM Publishers WHERE Name IN ('Хермес', 'Изток-Запад', 'Сиела', 'Колибри', 'Жанет 45');
SELECT 'Общо копия: ' || COUNT(*) AS Info FROM ItemCopies WHERE ItemId IN (SELECT Id FROM LibraryItems WHERE ItemCode LIKE 'BK-%');
SELECT '📚 Библиотеката е обогатена с класическа и съвременна българска литература!' AS Message;
