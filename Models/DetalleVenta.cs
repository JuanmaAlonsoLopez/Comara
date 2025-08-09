using System.ComponentModel.DataAnnotations;

namespace comara.Models
{
    public class DetalleVenta
    {
        [Key]
        public int detCod { get; set; }
        public int venCod { get; set; }
        public int artCod { get; set; }
        public float detCant { get; set; }
        public float detPrecio { get; set; }
        public float detSubtotal { get; set; }
    }
}
