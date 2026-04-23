using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("IVA")]
    public class Iva
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Required]
        [Column("porcentaje", TypeName = "numeric(5, 2)")]
        public decimal Porcentaje { get; set; }
    }
}
