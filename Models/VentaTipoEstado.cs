using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("ventaTipoEstado")]
    public class VentaTipoEstado
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Required]
        [StringLength(50)]
        [Column("descripcion")]
        public string Descripcion { get; set; } = string.Empty;
    }
}
