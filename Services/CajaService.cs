using comara.Data;
using comara.Models;
using comara.Models.ViewModels;
using Microsoft.EntityFrameworkCore;

namespace comara.Services
{
    public class CajaService : ICajaService
    {
        private readonly ApplicationDbContext _context;

        public CajaService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<CajaIndexViewModel> GetCajaDashboardAsync(int mes, int anio)
        {
            var viewModel = new CajaIndexViewModel
            {
                MesSeleccionado = mes,
                AnioSeleccionado = anio
            };

            // OPTIMIZACION 1: Obtener ventas CC con pagos en UNA sola consulta usando FK
            var ventasCC = await _context.Ventas
                .Include(v => v.Cliente)
                .Where(v => v.VenMetodoPago == 3 &&
                           v.VenFech.Month == mes &&
                           v.VenFech.Year == anio)
                .Select(v => new
                {
                    v.VenCod,
                    v.VenFech,
                    ClienteNombre = v.Cliente != null ? v.Cliente.CliNombre : "Sin cliente",
                    v.VenTotal,
                    // Usar FK VenCod directamente en lugar de buscar por texto
                    TotalPagado = _context.Pagos
                        .Where(p => p.VenCod == v.VenCod)
                        .Sum(p => (decimal?)p.PagMonto) ?? 0
                })
                .ToListAsync();

            viewModel.VentasCuentaCorriente = ventasCC.Select(v => new VentaCuentaCorrienteViewModel
            {
                VenCod = v.VenCod,
                VenFech = v.VenFech,
                ClienteNombre = v.ClienteNombre ?? "Sin cliente",
                VenTotal = v.VenTotal,
                TotalPagado = v.TotalPagado,
                SaldoPendiente = v.VenTotal - v.TotalPagado
            }).ToList();

            // OPTIMIZACION 2: Calcular balances en UNA consulta agregada por método de pago
            var metodosPago = await _context.VentaTipoMetodoPagos.ToListAsync();

            // DbContext no es thread-safe, ejecutar consultas secuencialmente
            // IMPORTANTE: Excluir ventas en Cuenta Corriente (MetodoPago=3) porque NO son ingresos directos.
            // El ingreso real se registra cuando el cliente paga (en la tabla PAGOS con el método de pago real).
            var ingresosVentas = await _context.Ventas
                .Where(v => v.VenFech.Month == mes &&
                           v.VenFech.Year == anio &&
                           v.VenMetodoPago != null &&
                           v.VenMetodoPago != MetodoPago.CuentaCorriente) // Excluir CC
                .GroupBy(v => v.VenMetodoPago!.Value)
                .Select(g => new { MetodoId = g.Key, Total = g.Sum(v => v.VenTotal) })
                .ToDictionaryAsync(x => x.MetodoId, x => x.Total);

            // Pagos de clientes (cobros de cuenta corriente) - estos SÍ son ingresos reales
            // El método de pago del Pago indica cómo se recibió el dinero (efectivo, cheque, etc.)
            var ingresosPagos = await _context.Pagos
                .Where(p => p.PagFech.Month == mes && p.PagFech.Year == anio)
                .GroupBy(p => p.PagMetodoPago)
                .Select(g => new { MetodoId = g.Key, Total = g.Sum(p => p.PagMonto) })
                .ToDictionaryAsync(x => x.MetodoId, x => x.Total);

            var ingresosMov = await _context.MovimientosCaja
                .Include(m => m.TipoMovimiento)
                .Where(m => m.TipoMovimiento!.Tipo == "INGRESO" &&
                           m.MovFecha.Month == mes &&
                           m.MovFecha.Year == anio)
                .GroupBy(m => m.MovMetodoPago)
                .Select(g => new { MetodoId = g.Key, Total = g.Sum(m => m.MovMonto) })
                .ToDictionaryAsync(x => x.MetodoId, x => x.Total);

            var egresosMov = await _context.MovimientosCaja
                .Include(m => m.TipoMovimiento)
                .Where(m => m.TipoMovimiento!.Tipo == "EGRESO" &&
                           m.MovFecha.Month == mes &&
                           m.MovFecha.Year == anio)
                .GroupBy(m => m.MovMetodoPago)
                .Select(g => new { MetodoId = g.Key, Total = g.Sum(m => m.MovMonto) })
                .ToDictionaryAsync(x => x.MetodoId, x => x.Total);

            // Construir el balance por método
            foreach (var metodo in metodosPago)
            {
                var totalIngresosVentas = ingresosVentas.GetValueOrDefault(metodo.Id, 0);
                var totalIngresosPagos = ingresosPagos.GetValueOrDefault(metodo.Id, 0);
                var totalIngresosMov = ingresosMov.GetValueOrDefault(metodo.Id, 0);
                var totalEgresosMov = egresosMov.GetValueOrDefault(metodo.Id, 0);

                var totalIngresos = totalIngresosVentas + totalIngresosPagos + totalIngresosMov;

                viewModel.BalancePorMetodo.Add(new BalanceMetodoPagoViewModel
                {
                    MetodoPago = metodo.Descripcion ?? "Sin descripcion",
                    TotalIngresos = totalIngresos,
                    TotalEgresos = totalEgresosMov,
                    SaldoNeto = totalIngresos - totalEgresosMov
                });
            }

            // Obtener cheques en caja
            var chequesEnCaja = await _context.Cheques
                .Where(c => c.ChqEnCaja)
                .OrderBy(c => c.ChqFechaCobro)
                .Select(c => new ChequeEnCajaViewModel
                {
                    ChqCod = c.ChqCod,
                    ChqNumero = c.ChqNumero ?? "",
                    ChqBanco = c.ChqBanco ?? "",
                    ChqFechaCobro = c.ChqFechaCobro,
                    ChqMonto = c.ChqMonto,
                    ChqLibrador = c.ChqLibrador ?? ""
                })
                .ToListAsync();

            viewModel.ChequesEnCaja = chequesEnCaja;

            // Calcular total efectivo en caja
            var efectivoBalance = viewModel.BalancePorMetodo.FirstOrDefault(b => b.MetodoPago == "Efectivo");
            viewModel.TotalEfectivoEnCaja = efectivoBalance?.SaldoNeto ?? 0;

            return viewModel;
        }

        public async Task<decimal> GetSaldoClienteAsync(int clienteId)
        {
            var ultimaCuenta = await _context.CuentasCorrientes
                .Where(c => c.CliCod == clienteId)
                .OrderByDescending(c => c.CctaCod)
                .FirstOrDefaultAsync();

            return ultimaCuenta?.CctaSaldo ?? 0;
        }

        public ResultadoValidacion ValidarDatosCheque(RegistrarPagoViewModel viewModel)
        {
            // Si no es pago con cheque (id=4), es valido
            if (viewModel.PagMetodoPago != 4)
            {
                return ResultadoValidacion.Valido();
            }

            var errores = new List<string>();

            if (string.IsNullOrEmpty(viewModel.ChqNumero))
                errores.Add("El numero de cheque es requerido");

            if (string.IsNullOrEmpty(viewModel.ChqBanco))
                errores.Add("El banco es requerido");

            if (!viewModel.ChqFechaEmision.HasValue)
                errores.Add("La fecha de emision es requerida");

            if (!viewModel.ChqFechaCobro.HasValue)
                errores.Add("La fecha de cobro es requerida");

            if (string.IsNullOrEmpty(viewModel.ChqLibrador))
                errores.Add("El librador es requerido");

            if (viewModel.ChqFechaEmision.HasValue && viewModel.ChqFechaCobro.HasValue)
            {
                if (viewModel.ChqFechaCobro < viewModel.ChqFechaEmision)
                    errores.Add("La fecha de cobro no puede ser anterior a la fecha de emision");
            }

            return errores.Any()
                ? ResultadoValidacion.Invalido(errores.ToArray())
                : ResultadoValidacion.Valido();
        }

        public async Task<ResultadoValidacion> ValidarPagoAsync(RegistrarPagoViewModel viewModel)
        {
            var errores = new List<string>();

            // Validar que el cliente existe
            var cliente = await _context.Clientes.FindAsync(viewModel.CliCod);
            if (cliente == null)
            {
                errores.Add("El cliente especificado no existe");
                return ResultadoValidacion.Invalido(errores.ToArray());
            }

            // Validar saldo
            var saldoActual = await GetSaldoClienteAsync(viewModel.CliCod);
            if (viewModel.PagMonto > saldoActual)
            {
                errores.Add($"El monto del pago ({viewModel.PagMonto:C}) no puede ser mayor al saldo actual ({saldoActual:C})");
            }

            // Validar datos de cheque si aplica
            var validacionCheque = ValidarDatosCheque(viewModel);
            if (!validacionCheque.EsValido)
            {
                errores.AddRange(validacionCheque.Errores);
            }

            return errores.Any()
                ? ResultadoValidacion.Invalido(errores.ToArray())
                : ResultadoValidacion.Valido();
        }

        public async Task<ResultadoOperacion> RegistrarPagoAsync(RegistrarPagoViewModel viewModel)
        {
            // Validar ANTES de cualquier operacion
            var validacion = await ValidarPagoAsync(viewModel);
            if (!validacion.EsValido)
            {
                return ResultadoOperacion.Fallo(string.Join(". ", validacion.Errores));
            }

            // Usar transaccion para garantizar atomicidad
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                // Usar FOR UPDATE para evitar race conditions en el saldo
                var saldoAnterior = await GetSaldoConLockAsync(viewModel.CliCod);
                var nuevoSaldo = saldoAnterior - viewModel.PagMonto;

                // Crear movimiento en cuenta corriente
                var cuentaCorriente = new CuentaCorriente
                {
                    CliCod = viewModel.CliCod,
                    CctaFech = CrearFechaUtc(viewModel.PagFech),
                    CctaMovimiento = "HABER",
                    CctaMonto = viewModel.PagMonto,
                    CctaSaldo = nuevoSaldo,
                    CctaDesc = $"Pago - {viewModel.PagDesc ?? "Sin descripcion"}"
                };

                _context.CuentasCorrientes.Add(cuentaCorriente);
                await _context.SaveChangesAsync();

                // Crear el pago con referencia a la venta si se especificó
                var pago = new Pago
                {
                    CliCod = viewModel.CliCod,
                    PagFech = CrearFechaUtc(viewModel.PagFech),
                    PagMonto = viewModel.PagMonto,
                    PagMetodoPago = viewModel.PagMetodoPago,
                    PagDesc = viewModel.PagDesc,
                    CctaCod = cuentaCorriente.CctaCod,
                    VenCod = viewModel.VenCod // Vincula el pago a la venta específica
                };

                _context.Pagos.Add(pago);
                await _context.SaveChangesAsync();

                // Actualizar estado de pago de la venta si se especificó
                if (viewModel.VenCod.HasValue)
                {
                    await ActualizarEstadoPagoVentaAsync(viewModel.VenCod.Value);
                }

                // Si es cheque, crear registro de cheque
                if (viewModel.PagMetodoPago == 4)
                {
                    var cheque = new Cheque
                    {
                        PagCod = pago.PagCod,
                        ChqNumero = viewModel.ChqNumero!,
                        ChqBanco = viewModel.ChqBanco!,
                        ChqFechaEmision = CrearFechaUtc(viewModel.ChqFechaEmision!.Value),
                        ChqFechaCobro = CrearFechaUtc(viewModel.ChqFechaCobro!.Value),
                        ChqMonto = viewModel.PagMonto,
                        ChqLibrador = viewModel.ChqLibrador!,
                        ChqCUIT = viewModel.ChqCUIT,
                        ChqEnCaja = true,
                        ChqObservaciones = viewModel.ChqObservaciones
                    };

                    _context.Cheques.Add(cheque);
                    await _context.SaveChangesAsync();
                }

                // Commit de la transaccion
                await transaction.CommitAsync();

                return ResultadoOperacion.Ok("Pago registrado exitosamente", pago.PagCod);
            }
            catch (Exception ex)
            {
                // Rollback automatico al salir del using si no se hizo commit
                await transaction.RollbackAsync();
                return ResultadoOperacion.Fallo($"Error al registrar el pago: {ex.Message}");
            }
        }

        public async Task<ResultadoOperacion> RegistrarMovimientoAsync(MovimientoCajaViewModel viewModel)
        {
            using var transaction = await _context.Database.BeginTransactionAsync();
            try
            {
                var tipoMovimiento = await _context.TipoMovimientosCaja.FindAsync(viewModel.MovTipo);

                if (tipoMovimiento == null)
                {
                    return ResultadoOperacion.Fallo("Tipo de movimiento no valido");
                }

                // Si es egreso de cheque, marcar el cheque como fuera de caja
                if (tipoMovimiento.Tipo == "EGRESO" && viewModel.ChqCod.HasValue)
                {
                    var cheque = await _context.Cheques.FindAsync(viewModel.ChqCod.Value);
                    if (cheque != null)
                    {
                        cheque.ChqEnCaja = false;
                        cheque.ChqFechaSalida = CrearFechaUtc(viewModel.MovFecha);
                        _context.Update(cheque);
                    }
                }

                var movimiento = new MovimientoCaja
                {
                    MovFecha = CrearFechaUtc(viewModel.MovFecha),
                    MovTipo = viewModel.MovTipo,
                    MovMetodoPago = viewModel.MovMetodoPago,
                    MovMonto = viewModel.MovMonto,
                    MovDescripcion = viewModel.MovDescripcion,
                    ChqCod = viewModel.ChqCod
                };

                _context.MovimientosCaja.Add(movimiento);
                await _context.SaveChangesAsync();

                await transaction.CommitAsync();

                return ResultadoOperacion.Ok("Movimiento registrado exitosamente", movimiento.MovCod);
            }
            catch (Exception ex)
            {
                await transaction.RollbackAsync();
                return ResultadoOperacion.Fallo($"Error al registrar el movimiento: {ex.Message}");
            }
        }

        private static DateTime CrearFechaUtc(DateTime fecha)
        {
            return new DateTime(fecha.Year, fecha.Month, fecha.Day, 12, 0, 0, DateTimeKind.Utc);
        }

        /// <summary>
        /// Obtiene el último saldo de cuenta corriente con lock FOR UPDATE para evitar race conditions.
        /// IMPORTANTE: Solo usar dentro de una transacción activa.
        /// </summary>
        private async Task<decimal> GetSaldoConLockAsync(int clienteId)
        {
            // Usar FOR UPDATE para adquirir lock exclusivo en las filas del cliente
            var ultimaCuenta = await _context.CuentasCorrientes
                .FromSqlRaw(
                    "SELECT * FROM \"CUENTAS_CORRIENTES\" WHERE \"cliCod\" = {0} ORDER BY \"cctaCod\" DESC LIMIT 1 FOR UPDATE",
                    clienteId)
                .FirstOrDefaultAsync();

            return ultimaCuenta?.CctaSaldo ?? 0;
        }

        /// <summary>
        /// Actualiza el estado de pago de una venta según los pagos realizados.
        /// NOTA: Esta lógica debe mantenerse sincronizada con VentasController.RegistrarPagoFactura
        /// Ambos módulos usan ValidacionPago.CalcularTolerancia y VentaEstadoPagoConstantes.
        /// </summary>
        private async Task ActualizarEstadoPagoVentaAsync(int venCod)
        {
            var venta = await _context.Ventas.FindAsync(venCod);
            if (venta == null) return;

            var totalPagado = await _context.Pagos
                .Where(p => p.VenCod == venCod)
                .SumAsync(p => p.PagMonto);

            // Usar tolerancia para comparación de decimales
            var tolerancia = ValidacionPago.CalcularTolerancia(venta.VenTotal);

            if (totalPagado >= venta.VenTotal - tolerancia)
            {
                venta.VenEstadoPago = VentaEstadoPagoConstantes.Pagada;
            }
            else if (totalPagado > 0)
            {
                venta.VenEstadoPago = VentaEstadoPagoConstantes.Parcial;
            }
            else
            {
                venta.VenEstadoPago = VentaEstadoPagoConstantes.Pendiente;
            }

            await _context.SaveChangesAsync();
        }
    }
}
