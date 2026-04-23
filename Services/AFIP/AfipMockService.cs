using comara.Models.AFIP;

namespace comara.Services.AFIP
{
    /// <summary>
    /// Servicio Mock de AFIP para testing sin conexión real
    /// Simula las respuestas de AFIP para desarrollo
    /// </summary>
    public class AfipMockService : IAfipAuthService, IAfipFacturacionService
    {
        private AfipAuthToken? _mockToken;

        // Implementación de IAfipAuthService
        public async Task<AfipAuthToken> GetAuthTokenAsync(string servicio = "wsfe")
        {
            await Task.Delay(100); // Simular latencia de red

            if (_mockToken != null && _mockToken.IsValid())
            {
                return _mockToken;
            }

            // Generar token mock
            _mockToken = new AfipAuthToken
            {
                Token = "MOCK_TOKEN_" + Guid.NewGuid().ToString("N"),
                Sign = "MOCK_SIGN_" + Guid.NewGuid().ToString("N"),
                ExpirationTime = DateTime.UtcNow.AddHours(12)
            };

            return _mockToken;
        }

        public async Task<bool> ValidateTokenAsync()
        {
            await Task.CompletedTask;
            return _mockToken != null && _mockToken.IsValid();
        }

        // Implementación de IAfipFacturacionService
        public async Task<FacturaResponse> AutorizarComprobanteAsync(FacturaRequest request)
        {
            await Task.Delay(500); // Simular latencia de AFIP

            // Generar CAE mock (13 dígitos)
            var random = new Random();
            var cae = string.Concat(Enumerable.Range(0, 13).Select(_ => random.Next(0, 10)));

            // Fecha de vencimiento CAE (10 días desde hoy)
            var vencimiento = DateTime.Now.AddDays(10);

            return new FacturaResponse
            {
                Success = true,
                CAE = cae,
                CAEVencimiento = vencimiento,
                NumeroComprobante = request.NumeroComprobante,
                Resultado = "A", // Aprobado
                Observaciones = "⚠️ MODO TESTING - Este CAE es simulado y no es válido para uso fiscal real",
                Errores = new List<string>()
            };
        }

        public async Task<long> ObtenerUltimoComprobanteAsync(int tipoComprobante, int puntoVenta)
        {
            await Task.Delay(200);

            // Retornar un número aleatorio para testing
            var random = new Random();
            return random.Next(1, 100);
        }

        public async Task<FacturaResponse> ConsultarComprobanteAsync(int tipoComprobante, int puntoVenta, long numeroComprobante)
        {
            await Task.Delay(300);

            return new FacturaResponse
            {
                Success = true,
                CAE = "9999999999999",
                CAEVencimiento = DateTime.Now.AddDays(10),
                NumeroComprobante = numeroComprobante,
                Resultado = "A",
                Observaciones = "⚠️ MODO TESTING - Consulta simulada",
                Errores = new List<string>()
            };
        }
    }
}
