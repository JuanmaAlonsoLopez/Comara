using comara.Data;
using comara.Models;
using Microsoft.EntityFrameworkCore;
using System.Diagnostics;

namespace comara.Services.Logging
{
    public class AfipLogService : IAfipLogService
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<AfipLogService> _logger;
        private readonly IHttpContextAccessor _httpContextAccessor;

        public AfipLogService(
            ApplicationDbContext context,
            ILogger<AfipLogService> logger,
            IHttpContextAccessor httpContextAccessor)
        {
            _context = context;
            _logger = logger;
            _httpContextAccessor = httpContextAccessor;
        }

        public async Task RegistrarLogAsync(AfipLog log)
        {
            try
            {
                // Obtener IP si está disponible
                if (log.IpAddress == null && _httpContextAccessor.HttpContext != null)
                {
                    log.IpAddress = _httpContextAccessor.HttpContext.Connection.RemoteIpAddress?.ToString();
                }

                _context.AfipLogs.Add(log);
                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al registrar log de AFIP");
            }
        }

        public async Task<AfipLog> RegistrarOperacionAsync(
            string tipoOperacion,
            string request,
            Func<Task<(bool exitoso, string response, string? error, string? cae)>> operacion,
            int? ventaId = null)
        {
            var stopwatch = Stopwatch.StartNew();
            var log = new AfipLog
            {
                Fecha = DateTime.UtcNow,
                TipoOperacion = tipoOperacion,
                Request = request,
                VenCod = ventaId
            };

            try
            {
                var resultado = await operacion();

                stopwatch.Stop();

                log.Exitoso = resultado.exitoso;
                log.Response = resultado.response;
                log.MensajeError = resultado.error;
                log.CAE = resultado.cae;
                log.DuracionMs = (int)stopwatch.ElapsedMilliseconds;

                await RegistrarLogAsync(log);

                return log;
            }
            catch (Exception ex)
            {
                stopwatch.Stop();

                log.Exitoso = false;
                log.MensajeError = ex.Message;
                log.Response = ex.ToString();
                log.DuracionMs = (int)stopwatch.ElapsedMilliseconds;

                await RegistrarLogAsync(log);

                throw;
            }
        }

        public async Task<List<AfipLog>> ObtenerLogsRecientesAsync(int cantidad = 50)
        {
            return await _context.AfipLogs
                .OrderByDescending(l => l.Fecha)
                .Take(cantidad)
                .ToListAsync();
        }

        public async Task<List<AfipLog>> ObtenerLogsPorVentaAsync(int ventaId)
        {
            return await _context.AfipLogs
                .Where(l => l.VenCod == ventaId)
                .OrderByDescending(l => l.Fecha)
                .ToListAsync();
        }
    }
}
