using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("CUENTAS_CORRIENTES")]
    public class CuentaCorriente
    {
        [Key]
        [Column("cctaCod")]
        public int CctaCod { get; set; }

        [Required]
        [Column("cliCod")]
        public int CliCod { get; set; }

        [Required]
        [Column("cctaFech")]
        public DateTime CctaFech { get; set; }

        [StringLength(10)]
        [Column("cctaMovimiento")]
        public string? CctaMovimiento { get; set; }

        [Required]
        [Column("cctaMonto")]
        public decimal CctaMonto { get; set; }

        [Required]
        [Column("cctaSaldo")]
        public decimal CctaSaldo { get; set; }

        [StringLength(255)]
        [Column("cctaDesc")]
        public string? CctaDesc { get; set; }

        // Propiedad de Navegaci�n
        [ForeignKey("CliCod")]
        public virtual Cliente? Cliente { get; set; }
    }
}