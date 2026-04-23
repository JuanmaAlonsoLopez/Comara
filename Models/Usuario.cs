using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("USUARIOS")]
    public class Usuario
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Required]
        [StringLength(50)]
        [Column("usuUsername")]
        [Display(Name = "Usuario")]
        public string UsuUsername { get; set; }

        [Required]
        [StringLength(255)]
        [Column("usuPasswordHash")]
        public string UsuPasswordHash { get; set; }

        [Required]
        [StringLength(20)]
        [Column("usuRole")]
        [Display(Name = "Rol")]
        public string UsuRole { get; set; } = "user";

        [Required]
        [StringLength(100)]
        [Column("usuNombreCompleto")]
        [Display(Name = "Nombre Completo")]
        public string UsuNombreCompleto { get; set; }

        [StringLength(100)]
        [Column("usuEmail")]
        [EmailAddress(ErrorMessage = "Formato de email inválido")]
        [Display(Name = "Email")]
        public string? UsuEmail { get; set; }

        [Column("usuActivo")]
        [Display(Name = "Activo")]
        public bool UsuActivo { get; set; } = true;

        [Column("usuFechaCreacion")]
        [Display(Name = "Fecha Creación")]
        public DateTime UsuFechaCreacion { get; set; } = DateTime.UtcNow;

        [Column("usuUltimoLogin")]
        [Display(Name = "Último Login")]
        public DateTime? UsuUltimoLogin { get; set; }

        [Column("usuCreadoPor")]
        public int? UsuCreadoPor { get; set; }

        [Column("usuModificadoPor")]
        public int? UsuModificadoPor { get; set; }

        [Column("usuFechaModificacion")]
        public DateTime? UsuFechaModificacion { get; set; }

        // Navigation properties
        [ForeignKey("UsuCreadoPor")]
        public virtual Usuario? CreadoPor { get; set; }

        // Computed properties
        [NotMapped]
        public bool IsAdmin => UsuRole == "admin";
    }
}
