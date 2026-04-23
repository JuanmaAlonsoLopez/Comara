using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("VENTAS")]
    public class Venta
    {
        [Key]
        [Column("venCod")]
        public int VenCod { get; set; }

        [Required]
        [Column("venFech")]
        public DateTime VenFech { get; set; }

        [Required]
        [Column("cliCod")]
        public int CliCod { get; set; }

        [Required]
        [Column("venTotal")]
        public decimal VenTotal { get; set; }

        [Column("venEstado")]
        public int? VenEstado { get; set; }

        [Column("venTipoCbte")]
        public int? VenTipoCbte { get; set; }

        [Column("venMetodoPago")]
        public int? VenMetodoPago { get; set; }

        [Column("venLista")]
        public int? VenLista { get; set; }

        // Campos para facturación electrónica AFIP
        [Column("venPuntoVenta")]
        public int? VenPuntoVenta { get; set; }

        [Column("venNumComprobante")]
        public long? VenNumComprobante { get; set; }

        [StringLength(20)]
        [Column("venCAE")]
        public string? VenCAE { get; set; }

        [Column("venCAEVencimiento")]
        public DateTime? VenCAEVencimiento { get; set; }

        [Column("venFechaAutorizacion")]
        public DateTime? VenFechaAutorizacion { get; set; }

        [Column("venResultadoAfip")]
        [StringLength(1)]
        public string? VenResultadoAfip { get; set; } // A=Aprobado, R=Rechazado, P=Parcial

        [Column("venObservacionesAfip")]
        public string? VenObservacionesAfip { get; set; }

        [Column("venFechVenta")]
        public DateTime? VenFechVenta { get; set; }

        [Column("venEstadoPago")]
        public int? VenEstadoPago { get; set; } // 1=Pendiente, 2=Parcial, 3=Pagada

        // Propiedades de Navegación
        [ForeignKey("CliCod")]
        public virtual Cliente? Cliente { get; set; }

        [ForeignKey("VenEstado")]
        public virtual VentaTipoEstado? TipoEstado { get; set; }

        [ForeignKey("VenMetodoPago")]
        public virtual VentaTipoMetodoPago? TipoMetodoPago { get; set; }

        [ForeignKey("VenTipoCbte")]
        public virtual TipoComprobante? TipoComprobante { get; set; }

        [ForeignKey("VenLista")]
        public virtual Lista? Lista { get; set; }

        [ForeignKey("VenEstadoPago")]
        public virtual VentaEstadoPago? EstadoPago { get; set; }

        public virtual ICollection<DetalleVenta> DetalleVentas { get; set; } = new List<DetalleVenta>();
        public virtual ICollection<Pago> Pagos { get; set; } = new List<Pago>();
    }
}
