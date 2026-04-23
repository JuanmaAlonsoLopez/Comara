namespace comara.Services.PDF
{
    public interface IPresupuestoPDFService
    {
        /// <summary>
        /// Genera un PDF de presupuesto para una venta
        /// </summary>
        /// <param name="ventaId">ID de la venta</param>
        /// <returns>Bytes del PDF generado</returns>
        Task<byte[]> GenerarPDFPresupuestoAsync(int ventaId);
    }
}
