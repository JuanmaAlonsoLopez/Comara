using System.ComponentModel.DataAnnotations;

namespace comara.Models.ViewModels
{
    public class VentaViewModel
    {
        public int VenCod { get; set; }

        [Required(ErrorMessage = "La fecha es obligatoria")]
        [Display(Name = "Fecha")]
        public DateTime VenFech { get; set; } = DateTime.Now;

        [Required(ErrorMessage = "Debe seleccionar un cliente")]
        [Display(Name = "Cliente")]
        public int CliCod { get; set; }

        [Display(Name = "Estado")]
        public int? VenEstado { get; set; }

        [Display(Name = "Tipo de Comprobante")]
        public int? VenTipoCbte { get; set; }

        [Display(Name = "Método de Pago")]
        public int? VenMetodoPago { get; set; }

        [Display(Name = "Lista de Precios")]
        public int? ListaCod { get; set; }

        public List<VentaItemViewModel> Items { get; set; } = new List<VentaItemViewModel>();

        // Propiedades de navegación para mostrar
        public Cliente? Cliente { get; set; }
        public decimal VenTotal { get; set; }

        // Para conversión desde cotización
        public int? CotizacionOrigen { get; set; }
    }

    public class VentaItemViewModel
    {
        public int DetCod { get; set; }

        [Required]
        public int ArtCod { get; set; }

        [Required(ErrorMessage = "La cantidad es obligatoria")]
        [Range(0.01, double.MaxValue, ErrorMessage = "La cantidad debe ser mayor a 0")]
        public decimal Cantidad { get; set; }

        public decimal Precio { get; set; }
        public decimal Subtotal { get; set; }
        public decimal CostoUnitario { get; set; }
        public decimal CostoTotal { get; set; }

        // Para mostrar información del artículo
        public string? ArtCodigoStr { get; set; } // Código del artículo como string (artCod de la tabla)
        public string? ArtDesc { get; set; }
        public decimal? ArtStock { get; set; }
    }
}
