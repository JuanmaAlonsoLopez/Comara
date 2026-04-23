using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("PAGOS")]
    public class Pago
    {
        [Key]
        [Column("pagCod")]
        public int PagCod { get; set; }

        [Required]
        [Column("cliCod")]
        public int CliCod { get; set; }

        [Required]
        [Column("pagFech")]
        public DateTime PagFech { get; set; }

        [Required]
        [Column("pagMonto")]
        public decimal PagMonto { get; set; }

        [Required]
        [Column("pagMetodoPago")]
        public int PagMetodoPago { get; set; } // FK a ventaTipoMetodoPagos

        [StringLength(255)]
        [Column("pagDesc")]
        public string? PagDesc { get; set; }

        [Column("cctaCod")]
        public int? CctaCod { get; set; } // Referencia a la cuenta corriente si aplica

        [Column("venCod")]
        public int? VenCod { get; set; } // FK a Venta para trazabilidad de pagos

        // Propiedades de Navegación
        [ForeignKey("CliCod")]
        public virtual Cliente? Cliente { get; set; }

        [ForeignKey("PagMetodoPago")]
        public virtual VentaTipoMetodoPago? TipoMetodoPago { get; set; }

        [ForeignKey("CctaCod")]
        public virtual CuentaCorriente? CuentaCorriente { get; set; }

        [ForeignKey("VenCod")]
        public virtual Venta? Venta { get; set; }
    }
}
