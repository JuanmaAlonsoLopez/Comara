namespace comara.Models.AFIP
{
    public class FacturaResponse
    {
        public bool Success { get; set; }
        public string Resultado { get; set; } = string.Empty; // A=Aprobado, R=Rechazado
        public string CAE { get; set; } = string.Empty;
        public DateTime? CAEVencimiento { get; set; }
        public long NumeroComprobante { get; set; }
        public string Observaciones { get; set; } = string.Empty;
        public List<string> Errores { get; set; } = new List<string>();
    }
}
