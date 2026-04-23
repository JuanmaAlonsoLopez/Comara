namespace comara.Services.PDF
{
    public interface IFacturaPDFService
    {
        byte[] GenerarPDFFactura(int ventaId);
        Task<byte[]> GenerarPDFFacturaAsync(int ventaId);
    }
}
