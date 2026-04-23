using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("COBROS")]
    public class Cobro
    {
        [Key]
        [Column("cobCod")]
        public int CobCod { get; set; }

        [Required]
        [Column("cliCod")]
        public int CliCod { get; set; }

        [Required]
        [Column("cobFech")]
        public DateTime CobFech { get; set; }

        [Required]
        [Column("cobMonto")]
        public decimal CobMonto { get; set; }

        [StringLength(50)]
        [Column("cobMetodo")]
        public string? CobMetodo { get; set; }

        // Propiedad de Navegaci�n
        [ForeignKey("CliCod")]
        public virtual Cliente? Cliente { get; set; }
    }
}