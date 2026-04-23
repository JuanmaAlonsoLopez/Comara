using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Collections.Generic;

namespace comara.Models
{
    [Table("tipoRazonCrea")]
    public class TipoRazonCrea
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Column("nombre_razon")]
        [StringLength(50)]
        public string NombreRazon { get; set; } = string.Empty;

        // Navegación inversa opcional
        public virtual ICollection<Cotizacion>? Cotizaciones { get; set; }
    }
}