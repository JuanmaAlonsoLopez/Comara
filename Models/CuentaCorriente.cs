using System.ComponentModel.DataAnnotations;

namespace comara.Models
{
    public class CuentaCorriente
    {
        [Key]
        public int cctaCod { get; set; }
        public int cliCod { get; set; }
        public DateTime cctaFech { get; set; }
        public string? cctaMovimiento { get; set; }
        public float cctaMonto { get; set; }
        public float cctaSaldo { get; set; }
        public string? cctaDesc { get; set; }

        public Cliente Cliente { get; set; }
    }
}
