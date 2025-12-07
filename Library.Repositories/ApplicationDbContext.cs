/*
 * ========================================================================================================
 * APPLICATION DB CONTEXT - КОНТЕКСТ НА БАЗАТА ДАННИ
 * ========================================================================================================
 * Автор: Божидар Георгиев
 * Email: 136ikz@unibit.bg
 * 
 * Описание:
 * Това е главният контекст на Entity Framework за достъп до базата данни.
 * Наследява IdentityDbContext за поддръжка на ASP.NET Core Identity.
 * Съдържа DbSet-ове за всички таблици в базата данни и конфигурация на връзките.
 * 
 * Използван подход: Code-First с Entity Framework Core
 * База данни: Microsoft SQL Server
 * ========================================================================================================
 */

using Library.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Library.Repositories
{
    /// <summary>
    /// DbContext за библиотечната система
    /// Управлява връзката с базата данни и всички операции с данни
    /// Автор: Божидар Георгиев (136ikz@unibit.bg)
    /// </summary>
    public class ApplicationDbContext : IdentityDbContext
    {
        /// <summary>
        /// Конструктор на контекста
        /// Приема настройки за конфигуриране на DbContext
        /// </summary>
        /// <param name="options">Опции за конфигуриране на контекста</param>
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }

        // ========================================================================================================
        // DBSET КОЛЕКЦИИ - ТАБЛИЦИ В БАЗАТА ДАННИ
        // ========================================================================================================
        // Всеки DbSet представлява таблица в базата данни
        // Използва се за CRUD операции (Create, Read, Update, Delete)

        /// <summary>Потребители на приложението с допълнителни полета</summary>
        public DbSet<ApplicationUser> ApplicationUsers { get; set; }

        /// <summary>Информация за библиотеката (адрес, телефон и др.)</summary>
        public DbSet<LibraryInfo> LibraryInfos { get; set; }

        /// <summary>Придобивания на нови артикули</summary>
        public DbSet<Acquisition> Acquisitions { get; set; }

        /// <summary>Артикули в придобиванията</summary>
        public DbSet<AcquisitionItem> AcquisitionItems { get; set; }

        /// <summary>Типове придобивания (покупка, дарение и др.)</summary>
        public DbSet<AcquisitionType> AcquisitionTypes { get; set; }

        /// <summary>Автори на книги и публикации</summary>
        public DbSet<Author> Authors { get; set; }

        /// <summary>Заемания на книги от членове</summary>
        public DbSet<Borrowing> Borrowings { get; set; }

        /// <summary>Категории на артикули</summary>
        public DbSet<Category> Categories { get; set; }

        /// <summary>Персонал в различни отдели на библиотеката</summary>
        public DbSet<DivisionStaff> DivisionStaff { get; set; }

        /// <summary>Дарители на книги и други артикули</summary>
        public DbSet<Donor> Donors { get; set; }

        /// <summary>Участници в библиотечни събития</summary>
        public DbSet<EventParticipant> EventParticipants { get; set; }

        /// <summary>Глоби за забавени връщания или повреди</summary>
        public DbSet<Fine> Fines { get; set; }

        /// <summary>Типове глоби</summary>
        public DbSet<FineType> FineTypes { get; set; }

        /// <summary>Жанрове на книги</summary>
        public DbSet<Genre> Genres { get; set; }

        /// <summary>Връзка между артикули и автори (много към много)</summary>
        public DbSet<ItemAuthor> ItemAuthors { get; set; }

        /// <summary>Състояние на артикули (ново, добро, повредено)</summary>
        public DbSet<ItemCondition> ItemConditions { get; set; }

        /// <summary>Физически копия на артикули</summary>
        public DbSet<ItemCopy> ItemCopies { get; set; }

        /// <summary>Езици на артикулите</summary>
        public DbSet<Language> Languages { get; set; }

        /// <summary>Отдели на библиотеката</summary>
        public DbSet<LibraryDivision> LibraryDivisions { get; set; }

        /// <summary>Библиотечни събития (лекции, презентации и др.)</summary>
        public DbSet<LibraryEvent> LibraryEvents { get; set; }

        /// <summary>Базов клас за всички артикули (книги, вестници, списания)</summary>
        public DbSet<LibraryItem> LibraryItems { get; set; }

        /// <summary>Членове на библиотеката</summary>
        public DbSet<Member> Members { get; set; }

        /// <summary>Типове членства (Basic, Premium и др.)</summary>
        public DbSet<MembershipType> MembershipTypes { get; set; }

        /// <summary>Плащания на глоби</summary>
        public DbSet<Payment> Payments { get; set; }

        /// <summary>Издатели на книги</summary>
        public DbSet<Publisher> Publishers { get; set; }

        /// <summary>Поръчки за покупка на артикули</summary>
        public DbSet<PurchaseOrder> PurchaseOrders { get; set; }

        /// <summary>Артикули в поръчките за покупка</summary>
        public DbSet<PurchaseOrderItem> PurchaseOrderItems { get; set; }

        /// <summary>Резервации на книги</summary>
        public DbSet<Reservation> Reservations { get; set; }

        /// <summary>Доставчици на книги и артикули</summary>
        public DbSet<Vendor> Vendors { get; set; }

        /// <summary>Информация "За нас"</summary>
        public DbSet<About> Abouts { get; set; }

        /// <summary>Съдържание на началната страница</summary>
        public DbSet<HomeContent> Contents { get; set; }

        /// <summary>Държави (за автори, издатели и др.)</summary>
        public DbSet<Country> Countries { get; set; }

        /// <summary>Книги (наследява LibraryItem)</summary>
        public DbSet<Book> Books { get; set; }

        /// <summary>Вестници (наследява LibraryItem)</summary>
        public DbSet<Newspaper> Newspapers { get; set; }

        /// <summary>Списания (наследява LibraryItem)</summary>
        public DbSet<Journal> Journals { get; set; }

        /// <summary>Периодични издания (наследява LibraryItem)</summary>
        public DbSet<Periodical> Periodicals { get; set; }

        /// <summary>Брояч за генериране на потребителски кодове</summary>
        public DbSet<UserCodeCounter> UserCodeCounters { get; set; }

        /// <summary>Области на обучение/специалности</summary>
        public DbSet<FieldOfStudy> FieldOfStudies { get; set; }

        // ========================================================================================================
        // ONMODELCREATING - КОНФИГУРАЦИЯ НА МОДЕЛА (FLUENT API)
        // ========================================================================================================
        /// <summary>
        /// Конфигурира модела на базата данни при създаването ѝ
        /// Използва Fluent API за дефиниране на връзки, индекси и ограничения
        /// Автор: Божидар Георгиев (136ikz@unibit.bg)
        /// </summary>
        /// <param name="modelbuilder">Model builder за конфигуриране</param>
        protected override void OnModelCreating(ModelBuilder modelbuilder)
        {
            // Извикване на базовата конфигурация (необходимо за Identity)
            base.OnModelCreating(modelbuilder);

            // ========================================================================================================
            // TPH (TABLE PER HIERARCHY) НАСЛЕДЯВАНЕ ЗА LIBRARYITEM
            // ========================================================================================================
            // Всички типове артикули (Book, Newspaper, Journal, Periodical) се съхраняват в една таблица
            // Използва discriminator колона "Item Type" за разграничаване на типовете
            modelbuilder.Entity<LibraryItem>()
                .HasDiscriminator<string>("Item Type")
                .HasValue<Book>("Book")
                .HasValue<Newspaper>("Newspaper")
                .HasValue<Journal>("Journal")
                .HasValue<Periodical>("Periodical");

            // ========================================================================================================
            // UNIQUE ИНДЕКС ЗА КОД НА СЪБИТИЕ
            // ========================================================================================================
            // Гарантира, че всяко събитие има уникален код
            modelbuilder.Entity<LibraryEvent>()
                .HasIndex(e => e.EventCode).IsUnique();

            // ========================================================================================================
            // COMPOSITE UNIQUE INDEX ЗА РЕГИСТРАЦИИ В СЪБИТИЯ
            // ========================================================================================================
            // Потребител може да се регистрира само веднъж за дадено събитие
            // Комбинацията от LibraryEventId и ApplicationUserId трябва да е уникална
            modelbuilder.Entity<EventParticipant>()
                .HasIndex(ep => new { ep.LibraryEventId, ep.ApplicationUserId })
                .IsUnique();

            // ========================================================================================================
            // UNIQUE ИНДЕКС ЗА ПОТРЕБИТЕЛСКИ КОД
            // ========================================================================================================
            // Всеки потребител има уникален код (напр. "USR-00001")
            modelbuilder.Entity<ApplicationUser>()
                .HasIndex(u => u.UserCode)
                .IsUnique();

            // ========================================================================================================
            // КОНФИГУРАЦИЯ НА ТИП ДАННИ ЗА ГОДИНА НА ПУБЛИКУВАНЕ
            // ========================================================================================================
            // Явно указва, че PublishedYear е integer колона в базата
            modelbuilder.Entity<LibraryItem>()
               .Property(p => p.PublishedYear)
               .HasColumnType("int");
        }

    }
}
