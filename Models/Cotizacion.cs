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
        public float CotTotal { get; set; }

        [StringLength(20)]
        [Column("cotEstado")]
        public string? CotEstado { get; set; }

        // Propiedad de Navegación
        [ForeignKey("CliCod")]
        public virtual Cliente? Cliente { get; set; }

        public virtual ICollection<DetalleCotizacion> DetalleCotizaciones { get; set; } = new List<DetalleCotizacion>();
    }
}