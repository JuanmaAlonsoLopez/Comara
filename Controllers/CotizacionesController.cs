using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using comara.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Mvc.Rendering;
using comara.Models;
using comara.Models.ViewModels;
using System.Text.Json;
using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;

namespace comara.Controllers
{
    [Authorize]
    public class CotizacionesController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<CotizacionesController> _logger;

        public CotizacionesController(ApplicationDbContext context, ILogger<CotizacionesController> logger)
        {
            _context = context;
            _logger = logger;
        }

        public async Task<IActionResult> Index(string? searchTerm, int? estadoFilter, int page = 1, int pageSize = 20)
        {
            // Query base
            var query = _context.Cotizaciones
                .Include(c => c.Cliente)
                .Include(c => c.Estado)
                .Include(c => c.DetalleCotizaciones)
                .AsQueryable();

            // Aplicar filtros
            if (!string.IsNullOrEmpty(searchTerm))
            {
                query = query.Where(c => c.Cliente != null &&
                    EF.Functions.ILike(c.Cliente.CliNombre, $"%{searchTerm}%"));
            }

            if (estadoFilter.HasValue)
            {
                query = query.Where(c => c.CotEstadoId == estadoFilter.Value);
            }

            // Ordenar por codigo (cotCod) descendente
            query = query.OrderByDescending(c => c.CotCod);

            // Contar total
            var totalItems = await query.CountAsync();
            var totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            // Asegurar pagina valida
            page = Math.Max(1, Math.Min(page, Math.Max(1, totalPages)));

            // Aplicar paginacion
            var cotizaciones = await query
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            // Cargar estados para el filtro
            var estados = await _context.CotizacionEstados.ToListAsync();

            // Pasar datos a la vista
            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.TotalItems = totalItems;
            ViewBag.PageSize = pageSize;
            ViewBag.SearchTerm = searchTerm;
            ViewBag.EstadoFilter = estadoFilter;
            ViewBag.Estados = estados;

            return View(cotizaciones);
        }

        // GET: Cotizaciones/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var cotizacion = await _context.Cotizaciones
                .Include(c => c.Cliente)
                .Include(c => c.Estado)
                .Include(c => c.RazonCrea)
                .Include(c => c.DetalleCotizaciones)
                    .ThenInclude(d => d.Articulo)
                .FirstOrDefaultAsync(m => m.CotCod == id);

            if (cotizacion == null)
            {
                return NotFound();
            }

            return View(cotizacion);
        }

        // GET: Cotizaciones/Create
        public async Task<IActionResult> Create()
        {
            ViewData["CliCod"] = new SelectList(await _context.Clientes.ToListAsync(), "Id", "CliNombre");
            ViewData["Listas"] = new SelectList(await _context.Listas.Where(l => l.ListStatus).ToListAsync(), "ListCode", "ListDesc");
            // Estados seleccionables por el usuario (no incluye Convertida ni Vencida)
            ViewData["EstadosCotizacion"] = new SelectList(
                await _context.CotizacionEstados
                    .Where(e => e.Id != CotizacionEstadoConstantes.Convertida && e.Id != CotizacionEstadoConstantes.Vencida)
                    .ToListAsync(),
                "Id", "Descripcion");

            ViewData["TipoRazonCrea"] = new SelectList(
                await _context.TipoRazonCreas.OrderBy(t => t.NombreRazon).ToListAsync(),
                "Id", "NombreRazon");

            return View(new CotizacionViewModel());
        }

        // POST: Cotizaciones/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create(CotizacionViewModel model, string itemsJson)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    // Deserializar items
                    var items = JsonSerializer.Deserialize<List<CotizacionItemViewModel>>(itemsJson ?? "[]");

                    if (items == null || items.Count == 0)
                    {
                        ModelState.AddModelError("", "Debe agregar al menos un artículo a la cotización");
                        await CargarViewDataCotizacion(model.CliCod, model.ListaCod, model.CotEstadoId, model.RazonCreaId);
                        return View(model);
                    }

                    // Crear cotización con transacción para atomicidad
                    using var transaction = await _context.Database.BeginTransactionAsync();
                    try
                    {
                        var cotizacion = new Cotizacion
                        {
                            CotFech = new DateTime(model.CotFech.Year, model.CotFech.Month, model.CotFech.Day, 12, 0, 0, DateTimeKind.Utc),
                            CliCod = model.CliCod,
                            CotEstadoId = model.CotEstadoId,
                            ListaCod = model.ListaCod,
                            CotDiasOferta = model.CantDiasOferta,
                            CotDiasPago = model.CantDiasPago,
                            RazonCreaId = model.RazonCreaId,
                            CotTotal = items.Sum(i => i.Subtotal)
                        };

                        _context.Cotizaciones.Add(cotizacion);

                        // Agregar detalles usando navigation property
                        foreach (var item in items)
                        {
                            var detalle = new DetalleCotizacion
                            {
                                Cotizacion = cotizacion,
                                ArtCod = item.ArtCod,
                                DetCant = item.Cantidad,
                                DetPrecio = item.Precio,
                                DetSubtotal = item.Subtotal
                            };
                            cotizacion.DetalleCotizaciones.Add(detalle);
                        }

                        await _context.SaveChangesAsync();
                        await transaction.CommitAsync();
                        return RedirectToAction(nameof(Index));
                    }
                    catch
                    {
                        await transaction.RollbackAsync();
                        throw;
                    }
                }
                catch (Exception ex)
                {
                    ModelState.AddModelError("", "Error al crear la cotización: " + ex.Message);
                }
            }

            await CargarViewDataCotizacion(model.CliCod, model.ListaCod, model.CotEstadoId, model.RazonCreaId);
            return View(model);
        }

        // GET: Cotizaciones/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var cotizacion = await _context.Cotizaciones
                .Include(c => c.DetalleCotizaciones)
                    .ThenInclude(d => d.Articulo)
                .FirstOrDefaultAsync(c => c.CotCod == id);

            if (cotizacion == null)
            {
                return NotFound();
            }

            var viewModel = new CotizacionViewModel
            {
                CotCod = cotizacion.CotCod,
                CotFech = cotizacion.CotFech,
                CliCod = cotizacion.CliCod,
                CotEstadoId = cotizacion.CotEstadoId ?? CotizacionEstadoConstantes.Pendiente,
                ListaCod = cotizacion.ListaCod,
                RazonCreaId = cotizacion.RazonCreaId,
                CantDiasOferta = cotizacion.CotDiasOferta ?? 15,
                CantDiasPago = cotizacion.CotDiasPago ?? 30,
                Items = cotizacion.DetalleCotizaciones.Select(d => new CotizacionItemViewModel
                {
                    DetCotCod = d.DetCotCod,
                    ArtCod = d.ArtCod,
                    Cantidad = d.DetCant,
                    Precio = d.DetPrecio,
                    Subtotal = d.DetSubtotal,
                    ArtDesc = d.Articulo?.ArtDesc,
                    ArtStock = d.Articulo?.ArtStock
                }).ToList()
            };

            await CargarViewDataCotizacion(cotizacion.CliCod, cotizacion.ListaCod, viewModel.CotEstadoId, viewModel.RazonCreaId);
            return View(viewModel);
        }

        // POST: Cotizaciones/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, CotizacionViewModel model, string itemsJson)
        {
            if (id != model.CotCod)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    var items = JsonSerializer.Deserialize<List<CotizacionItemViewModel>>(itemsJson ?? "[]");

                    if (items == null || items.Count == 0)
                    {
                        ModelState.AddModelError("", "Debe agregar al menos un artículo a la cotización");
                        await CargarViewDataCotizacion(model.CliCod, model.ListaCod, model.CotEstadoId, model.RazonCreaId);
                        return View(model);
                    }

                    var cotizacion = await _context.Cotizaciones
                        .Include(c => c.DetalleCotizaciones)
                        .FirstOrDefaultAsync(c => c.CotCod == id);

                    if (cotizacion == null)
                    {
                        return NotFound();
                    }

                    // Actualizar y eliminar/insertar detalles dentro de una transacción (Fix #6)
                    using var transaction = await _context.Database.BeginTransactionAsync();
                    try
                    {
                        // Actualizar cotización
                        cotizacion.CotFech = new DateTime(model.CotFech.Year, model.CotFech.Month, model.CotFech.Day, 12, 0, 0, DateTimeKind.Utc);
                        cotizacion.CliCod = model.CliCod;
                        cotizacion.CotEstadoId = model.CotEstadoId;
                        cotizacion.ListaCod = model.ListaCod;
                        cotizacion.RazonCreaId = model.RazonCreaId;
                        cotizacion.CotDiasOferta = model.CantDiasOferta;
                        cotizacion.CotDiasPago = model.CantDiasPago;
                        cotizacion.CotTotal = items.Sum(i => i.Subtotal);

                        // Eliminar detalles antiguos
                        _context.DetalleCotizaciones.RemoveRange(cotizacion.DetalleCotizaciones);

                        // Agregar nuevos detalles
                        foreach (var item in items)
                        {
                            var detalle = new DetalleCotizacion
                            {
                                CotCod = cotizacion.CotCod,
                                ArtCod = item.ArtCod,
                                DetCant = item.Cantidad,
                                DetPrecio = item.Precio,
                                DetSubtotal = item.Subtotal
                            };
                            _context.DetalleCotizaciones.Add(detalle);
                        }

                        await _context.SaveChangesAsync();
                        await transaction.CommitAsync();
                        return RedirectToAction(nameof(Index));
                    }
                    catch
                    {
                        await transaction.RollbackAsync();
                        throw;
                    }
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!CotizacionExists(model.CotCod))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
            }

            await CargarViewDataCotizacion(model.CliCod, model.ListaCod, model.CotEstadoId, model.RazonCreaId);
            return View(model);
        }

        // GET: Cotizaciones/ConvertToSale/5
        public async Task<IActionResult> ConvertToSale(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var cotizacion = await _context.Cotizaciones
                .Include(c => c.Cliente)
                .Include(c => c.DetalleCotizaciones)
                    .ThenInclude(d => d.Articulo)
                .FirstOrDefaultAsync(c => c.CotCod == id);

            if (cotizacion == null)
            {
                return NotFound();
            }

            var ventaViewModel = new VentaViewModel
            {
                VenFech = DateTime.UtcNow,
                CliCod = cotizacion.CliCod,
                Cliente = cotizacion.Cliente,
                VenEstado = null,  // Will be set from dropdown
                CotizacionOrigen = cotizacion.CotCod,
                Items = cotizacion.DetalleCotizaciones.Select(d => new VentaItemViewModel
                {
                    ArtCod = d.ArtCod,
                    Cantidad = d.DetCant,
                    Precio = d.DetPrecio,
                    Subtotal = d.DetSubtotal,
                    ArtDesc = d.Articulo?.ArtDesc,
                    ArtStock = d.Articulo?.ArtStock
                }).ToList()
            };

            ViewData["CliCod"] = new SelectList(await _context.Clientes.ToListAsync(), "Id", "CliNombre", ventaViewModel.CliCod);
            ViewData["Listas"] = new SelectList(await _context.Listas.Where(l => l.ListStatus).ToListAsync(), "ListCode", "ListDesc");
            ViewData["VenMetodoPago"] = new SelectList(await _context.VentaTipoMetodoPagos.ToListAsync(), "Id", "Descripcion");
            ViewData["VenEstado"] = new SelectList(await _context.VentaTipoEstados.ToListAsync(), "Id", "Descripcion");
            ViewData["VenTipoCbte"] = new SelectList(
                await _context.TipoComprobantes.Where(tc => tc.CodigoAfip <= 11).OrderBy(tc => tc.CodigoAfip).ToListAsync(),
                "CodigoAfip", "Descripcion");
            return View(ventaViewModel);
        }

        // POST: Cotizaciones/ConvertToSale
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ConvertToSale(VentaViewModel model, string itemsJson)
        {
            if (ModelState.IsValid)
            {
                try
                {
                    // Validación segura de deserialización JSON
                    List<VentaItemViewModel>? items;
                    try
                    {
                        items = JsonSerializer.Deserialize<List<VentaItemViewModel>>(itemsJson ?? "[]");
                    }
                    catch (JsonException ex)
                    {
                        _logger.LogWarning(ex, "Error al deserializar JSON en ConvertToSale");
                        ModelState.AddModelError("", "Los datos de los artículos son inválidos");
                        ViewData["CliCod"] = new SelectList(await _context.Clientes.ToListAsync(), "CliCod", "CliNombre", model.CliCod);
                        return View(model);
                    }

                    if (items == null || items.Count == 0)
                    {
                        ModelState.AddModelError("", "Debe incluir al menos un artículo en la venta");
                        ViewData["CliCod"] = new SelectList(await _context.Clientes.ToListAsync(), "CliCod", "CliNombre", model.CliCod);
                        return View(model);
                    }

                    // Validar cada item
                    foreach (var item in items)
                    {
                        if (item.ArtCod <= 0 || item.Cantidad <= 0 || item.Precio < 0)
                        {
                            ModelState.AddModelError("", "Datos de artículo inválidos");
                            ViewData["CliCod"] = new SelectList(await _context.Clientes.ToListAsync(), "CliCod", "CliNombre", model.CliCod);
                            return View(model);
                        }
                    }

                    // Punto 19: Usar transacción con FOR UPDATE locks para prevenir race conditions
                    using var transaction = await _context.Database.BeginTransactionAsync();
                    try
                    {
                        // Primero adquirir locks y verificar stock de TODOS los artículos
                        var articulosConLock = new Dictionary<int, Articulo>();

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

                        // Crear venta
                        var fechaUtc = new DateTime(model.VenFech.Year, model.VenFech.Month, model.VenFech.Day, 12, 0, 0, DateTimeKind.Utc);
                        var venta = new Venta
                        {
                            VenFech = fechaUtc,
                            CliCod = model.CliCod,
                            VenEstado = model.VenEstado,
                            VenTipoCbte = model.VenTipoCbte,
                            VenMetodoPago = model.VenMetodoPago,
                            VenLista = model.ListaCod,
                            VenTotal = items.Sum(i => i.Subtotal)
                        };

                        _context.Ventas.Add(venta);

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
                                CctaDesc = $"Venta #{venta.VenCod} desde cotización #{model.CotizacionOrigen}"
                            };

                            _context.CuentasCorrientes.Add(cuentaCorriente);
                        }

                        // Agregar detalles y actualizar stock (ya tenemos los locks)
                        foreach (var item in items)
                        {
                            var detalle = new DetalleVenta
                            {
                                Venta = venta,
                                ArtCod = item.ArtCod,
                                DetCant = item.Cantidad,
                                DetPrecio = item.Precio,
                                DetSubtotal = item.Subtotal
                            };
                            venta.DetalleVentas.Add(detalle);

                            // Actualizar stock del artículo (ya tenemos el lock)
                            var articulo = articulosConLock[item.ArtCod];
                            articulo.ArtStock = (articulo.ArtStock ?? 0) - item.Cantidad;
                            _context.Entry(articulo).State = EntityState.Modified;
                        }

                        // Actualizar estado de cotización si viene de una
                        if (model.CotizacionOrigen.HasValue)
                        {
                            var cotizacion = await _context.Cotizaciones.FindAsync(model.CotizacionOrigen.Value);
                            if (cotizacion != null)
                            {
                                cotizacion.CotEstadoId = CotizacionEstadoConstantes.Convertida;
                            }
                        }

                        // Un solo SaveChangesAsync para atomicidad
                        await _context.SaveChangesAsync();
                        await transaction.CommitAsync();

                        return RedirectToAction("Index", "Ventas");
                    }
                    catch (InvalidOperationException ex)
                    {
                        await transaction.RollbackAsync();
                        ModelState.AddModelError("", ex.Message);
                        await CargarViewDataConvertToSale(model.CliCod, model.VenEstado, model.VenMetodoPago, model.VenTipoCbte);
                        return View(model);
                    }
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex, "Error al convertir cotización {CotizacionId} a venta", model.CotizacionOrigen);
                    ModelState.AddModelError("", "Error al crear la venta. Por favor, intente nuevamente.");
                }
            }

            await CargarViewDataConvertToSale(model.CliCod, model.VenEstado, model.VenMetodoPago, model.VenTipoCbte);
            return View(model);
        }

        // GET: Cotizaciones/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var cotizacion = await _context.Cotizaciones
                .Include(c => c.Cliente)
                .Include(c => c.Estado)
                .Include(c => c.DetalleCotizaciones)
                .FirstOrDefaultAsync(m => m.CotCod == id);

            if (cotizacion == null)
            {
                return NotFound();
            }

            // No permitir eliminar cotizaciones convertidas a venta
            if (cotizacion.CotEstadoId == CotizacionEstadoConstantes.Convertida)
            {
                TempData["Error"] = "No se puede eliminar una cotización que ya fue convertida a venta";
                return RedirectToAction(nameof(Details), new { id = cotizacion.CotCod });
            }

            return View(cotizacion);
        }

        // POST: Cotizaciones/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var cotizacion = await _context.Cotizaciones
                .Include(c => c.DetalleCotizaciones)
                .FirstOrDefaultAsync(c => c.CotCod == id);

            if (cotizacion != null)
            {
                // Validar estado también en POST para evitar manipulación
                if (cotizacion.CotEstadoId == CotizacionEstadoConstantes.Convertida)
                {
                    TempData["Error"] = "No se puede eliminar una cotización que ya fue convertida a venta";
                    return RedirectToAction(nameof(Index));
                }

                _context.DetalleCotizaciones.RemoveRange(cotizacion.DetalleCotizaciones);
                _context.Cotizaciones.Remove(cotizacion);
                await _context.SaveChangesAsync();
            }

            return RedirectToAction(nameof(Index));
        }

        // GET: Cotizaciones/DescargarPresupuestoPDF/5
        public async Task<IActionResult> DescargarPresupuestoPDF(int id)
        {
            try
            {
                var cotizacion = await _context.Cotizaciones
                    .Include(c => c.Cliente)
                    .Include(c => c.RazonCrea)
                    .Include(c => c.DetalleCotizaciones)
                        .ThenInclude(d => d.Articulo)
                            .ThenInclude(a => a!.Marca)
                    .FirstOrDefaultAsync(c => c.CotCod == id);

                if (cotizacion == null)
                {
                    TempData["Error"] = "Cotizacion no encontrada";
                    return RedirectToAction(nameof(Index));
                }

                // Generar PDF
                var pdfBytes = GenerarPDFCotizacion(cotizacion);

                var fileName = $"Cotizacion_{cotizacion.CotCod}_{DateTime.Now:yyyyMMdd}.pdf";
                return File(pdfBytes, "application/pdf", fileName);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al generar PDF de cotizacion {CotizacionId}", id);
                TempData["Error"] = $"Error al generar PDF: {ex.Message}";
                return RedirectToAction(nameof(Details), new { id });
            }
        }

        private byte[] GenerarPDFCotizacion(Cotizacion cotizacion)
        {
            return Document.Create(container =>
            {
                container.Page(page =>
                {
                    page.Size(PageSizes.A4);
                    page.Margin(2, Unit.Centimetre);
                    page.DefaultTextStyle(x => x.FontSize(10));

                    // Header
                    page.Header().Column(column =>
                    {
                        column.Item().AlignCenter().Text(cotizacion.RazonCrea?.NombreRazon ?? "COMARA").Bold().FontSize(24);
                        column.Item().PaddingTop(5).AlignCenter().Text("COTIZACION / PRESUPUESTO").Bold().FontSize(18);
                        column.Item().PaddingTop(10).Row(row =>
                        {
                            row.RelativeItem().Text($"Cotizacion N: #{cotizacion.CotCod}").FontSize(12);
                            row.RelativeItem().AlignRight().Text($"Fecha: {cotizacion.CotFech:dd/MM/yyyy}").FontSize(12);
                        });
                        column.Item().PaddingTop(5);
                    });

                    // Content
                    page.Content().Column(column =>
                    {
                        // Cliente
                        column.Item().PaddingVertical(10).Text(text =>
                        {
                            text.Span("Cliente: ").Bold().FontSize(12);
                            text.Span(cotizacion.Cliente?.CliNombre ?? "Sin especificar").FontSize(12);
                        });

                        if (!string.IsNullOrEmpty(cotizacion.Cliente?.CliDireccion))
                        {
                            column.Item().Text(text =>
                            {
                                text.Span("Direccion: ").Bold();
                                text.Span(cotizacion.Cliente.CliDireccion);
                            });
                        }

                        if (!string.IsNullOrEmpty(cotizacion.Cliente?.CliTelefono))
                        {
                            column.Item().Text(text =>
                            {
                                text.Span("Telefono: ").Bold();
                                text.Span(cotizacion.Cliente.CliTelefono);
                            });
                        }

                        column.Item().PaddingVertical(15);

                        // Tabla de productos
                        column.Item().Table(table =>
                        {
                            table.ColumnsDefinition(columns =>
                            {
                                columns.ConstantColumn(60);   // Cantidad
                                columns.RelativeColumn(3);     // Descripcion
                                columns.RelativeColumn(1);     // Marca
                                columns.ConstantColumn(80);    // Precio Unit.
                                columns.ConstantColumn(80);    // Subtotal
                            });

                            // Encabezado
                            table.Header(header =>
                            {
                                header.Cell().Element(HeaderCellStyle).Text("Cant.").Bold();
                                header.Cell().Element(HeaderCellStyle).Text("Descripcion").Bold();
                                header.Cell().Element(HeaderCellStyle).Text("Marca").Bold();
                                header.Cell().Element(HeaderCellStyle).AlignRight().Text("P. Unit.").Bold();
                                header.Cell().Element(HeaderCellStyle).AlignRight().Text("Subtotal").Bold();

                                static IContainer HeaderCellStyle(IContainer container)
                                {
                                    return container.DefaultTextStyle(x => x.SemiBold().FontSize(11))
                                        .PaddingVertical(8)
                                        .BorderBottom(2)
                                        .BorderColor(Colors.Black)
                                        .Background(Colors.Grey.Lighten3);
                                }
                            });

                            // Filas
                            foreach (var detalle in cotizacion.DetalleCotizaciones ?? Enumerable.Empty<DetalleCotizacion>())
                            {
                                table.Cell().Element(BodyCellStyle).Text(detalle.DetCant.ToString("N0"));
                                table.Cell().Element(BodyCellStyle).Text(detalle.Articulo?.ArtDesc ?? "Sin descripcion");
                                table.Cell().Element(BodyCellStyle).Text(detalle.Articulo?.Marca?.marNombre ?? "-");
                                table.Cell().Element(BodyCellStyle).AlignRight().Text($"${detalle.DetPrecio:N2}");
                                table.Cell().Element(BodyCellStyle).AlignRight().Text($"${detalle.DetSubtotal:N2}");

                                static IContainer BodyCellStyle(IContainer container)
                                {
                                    return container.BorderBottom(1)
                                        .BorderColor(Colors.Grey.Lighten2)
                                        .PaddingVertical(6)
                                        .PaddingHorizontal(4);
                                }
                            }
                        });

                        column.Item().PaddingVertical(15);

                        // Total
                        column.Item().AlignRight().Column(totalColumn =>
                        {
                            totalColumn.Item().Width(250).Row(row =>
                            {
                                row.RelativeItem().Text("TOTAL:").Bold().FontSize(16);
                                row.RelativeItem().AlignRight().Text($"${cotizacion.CotTotal:N2}").Bold().FontSize(16);
                            });
                        });

                        column.Item().PaddingVertical(20);

                        // Nota de validez
                        column.Item().AlignCenter().Text(text =>
                        {
                            text.Span($"Mantenimiento de Oferta {(cotizacion.CotDiasOferta.HasValue ? cotizacion.CotDiasOferta.Value.ToString() : "15")} días.").FontSize(9).Italic();
                            text.Line("");
                            text.Line("Entrega INMEDIATA");
                            text.Line($"Pago {(cotizacion.CotDiasPago.HasValue ? cotizacion.CotDiasPago.Value.ToString() : "30")} Dias F/F");
                            text.Line("Estos valores incluyen IVA");
                        });
                    });

                    // Footer
                    page.Footer().AlignCenter().Text(x =>
                    {
                        x.CurrentPageNumber();
                        x.Span(" / ");
                        x.TotalPages();
                    });
                });
            }).GeneratePdf();
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

            return Json(new
            {
                success = true,
                precio = Math.Round(precioBase, 2),
                descripcion = articulo.ArtDesc,
                stock = articulo.ArtStock ?? 0,
                costoNeto = Math.Round(articulo.ArtCost ?? 0, 2),
                costoConDescuento = Math.Round(articulo.CostoConDescuento, 2),
                costoFinal = Math.Round(articulo.CostoFinal, 2)
            });
        }

        // API endpoint para buscar artículos con paginación
        [HttpGet]
        public async Task<JsonResult> BuscarArticulos(string term, int page = 1, int pageSize = 10)
        {
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

        private bool CotizacionExists(int id)
        {
            return _context.Cotizaciones.Any(e => e.CotCod == id);
        }

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

        /// <summary>
        /// Helper: carga ViewData comunes para Create/Edit de cotización.
        /// Evita repetición y centraliza la configuración de dropdowns.
        /// </summary>
        private async Task CargarViewDataCotizacion(int? selectedCli, int? selectedLista, int selectedEstado, int? selectedRazon = null)
        {
            ViewData["CliCod"] = new SelectList(
                await _context.Clientes.OrderBy(c => c.CliNombre).Select(c => new { c.Id, c.CliNombre }).ToListAsync(),
                "Id", "CliNombre", selectedCli);
            ViewData["Listas"] = new SelectList(
                await _context.Listas.Where(l => l.ListStatus).ToListAsync(),
                "ListCode", "ListDesc", selectedLista);
            ViewData["EstadosCotizacion"] = new SelectList(
                await _context.CotizacionEstados
                    .Where(e => e.Id != CotizacionEstadoConstantes.Convertida && e.Id != CotizacionEstadoConstantes.Vencida)
                    .ToListAsync(),
                "Id", "Descripcion", selectedEstado);

            // TipoRazonCrea para seleccionar motivo/razon de la cotización
            ViewData["TipoRazonCrea"] = new SelectList(
                await _context.TipoRazonCreas.OrderBy(t => t.NombreRazon).ToListAsync(),
                "Id", "NombreRazon", selectedRazon);
        }

        /// <summary>
        /// Helper: carga ViewData comunes para ConvertToSale.
        /// </summary>
        private async Task CargarViewDataConvertToSale(int? selectedCli, int? selectedEstado, int? selectedMetodoPago, int? selectedTipoCbte)
        {
            ViewData["CliCod"] = new SelectList(
                await _context.Clientes.OrderBy(c => c.CliNombre).Select(c => new { c.Id, c.CliNombre }).ToListAsync(),
                "Id", "CliNombre", selectedCli);
            ViewData["VenEstado"] = new SelectList(
                await _context.VentaTipoEstados.ToListAsync(), "Id", "Descripcion", selectedEstado);
            ViewData["VenMetodoPago"] = new SelectList(
                await _context.VentaTipoMetodoPagos.ToListAsync(), "Id", "Descripcion", selectedMetodoPago);
            ViewData["VenTipoCbte"] = new SelectList(
                await _context.TipoComprobantes.Where(tc => tc.CodigoAfip <= 11).OrderBy(tc => tc.CodigoAfip).ToListAsync(),
                "CodigoAfip", "Descripcion", selectedTipoCbte);
        }
    }
}
