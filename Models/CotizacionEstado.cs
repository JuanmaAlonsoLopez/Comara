using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("cotizacionEstados")]
    public class CotizacionEstado
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Required]
        [StringLength(50)]
        [Column("descripcion")]
        public string Descripcion { get; set; } = string.Empty;

        [StringLength(20)]
        [Column("color")]
        public string? Color { get; set; } = "secondary";
    }
}
