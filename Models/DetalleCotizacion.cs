using System.ComponentModel.DataAnnotations;

namespace comara.Models
{
    public class DetalleCotizacion
    {
        [Key]
        public int detCotCod { get; set; }
        public int cotCod { get; set; }
        public int artCod { get; set; }
        public float detCant { get; set; }
        public float detPrecio { get; set; }
        public float detSubtotal { get; set; }
    }
}
