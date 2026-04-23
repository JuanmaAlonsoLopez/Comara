using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace comara.Models.ViewModels
{
    public class RegistrarPagoFacturaViewModel
    {
        // Datos de la Factura/Venta
        public int VenCod { get; set; }
        public string? NumeroFactura { get; set; }
        public DateTime FechaFactura { get; set; }
        public string? ClienteNombre { get; set; }
        public int ClienteId { get; set; }
        public string? TipoComprobante { get; set; }
        public decimal TotalFactura { get; set; }
        public decimal TotalPagado { get; set; }
        public decimal SaldoPendiente => TotalFactura - TotalPagado;
        public int? EstadoPagoActual { get; set; }
        public string? EstadoPagoDescripcion { get; set; }

        // Datos del Pago a Registrar
        [Required(ErrorMessage = "El monto es requerido")]
        [Range(0.01, double.MaxValue, ErrorMessage = "El monto debe ser mayor a 0")]
        [Display(Name = "Monto a Pagar")]
        public decimal MontoPago { get; set; }

        [Required(ErrorMessage = "El metodo de pago es requerido")]
        [Display(Name = "Metodo de Pago")]
        public int MetodoPago { get; set; }

        [Display(Name = "Fecha de Pago")]
        public DateTime FechaPago { get; set; } = DateTime.Now;

        [StringLength(255)]
        [Display(Name = "Descripcion")]
        public string? Descripcion { get; set; }

        // Datos de Cheque (si aplica)
        [Display(Name = "Numero de Cheque")]
        public string? ChequeNumero { get; set; }

        [Display(Name = "Banco")]
        public string? ChequeBanco { get; set; }

        [Display(Name = "Fecha de Emision")]
        public DateTime? ChequeFechaEmision { get; set; }

        [Display(Name = "Fecha de Cobro")]
        public DateTime? ChequeFechaCobro { get; set; }

        [Display(Name = "Librador")]
        public string? ChequeLibrador { get; set; }

        [Display(Name = "CUIT del Librador")]
        public string? ChequeCUIT { get; set; }

        // Metodos de pago disponibles para este cliente
        public List<VentaTipoMetodoPago> MetodosPagoDisponibles { get; set; } = new List<VentaTipoMetodoPago>();

        // Historial de pagos realizados
        public List<PagoRegistrado> PagosRealizados { get; set; } = new List<PagoRegistrado>();

        // Datos adicionales del cliente
        public int? ClienteFormaPago { get; set; } // 1=Cuenta Corriente, 2=Efectivo, 3=Ambos
        public string? ClienteFormaPagoDescripcion { get; set; }
    }

    public class PagoRegistrado
    {
        public int PagCod { get; set; }
        public DateTime Fecha { get; set; }
        public decimal Monto { get; set; }
        public string? MetodoPago { get; set; }
        public string? Descripcion { get; set; }
    }
}
