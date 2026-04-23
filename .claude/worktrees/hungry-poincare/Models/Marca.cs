using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("MARCAS")]
    public class Marca
    {
        [Key]
        [Column("marCod")]
        public int marCod { get; set; }

        [Required]
        [StringLength(50)]
        [Column("marNombre")]
        public string marNombre { get; set; }
    }
}