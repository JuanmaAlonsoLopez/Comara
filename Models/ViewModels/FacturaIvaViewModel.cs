namespace comara.Models.ViewModels
{
    /// <summary>
    /// ViewModel para discriminación de IVA en facturas tipo A
    /// </summary>
    public class FacturaIvaViewModel
    {
        /// <summary>
        /// Subtotal neto (sin IVA) - Sumatoria de todos los artículos sin IVA
        /// </summary>
        public decimal SubtotalNeto { get; set; }

        /// <summary>
        /// Total final (con IVA) - Sumatoria de todos los artículos con IVA
        /// </summary>
        public decimal Total { get; set; }

        /// <summary>
        /// Indica si debe discriminar IVA (solo facturas tipo A)
        /// </summary>
        public bool DiscriminarIva { get; set; }

        /// <summary>
        /// Detalles de artículos con precios discriminados
        /// </summary>
        public List<DetalleArticuloConIva> Detalles { get; set; } = new List<DetalleArticuloConIva>();
    }

    /// <summary>
    /// Representa un artículo con sus precios discriminados por IVA
    /// </summary>
    public class DetalleArticuloConIva
    {
        /// <summary>
        /// Código del artículo
        /// </summary>
        public string? Codigo { get; set; }

        /// <summary>
        /// Descripción del artículo
        /// </summary>
        public string? Descripcion { get; set; }

        /// <summary>
        /// Cantidad
        /// </summary>
        public decimal Cantidad { get; set; }

        /// <summary>
        /// Precio unitario SIN IVA
        /// </summary>
        public decimal PrecioUnitarioSinIva { get; set; }

        /// <summary>
        /// Precio unitario CON IVA
        /// </summary>
        public decimal PrecioUnitarioConIva { get; set; }

        /// <summary>
        /// Subtotal SIN IVA (PrecioSinIva * Cantidad)
        /// </summary>
        public decimal SubtotalSinIva { get; set; }

        /// <summary>
        /// Subtotal CON IVA (PrecioConIva * Cantidad)
        /// </summary>
        public decimal SubtotalConIva { get; set; }

        /// <summary>
        /// Porcentaje de IVA aplicado
        /// </summary>
        public decimal PorcentajeIva { get; set; }
    }
}
