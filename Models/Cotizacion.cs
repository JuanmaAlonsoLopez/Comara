using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("COTIZACIONES")]
    public class Cotizacion
    {
        [Key]
        [Column("cotCod")]
        public int CotCod { get; set; }

        [Required]
        [Column("cotFech")]
        public DateTime CotFech { get; set; }

        [Required]
        [Column("cliCod")]
        public int CliCod { get; set; }

        [Required]
        [Column("cotTotal")]
        public decimal CotTotal { get; set; }

        /// <summary>
        /// OBSOLETO: Use CotEstadoId + Estado (navigation property) en su lugar.
        /// Esta propiedad se mantiene solo para compatibilidad con la base de datos existente.
        /// </summary>
        [Obsolete("Use CotEstadoId con la navegación Estado en su lugar")]
        [StringLength(20)]
        [Column("cotEstado")]
        public string? CotEstado { get; set; }

        [Column("cotEstadoId")]
        public int? CotEstadoId { get; set; } // FK a tabla de estados

        [Column("listaCod")]
        public int? ListaCod { get; set; } // Lista de precios usada al cotizar

        [Column("cotDiasOferta")]
        public int? CotDiasOferta { get; set; } // Días de mantenimiento de oferta (nullable en la BD)

        [Column("cotDiasPago")]
        public int? CotDiasPago { get; set; } // Días de pago (nullable en la BD)

        [Column("razonCrea")]
        public int? RazonCreaId { get; set; } // FK a tipoRazonCrea (nullable)

        public virtual TipoRazonCrea? RazonCrea { get; set; }

        // Propiedades de Navegacion
        [ForeignKey("CliCod")]
        public virtual Cliente? Cliente { get; set; }

        [ForeignKey("CotEstadoId")]
        public virtual CotizacionEstado? Estado { get; set; }

        [ForeignKey("ListaCod")]
        public virtual Lista? Lista { get; set; }

        public virtual ICollection<DetalleCotizacion> DetalleCotizaciones { get; set; } = new List<DetalleCotizacion>();
    }
}