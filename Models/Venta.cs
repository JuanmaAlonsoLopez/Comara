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
        public float VenTotal { get; set; }

        [StringLength(20)]
        [Column("venEstado")]
        public string? VenEstado { get; set; }

        [Column("venTipoCbte")]
        public int? VenTipoCbte { get; set; }

        // Propiedad de Navegación
        [ForeignKey("CliCod")]
        public virtual Cliente? Cliente { get; set; }

        public virtual ICollection<DetalleVenta> DetalleVentas { get; set; } = new List<DetalleVenta>();
    }
}