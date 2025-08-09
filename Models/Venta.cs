using System.ComponentModel.DataAnnotations;

namespace comara.Models
{
    public class Venta
    {
        [Key]
        public int venCod { get; set; }
        public DateTime venFech { get; set; }
        public int cliCod { get; set; }
        public float venTotal { get; set; }
        public string? venEstado { get; set; }
        public int? venTipoCbte { get; set; }

        public Cliente Cliente { get; set; }
    }
}
