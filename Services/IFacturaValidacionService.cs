using comara.Models;

namespace comara.Services
{
    /// <summary>
    /// Resultado de validación de tipo comprobante
    /// </summary>
    public class ValidacionComprobanteResult
    {
        public bool EsValido { get; set; }
        public string MensajeError { get; set; } = string.Empty;
        public List<string> Advertencias { get; set; } = new List<string>();
        public int? TipoComprobanteSugerido { get; set; }
    }

    /// <summary>
    /// Servicio para validar facturas según reglas AFIP
    /// </summary>
    public interface IFacturaValidacionService
    {
        /// <summary>
        /// Valida que el tipo de comprobante sea compatible con la condición IVA del cliente
        /// </summary>
        /// <param name="tipoComprobanteCodigoAfip">Código AFIP del tipo de comprobante (1=FC A, 6=FC B, 11=FC C)</param>
        /// <param name="condicionIVACodigoAfip">Código AFIP de la condición IVA del cliente (1=RI, 5=CF, 6=MT, 4=Exento)</param>
        /// <returns>Resultado de la validación</returns>
        ValidacionComprobanteResult ValidarTipoComprobanteCliente(int tipoComprobanteCodigoAfip, int condicionIVACodigoAfip);

        /// <summary>
        /// Valida que el cliente tenga todos los datos necesarios para facturar
        /// </summary>
        /// <param name="cliente">Cliente a validar</param>
        /// <returns>Resultado de la validación</returns>
        ValidacionComprobanteResult ValidarDatosCliente(Cliente cliente);

        /// <summary>
        /// Valida que todos los artículos de la venta tengan IVA configurado
        /// </summary>
        /// <param name="detalles">Lista de detalles de venta</param>
        /// <returns>Resultado de la validación</returns>
        ValidacionComprobanteResult ValidarArticulosVenta(List<DetalleVenta> detalles);

        /// <summary>
        /// Sugiere el tipo de comprobante según la condición IVA del cliente
        /// </summary>
        /// <param name="condicionIVACodigoAfip">Código AFIP de la condición IVA</param>
        /// <returns>Código AFIP del tipo de comprobante sugerido</returns>
        int SugerirTipoComprobante(int condicionIVACodigoAfip);

        /// <summary>
        /// Obtiene los tipos de comprobante válidos para una condición IVA
        /// </summary>
        /// <param name="condicionIVACodigoAfip">Código AFIP de la condición IVA</param>
        /// <returns>Lista de códigos AFIP de tipos de comprobante válidos</returns>
        List<int> ObtenerTiposComprobanteValidos(int condicionIVACodigoAfip);

        /// <summary>
        /// Valida que el CAE de una factura esté vigente
        /// </summary>
        /// <param name="caeVencimiento">Fecha de vencimiento del CAE</param>
        /// <returns>Resultado de la validación con estado y advertencias</returns>
        ValidacionCAEResult ValidarCAEVigente(DateTime? caeVencimiento);
    }

    /// <summary>
    /// Resultado de validación de vigencia del CAE
    /// </summary>
    public class ValidacionCAEResult
    {
        /// <summary>
        /// Indica si el CAE está vigente (no ha vencido)
        /// </summary>
        public bool EstaVigente { get; set; }

        /// <summary>
        /// Indica si el CAE está próximo a vencer (menos de 3 días)
        /// </summary>
        public bool ProximoAVencer { get; set; }

        /// <summary>
        /// Días restantes hasta el vencimiento (negativo si ya venció)
        /// </summary>
        public int DiasRestantes { get; set; }

        /// <summary>
        /// Mensaje descriptivo del estado del CAE
        /// </summary>
        public string Mensaje { get; set; } = string.Empty;

        /// <summary>
        /// Nivel de severidad: "success", "warning", "danger"
        /// </summary>
        public string Severidad { get; set; } = "success";
    }
}
