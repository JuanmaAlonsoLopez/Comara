using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("tipoComprobante")]
    public class TipoComprobante
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Required]
        [Column("codigoAfip")]
        public int CodigoAfip { get; set; }

        [Required]
        [Column("descripcion")]
        [StringLength(100)]
        public string Descripcion { get; set; } = string.Empty;

        [Column("requiereCAE")]
        public bool RequiereCAE { get; set; } = true;

        // Navegación
        public virtual ICollection<Venta> Ventas { get; set; } = new List<Venta>();
    }
}
