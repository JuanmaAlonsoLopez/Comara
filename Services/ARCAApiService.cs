using comara.Data;
using comara.Models.AFIP;
using comara.Services.AFIP;
using comara.Services.Logging;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;
using System.Text.Json;

namespace comara.Services
{
    public class ARCAApiService : IARCAApiService
    {
        private readonly IAfipFacturacionService _facturacionService;
        private readonly ApplicationDbContext _context;
        private readonly AfipConfig _config;
        private readonly ILogger<ARCAApiService> _logger;
        private readonly IAfipLogService _logService;
        private readonly IFacturaValidacionService _validacionService;

        public ARCAApiService(
            IAfipFacturacionService facturacionService,
            ApplicationDbContext context,
            IOptions<AfipConfig> config,
            ILogger<ARCAApiService> logger,
            IAfipLogService logService,
            IFacturaValidacionService validacionService)
        {
            _facturacionService = facturacionService;
            _context = context;
            _config = config.Value;
            _logger = logger;
            _logService = logService;
            _validacionService = validacionService;
        }

        public async Task<string> GetProductInfo(string productCode)
        {
            // Simulate API call
            await Task.Delay(100);
            return $"Product info for {productCode} from ARCA API (simulated)";
        }

        public async Task<FacturaResponse> GenerarFacturaElectronica(int ventaId)
        {
            try
            {
                // Obtener la venta con sus detalles y cliente
                var venta = await _context.Ventas
                    .Include(v => v.Cliente)
                        .ThenInclude(c => c.CondicionIVA) // IMPORTANTE: Incluir CondicionIVA del cliente
                    .Include(v => v.Cliente)
                        .ThenInclude(c => c.TipoDocumento) // IMPORTANTE: Incluir TipoDocumento del cliente
                    .Include(v => v.DetalleVentas)
                        .ThenInclude(d => d.Articulo)
                            .ThenInclude(a => a.Iva)
                    .Include(v => v.TipoComprobante)
                    .FirstOrDefaultAsync(v => v.VenCod == ventaId);

                if (venta == null)
                {
                    return new FacturaResponse
                    {
                        Success = false,
                        Errores = new List<string> { "Venta no encontrada" }
                    };
                }

                if (venta.Cliente == null)
                {
                    return new FacturaResponse
                    {
                        Success = false,
                        Errores = new List<string> { "Cliente no encontrado para esta venta" }
                    };
                }

                // === VALIDACIONES COMPLETAS ===
                var erroresValidacion = new List<string>();

                // Validar tipo de comprobante
                if (!venta.VenTipoCbte.HasValue)
                {
                    erroresValidacion.Add("La venta no tiene tipo de comprobante asignado");
                }

                // Validar cliente tiene tipo de documento
                if (!venta.Cliente.CliTipoDoc.HasValue)
                {
                    erroresValidacion.Add($"El cliente '{venta.Cliente.CliNombre}' no tiene tipo de documento configurado. Debe configurarlo en Clientes > Editar.");
                }

                // Validar cliente tiene número de documento
                if (string.IsNullOrWhiteSpace(venta.Cliente.CliNumDoc))
                {
                    erroresValidacion.Add($"El cliente '{venta.Cliente.CliNombre}' no tiene número de documento (CUIT/DNI). Debe configurarlo en Clientes > Editar.");
                }
                else
                {
                    // Validar formato del número de documento (solo números)
                    if (!long.TryParse(venta.Cliente.CliNumDoc.Replace("-", ""), out _))
                    {
                        erroresValidacion.Add($"El número de documento del cliente '{venta.Cliente.CliNumDoc}' no es válido. Debe contener solo números.");
                    }
                    // C5: Validar dígito verificador del CUIT si el tipo de documento es CUIT (código 80)
                    else if (venta.Cliente.TipoDocumento?.CodigoAfip == 80)
                    {
                        var errorCuit = CuitValidatorService.ObtenerErrorValidacion(venta.Cliente.CliNumDoc);
                        if (errorCuit != null)
                        {
                            erroresValidacion.Add($"Error en CUIT del cliente '{venta.Cliente.CliNombre}': {errorCuit}");
                        }
                    }
                }

                // Validar cliente tiene condición de IVA
                if (!venta.Cliente.CliCondicionIVA.HasValue)
                {
                    erroresValidacion.Add($"El cliente '{venta.Cliente.CliNombre}' no tiene condición de IVA configurada. Debe configurarlo en Clientes > Editar.");
                }
                else if (venta.Cliente.CondicionIVA == null)
                {
                    erroresValidacion.Add($"La condición de IVA del cliente '{venta.Cliente.CliNombre}' no existe en el sistema. ID: {venta.Cliente.CliCondicionIVA}");
                }

                // Validar que la venta tenga detalles
                if (venta.DetalleVentas == null || !venta.DetalleVentas.Any())
                {
                    erroresValidacion.Add("La venta no tiene productos/items cargados");
                }

                // Validar que todos los artículos tengan IVA configurado
                var articulosSinIVA = venta.DetalleVentas?
                    .Where(d => d.Articulo?.Iva == null)
                    .Select(d => d.Articulo?.ArtDesc ?? "Desconocido")
                    .ToList();

                if (articulosSinIVA?.Any() == true)
                {
                    erroresValidacion.Add($"Los siguientes artículos no tienen IVA configurado: {string.Join(", ", articulosSinIVA)}");
                }

                // Validar importes
                if (venta.VenTotal <= 0)
                {
                    erroresValidacion.Add("El total de la venta debe ser mayor a cero");
                }

                // C11: Validar compatibilidad entre tipo de comprobante y condición IVA del cliente
                if (venta.VenTipoCbte.HasValue && venta.Cliente.CondicionIVA != null && venta.TipoComprobante != null)
                {
                    var validacionComprobante = _validacionService.ValidarTipoComprobanteCliente(
                        venta.TipoComprobante.CodigoAfip,
                        venta.Cliente.CondicionIVA.CodigoAfip);

                    if (!validacionComprobante.EsValido)
                    {
                        erroresValidacion.Add(validacionComprobante.MensajeError ??
                            $"El tipo de comprobante {venta.TipoComprobante.Descripcion} no es compatible con la condición IVA del cliente.");
                    }
                }

                // C6: Validar que Factura A requiere CUIT (código documento 80)
                if (venta.TipoComprobante?.CodigoAfip == 1 && venta.Cliente.TipoDocumento?.CodigoAfip != 80)
                {
                    erroresValidacion.Add($"Factura A requiere CUIT (tipo documento 80) del receptor. El cliente '{venta.Cliente.CliNombre}' tiene tipo de documento {venta.Cliente.TipoDocumento?.CodigoAfip ?? 0}. No se permite DNI u otro documento para Factura A.");
                }

                // Si hay errores de validación, retornar
                if (erroresValidacion.Any())
                {
                    _logger.LogWarning("Validación fallida para venta {VentaId}: {Errores}",
                        ventaId, string.Join("; ", erroresValidacion));

                    return new FacturaResponse
                    {
                        Success = false,
                        Errores = erroresValidacion
                    };
                }

                // Validar punto de venta
                int puntoVenta = venta.VenPuntoVenta ?? _config.PuntoVenta;

                // Obtener siguiente número de comprobante
                long ultimoNumero = await _facturacionService.ObtenerUltimoComprobanteAsync(
                    venta.VenTipoCbte.Value,
                    puntoVenta);

                long numeroComprobante = ultimoNumero + 1;

                _logger.LogInformation(
                    "Último comprobante en AFIP: {Ultimo}, Siguiente a usar: {Siguiente}, Tipo: {Tipo}, PtoVta: {PtoVta}",
                    ultimoNumero, numeroComprobante, venta.VenTipoCbte.Value, puntoVenta);

                // Calcular totales de IVA agrupados por código AFIP (que es el ID)
                // C10: Separar artículos gravados de exentos/no gravados
                // Código AFIP 2 = Exento, Código AFIP 3 = No Gravado
                var articulosExentos = venta.DetalleVentas
                    .Where(d => d.Articulo?.Iva != null && d.Articulo.Iva.Id == 2) // Exento
                    .Sum(d => (decimal)d.DetSubtotal);

                var articulosNoGravados = venta.DetalleVentas
                    .Where(d => d.Articulo?.Iva != null && d.Articulo.Iva.Id == 3) // No gravado
                    .Sum(d => (decimal)d.DetSubtotal);

                // Solo procesar artículos gravados (códigos 4, 5, 6 = 10.5%, 21%, 27%)
                var itemsIVA = venta.DetalleVentas
                    .Where(d => d.Articulo?.Iva != null && d.Articulo.Iva.Id >= 4) // Solo gravados
                    .GroupBy(d => new { d.Articulo!.Iva!.Id, d.Articulo.Iva.Porcentaje })
                    .Select(g =>
                    {
                        var codigoAfip = g.Key.Id; // El ID es directamente el código AFIP
                        var porcentajeIVA = g.Key.Porcentaje;
                        var subtotalConIVA = g.Sum(d => (decimal)d.DetSubtotal);

                        // Calcular base imponible (precio sin IVA)
                        var baseImponible = subtotalConIVA / (1 + porcentajeIVA / 100m);
                        var importeIVA = subtotalConIVA - baseImponible;

                        return new FacturaIVAItem
                        {
                            CodigoIVA = codigoAfip, // Usar el ID directamente, no mapear
                            BaseImponible = Math.Round(baseImponible, 2),
                            Importe = Math.Round(importeIVA, 2)
                        };
                    })
                    .ToList();

                decimal importeNeto = itemsIVA.Sum(i => i.BaseImponible);
                decimal importeIVA = itemsIVA.Sum(i => i.Importe);
                decimal importeExento = Math.Round(articulosExentos, 2);
                decimal importeNoGravado = Math.Round(articulosNoGravados, 2);
                // Total calculado debe incluir: Neto gravado + IVA + Exento + No gravado
                decimal importeTotalCalculado = importeNeto + importeIVA + importeExento + importeNoGravado;
                decimal importeTotal = (decimal)venta.VenTotal;

                // Validar que el total calculado coincida con el total de la venta (con tolerancia de centavos)
                var diferencia = Math.Abs(importeTotalCalculado - importeTotal);
                if (diferencia > 0.10m) // Tolerancia de 10 centavos por redondeos
                {
                    _logger.LogWarning(
                        "Diferencia en totales para venta {VentaId}: Total BD={TotalBD}, Total Calculado={TotalCalc}, Diferencia={Dif}",
                        ventaId, importeTotal, importeTotalCalculado, diferencia);

                    // Ajustar el total al calculado (es más preciso)
                    importeTotal = importeTotalCalculado;
                }

                // Crear request para AFIP
                // IMPORTANTE: AFIP requiere la fecha de HOY (fecha de autorización), no la fecha de venta
                var fechaHoy = DateTime.Today;

                var facturaRequest = new FacturaRequest
                {
                    TipoComprobante = venta.VenTipoCbte.Value,
                    PuntoVenta = puntoVenta,
                    NumeroComprobante = numeroComprobante,
                    Fecha = fechaHoy, // Usar fecha de hoy para evitar problemas de timezone
                    TipoDocCliente = venta.Cliente.CliTipoDoc!.Value, // Ya validado arriba
                    NumeroDocCliente = long.Parse(venta.Cliente.CliNumDoc!.Replace("-", "")), // Ya validado arriba
                    CondicionIVAReceptor = venta.Cliente.CondicionIVA!.CodigoAfip, // Usar el código AFIP, no el ID
                    ImporteTotal = importeTotal,
                    ImporteNeto = importeNeto,
                    ImporteIVA = importeIVA,
                    ImporteExento = importeExento, // C10: Usar importe calculado de artículos exentos
                    ImporteTributos = 0, // TODO: Implementar cuando haya tributos adicionales
                    ImporteNoGravado = importeNoGravado, // Artículos no gravados
                    Concepto = "Productos",
                    ItemsIVA = itemsIVA
                };

                // Log de información de la factura
                _logger.LogInformation(
                    "Preparando factura: VentaId={VentaId}, Tipo={Tipo}, Cliente={Cliente}, Total={Total}, Neto={Neto}, IVA={IVA}",
                    ventaId, venta.VenTipoCbte.Value, venta.Cliente.CliNombre, importeTotal, importeNeto, importeIVA);

                // Preparar request para logging
                var requestJson = JsonSerializer.Serialize(facturaRequest, new JsonSerializerOptions { WriteIndented = true });

                // Autorizar en AFIP con logging
                var response = await _logService.RegistrarOperacionAsync(
                    tipoOperacion: "AutorizarFactura",
                    request: requestJson,
                    operacion: async () =>
                    {
                        var result = await _facturacionService.AutorizarComprobanteAsync(facturaRequest);
                        var responseJson = JsonSerializer.Serialize(result, new JsonSerializerOptions { WriteIndented = true });

                        return (
                            exitoso: result.Success,
                            response: responseJson,
                            error: result.Success ? null : string.Join("; ", result.Errores),
                            cae: result.CAE
                        );
                    },
                    ventaId: ventaId
                );

                // Obtener el resultado de la autorización
                var afipResponse = response.Exitoso
                    ? JsonSerializer.Deserialize<FacturaResponse>(response.Response ?? "{}")
                    : new FacturaResponse
                    {
                        Success = false,
                        Errores = new List<string> { response.MensajeError ?? "Error desconocido" }
                    };

                // Si fue exitoso, actualizar la venta con los datos de AFIP
                if (afipResponse?.Success == true)
                {
                    venta.VenPuntoVenta = puntoVenta;
                    venta.VenNumComprobante = afipResponse.NumeroComprobante;
                    venta.VenCAE = afipResponse.CAE;
                    venta.VenCAEVencimiento = afipResponse.CAEVencimiento;
                    venta.VenFechaAutorizacion = DateTime.UtcNow;
                    venta.VenResultadoAfip = afipResponse.Resultado;
                    venta.VenObservacionesAfip = afipResponse.Observaciones;

                    await _context.SaveChangesAsync();

                    _logger.LogInformation("Factura autorizada exitosamente. VentaID={VentaId}, CAE={CAE}", ventaId, afipResponse.CAE);
                }
                else
                {
                    _logger.LogError("Error al autorizar factura. VentaID={VentaId}, Errores={Errores}",
                        ventaId,
                        string.Join("; ", afipResponse?.Errores ?? new List<string> { "Error desconocido" }));
                }

                return afipResponse ?? new FacturaResponse { Success = false, Errores = new List<string> { "Error al procesar respuesta" } };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Error al generar factura electrónica para venta {ventaId}");
                return new FacturaResponse
                {
                    Success = false,
                    Errores = new List<string> { ex.Message }
                };
            }
        }

        public async Task<long> ObtenerUltimoNumeroComprobante(int tipoComprobante, int puntoVenta)
        {
            return await _facturacionService.ObtenerUltimoComprobanteAsync(tipoComprobante, puntoVenta);
        }

        public async Task<FacturaResponse> ConsultarFactura(int tipoComprobante, int puntoVenta, long numeroComprobante)
        {
            return await _facturacionService.ConsultarComprobanteAsync(tipoComprobante, puntoVenta, numeroComprobante);
        }

        // NOTA: En esta BD, el ID de la tabla IVA es directamente el código AFIP
        // Por ejemplo: ID=3 es 0%, ID=4 es 10.5%, ID=5 es 21%, ID=6 es 27%
        // No se necesita mapeo adicional
    }
}
