using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using comara.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Mvc.Rendering;
using comara.Models;
using comara.Models.ViewModels;
using System.Text.Json;
using comara.Services.AFIP;
using comara.Services.Logging;
using comara.Services.PDF;
using comara.Services;
using comara.Models.AFIP;

namespace comara.Controllers
{
    [Authorize]
    public class VentasController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly IAfipFacturacionService _afipService;
        private readonly IAfipLogService _afipLogService;
        private readonly IPresupuestoPDFService _presupuestoPDFService;
        private readonly IFacturaValidacionService _validacionService;
        private readonly ILogger<VentasController> _logger;

        public VentasController(
            ApplicationDbContext context,
            IAfipFacturacionService afipService,
            IAfipLogService afipLogService,
            IPresupuestoPDFService presupuestoPDFService,
            IFacturaValidacionService validacionService,
            ILogger<VentasController> logger)
        {
            _context = context;
            _afipService = afipService;
            _afipLogService = afipLogService;
            _presupuestoPDFService = presupuestoPDFService;
            _validacionService = validacionService;
            _logger = logger;
        }

        public async Task<IActionResult> Index(
            int page = 1,
            int pageSize = 20,
            string? searchTerm = null,
            int? estadoFilter = null,
            int? estadoPagoFilter = null,
            DateTime? fechaDesde = null,
            DateTime? fechaHasta = null)
        {
            // Punto 26: Proyectar solo campos necesarios para dropdowns
            ViewBag.Estados = await _context.VentaTipoEstados
                .OrderBy(e => e.Id)
                .ToListAsync();

            ViewBag.EstadosPago = await _context.VentaEstadoPagos
                .OrderBy(e => e.Id)
                .ToListAsync();

            // Punto 26: Para clientes, cargar solo Id y Nombre (no toda la entidad)
            ViewBag.Clientes = await _context.Clientes
                .OrderBy(c => c.CliNombre)
                .Select(c => new { c.Id, c.CliNombre })
                .ToListAsync();

            // Construir query base con filtros
            var query = _context.Ventas
                .Include(v => v.Cliente)
                .Include(v => v.TipoEstado)
                .Include(v => v.TipoComprobante)
                .Include(v => v.EstadoPago)
                .AsQueryable();

            // Aplicar filtros
            if (!string.IsNullOrWhiteSpace(searchTerm))
            {
                searchTerm = searchTerm.Trim().ToLower();
                query = query.Where(v =>
                    (v.Cliente != null && v.Cliente.CliNombre.ToLower().Contains(searchTerm)) ||
                    v.VenCod.ToString().Contains(searchTerm) ||
                    (v.VenCAE != null && v.VenCAE.Contains(searchTerm)));
            }

            if (estadoFilter.HasValue)
            {
                query = query.Where(v => v.VenEstado == estadoFilter.Value);
            }

            if (estadoPagoFilter.HasValue)
            {
                query = query.Where(v => v.VenEstadoPago == estadoPagoFilter.Value);
            }

            if (fechaDesde.HasValue)
            {
                query = query.Where(v => v.VenFech >= fechaDesde.Value);
            }

            if (fechaHasta.HasValue)
            {
                var fechaHastaInclusive = fechaHasta.Value.AddDays(1);
                query = query.Where(v => v.VenFech < fechaHastaInclusive);
            }

            // Contar total de items
            var totalItems = await query.CountAsync();
            var totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            // Validar página actual
            if (page < 1) page = 1;
            if (page > totalPages && totalPages > 0) page = totalPages;

            // Aplicar paginación
            var ventas = await query
                .OrderByDescending(v => v.VenCod)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            // Pasar información de paginación a la vista
            ViewBag.CurrentPage = page;
            ViewBag.PageSize = pageSize;
            ViewBag.TotalPages = totalPages;
            ViewBag.TotalItems = totalItems;
            ViewBag.SearchTerm = searchTerm;
            ViewBag.EstadoFilter = estadoFilter;
            ViewBag.EstadoPagoFilter = estadoPagoFilter;
            ViewBag.FechaDesde = fechaDesde?.ToString("yyyy-MM-dd");
            ViewBag.FechaHasta = fechaHasta?.ToString("yyyy-MM-dd");

            return View(ventas);
        }

        // API: Ventas/Filter
        [HttpGet]
        public async Task<IActionResult> Filter(DateTime? fechaDesde, DateTime? fechaHasta, int? estadoId, int? clienteId)
        {
            var query = _context.Ventas
                .Include(v => v.Cliente)
                .Include(v => v.TipoEstado)
                .Include(v => v.TipoMetodoPago)
                .AsQueryable();

            if (fechaDesde.HasValue)
            {
                query = query.Where(v => v.VenFech >= fechaDesde.Value);
            }

            if (fechaHasta.HasValue)
            {
                // Agregar un día para incluir todo el día de la fecha hasta
                var fechaHastaInclusive = fechaHasta.Value.AddDays(1);
                query = query.Where(v => v.VenFech < fechaHastaInclusive);
            }

            if (estadoId.HasValue && estadoId.Value > 0)
            {
                query = query.Where(v => v.VenEstado == estadoId.Value);
            }

            if (clienteId.HasValue && clienteId.Value > 0)
            {
                query = query.Where(v => v.CliCod == clienteId.Value);
            }

            var ventas = await query
                .OrderByDescending(v => v.VenCod)
                .Select(v => new
                {
                    v.VenCod,
                    VenFech = v.VenFech.ToString("dd/MM/yyyy"),
                    ClienteNombre = v.Cliente != null ? v.Cliente.CliNombre : "Sin cliente",
                    v.VenTotal,
                    EstadoDescripcion = v.TipoEstado != null ? v.TipoEstado.Descripcion : "Sin estado",
                    v.VenEstado,
                    v.VenCAE,
                    v.VenEstadoPago,
                    TipoComprobante = v.TipoComprobante != null ? v.TipoComprobante.Descripcion : null
                })
                .ToListAsync();

            return Json(new { ventas });
        }

        // GET: Ventas/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var venta = await _context.Ventas
                .Include(v => v.Cliente)
                .Include(v => v.TipoEstado)
                .Include(v => v.TipoMetodoPago)
                .Include(v => v.TipoComprobante)
                .Include(v => v.Lista)
                .Include(v => v.EstadoPago)
                .Include(v => v.Pagos)
                    .ThenInclude(p => p.TipoMetodoPago)
                .Include(v => v.DetalleVentas)
                    .ThenInclude(d => d.Articulo)
                        .ThenInclude(a => a.Marca)
                .FirstOrDefaultAsync(m => m.VenCod == id);

            if (venta == null)
            {
                return NotFound();
            }

            return View(venta);
        }

        //// GET: Ventas/Create
        //public async Task<IActionResult> Create()
        //{
        //    ViewData["CliCod"] = new SelectList(await _context.Clientes.ToListAsync(), "Id", "CliNombre");
        //    ViewData["Listas"] = new SelectList(await _context.Listas.Where(l => l.ListStatus).ToListAsync(), "ListCode", "ListDesc");
        //    ViewData["VenEstado"] = new SelectList(await _context.VentaTipoEstados.ToListAsync(), "Id", "Descripcion");
        //    ViewData["VenMetodoPago"] = new SelectList(await _context.VentaTipoMetodoPagos.ToListAsync(), "Id", "Descripcion");

        //    // Cargar tipos de comprobante (opcional en creación - solo facturas, no notas de crédito)
        //    // C8: Usar CodigoAfip como valor para consistencia con AFIP
        //    ViewData["TiposComprobante"] = new SelectList(
        //        await _context.TipoComprobantes
        //            .Where(tc => tc.CodigoAfip <= 11) // Solo facturas (1, 6, 11), excluir NC (3, 8, 13)
        //            .OrderBy(tc => tc.CodigoAfip)
        //            .ToListAsync(),
        //        "CodigoAfip",
        //        "Descripcion");

        //    return View(new VentaViewModel());
        //}

        // GET: Ventas/Create
        public async Task<IActionResult> Create(int? cotizacionId)
        {
            var model = new VentaViewModel
            {
                Items = new List<VentaItemViewModel>() // <-- Corregido: Usamos Items y VentaItemViewModel
            };

            // 1. Si venimos de una cotización, cargamos los datos
            if (cotizacionId.HasValue)
            {
                var cotizacion = await _context.Cotizaciones
                    .Include(c => c.DetalleCotizaciones)
                        .ThenInclude(d => d.Articulo)
                    .FirstOrDefaultAsync(c => c.CotCod == cotizacionId.Value);

                if (cotizacion != null)
                {
                    model.CliCod = cotizacion.CliCod;
                    model.ListaCod = cotizacion.ListaCod;

                    // Pasamos los artículos al modelo de la vista
                    foreach (var det in cotizacion.DetalleCotizaciones)
                    {
                        model.Items.Add(new VentaItemViewModel
                        {
                            ArtCod = det.ArtCod,
                            ArtDesc = det.Articulo?.ArtDesc,
                            ArtCodigoStr = det.Articulo?.ArtCod, // (Asegúrate de que coincida con tu modelo Articulo, si pide string y es int, agrégale .ToString() al final)
                            Cantidad = det.DetCant,              // <-- Corregido
                            Precio = det.DetPrecio,              // <-- Corregido
                            Subtotal = det.DetSubtotal           // <-- Corregido (aprovechamos que tu modelo ya lo calcula)
                        });
                    }

                    // Mensaje opcional para la vista
                    TempData["InfoPrecarga"] = $"Cargando datos de Cotización #{cotizacion.CotCod}";
                }
            }

            // ... (Aquí dejas tus ViewData de SelectLists tal cual los tenías) ...

            // 2. Cargamos los SelectLists (usamos model.CliCod y model.ListaCod para que aparezcan seleccionados)
            ViewData["CliCod"] = new SelectList(await _context.Clientes.ToListAsync(), "Id", "CliNombre", model.CliCod);
            ViewData["Listas"] = new SelectList(await _context.Listas.Where(l => l.ListStatus).ToListAsync(), "ListCode", "ListDesc", model.ListaCod);
            ViewData["VenEstado"] = new SelectList(await _context.VentaTipoEstados.ToListAsync(), "Id", "Descripcion");
            ViewData["VenMetodoPago"] = new SelectList(await _context.VentaTipoMetodoPagos.ToListAsync(), "Id", "Descripcion");

            ViewData["TiposComprobante"] = new SelectList(
                await _context.TipoComprobantes
                    .Where(tc => tc.CodigoAfip <= 11)
                    .OrderBy(tc => tc.CodigoAfip)
                    .ToListAsync(),
                "CodigoAfip",
                "Descripcion");

            return View(model);
        }

        // POST: Ventas/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(VentaViewModel model, string itemsJson)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    // Punto 18: Validación segura de deserialización JSON
                    List<VentaItemViewModel>? items;
                    try
                    {
                        items = JsonSerializer.Deserialize<List<VentaItemViewModel>>(itemsJson ?? "[]");
                    }
                    catch (JsonException ex)
                    {
                        _logger.LogWarning(ex, "Error al deserializar JSON de items de venta");
                        ModelState.AddModelError("", "Los datos de los artículos son inválidos");
                        await CargarViewDataVenta(model);
                        return View(model);
                    }

                    if (items == null || items.Count == 0)
                    {
                        ModelState.AddModelError("", "Debe agregar al menos un artículo a la venta");
                        await CargarViewDataVenta(model);
                        return View(model);
                    }

                    // Punto 18: Validar cada item deserializado
                    foreach (var item in items)
                    {
                        if (item.ArtCod <= 0)
                        {
                            ModelState.AddModelError("", "Código de artículo inválido");
                            await CargarViewDataVenta(model);
                            return View(model);
                        }
                        if (item.Cantidad <= 0)
                        {
                            ModelState.AddModelError("", "La cantidad debe ser mayor a 0");
                            await CargarViewDataVenta(model);
                            return View(model);
                        }
                        if (item.Precio < 0)
                        {
                            ModelState.AddModelError("", "El precio no puede ser negativo");
                            await CargarViewDataVenta(model);
                            return View(model);
                        }
                        if (item.Subtotal < 0)
                        {
                            ModelState.AddModelError("", "El subtotal no puede ser negativo");
                            await CargarViewDataVenta(model);
                            return View(model);
                        }
                    }

                    // Restaurar items en el modelo para que estén disponibles si se devuelve la vista por error
                    model.Items = items;

                    // Punto 16: La verificación de stock se hace DENTRO de la transacción
                    // con lock FOR UPDATE para prevenir race conditions

                    // Validar tipo de comprobante si se especificó
                    if (model.VenTipoCbte.HasValue && model.VenTipoCbte.Value > 0)
                    {
                        var cliente = await _context.Clientes
                            .Include(c => c.CondicionIVA)
                            .FirstOrDefaultAsync(c => c.Id == model.CliCod);

                        if (cliente?.CondicionIVA == null)
                        {
                            ModelState.AddModelError("", "El cliente debe tener una Condición de IVA configurada para asignar un tipo de comprobante.");
                            await CargarViewDataVenta(model);
                            return View(model);
                        }

                        // C8: Buscar por CodigoAfip, no por Id
                        var tipoComprobante = await _context.TipoComprobantes
                            .FirstOrDefaultAsync(tc => tc.CodigoAfip == model.VenTipoCbte.Value);
                        if (tipoComprobante != null)
                        {
                            var validacion = _validacionService.ValidarTipoComprobanteCliente(
                                tipoComprobante.CodigoAfip,
                                cliente.CondicionIVA.CodigoAfip);

                            if (!validacion.EsValido)
                            {
                                ModelState.AddModelError("", validacion.MensajeError);
                                await CargarViewDataVenta(model);
                                return View(model);
                            }

                            // Agregar advertencias como mensajes informativos
                            foreach (var advertencia in validacion.Advertencias)
                            {
                                TempData["Warning"] = advertencia;
                            }
                        }
                    }

                    // Usar transaccion para garantizar atomicidad y prevenir race conditions
                    using var transaction = await _context.Database.BeginTransactionAsync();
                    try
                    {
                        // Punto 16: TODA la verificación de stock se hace dentro de la transacción
                        // con lock FOR UPDATE para prevenir race conditions

                        // Primero adquirir locks y verificar stock de TODOS los artículos
                        var articulosConLock = new Dictionary<int, Articulo>();
                        bool hayNuevoStockCritico = false;

                        foreach (var item in items)
                        {
                            // Adquirir lock con FOR UPDATE
                            var articulo = await _context.Articulos
                                .FromSqlRaw("SELECT * FROM \"ARTICULOS\" WHERE \"id\" = {0} FOR UPDATE", item.ArtCod)
                                .FirstOrDefaultAsync();

                            if (articulo == null)
                            {
                                throw new InvalidOperationException($"Artículo con código {item.ArtCod} no encontrado");
                            }

                            // Verificar stock con el lock adquirido
                            if ((articulo.ArtStock ?? 0) < item.Cantidad)
                            {
                                throw new InvalidOperationException(
                                    $"Stock insuficiente para {articulo.ArtDesc}. " +
                                    $"Disponible: {articulo.ArtStock ?? 0}, Solicitado: {item.Cantidad}");
                            }

                            articulosConLock[item.ArtCod] = articulo;
                        }

                        // Crear venta (pedido)
                        // Punto 24: Usar método utilitario para conversión a UTC mediodía
                        var fechaUtc = ToUtcNoon(model.VenFech);

                        var venta = new Venta
                        {
                            VenFech = fechaUtc,
                            CliCod = model.CliCod,
                            // Punto 23: Usar constantes en lugar de números mágicos
                            VenEstado = VentaEstado.Pendiente,
                            VenTipoCbte = model.VenTipoCbte,
                            VenMetodoPago = model.VenMetodoPago,
                            VenLista = model.ListaCod,
                            VenTotal = items.Sum(i => i.Subtotal)
                        };

                        _context.Ventas.Add(venta);

                        // Agregar detalles y actualizar stock (ya tenemos los locks)
                        foreach (var item in items)
                        {
                            var detalle = new DetalleVenta
                            {
                                Venta = venta,
                                ArtCod = item.ArtCod,
                                DetCant = item.Cantidad,
                                DetPrecio = item.Precio,
                                DetCostoUnitario = item.CostoUnitario,
                                DetCostoTotal = item.CostoTotal,
                                DetSubtotal = item.Subtotal
                            };
                            venta.DetalleVentas.Add(detalle);

                            // Actualizar stock del artículo (ya tenemos el lock)
                            var articulo = articulosConLock[item.ArtCod];
                            articulo.ArtStock = (articulo.ArtStock ?? 0) - item.Cantidad;
                            _context.Entry(articulo).State = EntityState.Modified;

                            // Verificar si el artículo quedó en stock crítico
                            if (articulo.ArtStock <= articulo.ArtStockMin)
                            {
                                hayNuevoStockCritico = true;
                            }
                        }

                        // Guardar venta + detalles + stock para obtener VenCod real
                        await _context.SaveChangesAsync();

                        // Si la venta es en cuenta corriente, registrar en CUENTAS_CORRIENTES
                        if (model.VenMetodoPago == MetodoPago.CuentaCorriente)
                        {
                            // Usar FOR UPDATE para evitar race conditions
                            decimal saldoAnterior = await GetSaldoCuentaCorrienteConLockAsync(model.CliCod);
                            decimal nuevoSaldo = saldoAnterior + venta.VenTotal;

                            var cuentaCorriente = new CuentaCorriente
                            {
                                CliCod = model.CliCod,
                                CctaFech = fechaUtc,
                                CctaMovimiento = MovimientoTipo.Debe,
                                CctaMonto = venta.VenTotal,
                                CctaSaldo = nuevoSaldo,
                                CctaDesc = $"Venta #{venta.VenCod}"
                            };

                            _context.CuentasCorrientes.Add(cuentaCorriente);
                            await _context.SaveChangesAsync();
                        }

                        await transaction.CommitAsync();

                        // Si hay nuevo stock crítico, resetear la notificación
                        if (hayNuevoStockCritico)
                        {
                            // Punto 28: Usar constante SessionKeys en lugar de string mágico
                            HttpContext.Session.Remove(SessionKeys.StockCriticoViewed);
                        }
                        return RedirectToAction(nameof(Index));
                    }
                    catch (InvalidOperationException ex)
                    {
                        await transaction.RollbackAsync();
                        ModelState.AddModelError("", ex.Message);
                        await CargarViewDataVenta(model);
                        return View(model);
                    }
                }
                catch (Exception ex)
                {
                    // Punto 21: Loggear excepción completa internamente, mensaje genérico al usuario
                    _logger.LogError(ex, "Error al crear venta para cliente {ClienteId}", model.CliCod);
                    ModelState.AddModelError("", "Error al crear la venta. Por favor, intente nuevamente.");
                }
            }

            await CargarViewDataVenta(model);
            return View(model);
        }

        // GET: Ventas/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var venta = await _context.Ventas
                .Include(v => v.DetalleVentas)
                    .ThenInclude(d => d.Articulo)
                .FirstOrDefaultAsync(v => v.VenCod == id);

            if (venta == null)
            {
                return NotFound();
            }

            // Solo permitir edición si el estado es Pendiente
            // Punto 23: Usar constante VentaEstado.Pendiente
            if (venta.VenEstado != VentaEstado.Pendiente)
            {
                TempData["Error"] = "Solo se pueden editar ventas en estado Pendiente";
                return RedirectToAction(nameof(Details), new { id = venta.VenCod });
            }

            var viewModel = new VentaViewModel
            {
                VenCod = venta.VenCod,
                VenFech = venta.VenFech,
                CliCod = venta.CliCod,
                VenEstado = venta.VenEstado,
                VenTipoCbte = venta.VenTipoCbte,
                VenMetodoPago = venta.VenMetodoPago,
                ListaCod = venta.VenLista,
                Items = venta.DetalleVentas.Select(d => new VentaItemViewModel
                {
                    DetCod = d.DetCod,
                    ArtCod = d.ArtCod,
                    Cantidad = d.DetCant,
                    Precio = d.DetPrecio,
                    Subtotal = d.DetSubtotal,
                    ArtCodigoStr = d.Articulo?.ArtCod,
                    ArtDesc = d.Articulo?.ArtDesc,
                    ArtStock = d.Articulo?.ArtStock
                }).ToList()
            };

            ViewData["CliCod"] = new SelectList(await _context.Clientes.ToListAsync(), "Id", "CliNombre", venta.CliCod);
            ViewData["Listas"] = new SelectList(await _context.Listas.Where(l => l.ListStatus).ToListAsync(), "ListCode", "ListDesc", venta.VenLista);
            ViewData["VenEstado"] = new SelectList(await _context.VentaTipoEstados.ToListAsync(), "Id", "Descripcion", venta.VenEstado);
            ViewData["VenMetodoPago"] = new SelectList(await _context.VentaTipoMetodoPagos.ToListAsync(), "Id", "Descripcion", venta.VenMetodoPago);
            ViewData["TiposComprobante"] = new SelectList(
                await _context.TipoComprobantes.Where(tc => tc.CodigoAfip <= 11).OrderBy(tc => tc.CodigoAfip).ToListAsync(),
                "CodigoAfip", "Descripcion", venta.VenTipoCbte);
            return View(viewModel);
        }

        // POST: Ventas/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, VentaViewModel model, string itemsJson)
        {
            if (id != model.VenCod)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    // Punto 18: Validación segura de deserialización JSON
                    List<VentaItemViewModel>? items;
                    try
                    {
                        items = JsonSerializer.Deserialize<List<VentaItemViewModel>>(itemsJson ?? "[]");
                    }
                    catch (JsonException ex)
                    {
                        _logger.LogWarning(ex, "Error al deserializar JSON de items en edición de venta {VentaId}", id);
                        ModelState.AddModelError("", "Los datos de los artículos son inválidos");
                        await CargarViewDataVenta(model);
                        return View(model);
                    }

                    if (items == null || items.Count == 0)
                    {
                        ModelState.AddModelError("", "Debe agregar al menos un artículo a la venta");
                        await CargarViewDataVenta(model);
                        return View(model);
                    }

                    // Restaurar items en el modelo para que estén disponibles si se devuelve la vista por error
                    model.Items = items;

                    // Punto 18: Validar cada item deserializado
                    foreach (var item in items)
                    {
                        if (item.ArtCod <= 0)
                        {
                            ModelState.AddModelError("", "Código de artículo inválido");
                            await CargarViewDataVenta(model);
                            return View(model);
                        }
                        if (item.Cantidad <= 0)
                        {
                            ModelState.AddModelError("", "La cantidad debe ser mayor a 0");
                            await CargarViewDataVenta(model);
                            return View(model);
                        }
                        if (item.Precio < 0)
                        {
                            ModelState.AddModelError("", "El precio no puede ser negativo");
                            await CargarViewDataVenta(model);
                            return View(model);
                        }
                        if (item.Subtotal < 0)
                        {
                            ModelState.AddModelError("", "El subtotal no puede ser negativo");
                            await CargarViewDataVenta(model);
                            return View(model);
                        }
                    }

                    var venta = await _context.Ventas
                        .Include(v => v.DetalleVentas)
                        .FirstOrDefaultAsync(v => v.VenCod == id);

                    if (venta == null)
                    {
                        return NotFound();
                    }

                    // Verificar que el estado siga siendo Pendiente
                    // Punto 23: Usar constante VentaEstado.Pendiente
                    if (venta.VenEstado != VentaEstado.Pendiente)
                    {
                        TempData["Error"] = "Solo se pueden editar ventas en estado Pendiente";
                        return RedirectToAction(nameof(Details), new { id = venta.VenCod });
                    }

                    // Guardar valores anteriores para comparar cambios en CC
                    var metodoPagoAnterior = venta.VenMetodoPago;
                    var totalAnterior = venta.VenTotal;

                    // Usar transaccion para garantizar atomicidad
                    using var transaction = await _context.Database.BeginTransactionAsync();
                    try
                    {
                        // Restaurar stock de items anteriores con bloqueo
                        foreach (var detalle in venta.DetalleVentas)
                        {
                            var articulo = await _context.Articulos
                                .FromSqlRaw("SELECT * FROM \"ARTICULOS\" WHERE \"id\" = {0} FOR UPDATE", detalle.ArtCod)
                                .FirstOrDefaultAsync();
                            if (articulo != null)
                            {
                                articulo.ArtStock = (articulo.ArtStock ?? 0) + detalle.DetCant;
                                _context.Entry(articulo).State = EntityState.Modified;
                            }
                        }

                        // Actualizar venta
                        var fechaUtcEdit = new DateTime(model.VenFech.Year, model.VenFech.Month, model.VenFech.Day, 12, 0, 0, DateTimeKind.Utc);
                        venta.VenFech = fechaUtcEdit;
                        venta.CliCod = model.CliCod;
                        venta.VenEstado = model.VenEstado;
                        venta.VenTipoCbte = model.VenTipoCbte;
                        venta.VenMetodoPago = model.VenMetodoPago;
                        venta.VenLista = model.ListaCod;
                        venta.VenTotal = items.Sum(i => i.Subtotal);

                        // Manejar cambios en cuenta corriente
                        var eraCuentaCorriente = metodoPagoAnterior == MetodoPago.CuentaCorriente;
                        var esCuentaCorriente = model.VenMetodoPago == MetodoPago.CuentaCorriente;

                        if (eraCuentaCorriente && !esCuentaCorriente)
                        {
                            // Cambió DE cuenta corriente a otro método: revertir el DEBE anterior
                            // Usar FOR UPDATE para evitar race conditions
                            decimal saldoAnterior = await GetSaldoCuentaCorrienteConLockAsync(venta.CliCod);

                            _context.CuentasCorrientes.Add(new CuentaCorriente
                            {
                                CliCod = venta.CliCod,
                                CctaFech = fechaUtcEdit,
                                CctaMovimiento = MovimientoTipo.Haber,
                                CctaMonto = totalAnterior,
                                CctaSaldo = saldoAnterior - totalAnterior,
                                CctaDesc = $"Anulación CC Venta #{venta.VenCod} (cambio método pago)"
                            });
                        }
                        else if (!eraCuentaCorriente && esCuentaCorriente)
                        {
                            // Cambió a cuenta corriente: crear nuevo DEBE
                            // Usar FOR UPDATE para evitar race conditions
                            decimal saldoAnterior = await GetSaldoCuentaCorrienteConLockAsync(model.CliCod);

                            _context.CuentasCorrientes.Add(new CuentaCorriente
                            {
                                CliCod = model.CliCod,
                                CctaFech = fechaUtcEdit,
                                CctaMovimiento = MovimientoTipo.Debe,
                                CctaMonto = venta.VenTotal,
                                CctaSaldo = saldoAnterior + venta.VenTotal,
                                CctaDesc = $"Venta #{venta.VenCod}"
                            });
                        }
                        else if (eraCuentaCorriente && esCuentaCorriente && totalAnterior != venta.VenTotal)
                        {
                            // Sigue siendo CC pero cambió el total: ajustar diferencia
                            var diferencia = venta.VenTotal - totalAnterior;
                            // Usar FOR UPDATE para evitar race conditions
                            decimal saldoAnterior = await GetSaldoCuentaCorrienteConLockAsync(venta.CliCod);

                            _context.CuentasCorrientes.Add(new CuentaCorriente
                            {
                                CliCod = venta.CliCod,
                                CctaFech = fechaUtcEdit,
                                CctaMovimiento = diferencia > 0 ? MovimientoTipo.Debe : MovimientoTipo.Haber,
                                CctaMonto = Math.Abs(diferencia),
                                CctaSaldo = saldoAnterior + diferencia,
                                CctaDesc = $"Ajuste Venta #{venta.VenCod} (edición)"
                            });
                        }

                        // Eliminar detalles antiguos
                        _context.DetalleVentas.RemoveRange(venta.DetalleVentas);

                        // Agregar nuevos detalles y descontar stock
                        bool hayNuevoStockCritico = false;
                        foreach (var item in items)
                        {
                            var detalle = new DetalleVenta
                            {
                                VenCod = venta.VenCod,
                                ArtCod = item.ArtCod,
                                DetCant = item.Cantidad,
                                DetPrecio = item.Precio,
                                DetSubtotal = item.Subtotal,
                            };
                            _context.DetalleVentas.Add(detalle);

                            // Actualizar stock con bloqueo de fila
                            var articulo = await _context.Articulos
                                .FromSqlRaw("SELECT * FROM \"ARTICULOS\" WHERE \"id\" = {0} FOR UPDATE", item.ArtCod)
                                .FirstOrDefaultAsync();

                            if (articulo != null)
                            {
                                // Re-verificar stock
                                if ((articulo.ArtStock ?? 0) < item.Cantidad)
                                {
                                    throw new InvalidOperationException(
                                        $"Stock insuficiente para {articulo.ArtDesc}. " +
                                        $"Disponible: {articulo.ArtStock ?? 0}, Solicitado: {item.Cantidad}");
                                }

                                articulo.ArtStock = (articulo.ArtStock ?? 0) - item.Cantidad;
                                _context.Entry(articulo).State = EntityState.Modified;

                                // Verificar si el artículo quedó en stock crítico
                                if (articulo.ArtStock <= articulo.ArtStockMin)
                                {
                                    hayNuevoStockCritico = true;
                                }
                            }
                        }

                        await _context.SaveChangesAsync();
                        await transaction.CommitAsync();

                        // Si hay nuevo stock crítico, resetear la notificación
                        if (hayNuevoStockCritico)
                        {
                            // Punto 28: Usar constante SessionKeys en lugar de string mágico
                            HttpContext.Session.Remove(SessionKeys.StockCriticoViewed);
                        }
                        return RedirectToAction(nameof(Index));
                    }
                    catch (InvalidOperationException ex)
                    {
                        await transaction.RollbackAsync();
                        ModelState.AddModelError("", ex.Message);
                        await CargarViewDataVenta(model);
                        return View(model);
                    }
                }
                catch (DbUpdateConcurrencyException ex)
                {
                    _logger.LogError(ex, "Error de concurrencia al editar venta {VentaId}", model.VenCod);
                    if (!VentaExists(model.VenCod))
                    {
                        return NotFound();
                    }
                    else
                    {
                        ModelState.AddModelError("", "La venta fue modificada por otro usuario. Por favor, recargue e intente nuevamente.");
                    }
                }
            }

            await CargarViewDataVenta(model);
            return View(model);
        }

        // GET: Ventas/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var venta = await _context.Ventas
                .Include(v => v.Cliente)
                .Include(v => v.TipoEstado)
                .Include(v => v.TipoMetodoPago)
                .Include(v => v.TipoComprobante)
                .Include(v => v.Lista)
                .Include(v => v.DetalleVentas)
                    .ThenInclude(d => d.Articulo)
                .FirstOrDefaultAsync(m => m.VenCod == id);

            if (venta == null)
            {
                return NotFound();
            }

            return View(venta);
        }

        // POST: Ventas/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            // Usar transaccion para garantizar atomicidad
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                var venta = await _context.Ventas
                    .Include(v => v.DetalleVentas)
                    .FirstOrDefaultAsync(v => v.VenCod == id);

                if (venta != null)
                {
                    // Restaurar stock con bloqueo
                    foreach (var detalle in venta.DetalleVentas)
                    {
                        var articulo = await _context.Articulos
                            .FromSqlRaw("SELECT * FROM \"ARTICULOS\" WHERE \"id\" = {0} FOR UPDATE", detalle.ArtCod)
                            .FirstOrDefaultAsync();
                        if (articulo != null)
                        {
                            articulo.ArtStock = (articulo.ArtStock ?? 0) + detalle.DetCant;
                            _context.Entry(articulo).State = EntityState.Modified;
                        }
                    }

                    // Revertir cuenta corriente si la venta era con ese método de pago
                    if (venta.VenMetodoPago == MetodoPago.CuentaCorriente)
                    {
                        // Usar FOR UPDATE para evitar race conditions
                        decimal saldoAnterior = await GetSaldoCuentaCorrienteConLockAsync(venta.CliCod);
                        decimal nuevoSaldo = saldoAnterior - venta.VenTotal;

                        var cuentaCorriente = new CuentaCorriente
                        {
                            CliCod = venta.CliCod,
                            CctaFech = DateTime.UtcNow,
                            CctaMovimiento = MovimientoTipo.Haber,
                            CctaMonto = venta.VenTotal,
                            CctaSaldo = nuevoSaldo,
                            CctaDesc = $"Anulación Venta #{venta.VenCod}"
                        };

                        _context.CuentasCorrientes.Add(cuentaCorriente);
                    }

                    _context.DetalleVentas.RemoveRange(venta.DetalleVentas);
                    _context.Ventas.Remove(venta);
                    await _context.SaveChangesAsync();
                }

                await transaction.CommitAsync();
                return RedirectToAction(nameof(Index));
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync();
                _logger.LogError(ex, "Error al eliminar venta {VentaId}", id);
                TempData["Error"] = "Error al eliminar la venta: " + ex.Message;
                return RedirectToAction(nameof(Index));
            }
        }

        // API endpoint para obtener precio del artículo según lista
        [HttpGet]
        public async Task<JsonResult> GetArticuloPrecio(int artCod, int? listaCod)
        {
            // Cargar artículo con sus relaciones para calcular costos
            var articulo = await _context.Articulos
                .Include(a => a.Proveedor)
                .Include(a => a.Iva)
                .FirstOrDefaultAsync(a => a.Id == artCod);

            if (articulo == null)
            {
                return Json(new { success = false, message = "Artículo no encontrado" });
            }

            // El precio base es el CostoFinal (con descuento de proveedor e IVA)
            decimal precioBase = articulo.CostoFinal;

            // Aplicar lista de precios al costo final
            if (listaCod.HasValue)
            {
                var lista = await _context.Listas.FindAsync(listaCod.Value);
                if (lista != null)
                {
                    precioBase = articulo.CalcularPrecioVenta(lista.ListPercent);
                }
            }

            // Punto 30: Validar que el precio calculado sea válido
            if (precioBase <= 0)
            {
                _logger.LogWarning(
                    "Precio calculado inválido para artículo {ArtCod} con lista {ListaCod}: {Precio}",
                    artCod, listaCod, precioBase);
                return Json(new
                {
                    success = false,
                    message = "El precio calculado es inválido. Verifique el costo del artículo y la lista de precios."
                });
            }

            return Json(new
            {
                success = true,
                precio = (float)precioBase,
                descripcion = articulo.ArtDesc,
                stock = articulo.ArtStock ?? 0,
                costoNeto = (float)(articulo.ArtCost ?? 0),
                costoConDescuento = (float)articulo.CostoConDescuento,
                costoFinal = (float)articulo.CostoFinal
            });
        }

        // API endpoint para buscar artículos con paginación
        [HttpGet]
        public async Task<JsonResult> BuscarArticulos(string term, int page = 1, int pageSize = 10)
        {
            // Punto 22: Validar null en propiedades string antes de ILike
            if (string.IsNullOrWhiteSpace(term))
            {
                return Json(new { items = new List<object>(), total = 0, page = 1, pageSize, totalPages = 0 });
            }

            int? idBusqueda = int.TryParse(term.Trim(), out int parsedId) ? parsedId : (int?)null;

            var query = _context.Articulos
                .Include(a => a.Marca)
                .Where(a => (idBusqueda.HasValue && a.Id == idBusqueda.Value) ||
                            (a.ArtDesc != null && EF.Functions.ILike(a.ArtDesc, $"{term}%")) ||
                            (a.ArtDesc != null && EF.Functions.ILike(a.ArtDesc, $"%{term}%")) ||
                            (a.Marca != null && a.Marca.marNombre != null && EF.Functions.ILike(a.Marca.marNombre, $"%{term}%")));

            var total = await query.CountAsync();
            var totalPages = (int)Math.Ceiling(total / (double)pageSize);

            var articulos = await query
                .OrderBy(a => a.ArtDesc)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .Select(a => new
                {
                    id = a.Id,
                    text = $"#{a.Id} - {a.ArtDesc}",
                    codigo = a.Id.ToString(),
                    descripcion = a.ArtDesc,
                    stock = a.ArtStock ?? 0,
                    marca = a.Marca != null ? a.Marca.marNombre : "Sin marca",
                    costo = a.ArtCost ?? 0
                })
                .ToListAsync();

            return Json(new { items = articulos, total, page, pageSize, totalPages });
        }

        // ==================== MÉTODOS DE INTEGRACIÓN AFIP ====================

        /// <summary>
        /// API: Obtiene el último número de comprobante autorizado por AFIP
        /// GET: /Ventas/ObtenerUltimoNumeroAfip?tipoComprobante=6&puntoVenta=1
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> ObtenerUltimoNumeroAfip(int tipoComprobante, int puntoVenta)
        {
            try
            {
                _logger.LogInformation("Consultando último comprobante AFIP - Tipo: {Tipo}, PtoVta: {PtoVta}",
                    tipoComprobante, puntoVenta);

                var ultimoNumero = await _afipService.ObtenerUltimoComprobanteAsync(tipoComprobante, puntoVenta);

                return Json(new
                {
                    success = true,
                    ultimoNumero = ultimoNumero,
                    proximoNumero = ultimoNumero + 1
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al obtener último número de comprobante AFIP");
                return Json(new
                {
                    success = false,
                    error = ex.Message
                });
            }
        }

        /// <summary>
        /// API: Autoriza una venta con AFIP (obtiene CAE)
        /// GET/POST: /Ventas/AutorizarConAfip/5
        /// </summary>
        [HttpGet]
        [HttpPost]
        public async Task<IActionResult> AutorizarConAfip(int id)
        {
            try
            {
                // Cargar la venta con todas sus relaciones
                var venta = await _context.Ventas
                    .Include(v => v.Cliente)
                        .ThenInclude(c => c.TipoDocumento)
                    .Include(v => v.Cliente)
                        .ThenInclude(c => c.CondicionIVA)
                    .Include(v => v.TipoComprobante)
                    .Include(v => v.DetalleVentas)
                        .ThenInclude(d => d.Articulo)
                            .ThenInclude(a => a.Iva)
                    .FirstOrDefaultAsync(v => v.VenCod == id);

                _logger.LogDebug("Venta cargada - Cliente: {ClienteNombre}, CondIVA ID: {CondIVAId}, CondIVA Codigo: {CodigoAfip}",
                    venta?.Cliente?.CliNombre,
                    venta?.Cliente?.CliCondicionIVA,
                    venta?.Cliente?.CondicionIVA?.CodigoAfip);

                if (venta == null)
                {
                    return Json(new { success = false, error = "Venta no encontrada" });
                }

                // Verificar que no esté ya facturada
                if (!string.IsNullOrEmpty(venta.VenCAE))
                {
                    return Json(new
                    {
                        success = false,
                        error = "Esta venta ya tiene CAE asignado",
                        cae = venta.VenCAE
                    });
                }

                // Verificar que tenga cliente
                if (venta.Cliente == null)
                {
                    return Json(new { success = false, error = "La venta debe tener un cliente asignado" });
                }

                if (venta.Cliente.CliTipoDoc == null || string.IsNullOrEmpty(venta.Cliente.CliNumDoc))
                {
                    return Json(new
                    {
                        success = false,
                        error = "El cliente debe tener Tipo y Número de Documento configurados. Por favor, edite el cliente primero."
                    });
                }

                if (venta.Cliente.CliCondicionIVA == null)
                {
                    return Json(new
                    {
                        success = false,
                        error = "El cliente debe tener Condición de IVA configurada. Por favor, edite el cliente primero."
                    });
                }

                // Validar datos completos del cliente con el servicio de validación
                var validacionCliente = _validacionService.ValidarDatosCliente(venta.Cliente);
                if (!validacionCliente.EsValido)
                {
                    return Json(new { success = false, error = validacionCliente.MensajeError });
                }

                // Verificar que tenga tipo de comprobante
                if (venta.VenTipoCbte == null || venta.VenTipoCbte == 0)
                {
                    return Json(new
                    {
                        success = false,
                        error = "Debe especificar el tipo de comprobante antes de facturar. Use el formulario de Generar Factura."
                    });
                }

                // Punto 20: Verificar null explícitamente antes de acceder a propiedades de navegación
                if (venta.TipoComprobante == null)
                {
                    return Json(new
                    {
                        success = false,
                        error = "No se pudo cargar el tipo de comprobante. Por favor, intente nuevamente."
                    });
                }

                if (venta.Cliente.CondicionIVA == null)
                {
                    return Json(new
                    {
                        success = false,
                        error = "No se pudo cargar la condición de IVA del cliente. Por favor, verifique la configuración del cliente."
                    });
                }

                // Validar compatibilidad tipo comprobante con condición IVA
                var validacionComprobante = _validacionService.ValidarTipoComprobanteCliente(
                    venta.TipoComprobante.CodigoAfip,
                    venta.Cliente.CondicionIVA.CodigoAfip);

                if (!validacionComprobante.EsValido)
                {
                    return Json(new
                    {
                        success = false,
                        error = validacionComprobante.MensajeError,
                        tipoSugerido = validacionComprobante.TipoComprobanteSugerido
                    });
                }

                // Validar artículos de la venta
                var validacionArticulos = _validacionService.ValidarArticulosVenta(venta.DetalleVentas.ToList());

                // Recopilar todas las advertencias
                var advertencias = new List<string>();
                advertencias.AddRange(validacionCliente.Advertencias);
                advertencias.AddRange(validacionComprobante.Advertencias);
                advertencias.AddRange(validacionArticulos.Advertencias);

                // Verificar que tenga punto de venta
                if (venta.VenPuntoVenta == null || venta.VenPuntoVenta == 0)
                {
                    venta.VenPuntoVenta = 1; // Usar punto de venta por defecto
                    await _context.SaveChangesAsync();
                }

                // C9: Obtener el número de comprobante pero NO guardarlo hasta que AFIP autorice
                // Esto evita números "perdidos" cuando AFIP rechaza
                long numeroComprobanteAUsar;

                if (string.IsNullOrEmpty(venta.VenCAE))
                {
                    _logger.LogInformation("Venta sin CAE, consultando último número de comprobante a AFIP...");
                    // USAR CODIGO AFIP, NO ID LOCAL
                    var codigoAfipComprobante = venta.TipoComprobante?.CodigoAfip ?? 6;
                    var ultimoNumero = await _afipService.ObtenerUltimoComprobanteAsync(
                        codigoAfipComprobante,
                        venta.VenPuntoVenta ?? 1
                    );
                    numeroComprobanteAUsar = ultimoNumero + 1;
                    _logger.LogInformation("AFIP respondió: último comprobante = {UltimoNumero}, siguiente a usar = {Siguiente}",
                        ultimoNumero, numeroComprobanteAUsar);

                    // NO guardamos el número todavía - lo haremos solo si AFIP autoriza
                }
                else
                {
                    _logger.LogInformation("Venta ya autorizada con CAE: {CAE}, número: {NumeroComprobante}",
                        venta.VenCAE, venta.VenNumComprobante);
                    numeroComprobanteAUsar = venta.VenNumComprobante ?? 0;
                }

                // Calcular totales por alícuota de IVA
                var itemsIVA = venta.DetalleVentas
                    .Where(d => d.Articulo != null && d.Articulo.Iva != null)
                    .GroupBy(d => d.Articulo.Iva!.Id)
                    .Select(g => new FacturaIVAItem
                    {
                        CodigoIVA = g.Key, // El Id del IVA debería coincidir con el código AFIP (3=0%, 4=10.5%, 5=21%, 6=27%)
                        BaseImponible = g.Sum(d => (decimal)d.DetSubtotal / (1 + g.First().Articulo!.Iva!.Porcentaje / 100)),
                        Importe = g.Sum(d => (decimal)d.DetSubtotal - ((decimal)d.DetSubtotal / (1 + g.First().Articulo!.Iva!.Porcentaje / 100)))
                    })
                    .ToList();

                // Punto 29: Validar configuración de IVA contra condición del cliente
                if (!itemsIVA.Any())
                {
                    // Determinar el código IVA apropiado según la condición del cliente
                    var condicionCliente = venta.Cliente.CondicionIVA?.CodigoAfip ?? CondicionIvaAfip.ConsumidorFinal;
                    int codigoIvaDefault;

                    if (condicionCliente == CondicionIvaAfip.Exento)
                    {
                        codigoIvaDefault = CodigoIvaAfip.Exento; // Cliente exento
                    }
                    else if (condicionCliente == CondicionIvaAfip.ConsumidorFinal)
                    {
                        codigoIvaDefault = CodigoIvaAfip.NoGravado; // Consumidor final sin IVA discriminado
                    }
                    else
                    {
                        // Responsable Inscripto o Monotributista sin items IVA es sospechoso
                        _logger.LogWarning(
                            "Venta {VentaId} sin items con IVA configurado para cliente {ClienteId} con condición {CondicionIVA}",
                            venta.VenCod, venta.CliCod, condicionCliente);
                        codigoIvaDefault = CodigoIvaAfip.NoGravado;
                    }

                    itemsIVA.Add(new FacturaIVAItem
                    {
                        CodigoIVA = codigoIvaDefault,
                        BaseImponible = (decimal)venta.VenTotal,
                        Importe = 0
                    });
                }

                // Construir request para AFIP
                // IMPORTANTE: Usar el código AFIP de la condición IVA, no el ID de la tabla
                int condicionIVAReceptor = venta.Cliente?.CondicionIVA?.CodigoAfip ?? 5; // Default: Consumidor Final

                var request = new FacturaRequest
                {
                    TipoComprobante = venta.TipoComprobante?.CodigoAfip ?? 6, // Default: Factura B - USAR CODIGO AFIP
                    PuntoVenta = venta.VenPuntoVenta ?? 1,
                    NumeroComprobante = numeroComprobanteAUsar, // C9: Usar el número calculado, no el guardado
                    Fecha = venta.VenFech,
                    TipoDocCliente = venta.Cliente.TipoDocumento?.CodigoAfip ?? 99, // 99 = Sin identificar - USAR CODIGO AFIP
                    NumeroDocCliente = long.TryParse(venta.Cliente.CliNumDoc, out var docNum) ? docNum : 0,
                    CondicionIVAReceptor = condicionIVAReceptor, // IMPORTANTE: Usar código AFIP
                    Concepto = "Productos", // Puede ser "Productos", "Servicios" o "Productos y Servicios"
                    ImporteTotal = (decimal)venta.VenTotal,
                    ImporteNeto = itemsIVA.Sum(i => i.BaseImponible),
                    ImporteIVA = itemsIVA.Sum(i => i.Importe),
                    ImporteExento = 0,
                    ImporteTributos = 0,
                    MonedaCotizacion = 1, // Pesos argentinos
                    ItemsIVA = itemsIVA
                };

                // Llamar a AFIP
                _logger.LogInformation("Autorizando comprobante con AFIP - Venta: {VentaId}, Tipo: {Tipo}, Nro: {Numero}",
                    venta.VenCod, venta.VenTipoCbte, numeroComprobanteAUsar);

                var response = await _afipService.AutorizarComprobanteAsync(request);

                // Registrar el log de AFIP
                await _afipLogService.RegistrarLogAsync(new AfipLog
                {
                    VenCod = venta.VenCod,
                    TipoOperacion = "FECAESolic", // Truncado a 10 caracteres para BD
                    Fecha = DateTime.UtcNow,
                    Request = JsonSerializer.Serialize(request),
                    Response = JsonSerializer.Serialize(response),
                    Exitoso = response.Success,
                    CAE = response.CAE,
                    MensajeError = response.Success ? null : string.Join("; ", response.Errores)
                });

                if (response.Success)
                {
                    // C9: Solo ahora guardamos el número de comprobante (después de autorización exitosa)
                    venta.VenCAE = response.CAE;
                    venta.VenCAEVencimiento = response.CAEVencimiento;
                    // Usar el número de la respuesta si viene, sino usar el que calculamos
                    venta.VenNumComprobante = response.NumeroComprobante > 0
                        ? response.NumeroComprobante
                        : numeroComprobanteAUsar;
                    venta.VenFechaAutorizacion = DateTime.UtcNow;
                    venta.VenFechVenta = DateTime.UtcNow; // Registrar fecha de venta/facturación
                    venta.VenResultadoAfip = "A"; // A=Aprobado
                    venta.VenObservacionesAfip = response.Observaciones != null && response.Observaciones.Any()
                        ? string.Join("; ", response.Observaciones)
                        : null;
                    // Punto 23: Usar constante VentaEstado.Facturada
                    venta.VenEstado = VentaEstado.Facturada;

                    await _context.SaveChangesAsync();

                    _logger.LogInformation("CAE obtenido exitosamente - Venta: {VentaId}, CAE: {CAE}, Nro: {Numero}",
                        venta.VenCod, response.CAE, venta.VenNumComprobante);

                    return Json(new
                    {
                        success = true,
                        cae = response.CAE,
                        caeVencimiento = response.CAEVencimiento?.ToString("dd/MM/yyyy"),
                        numeroComprobante = response.NumeroComprobante,
                        observaciones = response.Observaciones,
                        advertencias = advertencias, // Advertencias de validación
                        mensaje = "Comprobante autorizado exitosamente por AFIP"
                    });
                }
                else
                {
                    // C9: NO guardamos el número de comprobante si AFIP rechazó
                    // Solo guardamos el resultado del intento para diagnóstico
                    venta.VenFechaAutorizacion = DateTime.UtcNow;
                    venta.VenResultadoAfip = "R"; // R=Rechazado
                    venta.VenObservacionesAfip = string.Join("; ", response.Errores);
                    // NO asignamos VenNumComprobante - el número queda disponible para el próximo intento
                    await _context.SaveChangesAsync();

                    _logger.LogWarning("Error al autorizar con AFIP - Venta: {VentaId}, Nro intentado: {NumeroIntentado}, Errores: {Errores}",
                        venta.VenCod, numeroComprobanteAUsar, string.Join("; ", response.Errores));

                    return Json(new
                    {
                        success = false,
                        error = "AFIP rechazó el comprobante",
                        errores = response.Errores,
                        observaciones = response.Observaciones
                    });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al autorizar venta {VentaId} con AFIP", id);

                // Registrar el error en el log
                await _afipLogService.RegistrarLogAsync(new AfipLog
                {
                    VenCod = id,
                    TipoOperacion = "FECAESolic", // Truncado a 10 caracteres para BD
                    Fecha = DateTime.UtcNow,
                    Request = $"VentaId: {id}",
                    Response = ex.Message,
                    Exitoso = false,
                    MensajeError = $"Error: {ex.Message}"
                });

                return Json(new
                {
                    success = false,
                    error = $"Error al comunicarse con AFIP: {ex.Message}"
                });
            }
        }

        /// <summary>
        /// API: Consulta un comprobante ya autorizado en AFIP
        /// GET: /Ventas/ConsultarComprobanteAfip?tipoComprobante=6&puntoVenta=1&numeroComprobante=123
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> ConsultarComprobanteAfip(int tipoComprobante, int puntoVenta, long numeroComprobante)
        {
            try
            {
                _logger.LogInformation("Consultando comprobante en AFIP - Tipo: {Tipo}, PtoVta: {PtoVta}, Nro: {Nro}",
                    tipoComprobante, puntoVenta, numeroComprobante);

                var response = await _afipService.ConsultarComprobanteAsync(tipoComprobante, puntoVenta, numeroComprobante);

                if (response.Success)
                {
                    return Json(new
                    {
                        success = true,
                        cae = response.CAE,
                        caeVencimiento = response.CAEVencimiento?.ToString("dd/MM/yyyy"),
                        numeroComprobante = response.NumeroComprobante,
                        resultado = response.Resultado
                    });
                }
                else
                {
                    return Json(new
                    {
                        success = false,
                        error = "No se pudo consultar el comprobante",
                        errores = response.Errores
                    });
                }
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al consultar comprobante en AFIP");
                return Json(new
                {
                    success = false,
                    error = ex.Message
                });
            }
        }

        /// <summary>
        /// API: Test de conexión con AFIP
        /// GET: /Ventas/TestConexionAfip
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> TestConexionAfip()
        {
            try
            {
                // Intentar obtener el último comprobante para verificar conectividad
                var ultimoNumero = await _afipService.ObtenerUltimoComprobanteAsync(6, 1); // Factura B, Punto de Venta 1

                return Json(new
                {
                    success = true,
                    mensaje = "Conexión exitosa con AFIP",
                    ultimoNumero = ultimoNumero,
                    ambiente = "Homologación"
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al probar conexión con AFIP");
                return Json(new
                {
                    success = false,
                    error = $"Error de conexión: {ex.Message}"
                });
            }
        }

        // ==================== FIN MÉTODOS AFIP ====================

        // ==================== MÉTODOS DE PRESUPUESTO ====================

        /// <summary>
        /// GET: Ventas/Presupuesto/5
        /// Muestra el formulario para seleccionar método de pago y generar presupuesto
        /// </summary>
        public async Task<IActionResult> Presupuesto(int id)
        {
            var venta = await _context.Ventas
                .Include(v => v.Cliente)
                .Include(v => v.TipoEstado)
                .Include(v => v.DetalleVentas)
                    .ThenInclude(d => d.Articulo)
                .FirstOrDefaultAsync(v => v.VenCod == id);

            if (venta == null)
            {
                return NotFound();
            }

            // Verificar que la venta esté en estado Pendiente
            // Punto 23: Usar constante VentaEstado.Pendiente
            if (venta.VenEstado != VentaEstado.Pendiente)
            {
                TempData["Error"] = "Solo se pueden generar presupuestos para ventas en estado Pendiente";
                return RedirectToAction(nameof(Details), new { id = venta.VenCod });
            }

            var viewModel = new GenerarPresupuestoViewModel
            {
                VenCod = id,
                Venta = venta
            };

            // Cargar métodos de pago (excluir Cuenta Corriente=3 si es necesario)
            ViewData["MetodosPago"] = new SelectList(
                await _context.VentaTipoMetodoPagos.ToListAsync(),
                "Id",
                "Descripcion"
            );

            return View(viewModel);
        }

        /// <summary>
        /// POST: Ventas/Presupuesto
        /// Procesa la generación del presupuesto con el método de pago seleccionado
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Presupuesto(GenerarPresupuestoViewModel model)
        {
            if (!ModelState.IsValid)
            {
                var venta = await _context.Ventas
                    .Include(v => v.Cliente)
                    .Include(v => v.TipoEstado)
                    .Include(v => v.DetalleVentas)
                        .ThenInclude(d => d.Articulo)
                    .FirstOrDefaultAsync(v => v.VenCod == model.VenCod);

                model.Venta = venta;
                ViewData["MetodosPago"] = new SelectList(
                    await _context.VentaTipoMetodoPagos.ToListAsync(),
                    "Id",
                    "Descripcion",
                    model.MetodoPago
                );
                return View(model);
            }

            try
            {
                var venta = await _context.Ventas
                    .Include(v => v.Cliente)
                    .Include(v => v.DetalleVentas)
                    .FirstOrDefaultAsync(v => v.VenCod == model.VenCod);

                if (venta == null)
                {
                    return NotFound();
                }

                // Verificar que la venta esté en estado Pendiente
                // Punto 23: Usar constante VentaEstado.Pendiente
                if (venta.VenEstado != VentaEstado.Pendiente)
                {
                    TempData["Error"] = "Solo se pueden generar presupuestos para ventas en estado Pendiente";
                    return RedirectToAction(nameof(Details), new { id = venta.VenCod });
                }

                // Actualizar la venta
                venta.VenMetodoPago = model.MetodoPago;
                venta.VenFechVenta = DateTime.UtcNow;
                // Punto 23: Usar constante VentaEstado.Completada
                venta.VenEstado = VentaEstado.Completada;

                await _context.SaveChangesAsync();

                var metodoPago = await _context.VentaTipoMetodoPagos.FindAsync(model.MetodoPago);

                _logger.LogInformation("Presupuesto generado para venta {VentaId} con método de pago {MetodoPago}",
                    venta.VenCod, metodoPago?.Descripcion);

                TempData["Success"] = $"Presupuesto generado exitosamente. Método de pago: {metodoPago?.Descripcion}";

                // Redirigir a la página de confirmación
                return RedirectToAction(nameof(PresupuestoGenerado), new { id = venta.VenCod });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al generar presupuesto para venta {VentaId}", model.VenCod);
                TempData["Error"] = $"Error al generar presupuesto: {ex.Message}";

                var venta = await _context.Ventas
                    .Include(v => v.Cliente)
                    .Include(v => v.TipoEstado)
                    .Include(v => v.DetalleVentas)
                        .ThenInclude(d => d.Articulo)
                    .FirstOrDefaultAsync(v => v.VenCod == model.VenCod);

                model.Venta = venta;
                ViewData["MetodosPago"] = new SelectList(
                    await _context.VentaTipoMetodoPagos.ToListAsync(),
                    "Id",
                    "Descripcion",
                    model.MetodoPago
                );
                return View(model);
            }
        }

        /// <summary>
        /// GET: Ventas/PresupuestoGenerado/5
        /// Muestra la página de confirmación después de generar el presupuesto
        /// </summary>
        public async Task<IActionResult> PresupuestoGenerado(int id)
        {
            var venta = await _context.Ventas
                .Include(v => v.Cliente)
                .FirstOrDefaultAsync(v => v.VenCod == id);

            if (venta == null)
            {
                return NotFound();
            }

            return View(venta);
        }

        /// <summary>
        /// GET: Ventas/DescargarPresupuestoPDF/5
        /// Descarga el PDF del presupuesto
        /// </summary>
        public async Task<IActionResult> DescargarPresupuestoPDF(int id)
        {
            try
            {
                var venta = await _context.Ventas.FindAsync(id);
                if (venta == null)
                {
                    return NotFound();
                }

                var pdfBytes = await _presupuestoPDFService.GenerarPDFPresupuestoAsync(id);
                var fileName = $"Presupuesto_{id}_{DateTime.Now:yyyyMMdd}.pdf";

                return File(pdfBytes, "application/pdf", fileName);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al generar PDF de presupuesto para venta {VentaId}", id);
                TempData["Error"] = $"Error al generar PDF: {ex.Message}";
                return RedirectToAction(nameof(Details), new { id = id });
            }
        }

        // ==================== FIN MÉTODOS PRESUPUESTO ====================

        // ==================== MÉTODOS DE REGISTRO DE PAGO ====================

        /// <summary>
        /// Obtiene los métodos de pago disponibles según la forma de pago configurada del cliente.
        /// CliFormaPago: 1=Solo Cuenta Corriente, 2=Solo Efectivo/otros, 3=Ambos, null=Todos
        /// </summary>
        private async Task<List<VentaTipoMetodoPago>> ObtenerMetodosPagoDisponibles(int? clienteFormaPago)
        {
            var todosMetodos = await _context.VentaTipoMetodoPagos.ToListAsync();

            if (clienteFormaPago == null || clienteFormaPago == 3)
            {
                // Ambos o sin configurar: todos los métodos disponibles
                return todosMetodos;
            }
            else if (clienteFormaPago == 1)
            {
                // Solo Cuenta Corriente (id=3)
                return todosMetodos.Where(m => m.Id == 3).ToList();
            }
            else if (clienteFormaPago == 2)
            {
                // Efectivo y otros (excluir Cuenta Corriente id=3)
                return todosMetodos.Where(m => m.Id != 3).ToList();
            }

            return todosMetodos;
        }

        /// <summary>
        /// GET: Ventas/RegistrarPagoFactura/5
        /// Muestra el formulario para registrar pago de una factura
        /// </summary>
        public async Task<IActionResult> RegistrarPagoFactura(int id)
        {
            var venta = await _context.Ventas
                .Include(v => v.Cliente)
                    .ThenInclude(c => c!.TipoFormaPago)
                .Include(v => v.TipoComprobante)
                .Include(v => v.EstadoPago)
                .Include(v => v.Pagos)
                    .ThenInclude(p => p.TipoMetodoPago)
                .FirstOrDefaultAsync(v => v.VenCod == id);

            if (venta == null)
            {
                return NotFound();
            }

            // Verificar que la venta esté facturada (tenga CAE)
            if (string.IsNullOrEmpty(venta.VenCAE))
            {
                TempData["Error"] = "Solo se pueden registrar pagos para facturas autorizadas por AFIP";
                return RedirectToAction(nameof(Details), new { id = venta.VenCod });
            }

            // Verificar que no esté completamente pagada
            var totalPagado = venta.Pagos?.Sum(p => p.PagMonto) ?? 0;
            if (totalPagado >= venta.VenTotal)
            {
                TempData["Warning"] = "Esta factura ya está completamente pagada";
                return RedirectToAction(nameof(Details), new { id = venta.VenCod });
            }

            // Obtener métodos de pago disponibles según el cliente
            var metodosPago = await ObtenerMetodosPagoDisponibles(venta.Cliente?.CliFormaPago);

            var viewModel = new RegistrarPagoFacturaViewModel
            {
                VenCod = venta.VenCod,
                NumeroFactura = $"{venta.VenPuntoVenta:D4}-{venta.VenNumComprobante:D8}",
                FechaFactura = venta.VenFechaAutorizacion ?? venta.VenFech,
                ClienteNombre = venta.Cliente?.CliNombre ?? "Sin cliente",
                ClienteId = venta.CliCod,
                TipoComprobante = venta.TipoComprobante?.Descripcion,
                TotalFactura = venta.VenTotal,
                TotalPagado = totalPagado,
                EstadoPagoActual = venta.VenEstadoPago,
                EstadoPagoDescripcion = venta.EstadoPago?.Descripcion ?? "Pendiente",
                MontoPago = venta.VenTotal - totalPagado, // Por defecto el saldo pendiente
                FechaPago = DateTime.Now,
                ClienteFormaPago = venta.Cliente?.CliFormaPago,
                ClienteFormaPagoDescripcion = venta.Cliente?.TipoFormaPago?.Descripcion,
                MetodosPagoDisponibles = metodosPago,
                PagosRealizados = venta.Pagos?.Select(p => new PagoRegistrado
                {
                    PagCod = p.PagCod,
                    Fecha = p.PagFech,
                    Monto = p.PagMonto,
                    MetodoPago = p.TipoMetodoPago?.Descripcion,
                    Descripcion = p.PagDesc
                }).ToList() ?? new List<PagoRegistrado>()
            };

            return View(viewModel);
        }

        /// <summary>
        /// POST: Ventas/RegistrarPagoFactura
        /// Procesa el registro de pago de una factura
        /// </summary>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> RegistrarPagoFactura(RegistrarPagoFacturaViewModel model)
        {
            var venta = await _context.Ventas
                .Include(v => v.Cliente)
                    .ThenInclude(c => c!.TipoFormaPago)
                .Include(v => v.TipoComprobante)
                .Include(v => v.EstadoPago)
                .Include(v => v.Pagos)
                    .ThenInclude(p => p.TipoMetodoPago)
                .FirstOrDefaultAsync(v => v.VenCod == model.VenCod);

            if (venta == null)
            {
                return NotFound();
            }

            // Recalcular total pagado
            var totalPagadoAnterior = venta.Pagos?.Sum(p => p.PagMonto) ?? 0;
            var saldoPendiente = venta.VenTotal - totalPagadoAnterior;

            // Punto 31: Usar tolerancia basada en porcentaje (el mayor entre 0.1% y 1 centavo)
            var tolerancia = ValidacionPago.CalcularTolerancia(saldoPendiente);
            if (model.MontoPago > saldoPendiente + tolerancia)
            {
                ModelState.AddModelError("MontoPago", $"El monto no puede exceder el saldo pendiente de ${saldoPendiente:N2}");
            }

            // Punto 32: Validación completa de cheque
            // Punto 23: Usar constante MetodoPago.Cheque
            if (model.MetodoPago == MetodoPago.Cheque)
            {
                // Validaciones básicas requeridas
                if (string.IsNullOrWhiteSpace(model.ChequeNumero))
                {
                    ModelState.AddModelError("ChequeNumero", "El número de cheque es requerido");
                }
                else
                {
                    // Validar formato del número de cheque (solo numérico, longitud apropiada)
                    var numeroLimpio = model.ChequeNumero.Trim();
                    if (!numeroLimpio.All(char.IsDigit))
                    {
                        ModelState.AddModelError("ChequeNumero", "El número de cheque debe contener solo dígitos");
                    }
                    else if (numeroLimpio.Length < ValidacionCheque.LongitudMinimaNumero ||
                             numeroLimpio.Length > ValidacionCheque.LongitudMaximaNumero)
                    {
                        ModelState.AddModelError("ChequeNumero",
                            $"El número de cheque debe tener entre {ValidacionCheque.LongitudMinimaNumero} y {ValidacionCheque.LongitudMaximaNumero} dígitos");
                    }
                    else
                    {
                        // Verificar cheques duplicados del mismo banco
                        var chequeDuplicado = await _context.Cheques
                            .AnyAsync(c => c.ChqNumero == numeroLimpio &&
                                          c.ChqBanco == model.ChequeBanco);
                        if (chequeDuplicado)
                        {
                            ModelState.AddModelError("ChequeNumero",
                                $"Ya existe un cheque registrado con número {numeroLimpio} del banco {model.ChequeBanco}");
                        }
                    }
                }

                if (string.IsNullOrWhiteSpace(model.ChequeBanco))
                    ModelState.AddModelError("ChequeBanco", "El banco es requerido");

                if (!model.ChequeFechaCobro.HasValue)
                {
                    ModelState.AddModelError("ChequeFechaCobro", "La fecha de cobro es requerida");
                }
                else
                {
                    // Validar que fecha de cobro no sea muy lejana
                    var fechaMaxima = DateTime.Now.AddDays(ValidacionCheque.DiasMaximosAdelante);
                    if (model.ChequeFechaCobro.Value > fechaMaxima)
                    {
                        ModelState.AddModelError("ChequeFechaCobro",
                            $"La fecha de cobro no puede ser mayor a {ValidacionCheque.DiasMaximosAdelante} días en el futuro");
                    }
                }

                // Validar fecha de emisión si se proporciona
                if (model.ChequeFechaEmision.HasValue)
                {
                    var fechaMinima = DateTime.Now.AddDays(-ValidacionCheque.DiasMaximosAtras);
                    if (model.ChequeFechaEmision.Value < fechaMinima)
                    {
                        ModelState.AddModelError("ChequeFechaEmision",
                            $"La fecha de emisión no puede ser mayor a {ValidacionCheque.DiasMaximosAtras} días en el pasado");
                    }

                    if (model.ChequeFechaCobro.HasValue &&
                        model.ChequeFechaEmision.Value > model.ChequeFechaCobro.Value)
                    {
                        ModelState.AddModelError("ChequeFechaEmision",
                            "La fecha de emisión no puede ser posterior a la fecha de cobro");
                    }
                }

                if (string.IsNullOrWhiteSpace(model.ChequeLibrador))
                    ModelState.AddModelError("ChequeLibrador", "El librador es requerido");
            }

            if (!ModelState.IsValid)
            {
                // Recargar datos del viewmodel
                var metodosPago = await ObtenerMetodosPagoDisponibles(venta.Cliente?.CliFormaPago);
                model.NumeroFactura = $"{venta.VenPuntoVenta:D4}-{venta.VenNumComprobante:D8}";
                model.FechaFactura = venta.VenFechaAutorizacion ?? venta.VenFech;
                model.ClienteNombre = venta.Cliente?.CliNombre ?? "Sin cliente";
                model.TipoComprobante = venta.TipoComprobante?.Descripcion;
                model.TotalFactura = venta.VenTotal;
                model.TotalPagado = totalPagadoAnterior;
                model.EstadoPagoActual = venta.VenEstadoPago;
                model.EstadoPagoDescripcion = venta.EstadoPago?.Descripcion ?? "Pendiente";
                model.ClienteFormaPago = venta.Cliente?.CliFormaPago;
                model.ClienteFormaPagoDescripcion = venta.Cliente?.TipoFormaPago?.Descripcion;
                model.MetodosPagoDisponibles = metodosPago;
                model.PagosRealizados = venta.Pagos?.Select(p => new PagoRegistrado
                {
                    PagCod = p.PagCod,
                    Fecha = p.PagFech,
                    Monto = p.PagMonto,
                    MetodoPago = p.TipoMetodoPago?.Descripcion,
                    Descripcion = p.PagDesc
                }).ToList() ?? new List<PagoRegistrado>();

                return View(model);
            }

            // Usar transacción para atomicidad y poder usar FOR UPDATE
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                var fechaUtc = DateTime.SpecifyKind(model.FechaPago, DateTimeKind.Utc);

                // Crear el pago
                var pago = new Pago
                {
                    CliCod = venta.CliCod,
                    VenCod = venta.VenCod,
                    PagFech = fechaUtc,
                    PagMonto = model.MontoPago,
                    PagMetodoPago = model.MetodoPago,
                    PagDesc = model.Descripcion ?? $"Pago Factura {model.NumeroFactura}"
                };

                _context.Pagos.Add(pago);
                await _context.SaveChangesAsync();

                // Si es Cuenta Corriente, registrar en CUENTAS_CORRIENTES como HABER
                // Punto 23: Usar constante MetodoPago.CuentaCorriente
                if (model.MetodoPago == MetodoPago.CuentaCorriente)
                {
                    // Usar FOR UPDATE para evitar race conditions
                    decimal saldoAnterior = await GetSaldoCuentaCorrienteConLockAsync(venta.CliCod);
                    decimal nuevoSaldo = saldoAnterior - model.MontoPago; // Restar porque es un pago (haber)

                    var cuentaCorriente = new CuentaCorriente
                    {
                        CliCod = venta.CliCod,
                        CctaFech = fechaUtc,
                        // Punto 23: Usar constante MovimientoTipo.Haber
                        CctaMovimiento = MovimientoTipo.Haber,
                        CctaMonto = model.MontoPago,
                        CctaSaldo = nuevoSaldo,
                        CctaDesc = $"Pago Factura #{venta.VenCod} - {model.NumeroFactura}"
                    };

                    _context.CuentasCorrientes.Add(cuentaCorriente);
                    await _context.SaveChangesAsync(); // Guardar primero para obtener el ID

                    // Ahora actualizar el pago con el ID de cuenta corriente generado
                    pago.CctaCod = cuentaCorriente.CctaCod;
                    await _context.SaveChangesAsync();
                }
                else
                {
                    // Registrar en MOVIMIENTOS_CAJA
                    var movimiento = new MovimientoCaja
                    {
                        MovFecha = fechaUtc,
                        // Punto 23: Usar constante TipoMovimientoCajaConstantes.Ingreso
                        MovTipo = TipoMovimientoCajaConstantes.Ingreso,
                        MovMetodoPago = model.MetodoPago,
                        MovMonto = model.MontoPago,
                        MovDescripcion = $"Pago Factura #{venta.VenCod} - {model.NumeroFactura} - {venta.Cliente?.CliNombre}"
                    };

                    // Si es Cheque, crear registro de cheque
                    // Punto 23: Usar constante MetodoPago.Cheque
                    if (model.MetodoPago == MetodoPago.Cheque)
                    {
                        var cheque = new Cheque
                        {
                            PagCod = pago.PagCod,
                            ChqNumero = model.ChequeNumero!,
                            ChqBanco = model.ChequeBanco!,
                            ChqFechaEmision = model.ChequeFechaEmision ?? fechaUtc,
                            ChqFechaCobro = model.ChequeFechaCobro ?? fechaUtc,
                            ChqMonto = model.MontoPago,
                            ChqLibrador = model.ChequeLibrador!,
                            ChqCUIT = model.ChequeCUIT,
                            ChqEnCaja = true,
                            ChqObservaciones = $"Factura #{venta.VenCod}"
                        };

                        _context.Cheques.Add(cheque);
                        await _context.SaveChangesAsync();

                        movimiento.ChqCod = cheque.ChqCod;
                    }

                    _context.MovimientosCaja.Add(movimiento);
                    await _context.SaveChangesAsync();
                }

                // Actualizar estado de pago de la venta
                // Punto 23: Usar constantes VentaEstadoPagoConstantes
                // Punto 31: Usar tolerancia calculada
                var nuevoTotalPagado = totalPagadoAnterior + model.MontoPago;
                var toleranciaPago = ValidacionPago.CalcularTolerancia(venta.VenTotal);
                if (nuevoTotalPagado >= venta.VenTotal - toleranciaPago)
                {
                    venta.VenEstadoPago = VentaEstadoPagoConstantes.Pagada;
                }
                else if (nuevoTotalPagado > 0)
                {
                    venta.VenEstadoPago = VentaEstadoPagoConstantes.Parcial;
                }
                else
                {
                    venta.VenEstadoPago = VentaEstadoPagoConstantes.Pendiente;
                }

                await _context.SaveChangesAsync();

                var metodoPagoNombre = await _context.VentaTipoMetodoPagos
                    .Where(m => m.Id == model.MetodoPago)
                    .Select(m => m.Descripcion)
                    .FirstOrDefaultAsync();

                _logger.LogInformation("Pago registrado para factura {VentaId} - Monto: ${Monto:N2} - Metodo: {Metodo}",
                    venta.VenCod, model.MontoPago, metodoPagoNombre);

                await transaction.CommitAsync();

                TempData["Success"] = $"Pago de ${model.MontoPago:N2} registrado exitosamente ({metodoPagoNombre})";

                // Si queda saldo pendiente, volver a la pantalla de pago
                if (nuevoTotalPagado < venta.VenTotal - toleranciaPago)
                {
                    return RedirectToAction(nameof(RegistrarPagoFactura), new { id = venta.VenCod });
                }

                return RedirectToAction(nameof(Details), new { id = venta.VenCod });
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync();
                _logger.LogError(ex, "Error al registrar pago para factura {VentaId}", model.VenCod);
                ModelState.AddModelError("", $"Error al registrar el pago: {ex.Message}");

                // Recargar viewmodel
                var metodosPago = await ObtenerMetodosPagoDisponibles(venta.Cliente?.CliFormaPago);
                model.MetodosPagoDisponibles = metodosPago;
                model.PagosRealizados = venta.Pagos?.Select(p => new PagoRegistrado
                {
                    PagCod = p.PagCod,
                    Fecha = p.PagFech,
                    Monto = p.PagMonto,
                    MetodoPago = p.TipoMetodoPago?.Descripcion,
                    Descripcion = p.PagDesc
                }).ToList() ?? new List<PagoRegistrado>();

                return View(model);
            }
        }

        // ==================== FIN MÉTODOS REGISTRO DE PAGO ====================

        /// <summary>
        /// API: Obtiene los tipos de comprobante válidos para un cliente según su condición IVA
        /// GET: /Ventas/ObtenerTiposComprobanteCliente?clienteId=5
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> ObtenerTiposComprobanteCliente(int clienteId)
        {
            try
            {
                var cliente = await _context.Clientes
                    .Include(c => c.CondicionIVA)
                    .FirstOrDefaultAsync(c => c.Id == clienteId);

                if (cliente?.CondicionIVA == null)
                {
                    return Json(new
                    {
                        success = false,
                        error = "El cliente no tiene Condición de IVA configurada. Por favor, edite el cliente y asigne una condición."
                    });
                }

                // Obtener tipos válidos según la condición IVA
                var tiposValidos = _validacionService.ObtenerTiposComprobanteValidos(cliente.CondicionIVA.CodigoAfip);
                var tipoSugerido = _validacionService.SugerirTipoComprobante(cliente.CondicionIVA.CodigoAfip);

                // Obtener los tipos de comprobante de la base de datos
                var tiposComprobante = await _context.TipoComprobantes
                    .Where(tc => tiposValidos.Contains(tc.CodigoAfip))
                    .Select(tc => new
                    {
                        id = tc.Id,
                        codigoAfip = tc.CodigoAfip,
                        descripcion = tc.Descripcion,
                        esSugerido = tc.CodigoAfip == tipoSugerido
                    })
                    .ToListAsync();

                return Json(new
                {
                    success = true,
                    tiposComprobante = tiposComprobante,
                    tipoSugerido = tipoSugerido,
                    condicionIVA = cliente.CondicionIVA.Descripcion
                });
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al obtener tipos de comprobante para cliente {ClienteId}", clienteId);
                return Json(new
                {
                    success = false,
                    error = $"Error al obtener tipos de comprobante: {ex.Message}"
                });
            }
        }

        /// <summary>
        /// Método helper para cargar ViewData de ventas (evita código duplicado)
        /// </summary>
        private async Task CargarViewDataVenta(VentaViewModel model)
        {
            ViewData["CliCod"] = new SelectList(await _context.Clientes.ToListAsync(), "Id", "CliNombre", model.CliCod);
            ViewData["Listas"] = new SelectList(await _context.Listas.Where(l => l.ListStatus).ToListAsync(), "ListCode", "ListDesc", model.ListaCod);
            ViewData["VenEstado"] = new SelectList(await _context.VentaTipoEstados.ToListAsync(), "Id", "Descripcion", model.VenEstado);
            ViewData["VenMetodoPago"] = new SelectList(await _context.VentaTipoMetodoPagos.ToListAsync(), "Id", "Descripcion", model.VenMetodoPago);
            ViewData["TiposComprobante"] = new SelectList(
                await _context.TipoComprobantes.Where(tc => tc.CodigoAfip <= 11).OrderBy(tc => tc.CodigoAfip).ToListAsync(),
                "CodigoAfip", "Descripcion", model.VenTipoCbte);
        }

        /// <summary>
        /// Punto 24: Método utilitario para convertir fecha a UTC mediodía.
        /// PostgreSQL usa timestamp with time zone, necesita UTC.
        /// Se usa mediodía (12:00) para evitar cambio de día por zona horaria.
        /// </summary>
        private static DateTime ToUtcNoon(DateTime date) =>
            new DateTime(date.Year, date.Month, date.Day, 12, 0, 0, DateTimeKind.Utc);

        /// <summary>
        /// Obtiene el último saldo de cuenta corriente con lock FOR UPDATE para evitar race conditions.
        /// IMPORTANTE: Solo usar dentro de una transacción activa.
        /// </summary>
        private async Task<decimal> GetSaldoCuentaCorrienteConLockAsync(int clienteId)
        {
            var ultimaCuenta = await _context.CuentasCorrientes
                .FromSqlRaw(
                    "SELECT * FROM \"CUENTAS_CORRIENTES\" WHERE \"cliCod\" = {0} ORDER BY \"cctaCod\" DESC LIMIT 1 FOR UPDATE",
                    clienteId)
                .FirstOrDefaultAsync();

            return ultimaCuenta?.CctaSaldo ?? 0;
        }

        private bool VentaExists(int id)
        {
            return _context.Ventas.Any(e => e.VenCod == id);
        }
    }
}
