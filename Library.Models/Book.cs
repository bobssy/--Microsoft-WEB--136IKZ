/*
 * ========================================================================================================
 * МОДЕЛ: КНИГА (BOOK)
 * ========================================================================================================
 * Автор: Божидар Георгиев
 * Email: 136ikz@unibit.bg
 * 
 * Описание:
 * Този модел представлява книга в библиотечната система.
 * Наследява LibraryItem и добавя специфични за книгите полета като ISBN и издание.
 * 
 * Връзки с други модели:
 * - Наследява LibraryItem (съдържа заглавие, език, категория, издател, жанр и др.)
 * - Има множество копия (ItemCopy) - връзка "един към много"
 * - Има множество автори (ItemAuthor) - връзка "много към много"
 * ========================================================================================================
 */

using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Library.Models
{
    /// <summary>
    /// Модел за книга в библиотечната система
    /// Автор: Божидар Георгиев (136ikz@unibit.bg)
    /// </summary>
    public class Book : LibraryItem
    {
        /// <summary>
        /// ISBN номер на книгата (International Standard Book Number)
        /// Уникален идентификатор за всяка публикувана книга
        /// </summary>
        public string ISBN { get; set; }

        /// <summary>
        /// Издание на книгата (напр. "Първо издание", "Второ преработено издание")
        /// </summary>
        public string Edition { get; set; }

        /// <summary>
        /// Път до изображението на корицата на книгата
        /// </summary>
        public string? CoverImagePath { get; set; }

        /// <summary>
        /// Път до електронния файл на книгата (PDF, EPUB, MOBI и др.)
        /// </summary>
        public string? BookFilePath { get; set; }
    }
}
