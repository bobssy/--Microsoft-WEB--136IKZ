/*
 * ========================================================================================================
 * МОДЕЛ: БИБЛИОТЕЧЕН АРТИКУЛ (LIBRARY ITEM)
 * ========================================================================================================
 * Автор: Божидар Георгиев
 * Email: 136ikz@unibit.bg
 * 
 * Описание:
 * Абстрактен базов клас за всички видове артикули в библиотеката.
 * Използва се Table Per Hierarchy (TPH) наследяване в Entity Framework.
 * От него наследяват: Book, Newspaper, Journal, Periodical
 * 
 * Връзки с други модели:
 * - Genre (жанр) - "много към един"
 * - Language (език) - "много към един"
 * - Category (категория) - "много към един"
 * - Publisher (издател) - "много към един"
 * - ItemCopy (копия) - "един към много"
 * - Reservation (резервации) - "един към много"
 * - ItemAuthor (автори) - "много към много"
 * ========================================================================================================
 */

using Microsoft.AspNetCore.Mvc.Rendering;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Library.Models
{
    /// <summary>
    /// Абстрактен базов клас за всички библиотечни артикули
    /// Автор: Божидар Георгиев (136ikz@unibit.bg)
    /// </summary>
    public abstract class LibraryItem
    {
        /// <summary>
        /// Уникален идентификатор на артикула (първичен ключ)
        /// </summary>
        [Key]
        public int Id { get; set; }

        /// <summary>
        /// Уникален код на артикула (напр. "ITD-BK-00001")
        /// Използва се за лесна идентификация
        /// </summary>
        [StringLength(12)]
        public string ItemCode { get; set; }

        /// <summary>
        /// Заглавие на артикула
        /// Задължително поле с максимална дължина 100 символа
        /// </summary>
        [Required(ErrorMessage = "Enter a Title.")]
        [StringLength(100)]
        public string Title { get; set; }

        /// <summary>
        /// Година на публикуване
        /// Незадължително поле
        /// </summary>
        public int? PublishedYear { get; set; }

        /// <summary>
        /// Тип на артикула (Book, Newspaper, Journal, Periodical)
        /// Използва се за discriminator в TPH наследяването
        /// </summary>
        public ItemType ItemType { get; set; }

        /// <summary>
        /// ID на езика на артикула
        /// Задължително поле - всеки артикул трябва да има език
        /// </summary>
        [Required(ErrorMessage = "Select a language.")]
        public int LanguageId { get; set; }

        /// <summary>
        /// ID на категорията на артикула
        /// Задължително поле - всеки артикул трябва да има категория
        /// </summary>
        [Required(ErrorMessage = "Select a category.")]
        public int CategoryId { get; set; }

        /// <summary>
        /// ID на издателя на артикула
        /// Незадължително поле
        /// </summary>
        public int? PublisherId { get; set; }

        /// <summary>
        /// ID на жанра на артикула
        /// Незадължително поле
        /// </summary>
        public int? GenreId { get; set; }

        /// <summary>
        /// Описание на артикула
        /// Незадължително текстово поле
        /// </summary>
        public string? Description { get; set; }

        // ========================================================================================================
        // НАВИГАЦИОННИ СВОЙСТВА (Navigation Properties)
        // Позволяват достъп до свързаните обекти
        // ========================================================================================================

        /// <summary>
        /// Жанр на артикула (навигационно свойство)
        /// </summary>
        public Genre Genre { get; set; }

        /// <summary>
        /// Език на артикула (навигационно свойство)
        /// </summary>
        public Language Language { get; set; }

        /// <summary>
        /// Категория на артикула (навигационно свойство)
        /// </summary>
        public Category Category { get; set; }

        /// <summary>
        /// Издател на артикула (навигационно свойство)
        /// </summary>
        public Publisher Publisher { get; set; }

        /// <summary>
        /// Колекция от физически копия на артикула
        /// Един артикул може да има много копия
        /// </summary>
        public ICollection<ItemCopy> Copies { get; set; }

        /// <summary>
        /// Колекция от резервации за артикула
        /// Един артикул може да има много резервации
        /// </summary>
        public ICollection<Reservation> Reservations { get; set; }

        /// <summary>
        /// Колекция от връзки с автори (много към много връзка)
        /// Един артикул може да има много автори
        /// </summary>
        public ICollection<ItemAuthor> ItemAuthors { get; set; }
    }

}

namespace Library.Models
{
    /// <summary>
    /// Изброим тип за видовете артикули в библиотеката
    /// Автор: Божидар Георгиев (136ikz@unibit.bg)
    /// </summary>
    public enum ItemType
    {
        Book,       // Книга
        Newspaper,  // Вестник
        Journal,    // Списание
        Periodical  // Периодично издание
    }
}