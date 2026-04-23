using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("CHEQUES")]
    public class Cheque
    {
        [Key]
        [Column("chqCod")]
        public int ChqCod { get; set; }

        [Required]
        [Column("pagCod")]
        public int PagCod { get; set; } // FK al pago

        [Required]
        [StringLength(50)]
        [Column("chqNumero")]
        public string ChqNumero { get; set; } = string.Empty; // Número de cheque

        [Required]
        [StringLength(100)]
        [Column("chqBanco")]
        public string ChqBanco { get; set; } = string.Empty; // Nombre del banco

        [Required]
        [Column("chqFechaEmision")]
        public DateTime ChqFechaEmision { get; set; }

        [Required]
        [Column("chqFechaCobro")]
        public DateTime ChqFechaCobro { get; set; } // Fecha de pago diferido

        [Required]
        [Column("chqMonto")]
        public decimal ChqMonto { get; set; }

        [Required]
        [StringLength(100)]
        [Column("chqLibrador")]
        public string ChqLibrador { get; set; } = string.Empty; // Quien emite el cheque

        [StringLength(20)]
        [Column("chqCUIT")]
        public string? ChqCUIT { get; set; } // CUIT del librador

        [Column("chqEnCaja")]
        public bool ChqEnCaja { get; set; } = true; // Si está físicamente en caja

        [Column("chqFechaSalida")]
        public DateTime? ChqFechaSalida { get; set; } // Cuándo salió de caja

        [StringLength(255)]
        [Column("chqObservaciones")]
        public string? ChqObservaciones { get; set; }

        // Propiedad de Navegación
        [ForeignKey("PagCod")]
        public virtual Pago? Pago { get; set; }
    }
}
