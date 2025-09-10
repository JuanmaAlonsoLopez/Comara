using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("CLIENTES")]
    public class Cliente
    {
        [Key]
        [Column("cliCod")]
        public int CliCod { get; set; }

        [Required]
        [StringLength(100)]
        [Column("cliNombre")]
        public string CliNombre { get; set; }

        [StringLength(20)]
        [Column("cliCUIT")]
        public string? CliCUIT { get; set; }

        [StringLength(200)]
        [Column("cliDireccion")]
        public string? CliDireccion { get; set; }

        [StringLength(20)]
        [Column("cliTelefono")]
        public string? CliTelefono { get; set; }

        [StringLength(100)]
        [Column("cliEmail")]
        public string? CliEmail { get; set; }
    }
}