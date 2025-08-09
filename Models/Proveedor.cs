using System.ComponentModel.DataAnnotations;

namespace comara.Models
{
    public class Proveedor
    {
        [Key]
        public int proCod { get; set; }
        public string proNombre { get; set; }
        public string? proCUIT { get; set; }
        public string? proContacto { get; set; }
    }
}
