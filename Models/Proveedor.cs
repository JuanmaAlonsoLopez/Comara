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

        [Column("proDescuento")]
        [Display(Name = "Descuento (%)")]
        [Range(0, 100, ErrorMessage = "El descuento debe estar entre 0 y 100")]
        public decimal? proDescuento { get; set; }

        [StringLength(100)]
        [Column("proEmail")]
        [EmailAddress(ErrorMessage = "El formato del email no es válido")]
        [Display(Name = "Email")]
        public string? proEmail { get; set; }

        [StringLength(20)]
        [Column("proCelular")]
        [Display(Name = "Celular")]
        public string? proCelular { get; set; }
    }
}