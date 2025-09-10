using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("DETALLE_COTIZACIONES")]
    public class DetalleCotizacion
    {
        [Key]
        [Column("detCotCod")]
        public int DetCotCod { get; set; }

        [Required]
        [Column("cotCod")]
        public int CotCod { get; set; }

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
        [ForeignKey("CotCod")]
        public virtual Cotizacion? Cotizacion { get; set; }

        [ForeignKey("ArtCod")]
        public virtual Articulo? Articulo { get; set; }
    }
}