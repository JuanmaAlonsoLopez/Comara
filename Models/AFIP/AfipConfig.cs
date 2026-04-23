namespace comara.Models.AFIP
{
    public class AfipConfig
    {
        public bool UsarModoTesting { get; set; } = false;
        public bool ModoProduccion { get; set; } = false;
        public string CuitRepresentado { get; set; } = string.Empty;
        public long CUIT => long.TryParse(CuitRepresentado, out var cuit) ? cuit : 0;
        public string CertificadoPath { get; set; } = string.Empty;
        public string CertificadoPassword { get; set; } = string.Empty;
        public int PuntoVenta { get; set; }

        // URLs configurables desde appsettings.json
        public string UrlWsaa { get; set; } = string.Empty;
        public string UrlWsfe { get; set; } = string.Empty;

        // Mantener compatibilidad con código existente
        public string Ambiente => ModoProduccion ? "Produccion" : "Homologacion";

        // URLs por defecto si no están en appsettings (compatibilidad hacia atrás)
        public string UrlWSAA => !string.IsNullOrEmpty(UrlWsaa)
            ? UrlWsaa
            : (ModoProduccion
                ? "https://wsaa.afip.gov.ar/ws/services/LoginCms"
                : "https://wsaahomo.afip.gov.ar/ws/services/LoginCms");

        public string UrlWSFEv1 => !string.IsNullOrEmpty(UrlWsfe)
            ? UrlWsfe
            : (ModoProduccion
                ? "https://servicios1.afip.gov.ar/wsfev1/service.asmx"
                : "https://wswhomo.afip.gov.ar/wsfev1/service.asmx");
    }
}
