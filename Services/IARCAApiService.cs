using comara.Models.AFIP;

namespace comara.Services
{
    public interface IARCAApiService
    {
        Task<string> GetProductInfo(string productCode);
        Task<FacturaResponse> GenerarFacturaElectronica(int ventaId);
        Task<long> ObtenerUltimoNumeroComprobante(int tipoComprobante, int puntoVenta);
        Task<FacturaResponse> ConsultarFactura(int tipoComprobante, int puntoVenta, long numeroComprobante);
    }
}
