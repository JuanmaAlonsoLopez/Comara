using System;
using System.Collections.Generic;

namespace comara.Models.ViewModels
{
    public class CajaIndexViewModel
    {
        public int? MesSeleccionado { get; set; }
        public int? AnioSeleccionado { get; set; }

        public List<VentaCuentaCorrienteViewModel> VentasCuentaCorriente { get; set; } = new();
        public List<BalanceMetodoPagoViewModel> BalancePorMetodo { get; set; } = new();
        public List<ChequeEnCajaViewModel> ChequesEnCaja { get; set; } = new();
        public decimal TotalEfectivoEnCaja { get; set; }
    }

    public class VentaCuentaCorrienteViewModel
    {
        public int VenCod { get; set; }
        public DateTime VenFech { get; set; }
        public string ClienteNombre { get; set; } = string.Empty;
        public decimal VenTotal { get; set; }
        public decimal SaldoPendiente { get; set; }
        public decimal TotalPagado { get; set; }
    }

    public class BalanceMetodoPagoViewModel
    {
        public string MetodoPago { get; set; } = string.Empty;
        public decimal TotalIngresos { get; set; }
        public decimal TotalEgresos { get; set; }
        public decimal SaldoNeto { get; set; }
    }

    public class ChequeEnCajaViewModel
    {
        public int ChqCod { get; set; }
        public string ChqNumero { get; set; } = string.Empty;
        public string ChqBanco { get; set; } = string.Empty;
        public DateTime ChqFechaCobro { get; set; }
        public decimal ChqMonto { get; set; }
        public string ChqLibrador { get; set; } = string.Empty;
    }
}
