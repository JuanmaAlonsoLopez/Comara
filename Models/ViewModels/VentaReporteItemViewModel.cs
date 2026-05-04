namespace comara.Models.ViewModels
{
    // Modelo para cada fila de la tabla
    // Modifica tu clase VentaReporteItem
    public class VentaReporteItem
    {
        public int VenCod { get; set; }
        public DateTime VenFech { get; set; }
        public string ClienteNombre { get; set; }
        public string MetodoPago { get; set; }
        public string Estado { get; set; }
        public decimal VenTotal { get; set; }

        // NUEVAS PROPIEDADES
        public decimal CostoTotal { get; set; }

        // Calcula el margen automáticamente para cada fila
        public decimal MargenPorcentaje => VenTotal > 0 && CostoTotal > 0
            ? ((VenTotal - CostoTotal) / VenTotal) * 100
            : 0;
    }

    // Modifica tu clase ReporteVentasViewModel
    public class ReporteVentasViewModel
    {
        public List<VentaReporteItem> Ventas { get; set; }
        // ... [Tus otras propiedades de paginación y filtros que ya tienes] ...

        public decimal TotalVentas { get; set; }
        public int CantidadVentas { get; set; }

        // NUEVAS PROPIEDADES
        public decimal GranTotalCostos { get; set; }

        // Calcula el margen general de todas las ventas consultadas
        public decimal MargenGeneral => TotalVentas > 0 && GranTotalCostos > 0
            ? ((TotalVentas - GranTotalCostos) / TotalVentas) * 100
            : 0;
    }
}
