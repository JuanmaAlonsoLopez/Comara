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
        public decimal DetCant { get; set; }

        [Required]
        [Column("detPrecio")]
        public decimal DetPrecio { get; set; }

        [Required]
        [Column("detSubtotal")]
        public decimal DetSubtotal { get; set; }

        [Required]
        [Column("detCostoUnitario")]
        public decimal DetCostoUnitario { get; set; }

        [Required]
        [Column("detCostoTotal")]
        public decimal DetCostoTotal { get; set; }

        // Propiedades de Navegaci�n
        [ForeignKey("VenCod")]
        public virtual Venta? Venta { get; set; }

        [ForeignKey("ArtCod")]
        public virtual Articulo? Articulo { get; set; }
    }
}