using System.ComponentModel.DataAnnotations;

namespace comara.Models
{
    public class Cobro
    {
        [Key]
        public int cobCod { get; set; }
        public int cliCod { get; set; }
        public DateTime cobFech { get; set; }
        public float cobMonto { get; set; }
        public string? cobMetodo { get; set; }

        public Cliente Cliente { get; set; }
    }
}
