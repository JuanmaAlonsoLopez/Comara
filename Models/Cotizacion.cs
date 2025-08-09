using System.ComponentModel.DataAnnotations;

namespace comara.Models
{
    public class Cotizacion
    {
        [Key]
        public int cotCod { get; set; }
        public DateTime cotFech { get; set; }
        public int cliCod { get; set; }
        public float cotTotal { get; set; }
        public string? cotEstado { get; set; }

        public Cliente Cliente { get; set; }
    }
}
