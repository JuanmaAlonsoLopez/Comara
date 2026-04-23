using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("CLIENTES")]
    public class Cliente
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Required]
        [StringLength(100)]
        [Column("cliNombre")]
        [Display(Name = "Nombre")]
        public string CliNombre { get; set; }

        [StringLength(200)]
        [Column("cliDireccion")]
        [Display(Name = "Dirección")]
        public string? CliDireccion { get; set; }

        [StringLength(20)]
        [Column("cliTelefono")]
        [Display(Name = "Teléfono")]
        public string? CliTelefono { get; set; }

        [StringLength(100)]
        [Column("cliEmail")]
        [Display(Name = "Email")]
        [EmailAddress(ErrorMessage = "Formato de email inválido")]
        public string? CliEmail { get; set; }

        // Campos para AFIP
        [Column("cliTipoDoc")]
        [Display(Name = "Tipo de Documento")]
        public int? CliTipoDoc { get; set; }

        [StringLength(20)]
        [Column("cliNumDoc")]
        [Display(Name = "Número de Documento")]
        public string? CliNumDoc { get; set; }

        [Column("cliCondicionIVA")]
        [Display(Name = "Condición IVA")]
        public int? CliCondicionIVA { get; set; }

        [Column("cliFormaPago")]
        [Display(Name = "Forma de Pago")]
        public int? CliFormaPago { get; set; }

        // Navegación
        [ForeignKey("CliTipoDoc")]
        public virtual TipoDocumento? TipoDocumento { get; set; }

        [ForeignKey("CliCondicionIVA")]
        public virtual CondicionIVA? CondicionIVA { get; set; }

        [ForeignKey("CliFormaPago")]
        public virtual ClienteTipoFormaPago? TipoFormaPago { get; set; }
    }
}