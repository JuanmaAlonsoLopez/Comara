using comara.Models;
using comara.Models.ViewModels;

namespace comara.Services
{
    public interface ICajaService
    {
        /// <summary>
        /// Obtiene los datos del dashboard de caja para un mes y año específicos
        /// </summary>
        Task<CajaIndexViewModel> GetCajaDashboardAsync(int mes, int anio);

        /// <summary>
        /// Registra un pago de cliente con todos sus componentes (cuenta corriente, pago, cheque si aplica)
        /// </summary>
        Task<ResultadoOperacion> RegistrarPagoAsync(RegistrarPagoViewModel viewModel);

        /// <summary>
        /// Registra un movimiento de caja (ingreso o egreso)
        /// </summary>
        Task<ResultadoOperacion> RegistrarMovimientoAsync(MovimientoCajaViewModel viewModel);

        /// <summary>
        /// Obtiene el saldo actual de un cliente
        /// </summary>
        Task<decimal> GetSaldoClienteAsync(int clienteId);

        /// <summary>
        /// Valida los datos de un pago antes de procesarlo
        /// </summary>
        Task<ResultadoValidacion> ValidarPagoAsync(RegistrarPagoViewModel viewModel);

        /// <summary>
        /// Valida los datos de un cheque
        /// </summary>
        ResultadoValidacion ValidarDatosCheque(RegistrarPagoViewModel viewModel);
    }

    public class ResultadoOperacion
    {
        public bool Exitoso { get; set; }
        public string? Mensaje { get; set; }
        public string? Error { get; set; }
        public int? IdGenerado { get; set; }

        public static ResultadoOperacion Ok(string mensaje, int? id = null) => new()
        {
            Exitoso = true,
            Mensaje = mensaje,
            IdGenerado = id
        };

        public static ResultadoOperacion Fallo(string error) => new()
        {
            Exitoso = false,
            Error = error
        };
    }

    public class ResultadoValidacion
    {
        public bool EsValido { get; set; }
        public List<string> Errores { get; set; } = new();

        public static ResultadoValidacion Valido() => new() { EsValido = true };

        public static ResultadoValidacion Invalido(params string[] errores) => new()
        {
            EsValido = false,
            Errores = errores.ToList()
        };
    }
}
