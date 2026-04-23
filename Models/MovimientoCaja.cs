using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("MOVIMIENTOS_CAJA")]
    public class MovimientoCaja
    {
        [Key]
        [Column("movCod")]
        public int MovCod { get; set; }

        [Required]
        [Column("movFecha")]
        public DateTime MovFecha { get; set; }

        [Required]
        [Column("movTipo")]
        public int MovTipo { get; set; } // FK a TipoMovimientoCaja

        [Required]
        [Column("movMetodoPago")]
        public int MovMetodoPago { get; set; } // FK a VentaTipoMetodoPago (Efectivo=5, Cheque=4)

        [Required]
        [Column("movMonto")]
        public decimal MovMonto { get; set; }

        [StringLength(255)]
        [Column("movDescripcion")]
        public string? MovDescripcion { get; set; }

        [Column("chqCod")]
        public int? ChqCod { get; set; } // FK a Cheque (si es movimiento de cheque)

        // Propiedades de Navegación
        [ForeignKey("MovTipo")]
        public virtual TipoMovimientoCaja? TipoMovimiento { get; set; }

        [ForeignKey("MovMetodoPago")]
        public virtual VentaTipoMetodoPago? TipoMetodoPago { get; set; }

        [ForeignKey("ChqCod")]
        public virtual Cheque? Cheque { get; set; }
    }
}
