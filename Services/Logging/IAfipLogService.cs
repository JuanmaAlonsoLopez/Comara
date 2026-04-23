using comara.Models;

namespace comara.Services.Logging
{
    public interface IAfipLogService
    {
        Task RegistrarLogAsync(AfipLog log);
        Task<AfipLog> RegistrarOperacionAsync(string tipoOperacion, string request, Func<Task<(bool exitoso, string response, string? error, string? cae)>> operacion, int? ventaId = null);
        Task<List<AfipLog>> ObtenerLogsRecientesAsync(int cantidad = 50);
        Task<List<AfipLog>> ObtenerLogsPorVentaAsync(int ventaId);
    }
}
