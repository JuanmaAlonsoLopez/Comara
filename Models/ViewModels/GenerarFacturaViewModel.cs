using System.ComponentModel.DataAnnotations;

namespace comara.Models.ViewModels
{
    /// <summary>
    /// ViewModel para la generación de facturas electrónicas AFIP
    /// </summary>
    public class GenerarFacturaViewModel
    {
        /// <summary>
        /// Código de la venta a facturar
        /// </summary>
        public int VenCod { get; set; }

        /// <summary>
        /// Tipo de comprobante seleccionado (código AFIP: 1=FC A, 6=FC B, 11=FC C)
        /// </summary>
        [Required(ErrorMessage = "Debe seleccionar el tipo de comprobante")]
        [Display(Name = "Tipo de Comprobante")]
        public int TipoComprobante { get; set; }

        /// <summary>
        /// Punto de venta autorizado en AFIP
        /// </summary>
        [Required(ErrorMessage = "Debe especificar el punto de venta")]
        [Range(1, 9999, ErrorMessage = "El punto de venta debe estar entre 1 y 9999")]
        [Display(Name = "Punto de Venta")]
        public int PuntoVenta { get; set; } = 1;

        /// <summary>
        /// Datos de la venta para mostrar en la vista
        /// </summary>
        public Venta? Venta { get; set; }

        /// <summary>
        /// Tipos de comprobante disponibles según la condición IVA del cliente
        /// </summary>
        public List<TipoComprobanteDisponible> TiposDisponibles { get; set; } = new();
    }

    /// <summary>
    /// Representa un tipo de comprobante disponible para selección
    /// </summary>
    public class TipoComprobanteDisponible
    {
        /// <summary>
        /// Código AFIP del tipo de comprobante
        /// </summary>
        public int CodigoAfip { get; set; }

        /// <summary>
        /// Descripción del tipo de comprobante (ej: "Factura A")
        /// </summary>
        public string Descripcion { get; set; } = string.Empty;

        /// <summary>
        /// Indica si es el tipo recomendado según la condición IVA del cliente
        /// </summary>
        public bool EsRecomendado { get; set; }

        /// <summary>
        /// Mensaje de advertencia o información adicional sobre este tipo
        /// </summary>
        public string? MensajeAdvertencia { get; set; }
    }
}
