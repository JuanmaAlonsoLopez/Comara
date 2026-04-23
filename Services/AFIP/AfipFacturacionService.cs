using comara.Models.AFIP;
using Microsoft.Extensions.Options;
using TuApp.Integraciones.Afip.Wsfe;
using System.Text.Json;

namespace comara.Services.AFIP
{
    /// <summary>
    /// Servicio de facturación electrónica con AFIP/ARCA usando WSFE
    /// Utiliza el cliente SOAP generado por dotnet-svcutil
    /// </summary>
    public class AfipFacturacionService : IAfipFacturacionService
    {
        private readonly AfipConfig _config;
        private readonly IAfipAuthService _authService;
        private readonly ILogger<AfipFacturacionService> _logger;
        private readonly IHttpClientFactory _httpClientFactory;

        public AfipFacturacionService(
            IOptions<AfipConfig> config,
            IAfipAuthService authService,
            ILogger<AfipFacturacionService> logger,
            IHttpClientFactory httpClientFactory)
        {
            _config = config.Value;
            _authService = authService;
            _logger = logger;
            _httpClientFactory = httpClientFactory;
        }

        /// <summary>
        /// Obtiene el último número de comprobante autorizado por AFIP
        /// </summary>
        public async Task<long> ObtenerUltimoComprobanteAsync(int tipoComprobante, int puntoVenta)
        {
            try
            {
                // 1. Obtener token de autenticación
                var auth = await _authService.GetAuthTokenAsync("wsfe");

                // 2. Crear cliente SOAP
                var client = CreateSoapClient();

                // 3. Construir request
                var authRequest = new FEAuthRequest
                {
                    Token = auth.Token,
                    Sign = auth.Sign,
                    Cuit = _config.CUIT
                };

                // 4. Llamar al servicio WSFE
                _logger.LogDebug("Consultando último comprobante autorizado: Tipo={TipoComprobante}, PtoVta={PuntoVenta}",
                    tipoComprobante, puntoVenta);

                var response = await client.FECompUltimoAutorizadoAsync(authRequest, puntoVenta, tipoComprobante);

                // 5. Validar respuesta
                if (response?.Body?.FECompUltimoAutorizadoResult == null)
                {
                    throw new Exception("Respuesta inválida de AFIP");
                }

                var result = response.Body.FECompUltimoAutorizadoResult;

                // Verificar errores
                if (result.Errors != null && result.Errors.Length > 0)
                {
                    var errores = string.Join("; ", result.Errors.Select(e => $"{e.Code}: {e.Msg}"));
                    _logger.LogError("Error al obtener último comprobante: {Errores}", errores);
                    throw new Exception($"Error AFIP: {errores}");
                }

                var ultimoNro = result.CbteNro;
                _logger.LogInformation("Último comprobante autorizado: {UltimoNumero}", ultimoNro);

                return ultimoNro;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al obtener último comprobante de AFIP");
                throw;
            }
        }

        /// <summary>
        /// Autoriza un comprobante (factura) con AFIP
        /// </summary>
        public async Task<FacturaResponse> AutorizarComprobanteAsync(FacturaRequest request)
        {
            try
            {
                // 1. Obtener token de autenticación
                var auth = await _authService.GetAuthTokenAsync("wsfe");

                // 2. Crear cliente SOAP
                var client = CreateSoapClient();

                // 3. Construir request de AFIP
                var authRequest = new FEAuthRequest
                {
                    Token = auth.Token,
                    Sign = auth.Sign,
                    Cuit = _config.CUIT
                };

                // Cabecera
                var cabecera = new FECAECabRequest
                {
                    CantReg = 1,
                    PtoVta = request.PuntoVenta,
                    CbteTipo = request.TipoComprobante
                };

                // Detalle
                var concepto = request.Concepto == "Productos" ? 1 : (request.Concepto == "Servicios" ? 2 : 3);

                // C2: Usar Math.Round al convertir decimal a double para evitar pérdida de precisión
                // AFIP rechaza si hay diferencias de centavos entre neto + IVA y total
                var detalle = new FECAEDetRequest
                {
                    Concepto = concepto,
                    DocTipo = request.TipoDocCliente,
                    DocNro = request.NumeroDocCliente,
                    CbteDesde = request.NumeroComprobante,
                    CbteHasta = request.NumeroComprobante,
                    CbteFch = request.Fecha.ToString("yyyyMMdd"),
                    ImpTotal = Math.Round((double)request.ImporteTotal, 2),
                    ImpTotConc = Math.Round((double)request.ImporteNoGravado, 2), // Usar ImporteNoGravado
                    ImpNeto = Math.Round((double)request.ImporteNeto, 2),
                    ImpOpEx = Math.Round((double)request.ImporteExento, 2),
                    ImpTrib = Math.Round((double)request.ImporteTributos, 2),
                    ImpIVA = Math.Round((double)request.ImporteIVA, 2),
                    MonId = "PES",
                    MonCotiz = Math.Round((double)request.MonedaCotizacion, 6), // Cotización puede tener más decimales
                    CondicionIVAReceptorId = request.CondicionIVAReceptor // Condición IVA del receptor
                };

                // Items de IVA - C2: Aplicar Math.Round también a los items de IVA
                if (request.ItemsIVA != null && request.ItemsIVA.Count > 0)
                {
                    detalle.Iva = request.ItemsIVA.Select(iva => new AlicIva
                    {
                        Id = iva.CodigoIVA,
                        BaseImp = Math.Round((double)iva.BaseImponible, 2),
                        Importe = Math.Round((double)iva.Importe, 2)
                    }).ToArray();
                }

                var caeRequest = new FECAERequest
                {
                    FeCabReq = cabecera,
                    FeDetReq = new[] { detalle }
                };

                // 4. Llamar al servicio WSFE
                _logger.LogInformation("Solicitando autorización de comprobante: Tipo={TipoComprobante}, PtoVta={PuntoVenta}, Nro={Numero}",
                    request.TipoComprobante, request.PuntoVenta, request.NumeroComprobante);

                // Log del request
                var requestJson = JsonSerializer.Serialize(new
                {
                    CbteTipo = request.TipoComprobante,
                    PtoVta = request.PuntoVenta,
                    CbteNro = request.NumeroComprobante,
                    Fecha = request.Fecha,
                    DocTipo = request.TipoDocCliente,
                    DocNro = request.NumeroDocCliente,
                    ImpTotal = request.ImporteTotal,
                    ImpNeto = request.ImporteNeto,
                    ImpIVA = request.ImporteIVA,
                    ItemsIVA = request.ItemsIVA
                });

                _logger.LogDebug("Request AFIP: {Request}", requestJson);

                var response = await client.FECAESolicitarAsync(authRequest, caeRequest);

                // Log de la respuesta
                var responseJson = response?.Body?.FECAESolicitarResult != null
                    ? JsonSerializer.Serialize(new
                    {
                        Errors = response.Body.FECAESolicitarResult.Errors?.Select(e => new { e.Code, e.Msg }),
                        Events = response.Body.FECAESolicitarResult.Events?.Select(e => new { e.Code, e.Msg }),
                        FeDetResp = response.Body.FECAESolicitarResult.FeDetResp?.FirstOrDefault() != null
                            ? new
                            {
                                CAE = response.Body.FECAESolicitarResult.FeDetResp[0].CAE,
                                CAEFchVto = response.Body.FECAESolicitarResult.FeDetResp[0].CAEFchVto,
                                Resultado = response.Body.FECAESolicitarResult.FeDetResp[0].Resultado,
                                Observaciones = response.Body.FECAESolicitarResult.FeDetResp[0].Observaciones?.Select(o => new { o.Code, o.Msg })
                            }
                            : null
                    })
                    : "null";

                _logger.LogDebug("Response AFIP: {Response}", responseJson);

                // 5. Parsear respuesta
                return ParseAutorizacionResponse(response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al autorizar comprobante con AFIP");
                return new FacturaResponse
                {
                    Success = false,
                    Errores = new List<string> { ex.Message }
                };
            }
        }

        /// <summary>
        /// Consulta un comprobante ya emitido
        /// </summary>
        public async Task<FacturaResponse> ConsultarComprobanteAsync(int tipoComprobante, int puntoVenta, long numeroComprobante)
        {
            try
            {
                // 1. Obtener token de autenticación
                var auth = await _authService.GetAuthTokenAsync("wsfe");

                // 2. Crear cliente SOAP
                var client = CreateSoapClient();

                // 3. Construir request
                var authRequest = new FEAuthRequest
                {
                    Token = auth.Token,
                    Sign = auth.Sign,
                    Cuit = _config.CUIT
                };

                var consultaReq = new FECompConsultaReq
                {
                    CbteTipo = tipoComprobante,
                    PtoVta = puntoVenta,
                    CbteNro = numeroComprobante
                };

                // 4. Llamar al servicio
                _logger.LogDebug("Consultando comprobante: Tipo={TipoComprobante}, PtoVta={PuntoVenta}, Nro={NumeroComprobante}",
                    tipoComprobante, puntoVenta, numeroComprobante);

                var response = await client.FECompConsultarAsync(authRequest, consultaReq);

                // 5. Parsear respuesta
                return ParseConsultaResponse(response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al consultar comprobante en AFIP");
                return new FacturaResponse
                {
                    Success = false,
                    Errores = new List<string> { ex.Message }
                };
            }
        }

        /// <summary>
        /// Crea una instancia del cliente SOAP configurado para el ambiente correcto
        /// </summary>
        private ServiceSoapClient CreateSoapClient()
        {
            // Determinar el endpoint según el ambiente
            var endpointConfig = _config.Ambiente == "Produccion"
                ? ServiceSoapClient.EndpointConfiguration.ServiceSoap
                : ServiceSoapClient.EndpointConfiguration.ServiceSoap;

            // Crear cliente con HttpClientFactory para mejor manejo de conexiones
            var httpClient = _httpClientFactory.CreateClient("AfipWSFE");

            // Configurar el endpoint URL correcto
            var client = new ServiceSoapClient(endpointConfig);

            // Actualizar la URL del endpoint según el ambiente
            client.Endpoint.Address = new System.ServiceModel.EndpointAddress(_config.UrlWSFEv1);

            _logger.LogDebug("Cliente SOAP creado para ambiente: {Ambiente}, URL: {URL}",
                _config.Ambiente, _config.UrlWSFEv1);

            return client;
        }

        /// <summary>
        /// Parsea la respuesta de FECAESolicitar
        /// </summary>
        private FacturaResponse ParseAutorizacionResponse(FECAESolicitarResponse response)
        {
            if (response?.Body?.FECAESolicitarResult == null)
            {
                return new FacturaResponse
                {
                    Success = false,
                    Errores = new List<string> { "Respuesta inválida de AFIP" }
                };
            }

            var result = response.Body.FECAESolicitarResult;

            // Verificar errores globales
            var errores = new List<string>();
            if (result.Errors != null && result.Errors.Length > 0)
            {
                errores.AddRange(result.Errors.Select(e => $"{e.Code}: {e.Msg}"));
            }

            // Verificar si hay detalles de respuesta
            if (result.FeDetResp == null || result.FeDetResp.Length == 0)
            {
                return new FacturaResponse
                {
                    Success = false,
                    Errores = errores.Count > 0 ? errores : new List<string> { "No se recibió respuesta de detalle" }
                };
            }

            var detResp = result.FeDetResp[0];

            // Verificar observaciones
            var observaciones = new List<string>();
            if (detResp.Observaciones != null && detResp.Observaciones.Length > 0)
            {
                observaciones.AddRange(detResp.Observaciones.Select(o => $"{o.Code}: {o.Msg}"));
            }

            // Parsear fecha de vencimiento CAE
            DateTime? caeVencimiento = null;
            if (!string.IsNullOrEmpty(detResp.CAEFchVto))
            {
                if (DateTime.TryParseExact(detResp.CAEFchVto, "yyyyMMdd", null,
                    System.Globalization.DateTimeStyles.None, out var vtoDate))
                {
                    // IMPORTANTE: Convertir a UTC a mediodía para evitar problemas de zona horaria
                    caeVencimiento = new DateTime(vtoDate.Year, vtoDate.Month, vtoDate.Day, 12, 0, 0, DateTimeKind.Utc);
                }
            }

            var success = detResp.Resultado == "A" && !string.IsNullOrEmpty(detResp.CAE);

            return new FacturaResponse
            {
                Success = success,
                Resultado = detResp.Resultado ?? "R",
                CAE = detResp.CAE ?? string.Empty,
                CAEVencimiento = caeVencimiento,
                NumeroComprobante = detResp.CbteDesde,
                Observaciones = observaciones.Count > 0 ? string.Join("; ", observaciones) : string.Empty,
                Errores = errores
            };
        }

        /// <summary>
        /// Parsea la respuesta de FECompConsultar
        /// </summary>
        private FacturaResponse ParseConsultaResponse(FECompConsultarResponse response)
        {
            if (response?.Body?.FECompConsultarResult?.ResultGet == null)
            {
                return new FacturaResponse
                {
                    Success = false,
                    Errores = new List<string> { "Respuesta inválida de AFIP" }
                };
            }

            var result = response.Body.FECompConsultarResult.ResultGet;

            DateTime? caeVencimiento = null;
            if (!string.IsNullOrEmpty(result.FchVto))
            {
                if (DateTime.TryParseExact(result.FchVto, "yyyyMMdd", null,
                    System.Globalization.DateTimeStyles.None, out var vtoDate))
                {
                    caeVencimiento = vtoDate;
                }
            }

            return new FacturaResponse
            {
                Success = !string.IsNullOrEmpty(result.CodAutorizacion),
                Resultado = result.Resultado ?? string.Empty,
                CAE = result.CodAutorizacion ?? string.Empty,
                CAEVencimiento = caeVencimiento,
                NumeroComprobante = result.CbteDesde,
                Errores = new List<string>()
            };
        }
    }
}
