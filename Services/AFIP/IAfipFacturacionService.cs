using comara.Models.AFIP;

namespace comara.Services.AFIP
{
    public interface IAfipFacturacionService
    {
        Task<FacturaResponse> AutorizarComprobanteAsync(FacturaRequest request);
        Task<long> ObtenerUltimoComprobanteAsync(int tipoComprobante, int puntoVenta);
        Task<FacturaResponse> ConsultarComprobanteAsync(int tipoComprobante, int puntoVenta, long numeroComprobante);
    }
}
