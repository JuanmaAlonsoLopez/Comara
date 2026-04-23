using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using comara.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Mvc.Rendering;
using comara.Models;
using comara.Models.ViewModels;
using comara.Services;

namespace comara.Controllers
{
    [Authorize]
    public class CajaController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly ICajaService _cajaService;

        public CajaController(ApplicationDbContext context, ICajaService cajaService)
        {
            _context = context;
            _cajaService = cajaService;
        }

        // GET: Caja/Index
        [Authorize(Policy = "AuthenticatedUser")]
        public async Task<IActionResult> Index(int? mes, int? anio)
        {
            var mesActual = mes ?? DateTime.Now.Month;
            var anioActual = anio ?? DateTime.Now.Year;

            // Usar el servicio optimizado que elimina N+1 queries
            var viewModel = await _cajaService.GetCajaDashboardAsync(mesActual, anioActual);

            return View(viewModel);
        }

        // GET: Caja/RegistrarPago
        [Authorize(Policy = "AuthenticatedUser")]
        public async Task<IActionResult> RegistrarPago(int? clienteId)
        {
            var viewModel = new RegistrarPagoViewModel();

            await CargarSelectListsPago(clienteId);

            if (clienteId.HasValue)
            {
                viewModel.SaldoActual = await _cajaService.GetSaldoClienteAsync(clienteId.Value);
                viewModel.CliCod = clienteId.Value;
                viewModel.VentasPendientes = await GetVentasPendientesListAsync(clienteId.Value);
            }

            return View(viewModel);
        }

        // POST: Caja/RegistrarPago
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Authorize(Policy = "AuthenticatedUser")]
        public async Task<IActionResult> RegistrarPago(RegistrarPagoViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                // Validar ANTES de guardar (incluye validacion de cheque)
                var validacion = await _cajaService.ValidarPagoAsync(viewModel);
                if (!validacion.EsValido)
                {
                    foreach (var error in validacion.Errores)
                    {
                        ModelState.AddModelError("", error);
                    }
                    await CargarSelectListsPago(viewModel.CliCod, viewModel.PagMetodoPago);
                    viewModel.SaldoActual = await _cajaService.GetSaldoClienteAsync(viewModel.CliCod);
                    return View(viewModel);
                }

                // Registrar pago con transaccion atomica
                var resultado = await _cajaService.RegistrarPagoAsync(viewModel);

                if (resultado.Exitoso)
                {
                    TempData["Success"] = resultado.Mensaje;
                    return RedirectToAction(nameof(Index));
                }
                else
                {
                    ModelState.AddModelError("", resultado.Error ?? "Error desconocido");
                }
            }

            await CargarSelectListsPago(viewModel.CliCod, viewModel.PagMetodoPago);
            viewModel.SaldoActual = await _cajaService.GetSaldoClienteAsync(viewModel.CliCod);
            viewModel.VentasPendientes = await GetVentasPendientesListAsync(viewModel.CliCod);

            return View(viewModel);
        }

        // GET: Caja/RegistrarMovimiento
        [Authorize(Policy = "AuthenticatedUser")]
        public async Task<IActionResult> RegistrarMovimiento()
        {
            await CargarSelectListsMovimiento();
            return View();
        }

        // POST: Caja/RegistrarMovimiento
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Authorize(Policy = "AuthenticatedUser")]
        public async Task<IActionResult> RegistrarMovimiento(MovimientoCajaViewModel viewModel)
        {
            if (ModelState.IsValid)
            {
                var resultado = await _cajaService.RegistrarMovimientoAsync(viewModel);

                if (resultado.Exitoso)
                {
                    TempData["Success"] = resultado.Mensaje;
                    return RedirectToAction(nameof(Index));
                }
                else
                {
                    ModelState.AddModelError("", resultado.Error ?? "Error desconocido");
                }
            }

            await CargarSelectListsMovimiento(viewModel.MovTipo, viewModel.MovMetodoPago, viewModel.ChqCod);
            return View(viewModel);
        }

        // GET: Caja/VerCheques
        [Authorize(Policy = "AuthenticatedUser")]
        public async Task<IActionResult> VerCheques()
        {
            var cheques = await _context.Cheques
                .Include(c => c.Pago)
                    .ThenInclude(p => p!.Cliente)
                .OrderByDescending(c => c.ChqEnCaja)
                .ThenBy(c => c.ChqFechaCobro)
                .ToListAsync();

            return View(cheques);
        }

        // GET: Caja/VerMovimientos
        [Authorize(Policy = "AuthenticatedUser")]
        public async Task<IActionResult> VerMovimientos(int? mes, int? anio)
        {
            var mesActual = mes ?? DateTime.Now.Month;
            var anioActual = anio ?? DateTime.Now.Year;

            var movimientos = await _context.MovimientosCaja
                .Include(m => m.TipoMovimiento)
                .Include(m => m.TipoMetodoPago)
                .Include(m => m.Cheque)
                .Where(m => m.MovFecha.Month == mesActual && m.MovFecha.Year == anioActual)
                .OrderByDescending(m => m.MovFecha)
                .ToListAsync();

            ViewData["MesSeleccionado"] = mesActual;
            ViewData["AnioSeleccionado"] = anioActual;
            ViewData["MesNombre"] = new DateTime(anioActual, mesActual, 1).ToString("MMMM yyyy", new System.Globalization.CultureInfo("es-ES"));

            return View(movimientos);
        }

        // GET: Caja/Details/5
        [Authorize(Policy = "AuthenticatedUser")]
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var pago = await _context.Pagos
                .Include(p => p.Cliente)
                .Include(p => p.TipoMetodoPago)
                .Include(p => p.CuentaCorriente)
                .FirstOrDefaultAsync(m => m.PagCod == id);

            if (pago == null)
            {
                return NotFound();
            }

            return View(pago);
        }

        // GET: Caja/VerCuentaCorriente/5
        [Authorize(Policy = "AuthenticatedUser")]
        public async Task<IActionResult> VerCuentaCorriente(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var cliente = await _context.Clientes.FindAsync(id);
            if (cliente == null)
            {
                return NotFound();
            }

            var movimientos = await _context.CuentasCorrientes
                .Where(c => c.CliCod == id)
                .OrderByDescending(c => c.CctaFech)
                .ToListAsync();

            ViewBag.Cliente = cliente;
            return View(movimientos);
        }

        // API endpoint para obtener el saldo actual de un cliente
        [HttpGet]
        [Authorize(Policy = "AuthenticatedUser")]
        public async Task<JsonResult> GetSaldoCliente(int clienteId)
        {
            var saldo = await _cajaService.GetSaldoClienteAsync(clienteId);
            return Json(new
            {
                success = true,
                saldo = saldo
            });
        }

        // API endpoint para obtener las ventas pendientes de un cliente
        [HttpGet]
        [Authorize(Policy = "AuthenticatedUser")]
        public async Task<JsonResult> GetVentasPendientes(int clienteId)
        {
            var ventas = await GetVentasPendientesListAsync(clienteId);
            return Json(new
            {
                success = true,
                ventas = ventas.Select(v => new
                {
                    venCod = v.VenCod,
                    descripcion = v.Descripcion,
                    total = v.Total,
                    pagado = v.Pagado,
                    pendiente = v.Pendiente
                })
            });
        }

        /// <summary>
        /// Obtiene la lista de ventas con saldo pendiente de un cliente
        /// </summary>
        private async Task<List<VentaPendienteItem>> GetVentasPendientesListAsync(int clienteId)
        {
            // Obtener ventas en cuenta corriente del cliente con saldo pendiente
            var ventasCC = await _context.Ventas
                .Where(v => v.CliCod == clienteId &&
                           v.VenMetodoPago == MetodoPago.CuentaCorriente)
                .Select(v => new
                {
                    v.VenCod,
                    v.VenFech,
                    v.VenTotal,
                    v.VenNumComprobante,
                    TotalPagado = _context.Pagos
                        .Where(p => p.VenCod == v.VenCod)
                        .Sum(p => (decimal?)p.PagMonto) ?? 0
                })
                .ToListAsync();

            return ventasCC
                .Where(v => v.VenTotal - v.TotalPagado > 0) // Solo con saldo pendiente
                .OrderByDescending(v => v.VenFech)
                .Select(v => new VentaPendienteItem
                {
                    VenCod = v.VenCod,
                    Descripcion = v.VenNumComprobante.HasValue
                        ? $"Factura {v.VenNumComprobante} - {v.VenFech:dd/MM/yyyy}"
                        : $"Venta {v.VenFech:dd/MM/yyyy}",
                    Total = v.VenTotal,
                    Pagado = v.TotalPagado
                })
                .ToList();
        }

        #region Metodos auxiliares privados

        private async Task CargarSelectListsPago(int? clienteId = null, int? metodoPagoId = null)
        {
            ViewData["CliCod"] = new SelectList(
                await _context.Clientes.OrderBy(c => c.CliNombre).ToListAsync(),
                "Id",
                "CliNombre",
                clienteId
            );

            var metodosPago = await _context.VentaTipoMetodoPagos
                .Where(m => m.Id != 3) // Excluir Cuenta Corriente
                .ToListAsync();

            ViewData["PagMetodoPago"] = new SelectList(metodosPago, "Id", "Descripcion", metodoPagoId);
        }

        private async Task CargarSelectListsMovimiento(int? tipoId = null, int? metodoPagoId = null, int? chequeId = null)
        {
            var tiposMovimiento = await _context.TipoMovimientosCaja.ToListAsync();
            ViewData["MovTipo"] = new SelectList(tiposMovimiento, "Id", "Descripcion", tipoId);

            var metodosPago = await _context.VentaTipoMetodoPagos
                .Where(m => m.Id == 4 || m.Id == 5) // Solo Cheque y Efectivo
                .ToListAsync();
            ViewData["MovMetodoPago"] = new SelectList(metodosPago, "Id", "Descripcion", metodoPagoId);

            var chequesEnCaja = await _context.Cheques
                .Where(c => c.ChqEnCaja)
                .ToListAsync();
            ViewData["ChqCod"] = new SelectList(chequesEnCaja, "ChqCod", "ChqNumero", chequeId);
        }

        #endregion
    }
}
