using comara.Models;

namespace comara.Services
{
    public class FacturaValidacionService : IFacturaValidacionService
    {
        // Matriz de validación: Tipo Comprobante → Condiciones IVA válidas
        // Basada en las reglas de AFIP para facturación electrónica
        private readonly Dictionary<int, List<int>> _matrizValidacion = new()
        {
            // Factura A (1) → Solo RI (1)
            { 1, new List<int> { 1 } },

            // Factura B (6) → Consumidor Final (5), Monotributo (6), Exento (4)
            { 6, new List<int> { 5, 6, 4 } },

            // Factura C (11) → Monotributo (6), Exento (4)
            { 11, new List<int> { 6, 4 } },

            // Nota de Crédito A (3) → Solo RI (1)
            { 3, new List<int> { 1 } },

            // Nota de Crédito B (8) → Consumidor Final (5), Monotributo (6), Exento (4)
            { 8, new List<int> { 5, 6, 4 } },

            // Nota de Crédito C (13) → Monotributo (6), Exento (4)
            { 13, new List<int> { 6, 4 } }
        };

        public ValidacionComprobanteResult ValidarTipoComprobanteCliente(
            int tipoComprobanteCodigoAfip,
            int condicionIVACodigoAfip)
        {
            var result = new ValidacionComprobanteResult();

            // Verificar si existe el tipo de comprobante en la matriz
            if (!_matrizValidacion.ContainsKey(tipoComprobanteCodigoAfip))
            {
                result.EsValido = false;
                result.MensajeError = $"Tipo de comprobante {tipoComprobanteCodigoAfip} no es válido.";
                return result;
            }

            // Verificar compatibilidad
            var condicionesValidas = _matrizValidacion[tipoComprobanteCodigoAfip];
            if (!condicionesValidas.Contains(condicionIVACodigoAfip))
            {
                result.EsValido = false;
                result.MensajeError = ObtenerMensajeErrorValidacion(tipoComprobanteCodigoAfip, condicionIVACodigoAfip);
                result.TipoComprobanteSugerido = SugerirTipoComprobante(condicionIVACodigoAfip);
                return result;
            }

            // Advertencias adicionales
            if (tipoComprobanteCodigoAfip == 1 && condicionIVACodigoAfip == 1)
            {
                result.Advertencias.Add("Factura A requiere que el cliente tenga CUIT (tipo documento 80).");
            }

            result.EsValido = true;
            return result;
        }

        public ValidacionComprobanteResult ValidarDatosCliente(Cliente cliente)
        {
            var result = new ValidacionComprobanteResult { EsValido = true };

            if (cliente == null)
            {
                result.EsValido = false;
                result.MensajeError = "El cliente no puede ser nulo.";
                return result;
            }

            if (cliente.CliTipoDoc == null)
            {
                result.EsValido = false;
                result.MensajeError = "El cliente no tiene configurado el Tipo de Documento. Por favor, edite el cliente y asigne un tipo de documento.";
                return result;
            }

            if (string.IsNullOrWhiteSpace(cliente.CliNumDoc))
            {
                result.EsValido = false;
                result.MensajeError = "El cliente no tiene configurado el Número de Documento (CUIT/DNI). Por favor, edite el cliente.";
                return result;
            }

            if (cliente.CliCondicionIVA == null)
            {
                result.EsValido = false;
                result.MensajeError = "El cliente no tiene configurada la Condición de IVA. Por favor, edite el cliente y asigne una condición.";
                return result;
            }

            // C6: Validar que Responsable Inscripto (para Factura A) tenga CUIT
            // Según normativa AFIP, Factura A REQUIERE CUIT obligatoriamente
            if (cliente.CondicionIVA?.CodigoAfip == 1 && cliente.TipoDocumento?.CodigoAfip != 80)
            {
                // Esto es un ERROR, no una advertencia, porque Factura A requiere CUIT
                result.EsValido = false;
                result.MensajeError = $"El cliente '{cliente.CliNombre}' es Responsable Inscripto pero no tiene CUIT configurado (tipo documento 80). " +
                    "Para emitir Factura A es obligatorio que el cliente tenga CUIT. " +
                    "Por favor, configure el tipo de documento como CUIT en la ficha del cliente.";
                return result;
            }

            // C5: Validar formato y dígito verificador de CUIT si corresponde
            if (cliente.TipoDocumento?.CodigoAfip == 80 && !string.IsNullOrWhiteSpace(cliente.CliNumDoc))
            {
                var errorCuit = CuitValidatorService.ObtenerErrorValidacion(cliente.CliNumDoc);
                if (errorCuit != null)
                {
                    result.EsValido = false;
                    result.MensajeError = $"Error en el CUIT del cliente '{cliente.CliNombre}': {errorCuit}";
                    return result;
                }
            }

            return result;
        }

        public ValidacionComprobanteResult ValidarArticulosVenta(List<DetalleVenta> detalles)
        {
            var result = new ValidacionComprobanteResult { EsValido = true };

            if (detalles == null || !detalles.Any())
            {
                result.EsValido = false;
                result.MensajeError = "La venta debe tener al menos un artículo.";
                return result;
            }

            var articulosSinIVA = detalles
                .Where(d => d.Articulo != null && d.Articulo.IvaCod == 0)
                .Select(d => d.Articulo?.ArtDesc ?? "Sin descripción")
                .ToList();

            if (articulosSinIVA.Any())
            {
                result.Advertencias.Add($"Los siguientes artículos no tienen IVA configurado: {string.Join(", ", articulosSinIVA)}. Se asumirá IVA no gravado (0%).");
            }

            return result;
        }

        public int SugerirTipoComprobante(int condicionIVACodigoAfip)
        {
            return condicionIVACodigoAfip switch
            {
                1 => 1,  // Responsable Inscripto → Factura A
                5 => 6,  // Consumidor Final → Factura B
                6 => 6,  // Monotributo → Factura B (o C, pero B es más común)
                4 => 6,  // Exento → Factura B
                _ => 6   // Por defecto Factura B
            };
        }

        public List<int> ObtenerTiposComprobanteValidos(int condicionIVACodigoAfip)
        {
            var tiposValidos = new List<int>();

            foreach (var kvp in _matrizValidacion)
            {
                // Solo incluir facturas (no notas de crédito)
                // Facturas: 1, 6, 11
                // Notas de Crédito: 3, 8, 13
                if (kvp.Key <= 11 && kvp.Value.Contains(condicionIVACodigoAfip))
                {
                    tiposValidos.Add(kvp.Key);
                }
            }

            return tiposValidos.OrderBy(x => x).ToList();
        }

        public ValidacionCAEResult ValidarCAEVigente(DateTime? caeVencimiento)
        {
            var result = new ValidacionCAEResult();

            if (!caeVencimiento.HasValue)
            {
                result.EstaVigente = false;
                result.ProximoAVencer = false;
                result.DiasRestantes = 0;
                result.Mensaje = "La factura no tiene CAE asignado.";
                result.Severidad = "warning";
                return result;
            }

            // Calcular días restantes considerando la fecha local
            // El CAE vence a las 23:59:59 del día indicado
            var fechaVencimiento = caeVencimiento.Value.Date;
            var hoy = DateTime.Today;
            var diasRestantes = (fechaVencimiento - hoy).Days;

            result.DiasRestantes = diasRestantes;

            if (diasRestantes < 0)
            {
                // CAE vencido
                result.EstaVigente = false;
                result.ProximoAVencer = false;
                result.Mensaje = $"El CAE venció hace {Math.Abs(diasRestantes)} día(s) ({fechaVencimiento:dd/MM/yyyy}). " +
                    "Esta factura ya no es válida fiscalmente.";
                result.Severidad = "danger";
            }
            else if (diasRestantes == 0)
            {
                // Vence hoy
                result.EstaVigente = true;
                result.ProximoAVencer = true;
                result.Mensaje = "El CAE vence HOY. Asegúrese de entregar la factura al cliente antes de la medianoche.";
                result.Severidad = "warning";
            }
            else if (diasRestantes <= 3)
            {
                // Próximo a vencer (3 días o menos)
                result.EstaVigente = true;
                result.ProximoAVencer = true;
                result.Mensaje = $"El CAE vence en {diasRestantes} día(s) ({fechaVencimiento:dd/MM/yyyy}). " +
                    "Se recomienda entregar la factura al cliente pronto.";
                result.Severidad = "warning";
            }
            else
            {
                // CAE vigente sin problemas
                result.EstaVigente = true;
                result.ProximoAVencer = false;
                result.Mensaje = $"CAE vigente hasta el {fechaVencimiento:dd/MM/yyyy} ({diasRestantes} días restantes).";
                result.Severidad = "success";
            }

            return result;
        }

        private string ObtenerMensajeErrorValidacion(int tipoComprobante, int condicionIVA)
        {
            var nombreComprobante = tipoComprobante switch
            {
                1 => "Factura A",
                6 => "Factura B",
                11 => "Factura C",
                3 => "Nota de Crédito A",
                8 => "Nota de Crédito B",
                13 => "Nota de Crédito C",
                _ => $"Comprobante tipo {tipoComprobante}"
            };

            var nombreCondicion = condicionIVA switch
            {
                1 => "Responsable Inscripto",
                5 => "Consumidor Final",
                6 => "Monotributo",
                4 => "Exento",
                2 => "Responsable No Inscripto",
                3 => "No Categorizado",
                _ => $"Condición IVA código {condicionIVA}"
            };

            var tipoSugerido = SugerirTipoComprobante(condicionIVA);
            var nombreSugerido = tipoSugerido switch
            {
                1 => "Factura A",
                6 => "Factura B",
                11 => "Factura C",
                _ => $"tipo {tipoSugerido}"
            };

            return $"{nombreComprobante} no es compatible con la condición IVA '{nombreCondicion}' del cliente. " +
                   $"Para este cliente, considere usar {nombreSugerido}.";
        }
    }
}
