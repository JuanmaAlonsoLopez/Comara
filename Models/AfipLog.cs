using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("afipLogs")]
    public class AfipLog
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Required]
        [Column("fecha")]
        public DateTime Fecha { get; set; }

        [Required]
        [Column("tipoOperacion")]
        [StringLength(50)]
        public string TipoOperacion { get; set; } = string.Empty; // AuthWSAA, AutorizarFactura, ConsultarComprobante, etc.

        [Column("venCod")]
        public int? VenCod { get; set; }

        [Column("tipoComprobante")]
        public int? TipoComprobante { get; set; }

        [Column("puntoVenta")]
        public int? PuntoVenta { get; set; }

        [Column("numeroComprobante")]
        public long? NumeroComprobante { get; set; }

        [Required]
        [Column("request")]
        public string Request { get; set; } = string.Empty; // XML o JSON del request

        [Column("response")]
        public string? Response { get; set; } // XML o JSON de la respuesta

        [Required]
        [Column("exitoso")]
        public bool Exitoso { get; set; }

        [Column("mensajeError")]
        public string? MensajeError { get; set; }

        [Column("cae")]
        [StringLength(20)]
        public string? CAE { get; set; }

        [Column("duracionMs")]
        public int? DuracionMs { get; set; } // Duración en milisegundos

        [Column("ipAddress")]
        [StringLength(45)]
        public string? IpAddress { get; set; }

        // Navegación
        [ForeignKey("VenCod")]
        public virtual Venta? Venta { get; set; }
    }
}
