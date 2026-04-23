using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("PROVEEDORES")]
    public class Proveedor
    {
        [Key]
        [Column("proCod")]
        public int proCod { get; set; }

        [Required]
        [StringLength(100)]
        [Column("proNombre")]
        public string proNombre { get; set; }

        [StringLength(20)]
        [Column("proCUIT")]
        public string? proCUIT { get; set; }

        [StringLength(100)]
        [Column("proContacto")]
        public string? proContacto { get; set; }
    }
}