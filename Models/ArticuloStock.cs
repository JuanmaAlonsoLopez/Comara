using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    public class ArticuloStock
    {
        public int Id { get; set; }

        [Display(Name = "Código")]
        public string? ArtCod { get; set; }

        [Display(Name = "Descripción")]
        public string? ArtDesc { get; set; }

        [Display(Name = "Stock")]
        public decimal? ArtStock { get; set; }

        [Display(Name = "Stock mínimo")]
        public decimal? ArtStockMin { get; set; }
    }
}