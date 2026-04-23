using comara.Models;
using comara.Models.ViewModels;

namespace comara.Services
{
    /// <summary>
    /// Servicio para calcular la discriminación de IVA en facturas
    /// </summary>
    public class FacturaIvaCalculadorService
    {
        /// <summary>
        /// Calcula la discriminación de IVA para una venta
        /// </summary>
        /// <param name="venta">Venta con detalles e información del artículo/IVA cargados</param>
        /// <returns>ViewModel con IVA discriminado por artículo</returns>
        public static FacturaIvaViewModel CalcularIvaDiscriminado(Venta venta)
        {
            var resultado = new FacturaIvaViewModel
            {
                Total = (decimal)venta.VenTotal
            };

            // Solo discriminar IVA para Facturas Tipo A (código AFIP = 1)
            var esFacturaTipoA = venta.TipoComprobante?.CodigoAfip == 1;
            resultado.DiscriminarIva = esFacturaTipoA;

            if (!esFacturaTipoA)
            {
                // Para tipo B, C, etc., no discriminar - solo pasar los datos originales
                resultado.SubtotalNeto = resultado.Total;

                // Crear detalles sin discriminación
                foreach (var detalle in venta.DetalleVentas ?? Enumerable.Empty<DetalleVenta>())
                {
                    resultado.Detalles.Add(new DetalleArticuloConIva
                    {
                        Codigo = detalle.Articulo?.ArtCod,
                        Descripcion = detalle.Articulo?.ArtDesc,
                        Cantidad = detalle.DetCant,
                        PrecioUnitarioSinIva = (decimal)detalle.DetPrecio,
                        PrecioUnitarioConIva = (decimal)detalle.DetPrecio,
                        SubtotalSinIva = (decimal)detalle.DetSubtotal,
                        SubtotalConIva = (decimal)detalle.DetSubtotal,
                        PorcentajeIva = 0
                    });
                }

                return resultado;
            }

            // Calcular discriminación de IVA para Factura Tipo A
            decimal subtotalNeto = 0;
            decimal totalConIva = 0;

            foreach (var detalle in venta.DetalleVentas ?? Enumerable.Empty<DetalleVenta>())
            {
                // Obtener porcentaje de IVA del artículo
                var porcentajeIva = detalle.Articulo?.Iva?.Porcentaje ?? 0;

                // Precio CON IVA (el que está guardado en la base de datos)
                var precioUnitarioConIva = (decimal)detalle.DetPrecio;
                var subtotalConIva = (decimal)detalle.DetSubtotal;

                // Calcular precio SIN IVA
                // Fórmula: PrecioSinIva = PrecioConIva / (1 + IVA/100)
                var divisor = 1 + (porcentajeIva / 100);
                var precioUnitarioSinIva = precioUnitarioConIva / divisor;
                var subtotalSinIva = precioUnitarioSinIva * (decimal)detalle.DetCant;

                // Acumular totales
                subtotalNeto += subtotalSinIva;
                totalConIva += subtotalConIva;

                // Agregar detalle
                resultado.Detalles.Add(new DetalleArticuloConIva
                {
                    Codigo = detalle.Articulo?.ArtCod,
                    Descripcion = detalle.Articulo?.ArtDesc,
                    Cantidad = detalle.DetCant,
                    PrecioUnitarioSinIva = precioUnitarioSinIva,
                    PrecioUnitarioConIva = precioUnitarioConIva,
                    SubtotalSinIva = subtotalSinIva,
                    SubtotalConIva = subtotalConIva,
                    PorcentajeIva = porcentajeIva
                });
            }

            resultado.SubtotalNeto = subtotalNeto;
            resultado.Total = totalConIva;

            return resultado;
        }
    }
}
