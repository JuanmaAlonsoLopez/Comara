using System.ComponentModel.DataAnnotations;

namespace comara.Models.ViewModels
{
    public class EditUsuarioViewModel
    {
        public int Id { get; set; }

        [Required(ErrorMessage = "El nombre de usuario es obligatorio")]
        [StringLength(50)]
        [Display(Name = "Usuario")]
        public string UsuUsername { get; set; }

        [Required(ErrorMessage = "El nombre completo es obligatorio")]
        [StringLength(100)]
        [Display(Name = "Nombre Completo")]
        public string UsuNombreCompleto { get; set; }

        [EmailAddress(ErrorMessage = "Email inválido")]
        [Display(Name = "Email")]
        public string? UsuEmail { get; set; }

        [Required(ErrorMessage = "El rol es obligatorio")]
        [Display(Name = "Rol")]
        public string UsuRole { get; set; }

        [Display(Name = "Activo")]
        public bool UsuActivo { get; set; }
    }
}
