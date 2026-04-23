using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("tipoMovimientoCaja")]
    public class TipoMovimientoCaja
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Required]
        [StringLength(50)]
        [Column("descripcion")]
        public string Descripcion { get; set; } = string.Empty;

        [Required]
        [StringLength(10)]
        [Column("tipo")]
        public string Tipo { get; set; } = string.Empty; // "INGRESO" o "EGRESO"
    }
}
