using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using comara.Data;
using Microsoft.EntityFrameworkCore;
using comara.Models;
using comara.Models.ViewModels;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace comara.Controllers
{
    [Authorize]
    public class ReportesController : Controller
    {
        private readonly ApplicationDbContext _context;
        private const int RegistrosPorPaginaDefault = 20;

        public ReportesController(ApplicationDbContext context)
        {
            _context = context;
        }

        [Authorize(Policy = "AuthenticatedUser")]
        public IActionResult Index()
        {
            return View();
        }

        [Authorize(Policy = "AuthenticatedUser")]
        public async Task<IActionResult> Ventas(
            DateTime? fechaDesde,
            DateTime? fechaHasta,
            int? clienteId,
            int? metodoPagoId,
            int? estadoId,
            int pagina = 1)
        {
            var query = _context.Ventas
                .Include(v => v.Cliente)
                .Include(v => v.TipoMetodoPago)
                .Include(v => v.TipoEstado)
                .Include(v => v.DetalleVentas)
                .AsQueryable();

            // Aplicar filtros
            if (fechaDesde.HasValue)
            {
                var desde = DateTime.SpecifyKind(fechaDesde.Value.Date, DateTimeKind.Utc);
                query = query.Where(v => v.VenFech >= desde);
            }

            if (fechaHasta.HasValue)
            {
                var hasta = DateTime.SpecifyKind(fechaHasta.Value.Date.AddDays(1).AddTicks(-1), DateTimeKind.Utc);
                query = query.Where(v => v.VenFech <= hasta);
            }

            if (clienteId.HasValue)
            {
                query = query.Where(v => v.CliCod == clienteId.Value);
            }

            if (metodoPagoId.HasValue)
            {
                query = query.Where(v => v.VenMetodoPago == metodoPagoId.Value);
            }

            if (estadoId.HasValue)
            {
                query = query.Where(v => v.VenEstado == estadoId.Value);
            }

            // Ordenar por fecha descendente
            query = query.OrderByDescending(v => v.VenFech);

            // Calcular totales ANTES de paginar
            var totalRegistros = await query.CountAsync();
            var totalVentas = await query.SumAsync(v => (decimal?)v.VenTotal) ?? 0;
            var granTotalCostos = await query
                .SelectMany(v => v.DetalleVentas)
                .SumAsync(d => (decimal?)d.DetCostoTotal) ?? 0;

            // Paginacion
            var totalPaginas = (int)Math.Ceiling(totalRegistros / (double)RegistrosPorPaginaDefault);
            pagina = Math.Max(1, Math.Min(pagina, Math.Max(1, totalPaginas)));

            var ventas = await query
                .Skip((pagina - 1) * RegistrosPorPaginaDefault)
                .Take(RegistrosPorPaginaDefault)
                .Select(v => new VentaReporteItem
                {
                    VenCod = v.VenCod,
                    VenFech = v.VenFech,
                    ClienteNombre = v.Cliente != null ? v.Cliente.CliNombre ?? "Sin nombre" : "Sin cliente",
                    MetodoPago = v.TipoMetodoPago != null ? v.TipoMetodoPago.Descripcion ?? "" : "",
                    Estado = v.TipoEstado != null ? v.TipoEstado.Descripcion ?? "" : "",
                    CostoTotal = v.DetalleVentas.Sum(d => d.DetCostoTotal),
                    VenTotal = v.VenTotal
                })
                .ToListAsync();

            var viewModel = new ReporteVentasViewModel
            {
                Ventas = ventas,
                PaginaActual = pagina,
                TotalPaginas = totalPaginas,
                TotalRegistros = totalRegistros,
                RegistrosPorPagina = RegistrosPorPaginaDefault,
                FechaDesde = fechaDesde,
                FechaHasta = fechaHasta,
                ClienteId = clienteId,
                MetodoPagoId = metodoPagoId,
                EstadoId = estadoId,
                TotalVentas = totalVentas,
                CantidadVentas = totalRegistros,
                GranTotalCostos = granTotalCostos
            };

            await CargarSelectListsVentas(clienteId, metodoPagoId, estadoId);

            return View(viewModel);
        }

        [Authorize(Policy = "AuthenticatedUser")]
        public async Task<IActionResult> StockCritico()
        {
            // Punto 28: Usar constante SessionKeys en lugar de string mágico
            HttpContext.Session.SetString(SessionKeys.StockCriticoViewed, "true");

            var stockCritico = await _context.Articulos
                .Include(a => a.Marca)
                .Where(a => a.ArtStock <= a.ArtStockMin)
                .OrderBy(a => a.ArtStock - a.ArtStockMin) // Mas criticos primero
                .Select(a => new StockReporteItem
                {
                    ArtCod = a.ArtCod,
                    ArtDesc = a.ArtDesc,
                    MarcaNombre = a.Marca != null ? a.Marca.marNombre : null,
                    ArtStock = a.ArtStock ?? 0,
                    ArtStockMin = a.ArtStockMin ?? 0,
                    PrecioLista1 = a.ArtL1 ?? 0
                })
                .ToListAsync();

            return View(stockCritico);
        }

        [Authorize(Policy = "AuthenticatedUser")]
        public async Task<IActionResult> CuentasCorrientes(
            DateTime? fechaDesde,
            DateTime? fechaHasta,
            int? clienteId,
            string? tipoMovimiento,
            int pagina = 1)
        {
            var query = _context.CuentasCorrientes
                .Include(cc => cc.Cliente)
                .AsQueryable();

            // Aplicar filtros
            if (fechaDesde.HasValue)
            {
                var desde = DateTime.SpecifyKind(fechaDesde.Value.Date, DateTimeKind.Utc);
                query = query.Where(cc => cc.CctaFech >= desde);
            }

            if (fechaHasta.HasValue)
            {
                var hasta = DateTime.SpecifyKind(fechaHasta.Value.Date.AddDays(1).AddTicks(-1), DateTimeKind.Utc);
                query = query.Where(cc => cc.CctaFech <= hasta);
            }

            if (clienteId.HasValue)
            {
                query = query.Where(cc => cc.CliCod == clienteId.Value);
            }

            if (!string.IsNullOrEmpty(tipoMovimiento))
            {
                query = query.Where(cc => cc.CctaMovimiento == tipoMovimiento);
            }

            // Ordenar por fecha descendente
            query = query.OrderByDescending(cc => cc.CctaFech);

            // Calcular totales ANTES de paginar
            var totalRegistros = await query.CountAsync();
            var totalDebe = await query.Where(cc => cc.CctaMovimiento == "DEBE").SumAsync(cc => (decimal?)cc.CctaMonto) ?? 0;
            var totalHaber = await query.Where(cc => cc.CctaMovimiento == "HABER").SumAsync(cc => (decimal?)cc.CctaMonto) ?? 0;

            // Paginacion
            var totalPaginas = (int)Math.Ceiling(totalRegistros / (double)RegistrosPorPaginaDefault);
            pagina = Math.Max(1, Math.Min(pagina, Math.Max(1, totalPaginas)));

            var movimientos = await query
                .Skip((pagina - 1) * RegistrosPorPaginaDefault)
                .Take(RegistrosPorPaginaDefault)
                .Select(cc => new CuentaCorrienteReporteItem
                {
                    CctaCod = cc.CctaCod,
                    CctaFech = cc.CctaFech,
                    ClienteNombre = cc.Cliente != null ? cc.Cliente.CliNombre ?? "Sin nombre" : "Sin cliente",
                    Movimiento = cc.CctaMovimiento ?? "",
                    Monto = cc.CctaMonto,
                    Saldo = cc.CctaSaldo,
                    Descripcion = cc.CctaDesc
                })
                .ToListAsync();

            var viewModel = new ReporteCuentasCorrientesViewModel
            {
                Movimientos = movimientos,
                PaginaActual = pagina,
                TotalPaginas = totalPaginas,
                TotalRegistros = totalRegistros,
                RegistrosPorPagina = RegistrosPorPaginaDefault,
                FechaDesde = fechaDesde,
                FechaHasta = fechaHasta,
                ClienteId = clienteId,
                TipoMovimiento = tipoMovimiento,
                TotalDebe = totalDebe,
                TotalHaber = totalHaber
            };

            await CargarSelectListsCuentasCorrientes(clienteId, tipoMovimiento);

            return View(viewModel);
        }

        [Authorize(Policy = "AuthenticatedUser")]
        public async Task<IActionResult> ReporteStock(
            int? marcaId,
            int? proveedorId,
            bool? soloStockCritico,
            string? busqueda,
            int pagina = 1)
        {
            var query = _context.Articulos
                .Include(a => a.Marca)
                .Include(a => a.Proveedor)
                .Include(a => a.Iva)
                .AsQueryable();

            // Aplicar filtros
            if (marcaId.HasValue)
            {
                query = query.Where(a => a.MarCod == marcaId.Value);
            }

            if (proveedorId.HasValue)
            {
                query = query.Where(a => a.ProCod == proveedorId.Value);
            }

            if (soloStockCritico == true)
            {
                query = query.Where(a => a.ArtStock <= a.ArtStockMin);
            }

            if (!string.IsNullOrWhiteSpace(busqueda))
            {
                var busquedaLower = busqueda.ToLower();
                query = query.Where(a =>
                    (a.ArtDesc != null && a.ArtDesc.ToLower().Contains(busquedaLower)) ||
                    (a.ArtCod != null && a.ArtCod.ToLower().Contains(busquedaLower)));
            }

            // Ordenar
            query = query.OrderBy(a => a.Id);

            // Materializar todos los filtrados para calcular totales en memoria (evita overflow de numeric en PostgreSQL)
            var todos = await query.ToListAsync();

            var totalRegistros = todos.Count;
            var articulosCriticos = todos.Count(a => a.ArtStock <= a.ArtStockMin);
            var valorTotalStock = todos.Sum(a => (a.ArtStock ?? 0) * a.CostoFinal);

            // Paginacion
            var totalPaginas = (int)Math.Ceiling(totalRegistros / (double)RegistrosPorPaginaDefault);
            pagina = Math.Max(1, Math.Min(pagina, Math.Max(1, totalPaginas)));

            var articulos = todos
                .Skip((pagina - 1) * RegistrosPorPaginaDefault)
                .Take(RegistrosPorPaginaDefault)
                .Select(a => new StockReporteItem
                {
                    ArtCod = a.ArtCod,
                    ArtDesc = a.ArtDesc,
                    MarcaNombre = a.Marca?.marNombre,
                    ProveedorNombre = a.Proveedor?.proNombre,
                    ArtStock = a.ArtStock ?? 0,
                    ArtStockMin = a.ArtStockMin ?? 0,
                    ValorStock = (a.ArtStock ?? 0) * a.CostoFinal,
                    CostoNeto = a.ArtCost ?? 0,
                    DescuentoProveedor = a.Proveedor?.proDescuento ?? 0,
                    CostoConDescuento = a.CostoConDescuento,
                    PorcentajeIva = a.Iva?.Porcentaje ?? 0,
                    CostoFinal = a.CostoFinal
                }).ToList();

            var viewModel = new ReporteStockViewModel
            {
                Articulos = articulos,
                PaginaActual = pagina,
                TotalPaginas = totalPaginas,
                TotalRegistros = totalRegistros,
                RegistrosPorPagina = RegistrosPorPaginaDefault,
                MarcaId = marcaId,
                ProveedorId = proveedorId,
                SoloStockCritico = soloStockCritico,
                Busqueda = busqueda,
                TotalArticulos = totalRegistros,
                ArticulosStockCritico = articulosCriticos,
                ValorTotalStock = valorTotalStock
            };

            await CargarSelectListsStock(marcaId, proveedorId);

            return View(viewModel);
        }

        #region Metodos auxiliares

        private async Task CargarSelectListsVentas(int? clienteId, int? metodoPagoId, int? estadoId)
        {
            ViewData["Clientes"] = new SelectList(
                await _context.Clientes.OrderBy(c => c.CliNombre).ToListAsync(),
                "Id",
                "CliNombre",
                clienteId
            );

            ViewData["MetodosPago"] = new SelectList(
                await _context.VentaTipoMetodoPagos.ToListAsync(),
                "Id",
                "Descripcion",
                metodoPagoId
            );

            ViewData["Estados"] = new SelectList(
                await _context.VentaTipoEstados.ToListAsync(),
                "Id",
                "Descripcion",
                estadoId
            );
        }

        private async Task CargarSelectListsCuentasCorrientes(int? clienteId, string? tipoMovimiento)
        {
            ViewData["Clientes"] = new SelectList(
                await _context.Clientes.OrderBy(c => c.CliNombre).ToListAsync(),
                "Id",
                "CliNombre",
                clienteId
            );

            ViewData["TiposMovimiento"] = new SelectList(
                new[] {
                    new { Value = "DEBE", Text = "DEBE" },
                    new { Value = "HABER", Text = "HABER" }
                },
                "Value",
                "Text",
                tipoMovimiento
            );
        }

        private async Task CargarSelectListsStock(int? marcaId, int? proveedorId)
        {
            ViewData["Marcas"] = new SelectList(
                await _context.Marcas.OrderBy(m => m.marNombre).ToListAsync(),
                "marCod",
                "marNombre",
                marcaId
            );

            ViewData["Proveedores"] = new SelectList(
                await _context.Proveedores.OrderBy(p => p.proNombre).ToListAsync(),
                "proCod",
                "proNombre",
                proveedorId
            );
        }

        #endregion
    }
}
