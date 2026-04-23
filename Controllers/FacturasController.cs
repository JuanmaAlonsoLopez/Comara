using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using comara.Services;
using comara.Services.PDF;
using comara.Data;
using comara.Models;
using comara.Models.ViewModels;
using Microsoft.EntityFrameworkCore;

namespace comara.Controllers
{
    [Authorize]
    public class FacturasController : Controller
    {
        private readonly IARCAApiService _arcaService;
        private readonly IFacturaPDFService _pdfService;
        private readonly ApplicationDbContext _context;
        private readonly IFacturaValidacionService _validacionService;
        private readonly ILogger<FacturasController> _logger;

        public FacturasController(
            IARCAApiService arcaService,
            IFacturaPDFService pdfService,
            ApplicationDbContext context,
            IFacturaValidacionService validacionService,
            ILogger<FacturasController> logger)
        {
            _arcaService = arcaService;
            _pdfService = pdfService;
            _context = context;
            _validacionService = validacionService;
            _logger = logger;
        }

        // GET: Facturas
        public async Task<IActionResult> Index()
        {
            // Mostrar ventas con sus facturas electrónicas
            var ventas = await _context.Ventas
                .Include(v => v.Cliente)
                .Include(v => v.TipoComprobante)
                .Where(v => v.VenCAE != null) // Solo facturas electrónicas autorizadas
                .OrderByDescending(v => v.VenFech)
                .ToListAsync();

            // Calcular estadísticas de CAE para alertas
            var hoy = DateTime.Today;
            var facturasCAEVencido = ventas.Count(v => v.VenCAEVencimiento.HasValue && v.VenCAEVencimiento.Value.Date < hoy);
            var facturasCAEProximoVencer = ventas.Count(v => v.VenCAEVencimiento.HasValue &&
                v.VenCAEVencimiento.Value.Date >= hoy &&
                v.VenCAEVencimiento.Value.Date <= hoy.AddDays(3));

            if (facturasCAEVencido > 0)
            {
                ViewBag.AlertaCAEVencido = $"Hay {facturasCAEVencido} factura(s) con CAE vencido.";
            }
            if (facturasCAEProximoVencer > 0)
            {
                ViewBag.AlertaCAEProximoVencer = $"Hay {facturasCAEProximoVencer} factura(s) con CAE próximo a vencer (3 días o menos).";
            }

            // Pasar el servicio de validación para usar en la vista
            ViewBag.ValidacionService = _validacionService;

            return View(ventas);
        }

        // GET: Facturas/Generar/5
        public async Task<IActionResult> Generar(int id)
        {
            var venta = await _context.Ventas
                .Include(v => v.Cliente)
                    .ThenInclude(c => c.CondicionIVA)
                .Include(v => v.Cliente)
                    .ThenInclude(c => c.TipoDocumento)
                .Include(v => v.TipoComprobante)
                .Include(v => v.DetalleVentas)
                    .ThenInclude(d => d.Articulo)
                        .ThenInclude(a => a.Iva)
                .FirstOrDefaultAsync(v => v.VenCod == id);

            if (venta == null)
            {
                return NotFound();
            }

            // Validar datos del cliente antes de mostrar formulario
            var validacionCliente = _validacionService.ValidarDatosCliente(venta.Cliente!);
            if (!validacionCliente.EsValido)
            {
                TempData["Error"] = validacionCliente.MensajeError;
                return RedirectToAction("Details", "Ventas", new { id = venta.VenCod });
            }

            // Obtener tipos de comprobante válidos para el cliente
            var tiposValidos = new List<TipoComprobanteDisponible>();

            if (venta.Cliente?.CondicionIVA != null)
            {
                var codigosValidos = _validacionService.ObtenerTiposComprobanteValidos(venta.Cliente.CondicionIVA.CodigoAfip);
                var tipoSugerido = _validacionService.SugerirTipoComprobante(venta.Cliente.CondicionIVA.CodigoAfip);

                var tiposComprobante = await _context.TipoComprobantes
                    .Where(tc => codigosValidos.Contains(tc.CodigoAfip))
                    .ToListAsync();

                foreach (var tipo in tiposComprobante)
                {
                    var advertencias = new List<string>();

                    // Agregar advertencias específicas
                    if (tipo.CodigoAfip == 1 && venta.Cliente.TipoDocumento?.CodigoAfip != 80)
                    {
                        advertencias.Add("Factura A requiere que el cliente tenga CUIT.");
                    }

                    tiposValidos.Add(new TipoComprobanteDisponible
                    {
                        CodigoAfip = tipo.CodigoAfip,
                        Descripcion = tipo.Descripcion,
                        EsRecomendado = tipo.CodigoAfip == tipoSugerido,
                        MensajeAdvertencia = advertencias.Any() ? string.Join(" ", advertencias) : null
                    });
                }
            }

            var viewModel = new GenerarFacturaViewModel
            {
                VenCod = id,
                Venta = venta,
                TiposDisponibles = tiposValidos,
                PuntoVenta = venta.VenPuntoVenta ?? 1,
                TipoComprobante = venta.VenTipoCbte ?? tiposValidos.FirstOrDefault(t => t.EsRecomendado)?.CodigoAfip ?? 0
            };

            // Advertencias de artículos
            var validacionArticulos = _validacionService.ValidarArticulosVenta(venta.DetalleVentas.ToList());
            if (validacionArticulos.Advertencias.Any())
            {
                ViewBag.AdvertenciasArticulos = validacionArticulos.Advertencias;
            }

            return View(viewModel);
        }

        // POST: Facturas/Generar/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> GenerarFactura(int id, int tipoComprobante, int puntoVenta)
        {
            try
            {
                var venta = await _context.Ventas
                    .Include(v => v.Cliente)
                        .ThenInclude(c => c.CondicionIVA)
                    .FirstOrDefaultAsync(v => v.VenCod == id);

                if (venta == null)
                {
                    return NotFound();
                }

                // Validar datos del cliente
                var validacionCliente = _validacionService.ValidarDatosCliente(venta.Cliente!);
                if (!validacionCliente.EsValido)
                {
                    TempData["Error"] = validacionCliente.MensajeError;
                    return RedirectToAction(nameof(Generar), new { id = id });
                }

                // Buscar tipo de comprobante en la base de datos
                var tipoComprobanteEntity = await _context.TipoComprobantes
                    .FirstOrDefaultAsync(tc => tc.Id == tipoComprobante || tc.CodigoAfip == tipoComprobante);

                if (tipoComprobanteEntity == null)
                {
                    TempData["Error"] = "Tipo de comprobante no válido.";
                    return RedirectToAction(nameof(Generar), new { id = id });
                }

                // Validar compatibilidad tipo comprobante con condición IVA
                var validacion = _validacionService.ValidarTipoComprobanteCliente(
                    tipoComprobanteEntity.CodigoAfip,
                    venta.Cliente!.CondicionIVA!.CodigoAfip);

                if (!validacion.EsValido)
                {
                    TempData["Error"] = validacion.MensajeError;
                    return RedirectToAction(nameof(Generar), new { id = id });
                }

                // C8: Actualizar la venta con el código AFIP (no el ID de la tabla)
                // Esto garantiza consistencia en toda la aplicación
                venta.VenTipoCbte = tipoComprobanteEntity.CodigoAfip;
                venta.VenPuntoVenta = puntoVenta;
                await _context.SaveChangesAsync();

                // Agregar advertencias si las hay
                if (validacion.Advertencias.Any())
                {
                    TempData["Warning"] = string.Join(" ", validacion.Advertencias);
                }

                // Redirigir al método de autorización
                return RedirectToAction("AutorizarConAfip", "Ventas", new { id = id });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Error al preparar factura para venta {id}");
                TempData["Error"] = $"Error: {ex.Message}";
                return RedirectToAction(nameof(Generar), new { id = id });
            }
        }
        //VIEJO:
        //public async Task<IActionResult> GenerarFactura(int id, int tipoComprobante, int puntoVenta)
        //{
        //    try
        //    {
        //        // Actualizar tipo de comprobante y punto de venta si se especificaron
        //        var venta = await _context.Ventas.FindAsync(id);
        //        if (venta == null)
        //        {
        //            return NotFound();
        //        }

        //        venta.VenTipoCbte = tipoComprobante;
        //        venta.VenPuntoVenta = puntoVenta;
        //        venta.VenFechVenta = DateTime.UtcNow; // Registrar fecha de venta/facturación
        //        await _context.SaveChangesAsync();

        //        // Generar factura electrónica
        //        var resultado = await _arcaService.GenerarFacturaElectronica(id);

        //        if (resultado.Success)
        //        {
        //            TempData["Success"] = $"Factura autorizada correctamente. CAE: {resultado.CAE}";
        //            return RedirectToAction(nameof(Detalle), new { id = id });
        //        }
        //        else
        //        {
        //            TempData["Error"] = $"Error al generar factura: {string.Join(", ", resultado.Errores)}";
        //            return RedirectToAction(nameof(Generar), new { id = id });
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        _logger.LogError(ex, $"Error al generar factura para venta {id}");
        //        TempData["Error"] = $"Error al generar factura: {ex.Message}";
        //        return RedirectToAction(nameof(Generar), new { id = id });
        //    }
        //}

        // GET: Facturas/Detalle/5
        public async Task<IActionResult> Detalle(int id)
        {
            var venta = await _context.Ventas
                .Include(v => v.Cliente)
                    .ThenInclude(c => c.TipoDocumento)
                .Include(v => v.Cliente)
                    .ThenInclude(c => c.CondicionIVA)
                .Include(v => v.TipoComprobante)
                .Include(v => v.DetalleVentas)
                    .ThenInclude(d => d.Articulo)
                .FirstOrDefaultAsync(v => v.VenCod == id);

            if (venta == null)
            {
                return NotFound();
            }

            // Validar vigencia del CAE y mostrar advertencias
            if (!string.IsNullOrEmpty(venta.VenCAE))
            {
                var validacionCAE = _validacionService.ValidarCAEVigente(venta.VenCAEVencimiento);
                ViewBag.ValidacionCAE = validacionCAE;

                if (!validacionCAE.EstaVigente)
                {
                    TempData["Error"] = validacionCAE.Mensaje;
                }
                else if (validacionCAE.ProximoAVencer)
                {
                    TempData["Warning"] = validacionCAE.Mensaje;
                }
            }

            return View(venta);
        }

        // GET: Facturas/Consultar
        public IActionResult Consultar()
        {
            return View();
        }

        // POST: Facturas/Consultar
        [HttpPost]
        public async Task<IActionResult> ConsultarFactura(int tipoComprobante, int puntoVenta, long numeroComprobante)
        {
            try
            {
                var resultado = await _arcaService.ConsultarFactura(tipoComprobante, puntoVenta, numeroComprobante);

                if (resultado.Success)
                {
                    ViewBag.Resultado = resultado;
                    TempData["Success"] = "Consulta realizada correctamente";
                }
                else
                {
                    TempData["Error"] = $"Error al consultar: {string.Join(", ", resultado.Errores)}";
                }

                return View("Consultar");
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al consultar factura en AFIP");
                TempData["Error"] = $"Error: {ex.Message}";
                return View("Consultar");
            }
        }

        // GET: Facturas/ObtenerUltimoNumero
        [HttpGet]
        public async Task<JsonResult> ObtenerUltimoNumero(int tipoComprobante, int puntoVenta)
        {
            try
            {
                var ultimoNumero = await _arcaService.ObtenerUltimoNumeroComprobante(tipoComprobante, puntoVenta);
                return Json(new { success = true, ultimoNumero = ultimoNumero });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al obtener último número de comprobante");
                return Json(new { success = false, message = ex.Message });
            }
        }

        // GET: Facturas/DescargarPDF/5
        public async Task<IActionResult> DescargarPDF(int id)
        {
            try
            {
                var pdfBytes = await _pdfService.GenerarPDFFacturaAsync(id);

                var venta = await _context.Ventas
                    .Include(v => v.TipoComprobante)
                    .FirstOrDefaultAsync(v => v.VenCod == id);

                var fileName = $"Factura_{venta?.VenPuntoVenta:D4}_{venta?.VenNumComprobante:D8}.pdf";

                return File(pdfBytes, "application/pdf", fileName);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Error al generar PDF de factura {id}");
                TempData["Error"] = $"Error al generar PDF: {ex.Message}";
                return RedirectToAction(nameof(Detalle), new { id = id });
            }
        }

        // GET: Facturas/NotaCredito/5
        public async Task<IActionResult> NotaCredito(int id)
        {
            var factura = await _context.Ventas
                .Include(v => v.Cliente)
                .Include(v => v.TipoComprobante)
                .Include(v => v.DetalleVentas)
                    .ThenInclude(d => d.Articulo)
                .FirstOrDefaultAsync(v => v.VenCod == id);

            if (factura == null)
            {
                return NotFound();
            }

            if (string.IsNullOrEmpty(factura.VenCAE))
            {
                TempData["Error"] = "Solo se pueden anular facturas con CAE autorizado";
                return RedirectToAction(nameof(Detalle), new { id = id });
            }

            return View(factura);
        }

        // POST: Facturas/GenerarNotaCredito/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> GenerarNotaCredito(int id, string motivo)
        {
            try
            {
                var facturaOriginal = await _context.Ventas
                    .Include(v => v.Cliente)
                    .Include(v => v.DetalleVentas)
                    .FirstOrDefaultAsync(v => v.VenCod == id);

                if (facturaOriginal == null)
                {
                    return NotFound();
                }

                // Crear nueva venta como Nota de Crédito
                var notaCredito = new Models.Venta
                {
                    VenFech = DateTime.UtcNow,
                    CliCod = facturaOriginal.CliCod,
                    VenTotal = -facturaOriginal.VenTotal, // Monto negativo
                    VenEstado = facturaOriginal.VenEstado,
                    VenMetodoPago = facturaOriginal.VenMetodoPago,
                    // Tipo de comprobante según el original:
                    // Si era Factura A (1) → Nota Crédito A (3)
                    // Si era Factura B (6) → Nota Crédito B (8)
                    // Si era Factura C (11) → Nota Crédito C (13)
                    VenTipoCbte = facturaOriginal.VenTipoCbte switch
                    {
                        1 => 3,   // FC A → NC A
                        6 => 8,   // FC B → NC B
                        11 => 13, // FC C → NC C
                        _ => null
                    },
                    VenPuntoVenta = facturaOriginal.VenPuntoVenta
                };

                _context.Ventas.Add(notaCredito);
                await _context.SaveChangesAsync();

                // Copiar detalles con cantidades negativas
                foreach (var detalle in facturaOriginal.DetalleVentas ?? Enumerable.Empty<Models.DetalleVenta>())
                {
                    var detalleNC = new Models.DetalleVenta
                    {
                        VenCod = notaCredito.VenCod,
                        ArtCod = detalle.ArtCod,
                        DetCant = -detalle.DetCant,
                        DetPrecio = detalle.DetPrecio,
                        DetSubtotal = -detalle.DetSubtotal
                    };
                    _context.DetalleVentas.Add(detalleNC);
                }

                await _context.SaveChangesAsync();

                // Generar en AFIP
                var resultado = await _arcaService.GenerarFacturaElectronica(notaCredito.VenCod);

                if (resultado.Success)
                {
                    TempData["Success"] = $"Nota de Crédito generada correctamente. CAE: {resultado.CAE}";
                    return RedirectToAction(nameof(Detalle), new { id = notaCredito.VenCod });
                }
                else
                {
                    TempData["Error"] = $"Error al generar Nota de Crédito en AFIP: {string.Join(", ", resultado.Errores)}";
                    return RedirectToAction(nameof(NotaCredito), new { id = id });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Error al generar Nota de Crédito para factura {id}");
                TempData["Error"] = $"Error: {ex.Message}";
                return RedirectToAction(nameof(NotaCredito), new { id = id });
            }
        }
    }
}
