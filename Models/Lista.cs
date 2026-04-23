using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("LISTAS")]
    public class Lista
    {
        [Key]
        [Column("listCod")]
        public int ListCode { get; set; }

        [StringLength(50)]
        [Column("listDesc")]
        public string? ListDesc { get; set; }

        [Required(ErrorMessage = "El porcentaje es obligatorio.")]
        [Column("listPercent")]
        public decimal ListPercent { get; set; }

        [Required]
        [Column("listStatus")]
        public bool ListStatus { get; set; }

    }
}