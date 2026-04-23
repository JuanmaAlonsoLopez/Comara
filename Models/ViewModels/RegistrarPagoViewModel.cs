using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;

namespace comara.Models.ViewModels
{
    public class RegistrarPagoViewModel
    {
        [Required(ErrorMessage = "El cliente es requerido")]
        [Display(Name = "Cliente")]
        public int CliCod { get; set; }

        [Required(ErrorMessage = "La fecha es requerida")]
        [Display(Name = "Fecha")]
        [DataType(DataType.Date)]
        public DateTime PagFech { get; set; } = DateTime.Now;

        [Required(ErrorMessage = "El monto es requerido")]
        [Display(Name = "Monto")]
        [Range(0.01, double.MaxValue, ErrorMessage = "El monto debe ser mayor a 0")]
        public decimal PagMonto { get; set; }

        [Required(ErrorMessage = "El método de pago es requerido")]
        [Display(Name = "Método de Pago")]
        public int PagMetodoPago { get; set; }

        [Display(Name = "Venta/Factura asociada")]
        public int? VenCod { get; set; }

        [Display(Name = "Descripción")]
        [StringLength(255)]
        public string? PagDesc { get; set; }

        // Datos del cheque (solo si método de pago = Cheque)
        [Display(Name = "Número de Cheque")]
        [StringLength(50)]
        public string? ChqNumero { get; set; }

        [Display(Name = "Banco")]
        [StringLength(100)]
        public string? ChqBanco { get; set; }

        [Display(Name = "Fecha de Emisión")]
        [DataType(DataType.Date)]
        public DateTime? ChqFechaEmision { get; set; }

        [Display(Name = "Fecha de Cobro")]
        [DataType(DataType.Date)]
        public DateTime? ChqFechaCobro { get; set; }

        [Display(Name = "Librador")]
        [StringLength(100)]
        public string? ChqLibrador { get; set; }

        [Display(Name = "CUIT")]
        [StringLength(20)]
        public string? ChqCUIT { get; set; }

        [Display(Name = "Observaciones")]
        [StringLength(255)]
        public string? ChqObservaciones { get; set; }

        public decimal SaldoActual { get; set; }

        // Lista de ventas pendientes del cliente para el dropdown
        public List<VentaPendienteItem> VentasPendientes { get; set; } = new();
    }

    /// <summary>
    /// Item para mostrar ventas pendientes en el dropdown
    /// </summary>
    public class VentaPendienteItem
    {
        public int VenCod { get; set; }
        public string Descripcion { get; set; } = string.Empty;
        public decimal Total { get; set; }
        public decimal Pagado { get; set; }
        public decimal Pendiente => Total - Pagado;
    }
}
