-- ========================================================================================================
-- СКРИПТ ЗА ПОПЪЛВАНЕ НА БЪЛГАРСКИ КНИГИ В БИБЛИОТЕКАТА
-- ========================================================================================================
-- Базиран на класическа и съвременна българска литература
-- Включва автори, издатели, жанрове и книги
-- ========================================================================================================

-- Добавяне на български автори
INSERT INTO Authors (FirstName, LastName, Biography, DateOfBirth, DateOfDeath, CountryId, PictureUrl) VALUES
('Иван', 'Вазов', 'Патриарх на българската литература, автор на "Под игото"', '1850-06-27', '1921-09-22', 1, NULL),
('Алеко', 'Константинов', 'Български писател и общественик, създател на Бай Ганьо', '1863-01-13', '1897-05-11', 1, NULL),
('Йордан', 'Йовков', 'Майстор на българския разказ', '1880-11-09', '1937-10-15', 1, NULL),
('Димитър', 'Талев', 'Автор на "Железният светилник" и "Илинден"', '1898-11-01', '1966-06-20', 1, NULL),
('Димитър', 'Димов', 'Автор на романа "Тютюн"', '1909-06-26', '1966-03-01', 1, NULL),
('Георги', 'Данаилов', 'Съвременен български писател', '1939-03-25', NULL, 1, NULL),
('Павел', 'Вежинов', 'Автор на "Нощем с белите коне" и "Барierата"', '1914-03-24', '1983-06-22', 1, NULL),
('Елин', 'Пелин', 'Класик на българската литература', '1877-07-08', '1949-12-03', 1, NULL),
('Христо', 'Ботев', 'Поет и революционер', '1848-01-06', '1876-06-02', 1, NULL),
('Пенчо', 'Славейков', 'Български поет и общественик', '1866-04-27', '1912-05-28', 1, NULL),
('Георги', 'Господинов', 'Съвременен български писател, автор на "Времеубежище"', '1968-01-07', NULL, 1, NULL),
('Здравка', 'Евтимова', 'Съвременна българска писателка', '1959-07-16', NULL, 1, NULL),
('Захари', 'Стоянов', 'Български писател и революционер', '1850-08-20', '1889-09-02', 1, NULL),
('Любен', 'Каравелов', 'Писател и революционер', '1834-11-01', '1879-01-21', 1, NULL),
('Кирил', 'Христов', 'Български поет', '1875-05-12', '1944-12-08', 1, NULL);

-- Добавяне на български издатели
INSERT INTO Publishers (Name, Address, Phone, Email, Website) VALUES
('Хермес', 'София, бул. Христо Ботев 34', '+359 2 987 6543', 'info@hermes.bg', 'https://hermes.bg'),
('Изток-Запад', 'София, ул. Граф Игнатиев 15', '+359 2 988 1234', 'office@iztok-zapad.bg', 'https://iztok-zapad.bg'),
('Сиела', 'София, ул. Граф Игнатиев 21', '+359 2 810 4719', 'info@ciela.com', 'https://www.ciela.com'),
('Колибри', 'София, бул. Цар Борис III 111', '+359 2 973 3380', 'info@colibri.bg', 'https://colibri.bg'),
('Жанет 45', 'Пловдив, ул. Найден Геров 2', '+359 32 623 456', 'info@janet45.com', 'https://janet45.com'),
('Bulgarian Bestseller', 'София, бул. Витоша 1', '+359 2 980 5432', 'office@bb.bg', 'https://bulgarianbest.com'),
('Народна култура', 'София, бул. Витоша 34', '+359 2 987 1234', 'nk@culture.bg', NULL);

-- Добавяне на жанрове
INSERT INTO Genres (Name, Description) VALUES
('Историческа проза', 'Исторически романи и разкази'),
('Класическа литература', 'Златният фонд на българската литература'),
('Съвременна проза', 'Съвременни български романи'),
('Поезия', 'Поетически сборници'),
('Разкази', 'Сборници с разкази'),
('Мемоари', 'Автобиографични произведения'),
('Фантастика', 'Научна фантастика и фентъзи');

-- Добавяне на категории за книги
INSERT INTO Categories (Name, Description, ItemType) VALUES
('Българска класика', 'Класически произведения на българската литература', 0),
('Съвременна българска литература', 'Съвременни български автори', 0),
('Исторически романи', 'Романи на исторически теми', 0),
('Поезия и стихосбирки', 'Поетически творби', 0);

-- Добавяне на български език (ако не съществува)
IF NOT EXISTS (SELECT 1 FROM Languages WHERE Code = 'BG')
BEGIN
    INSERT INTO Languages (Code, Name) VALUES ('BG', 'Български');
END

-- Добавяне на книги (ItemType = 0 за книга)
-- Забележка: Трябва да вземем ID-тата на авторите, издателите и др.

DECLARE @BulgarianLanguageId INT = (SELECT Id FROM Languages WHERE Code = 'BG');
DECLARE @ClassicCategoryId INT = (SELECT Id FROM Categories WHERE Name = 'Българска класика' AND ItemType = 0);
DECLARE @ContemporaryCategoryId INT = (SELECT Id FROM Categories WHERE Name = 'Съвременна българска литература' AND ItemType = 0);
DECLARE @HistoricalCategoryId INT = (SELECT Id FROM Categories WHERE Name = 'Исторически романи' AND ItemType = 0);
DECLARE @PoetryCategoryId INT = (SELECT Id FROM Categories WHERE Name = 'Поезия и стихосбирки' AND ItemType = 0);

DECLARE @VazovId INT = (SELECT Id FROM Authors WHERE LastName = 'Вазов');
DECLARE @KonstantinovId INT = (SELECT Id FROM Authors WHERE LastName = 'Константинов');
DECLARE @YovkovId INT = (SELECT Id FROM Authors WHERE LastName = 'Йовков');
DECLARE @TalevId INT = (SELECT Id FROM Authors WHERE LastName = 'Талев');
DECLARE @DimovId INT = (SELECT Id FROM Authors WHERE LastName = 'Димов' AND FirstName = 'Димитър');
DECLARE @VezhinovId INT = (SELECT Id FROM Authors WHERE LastName = 'Вежинов');
DECLARE @PelinId INT = (SELECT Id FROM Authors WHERE LastName = 'Пелин');
DECLARE @BotevId INT = (SELECT Id FROM Authors WHERE LastName = 'Ботев');
DECLARE @SlaveykovId INT = (SELECT Id FROM Authors WHERE LastName = 'Славейков');
DECLARE @GospodinovId INT = (SELECT Id FROM Authors WHERE LastName = 'Господинов');
DECLARE @StoyanovId INT = (SELECT Id FROM Authors WHERE LastName = 'Стоянов' AND FirstName = 'Захари');

DECLARE @HermesId INT = (SELECT Id FROM Publishers WHERE Name = 'Хермес');
DECLARE @IztokZapadId INT = (SELECT Id FROM Publishers WHERE Name = 'Изток-Запад');
DECLARE @SielaId INT = (SELECT Id FROM Publishers WHERE Name = 'Сиела');
DECLARE @KolibriId INT = (SELECT Id FROM Publishers WHERE Name = 'Колибри');
DECLARE @Janet45Id INT = (SELECT Id FROM Publishers WHERE Name = 'Жанет 45');

DECLARE @HistoricalGenreId INT = (SELECT Id FROM Genres WHERE Name = 'Историческа проза');
DECLARE @ClassicGenreId INT = (SELECT Id FROM Genres WHERE Name = 'Класическа литература');
DECLARE @ContemporaryGenreId INT = (SELECT Id FROM Genres WHERE Name = 'Съвременна проза');
DECLARE @PoetryGenreId INT = (SELECT Id FROM Genres WHERE Name = 'Поезия');
DECLARE @StoriesGenreId INT = (SELECT Id FROM Genres WHERE Name = 'Разкази');

-- Създаване на книги
INSERT INTO LibraryItems (ItemType, Title, ItemCode, LanguageId, CategoryId, PublisherId, GenreId, Description, PublishedYear, Edition, ISBN, PageCount, CoverImageUrl, IsActive) VALUES
(0, 'Под игото', 'BK-001-BG', @BulgarianLanguageId, @ClassicCategoryId, @HermesId, @HistoricalGenreId, 
 'Класически роман за българското Възраждане и борбата за свобода', 1889, '15-то издание', '978-954-26-0001-1', 420, NULL, 1),

(0, 'Бай Ганьо', 'BK-002-BG', @BulgarianLanguageId, @ClassicCategoryId, @IztokZapadId, @ClassicGenreId,
 'Безсмъртният образ на българина в преход', 1895, '12-то издание', '978-954-26-0002-8', 180, NULL, 1),

(0, 'Старопланински легенди', 'BK-003-BG', @BulgarianLanguageId, @ClassicCategoryId, @KolibriId, @StoriesGenreId,
 'Сборник разкази от Балкана', 1927, '8-мо издание', '978-954-26-0003-5', 256, NULL, 1),

(0, 'Железният светилник', 'BK-004-BG', @BulgarianLanguageId, @HistoricalCategoryId, @HermesId, @HistoricalGenreId,
 'Първа част от трилогията на Димитър Талев', 1952, '6-то издание', '978-954-26-0004-2', 380, NULL, 1),

(0, 'Илинден', 'BK-005-BG', @BulgarianLanguageId, @HistoricalCategoryId, @HermesId, @HistoricalGenreId,
 'Втора част от трилогията на Димитър Талев', 1953, '6-то издание', '978-954-26-0005-9', 420, NULL, 1),

(0, 'Тютюн', 'BK-006-BG', @BulgarianLanguageId, @ClassicCategoryId, @SielaId, @ClassicGenreId,
 'Епичен роман за живота в България между двете войни', 1951, '10-то издание', '978-954-26-0006-6', 650, NULL, 1),

(0, 'Нощем с белите коне', 'BK-007-BG', @BulgarianLanguageId, @ClassicCategoryId, @KolibriId, @ClassicGenreId,
 'Поетична история за любовта и съдбата', 1965, '7-мо издание', '978-954-26-0007-3', 280, NULL, 1),

(0, 'Бариерата', 'BK-008-BG', @BulgarianLanguageId, @ClassicCategoryId, @KolibriId, @ContemporaryGenreId,
 'Философски роман на Павел Вежинов', 1976, '5-то издание', '978-954-26-0008-0', 320, NULL, 1),

(0, 'Земя', 'BK-009-BG', @BulgarianLanguageId, @ClassicCategoryId, @Janet45Id, @StoriesGenreId,
 'Сборник разкази на Елин Пелин', 1922, '9-то издание', '978-954-26-0009-7', 240, NULL, 1),

(0, 'Гераците', 'BK-010-BG', @BulgarianLanguageId, @ClassicCategoryId, @Janet45Id, @StoriesGenreId,
 'Известният разказ на Елин Пелин', 1911, '11-то издание', '978-954-26-0010-3', 80, NULL, 1),

(0, 'Стихотворения', 'BK-011-BG', @BulgarianLanguageId, @PoetryCategoryId, @HermesId, @PoetryGenreId,
 'Пълно събрание на стихотворенията на Христо Ботев', 1875, '20-то издание', '978-954-26-0011-0', 150, NULL, 1),

(0, 'На острова на блажените', 'BK-012-BG', @BulgarianLanguageId, @PoetryCategoryId, @IztokZapadId, @PoetryGenreId,
 'Поезия на Пенчо Славейков', 1910, '8-мо издание', '978-954-26-0012-7', 200, NULL, 1),

(0, 'Времеубежище', 'BK-013-BG', @BulgarianLanguageId, @ContemporaryCategoryId, @KolibriId, @ContemporaryGenreId,
 'Най-новият роман на Георги Господинов, носител на международни награди', 2020, '1-во издание', '978-954-26-0013-4', 340, NULL, 1),

(0, 'Естествен роман', 'BK-014-BG', @BulgarianLanguageId, @ContemporaryCategoryId, @KolibriId, @ContemporaryGenreId,
 'Дебютен роман на Георги Господинов', 1999, '5-то издание', '978-954-26-0014-1', 280, NULL, 1),

(0, 'Физика на тъгата', 'BK-015-BG', @BulgarianLanguageId, @ContemporaryCategoryId, @KolibriId, @ContemporaryGenreId,
 'Роман на Георги Господинов', 2011, '4-то издание', '978-954-26-0015-8', 320, NULL, 1),

(0, 'Записки по българските въстания', 'BK-016-BG', @BulgarianLanguageId, @HistoricalCategoryId, @HermesId, @HistoricalGenreId,
 'Исторически мемоари на Захари Стоянов', 1884, '7-мо издание', '978-954-26-0016-5', 450, NULL, 1),

(0, 'Немили-недраги', 'BK-017-BG', @BulgarianLanguageId, @ClassicCategoryId, @SielaId, @ClassicGenreId,
 'Роман на Иван Вазов', 1883, '6-то издание', '978-954-26-0017-2', 380, NULL, 1),

(0, 'Пепел от рози', 'BK-018-BG', @BulgarianLanguageId, @ClassicCategoryId, @Janet45Id, @StoriesGenreId,
 'Разкази на Йордан Йовков', 1928, '7-мо издание', '978-954-26-0018-9', 220, NULL, 1),

(0, 'Вечери в Антимовския хан', 'BK-019-BG', @BulgarianLanguageId, @ClassicCategoryId, @Janet45Id, @StoriesGenreId,
 'Сборник разкази на Йордан Йовков', 1928, '8-мо издание', '978-954-26-0019-6', 240, NULL, 1),

(0, 'Хайдушки копнения', 'BK-020-BG', @BulgarianLanguageId, @ClassicCategoryId, @HermesId, @ClassicGenreId,
 'Разкази на Иван Вазов', 1894, '5-то издание', '978-954-26-0020-2', 280, NULL, 1),

(0, 'Селяндия', 'BK-021-BG', @BulgarianLanguageId, @ClassicCategoryId, @IztokZapadId, @StoriesGenreId,
 'Разкази от селото на Елин Пелин', 1920, '8-мо издание', '978-954-26-0021-9', 300, NULL, 1),

(0, 'Чудомир - Разкази', 'BK-022-BG', @BulgarianLanguageId, @ClassicCategoryId, @SielaId, @StoriesGenreId,
 'Избрани разкази на Чудомир', 1930, '6-то издание', '978-954-26-0022-6', 260, NULL, 1),

(0, 'Преспанските камбани', 'BK-023-BG', @BulgarianLanguageId, @HistoricalCategoryId, @HermesId, @HistoricalGenreId,
 'Трета част от трилогията на Димитър Талев', 1954, '5-то издание', '978-954-26-0023-3', 400, NULL, 1),

(0, 'Момини сълзи', 'BK-024-BG', @BulgarianLanguageId, @ClassicCategoryId, @Janet45Id, @StoriesGenreId,
 'Разкази на Елин Пелин', 1924, '7-мо издание', '978-954-26-0024-0', 180, NULL, 1),

(0, 'Завера', 'BK-025-BG', @BulgarianLanguageId, @HistoricalCategoryId, @HermesId, @HistoricalGenreId,
 'Исторически роман на Фани Попова-Мутафова', 1928, '4-то издание', '978-954-26-0025-7', 520, NULL, 1);

-- Свързване на автори с книги (ItemAuthor таблица)
-- Забележка: Използваме ItemId от LibraryItems таблицата

DECLARE @UnderTheYokeId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-001-BG');
DECLARE @BayGanyoId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-002-BG');
DECLARE @StaroplaninkiLegendId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-003-BG');
DECLARE @IronCandlestickId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-004-BG');
DECLARE @IlindenId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-005-BG');
DECLARE @TobaccoId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-006-BG');
DECLARE @NightWithWhiteHorsesId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-007-BG');
DECLARE @BarrierId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-008-BG');
DECLARE @EarthId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-009-BG');
DECLARE @GeratsiteId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-010-BG');
DECLARE @PoemsId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-011-BG');
DECLARE @IslandOfBlessedId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-012-BG');
DECLARE @TimeShelerId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-013-BG');
DECLARE @NaturalNovelId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-014-BG');
DECLARE @PhysicsOfSorrowId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-015-BG');
DECLARE @NotesOnRebellionsId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-016-BG');
DECLARE @NemiliNedragiId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-017-BG');
DECLARE @AshesFromRosesId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-018-BG');
DECLARE @EveningsInAntimovId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-019-BG');
DECLARE @HaydutiYearningsId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-020-BG');
DECLARE @SelandiaId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-021-BG');
DECLARE @ChudomirStoriesId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-022-BG');
DECLARE @PrespanskiBellsId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-023-BG');
DECLARE @MaidenTearsId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-024-BG');
DECLARE @ConspiracyId INT = (SELECT Id FROM LibraryItems WHERE ItemCode = 'BK-025-BG');

-- Свързване автор-книга
INSERT INTO ItemAuthors (ItemId, AuthorId) VALUES
(@UnderTheYokeId, @VazovId),
(@BayGanyoId, @KonstantinovId),
(@StaroplaninkiLegendId, @YovkovId),
(@IronCandlestickId, @TalevId),
(@IlindenId, @TalevId),
(@TobaccoId, @DimovId),
(@NightWithWhiteHorsesId, @VezhinovId),
(@BarrierId, @VezhinovId),
(@EarthId, @PelinId),
(@GeratsiteId, @PelinId),
(@PoemsId, @BotevId),
(@IslandOfBlessedId, @SlaveykovId),
(@TimeShelerId, @GospodinovId),
(@NaturalNovelId, @GospodinovId),
(@PhysicsOfSorrowId, @GospodinovId),
(@NotesOnRebellionsId, @StoyanovId),
(@NemiliNedragiId, @VazovId),
(@AshesFromRosesId, @YovkovId),
(@EveningsInAntimovId, @YovkovId),
(@HaydutiYearningsId, @VazovId),
(@SelandiaId, @PelinId),
(@PrespanskiBellsId, @TalevId),
(@MaidenTearsId, @PelinId);

-- Добавяне на копия от книгите (ItemCopies)
-- Всяка книга ще има 3-5 копия
DECLARE @BookId INT;
DECLARE BookCursor CURSOR FOR 
    SELECT Id FROM LibraryItems WHERE ItemType = 0 AND ItemCode LIKE 'BK-%';

OPEN BookCursor;
FETCH NEXT FROM BookCursor INTO @BookId;

WHILE @@FETCH_STATUS = 0
BEGIN
    DECLARE @CopyCount INT = 3 + (ABS(CHECKSUM(NEWID())) % 3); --Randomно между 3 и 5
    DECLARE @i INT = 1;
    
    WHILE @i <= @CopyCount
    BEGIN
        INSERT INTO ItemCopies (ItemId, CopyNumber, Condition, Location, AcquisitionDate, Status, Notes)
        VALUES (@BookId, @i, 0, -- Отлично състояние
                'Основна библиотека - Секция българска литература', 
                DATEADD(YEAR, -5 + (ABS(CHECKSUM(NEWID())) % 10), GETDATE()), -- Случайна дата от последните 10 години
                0, -- Налична
                NULL);
        SET @i = @i + 1;
    END
    
    FETCH NEXT FROM BookCursor INTO @BookId;
END

CLOSE BookCursor;
DEALLOCATE BookCursor;

PRINT '✅ Успешно добавени 25 български книги с техните автори, издатели и копия!';
PRINT '📚 Библиотеката е обогатена с класическа и съвременна българска литература.';
