using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("tipoDocumento")]
    public class TipoDocumento
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Required]
        [Column("codigoAfip")]
        public int CodigoAfip { get; set; }

        [Required]
        [Column("descripcion")]
        [StringLength(50)]
        public string Descripcion { get; set; } = string.Empty;

        // Navegación
        public virtual ICollection<Cliente> Clientes { get; set; } = new List<Cliente>();
    }
}
