using System;
using System.Collections.Generic;
using comara.Models;

namespace comara.Models.ViewModels
{
    // Clase base para paginacion
    public class PaginacionViewModel
    {
        public int PaginaActual { get; set; } = 1;
        public int TotalPaginas { get; set; }
        public int TotalRegistros { get; set; }
        public int RegistrosPorPagina { get; set; } = 20;

        public bool TienePaginaAnterior => PaginaActual > 1;
        public bool TienePaginaSiguiente => PaginaActual < TotalPaginas;
    }

    // ViewModel para Reporte de Ventas
    public class ReporteVentasViewModel : PaginacionViewModel
    {
        public List<VentaReporteItem> Ventas { get; set; } = new();

        // Filtros
        public DateTime? FechaDesde { get; set; }
        public DateTime? FechaHasta { get; set; }
        public int? ClienteId { get; set; }
        public int? MetodoPagoId { get; set; }
        public int? EstadoId { get; set; }

        // Totales
        public decimal TotalVentas { get; set; }
        public int CantidadVentas { get; set; }
    }

    public class VentaReporteItem
    {
        public int VenCod { get; set; }
        public DateTime VenFech { get; set; }
        public string ClienteNombre { get; set; } = string.Empty;
        public string MetodoPago { get; set; } = string.Empty;
        public string Estado { get; set; } = string.Empty;
        public decimal VenTotal { get; set; }
    }

    // ViewModel para Reporte de Cuentas Corrientes
    public class ReporteCuentasCorrientesViewModel : PaginacionViewModel
    {
        public List<CuentaCorrienteReporteItem> Movimientos { get; set; } = new();

        // Filtros
        public DateTime? FechaDesde { get; set; }
        public DateTime? FechaHasta { get; set; }
        public int? ClienteId { get; set; }
        public string? TipoMovimiento { get; set; }

        // Totales
        public decimal TotalDebe { get; set; }
        public decimal TotalHaber { get; set; }
    }

    public class CuentaCorrienteReporteItem
    {
        public int CctaCod { get; set; }
        public DateTime CctaFech { get; set; }
        public string ClienteNombre { get; set; } = string.Empty;
        public string Movimiento { get; set; } = string.Empty;
        public decimal Monto { get; set; }
        public decimal Saldo { get; set; }
        public string? Descripcion { get; set; }
    }

    // ViewModel para Reporte de Stock
    public class ReporteStockViewModel : PaginacionViewModel
    {
        public List<StockReporteItem> Articulos { get; set; } = new();

        // Filtros
        public int? MarcaId { get; set; }
        public int? ProveedorId { get; set; }
        public bool? SoloStockCritico { get; set; }
        public string? Busqueda { get; set; }

        // Totales
        public int TotalArticulos { get; set; }
        public int ArticulosStockCritico { get; set; }
        public decimal ValorTotalStock { get; set; }
    }

    public class StockReporteItem
    {
        public string? ArtCod { get; set; }
        public string? ArtDesc { get; set; }
        public string? MarcaNombre { get; set; }
        public string? ProveedorNombre { get; set; }
        public decimal ArtStock { get; set; }
        public decimal ArtStockMin { get; set; }
        public decimal PrecioLista1 { get; set; }
        public decimal ValorStock { get; set; }
        public decimal CostoNeto { get; set; }
        public decimal DescuentoProveedor { get; set; }
        public decimal CostoConDescuento { get; set; }
        public decimal PorcentajeIva { get; set; }
        public decimal CostoFinal { get; set; }
        public bool EsCritico => ArtStock <= ArtStockMin;
    }
}
