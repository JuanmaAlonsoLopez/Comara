using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("DETALLE_VENTAS")]
    public class DetalleVenta
    {
        [Key]
        [Column("detCod")]
        public int DetCod { get; set; }

        [Required]
        [Column("venCod")]
        public int VenCod { get; set; }

        [Required]
        [Column("artCod")]
        public int ArtCod { get; set; }

        [Required]
        [Column("detCant")]
        public float DetCant { get; set; }

        [Required]
        [Column("detPrecio")]
        public float DetPrecio { get; set; }

        [Required]
        [Column("detSubtotal")]
        public float DetSubtotal { get; set; }

        // Propiedades de Navegación
        [ForeignKey("VenCod")]
        public virtual Venta? Venta { get; set; }

        [ForeignKey("ArtCod")]
        public virtual Articulo? Articulo { get; set; }
    }
}