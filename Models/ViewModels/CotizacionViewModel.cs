using System.ComponentModel.DataAnnotations;
using comara.Models;

namespace comara.Models.ViewModels
{
    public class CotizacionViewModel
    {
        public int CotCod { get; set; }

        [Required(ErrorMessage = "La fecha es obligatoria")]
        [Display(Name = "Fecha")]
        public DateTime CotFech { get; set; } = DateTime.Now;

        [Required(ErrorMessage = "Debe seleccionar un cliente")]
        [Display(Name = "Cliente")]
        public int CliCod { get; set; }

        [Display(Name = "Estado")]
        public int CotEstadoId { get; set; } = CotizacionEstadoConstantes.Pendiente;

        [Display(Name = "Lista de Precios")]
        public int? ListaCod { get; set; }

        [Display(Name = "Razon de Creación")]
        [Required(ErrorMessage = "La razón de creación es obligatoria")]
        public int? RazonCreaId { get; set; }

        [Required(ErrorMessage = "La cantidad de días de mantenimiento de oferta es obligatoria")]
        [Display(Name = "Mantenimiento de Oferta (días)")]
        public int CantDiasOferta { get; set; } = 15;

        [Required(ErrorMessage = "La cantidad de días de pago es obligatoria")]
        [Display(Name = "Pago (días)")]
        public int CantDiasPago { get; set; } = 30;

        public List<CotizacionItemViewModel> Items { get; set; } = new List<CotizacionItemViewModel>();

        // Propiedades de navegación para mostrar
        public Cliente? Cliente { get; set; }
        public decimal CotTotal { get; set; }
    }

    public class CotizacionItemViewModel
    {
        public int DetCotCod { get; set; }

        [Required]
        public int ArtCod { get; set; }

        [Required(ErrorMessage = "La cantidad es obligatoria")]
        [Range(0.01, double.MaxValue, ErrorMessage = "La cantidad debe ser mayor a 0")]
        public decimal Cantidad { get; set; }

        public decimal Precio { get; set; }
        public decimal Subtotal { get; set; }

        // Para mostrar información del artículo
        public string? ArtDesc { get; set; }
        public decimal? ArtStock { get; set; }
    }
}
