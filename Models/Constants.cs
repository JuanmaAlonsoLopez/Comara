namespace comara.Models
{
    /// <summary>
    /// Constantes para tipos de movimiento en Cuenta Corriente
    /// </summary>
    public static class MovimientoTipo
    {
        public const string Debe = "DEBE";
        public const string Haber = "HABER";
    }

    /// <summary>
    /// Constantes para estados de venta (venEstado)
    /// </summary>
    public static class VentaEstado
    {
        public const int Completada = 1;
        public const int Pendiente = 2;
        public const int Cancelada = 3;
        public const int Facturada = 4;
    }

    /// <summary>
    /// Constantes para estados de pago de venta (venEstadoPago)
    /// </summary>
    public static class VentaEstadoPagoConstantes
    {
        public const int Pendiente = 1;
        public const int Parcial = 2;
        public const int Pagada = 3;
    }

    /// <summary>
    /// Constantes para métodos de pago (ventaTipoMetodoPagos)
    /// </summary>
    public static class MetodoPago
    {
        public const int Efectivo = 5;
        public const int Cheque = 4;
        public const int CuentaCorriente = 3;
        public const int Transferencia = 2;
        public const int Tarjeta = 1;
    }

    /// <summary>
    /// Constantes para tipos de movimiento de caja
    /// </summary>
    public static class TipoMovimientoCajaConstantes
    {
        public const int Ingreso = 1;
        public const int Egreso = 2;
    }

    /// <summary>
    /// Constantes para estados de cotización
    /// </summary>
    public static class CotizacionEstadoConstantes
    {
        public const int Pendiente = 1;
        public const int Aprobada = 2;
        public const int Rechazada = 3;
        public const int Convertida = 4;
        public const int Vencida = 5;
    }

    /// <summary>
    /// Constantes para resultados de AFIP
    /// </summary>
    public static class AfipResultado
    {
        public const string Aprobado = "A";
        public const string Rechazado = "R";
        public const string Parcial = "P";
    }

    /// <summary>
    /// Punto 28: Constantes para claves de sesión (evita strings mágicos)
    /// </summary>
    public static class SessionKeys
    {
        public const string StockCriticoViewed = "StockCriticoViewed";
        public const string UltimaVenta = "UltimaVenta";
        public const string UltimaCotizacion = "UltimaCotizacion";
    }

    /// <summary>
    /// Punto 31: Constantes para validación de pagos
    /// </summary>
    public static class ValidacionPago
    {
        /// <summary>
        /// Tolerancia porcentual para validación de pagos (0.1% del monto)
        /// </summary>
        public const decimal ToleranciaRelativa = 0.001m;

        /// <summary>
        /// Tolerancia mínima absoluta (1 centavo)
        /// </summary>
        public const decimal ToleranciaMinimaAbsoluta = 0.01m;

        /// <summary>
        /// Calcula la tolerancia para un monto dado (el mayor entre relativa y absoluta)
        /// </summary>
        public static decimal CalcularTolerancia(decimal monto)
        {
            var toleranciaRelativa = Math.Abs(monto) * ToleranciaRelativa;
            return Math.Max(toleranciaRelativa, ToleranciaMinimaAbsoluta);
        }
    }

    /// <summary>
    /// Punto 32: Constantes para validación de cheques
    /// </summary>
    public static class ValidacionCheque
    {
        /// <summary>
        /// Longitud mínima del número de cheque
        /// </summary>
        public const int LongitudMinimaNumero = 6;

        /// <summary>
        /// Longitud máxima del número de cheque
        /// </summary>
        public const int LongitudMaximaNumero = 20;

        /// <summary>
        /// Días máximos hacia atrás para fecha de cheque
        /// </summary>
        public const int DiasMaximosAtras = 30;

        /// <summary>
        /// Días máximos hacia adelante para fecha de cobro
        /// </summary>
        public const int DiasMaximosAdelante = 365;
    }

    /// <summary>
    /// Punto 29: Códigos de IVA de AFIP
    /// </summary>
    public static class CodigoIvaAfip
    {
        public const int NoGravado = 1;
        public const int Exento = 2;
        public const int Cero = 3;
        public const int Diez = 4;      // 10.5%
        public const int Veintiuno = 5; // 21%
        public const int Veintisiete = 6; // 27%
    }

    /// <summary>
    /// Punto 29: Condiciones de IVA de AFIP
    /// </summary>
    public static class CondicionIvaAfip
    {
        public const int ResponsableInscripto = 1;
        public const int Monotributista = 6;
        public const int Exento = 4;
        public const int ConsumidorFinal = 5;
    }
}
