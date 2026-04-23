using System.Security.Cryptography.Pkcs;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using System.Xml;
using comara.Data;
using comara.Models.AFIP;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Options;

namespace comara.Services.AFIP
{
    /// <summary>
    /// Servicio de autenticación con AFIP/ARCA usando WSAA
    /// Implementa caché en PostgreSQL para evitar llamadas innecesarias
    /// </summary>
    public class AfipAuthService : IAfipAuthService
    {
        private readonly AfipConfig _config;
        private readonly ApplicationDbContext _context;
        private readonly ILogger<AfipAuthService> _logger;
        private readonly SemaphoreSlim _semaphore = new SemaphoreSlim(1, 1);

        public AfipAuthService(
            IOptions<AfipConfig> config,
            ApplicationDbContext context,
            ILogger<AfipAuthService> logger)
        {
            _config = config.Value;
            _context = context;
            _logger = logger;
        }

        /// <summary>
        /// Obtiene un token de autenticación válido
        /// LÓGICA DE CACHÉ CRÍTICA: Consulta primero la DB antes de llamar a AFIP
        /// </summary>
        public async Task<AfipAuthToken> GetAuthTokenAsync(string servicio = "wsfe")
        {
            await _semaphore.WaitAsync();
            try
            {
                var cuitStr = _config.CUIT.ToString();
                var environment = _config.Ambiente;

                // 1. CONSULTAR LA BASE DE DATOS PRIMERO
                var cachedTicket = await _context.Set<AfipAuthTicket>()
                    .Where(t => t.CuitRepresentado == cuitStr
                                && t.Environment == environment
                                && t.ExpirationTime > DateTime.UtcNow.AddMinutes(10))
                    .OrderByDescending(t => t.GeneratedAt)
                    .FirstOrDefaultAsync();

                // 2. Si existe un ticket válido en caché, devolverlo
                if (cachedTicket != null && cachedTicket.IsValid(10))
                {
                    _logger.LogInformation("Token válido encontrado en caché para CUIT {CUIT} en {Ambiente}",
                        cuitStr, environment);

                    return new AfipAuthToken
                    {
                        Token = cachedTicket.Token,
                        Sign = cachedTicket.Sign,
                        ExpirationTime = cachedTicket.ExpirationTime
                    };
                }

                // 3. Si no existe o venció, generar uno nuevo
                _logger.LogInformation("Generando nuevo token para CUIT {CUIT} en {Ambiente}",
                    cuitStr, environment);

                var newToken = await GenerateNewTokenAsync(servicio);

                // 4. Guardar el nuevo token en la base de datos
                var newTicket = new AfipAuthTicket
                {
                    CuitRepresentado = cuitStr,
                    Token = newToken.Token,
                    Sign = newToken.Sign,
                    GeneratedAt = DateTime.UtcNow,
                    ExpirationTime = newToken.ExpirationTime,
                    Environment = environment
                };

                _context.Set<AfipAuthTicket>().Add(newTicket);
                await _context.SaveChangesAsync();

                _logger.LogInformation("Token guardado en caché. Expira en: {ExpirationTime}",
                    newToken.ExpirationTime);

                return newToken;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al obtener token de autenticación AFIP");
                throw;
            }
            finally
            {
                _semaphore.Release();
            }
        }

        public async Task<bool> ValidateTokenAsync()
        {
            try
            {
                var token = await GetAuthTokenAsync();
                return token.IsValid();
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// Genera un nuevo token llamando a WSAA de AFIP
        /// Usa System.Security.Cryptography.Pkcs para la firma CMS
        /// </summary>
        private async Task<AfipAuthToken> GenerateNewTokenAsync(string servicio)
        {
            try
            {
                // 1. Crear el TRA (Ticket de Requerimiento de Acceso)
                var tra = CreateTRA(servicio);

                // 2. Firmar el TRA con CMS usando el certificado .p12
                var traFirmado = SignTRAWithCMS(tra);

                // 3. Enviar a WSAA y obtener respuesta
                var response = await SendToWSAA(traFirmado);

                // 4. Parsear respuesta y extraer token y sign
                return ParseWSAAResponse(response);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al generar nuevo token AFIP");
                throw new Exception($"Error al autenticar con AFIP: {ex.Message}", ex);
            }
        }

        /// <summary>
        /// Crea el XML del TRA (Ticket de Requerimiento de Acceso)
        /// IMPORTANTE: AFIP requiere tiempo en horario de Argentina (UTC-3)
        /// </summary>
        private string CreateTRA(string servicio)
        {
            // Obtener hora actual de Argentina (UTC-3)
            // Usar offset fijo de -3 horas para compatibilidad multiplataforma
            var now = DateTime.UtcNow.AddHours(-3);

            var uniqueId = Convert.ToInt64((DateTime.UtcNow - new DateTime(1970, 1, 1)).TotalSeconds);

            // Restar 1 minuto para evitar problemas de sincronización con el servidor de AFIP
            // AFIP rechaza si el generationTime está "en el futuro"
            var generationTime = now.AddMinutes(-1);
            var expirationTime = now.AddHours(12);

            // Formatear en formato ISO 8601 sin zona horaria (AFIP espera formato yyyy-MM-ddTHH:mm:ss)
            var generationTimeStr = generationTime.ToString("yyyy-MM-ddTHH:mm:ss");
            var expirationTimeStr = expirationTime.ToString("yyyy-MM-ddTHH:mm:ss");

            var tra = $@"<?xml version=""1.0"" encoding=""UTF-8""?>
<loginTicketRequest version=""1.0"">
    <header>
        <uniqueId>{uniqueId}</uniqueId>
        <generationTime>{generationTimeStr}</generationTime>
        <expirationTime>{expirationTimeStr}</expirationTime>
    </header>
    <service>{servicio}</service>
</loginTicketRequest>";

            _logger.LogInformation("TRA generado - UTC Now: {UtcNow}, Argentina Time: {ArgTime}, Generation: {GenTime}, Expiration: {ExpTime}",
                DateTime.UtcNow.ToString("yyyy-MM-ddTHH:mm:ss"),
                now.ToString("yyyy-MM-ddTHH:mm:ss"),
                generationTimeStr,
                expirationTimeStr);
            _logger.LogDebug("TRA completo: {TRA}", tra);

            return tra;
        }

        /// <summary>
        /// Firma el TRA usando CMS (Cryptographic Message Syntax) con System.Security.Cryptography.Pkcs
        /// Compatible con Linux/Docker - carga el certificado desde archivo
        /// </summary>
        private string SignTRAWithCMS(string tra)
        {
            // Cargar certificado desde archivo .p12
            if (!File.Exists(_config.CertificadoPath))
            {
                throw new FileNotFoundException($"Certificado no encontrado en: {_config.CertificadoPath}");
            }

            // Cargar certificado con soporte multiplataforma
            X509Certificate2 cert;
            try
            {
                cert = new X509Certificate2(
                    _config.CertificadoPath,
                    _config.CertificadoPassword,
                    X509KeyStorageFlags.Exportable | X509KeyStorageFlags.PersistKeySet
                );
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error al cargar certificado desde {Path}", _config.CertificadoPath);
                throw new Exception($"Error al cargar certificado: {ex.Message}", ex);
            }

            // Validar que el certificado tenga clave privada
            if (!cert.HasPrivateKey)
            {
                throw new Exception("El certificado no contiene una clave privada");
            }

            // Convertir TRA a bytes
            var traBytes = Encoding.UTF8.GetBytes(tra);

            // Crear ContentInfo para CMS
            var contentInfo = new ContentInfo(traBytes);

            // Crear SignedCms
            var signedCms = new SignedCms(contentInfo, detached: false);

            // Crear CmsSigner con el certificado
            var signer = new CmsSigner(cert)
            {
                IncludeOption = X509IncludeOption.EndCertOnly
            };

            // Firmar
            signedCms.ComputeSignature(signer);

            // Obtener el CMS firmado en formato Base64
            var cmsSignedBytes = signedCms.Encode();
            var cmsSignedBase64 = Convert.ToBase64String(cmsSignedBytes);

            return cmsSignedBase64;
        }

        /// <summary>
        /// Envía el TRA firmado al WSAA de AFIP
        /// </summary>
        private async Task<string> SendToWSAA(string traFirmado)
        {
            using var httpClient = new HttpClient();
            httpClient.Timeout = TimeSpan.FromSeconds(30);

            var soapEnvelope = $@"<?xml version=""1.0"" encoding=""UTF-8""?>
<soapenv:Envelope xmlns:soapenv=""http://schemas.xmlsoap.org/soap/envelope/"" xmlns:wsaa=""http://wsaa.view.sua.dvadac.desein.afip.gov"">
    <soapenv:Header/>
    <soapenv:Body>
        <wsaa:loginCms>
            <wsaa:in0>{traFirmado}</wsaa:in0>
        </wsaa:loginCms>
    </soapenv:Body>
</soapenv:Envelope>";

            var content = new StringContent(soapEnvelope, Encoding.UTF8, "text/xml");
            content.Headers.Remove("Content-Type");
            content.Headers.Add("Content-Type", "text/xml; charset=utf-8");
            content.Headers.Add("SOAPAction", "");

            _logger.LogDebug("Enviando solicitud a WSAA: {URL}", _config.UrlWSAA);

            var response = await httpClient.PostAsync(_config.UrlWSAA, content);

            var responseContent = await response.Content.ReadAsStringAsync();

            if (!response.IsSuccessStatusCode)
            {
                _logger.LogError("Error en respuesta WSAA: {StatusCode} - {Content}",
                    response.StatusCode, responseContent);
                throw new Exception($"Error al comunicarse con WSAA: {response.StatusCode}");
            }

            return responseContent;
        }

        /// <summary>
        /// Parsea la respuesta XML del WSAA y extrae token, sign y expiración
        /// </summary>
        private AfipAuthToken ParseWSAAResponse(string xmlResponse)
        {
            var xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(xmlResponse);

            var nsmgr = new XmlNamespaceManager(xmlDoc.NameTable);
            nsmgr.AddNamespace("soap", "http://schemas.xmlsoap.org/soap/envelope/");
            nsmgr.AddNamespace("ns1", "http://wsaa.view.sua.dvadac.desein.afip.gov");

            // Buscar el loginCmsReturn en la respuesta
            var loginCmsReturn = xmlDoc.SelectSingleNode("//ns1:loginCmsReturn", nsmgr)?.InnerText;

            if (string.IsNullOrEmpty(loginCmsReturn))
            {
                throw new Exception("No se encontró loginCmsReturn en la respuesta de WSAA");
            }

            // Parsear el XML interno de loginCmsReturn
            var credentialsDoc = new XmlDocument();
            credentialsDoc.LoadXml(loginCmsReturn);

            var token = credentialsDoc.SelectSingleNode("//token")?.InnerText;
            var sign = credentialsDoc.SelectSingleNode("//sign")?.InnerText;
            var expirationTimeStr = credentialsDoc.SelectSingleNode("//expirationTime")?.InnerText;

            if (string.IsNullOrEmpty(token) || string.IsNullOrEmpty(sign))
            {
                throw new Exception("No se pudo obtener token o sign de la respuesta de AFIP");
            }

            // C4: Parsear fecha de expiración correctamente
            // AFIP puede devolver fechas en varios formatos ISO 8601:
            // - "2024-01-24T15:30:00" (sin zona horaria - asumir Argentina UTC-3)
            // - "2024-01-24T15:30:00-03:00" (con zona horaria)
            // - "2024-01-24T15:30:00.000-03:00" (con milisegundos)
            DateTime expirationTime = DateTime.UtcNow.AddHours(12);
            if (!string.IsNullOrEmpty(expirationTimeStr))
            {
                // Intentar parsear con zona horaria primero (DateTimeOffset maneja esto bien)
                if (DateTimeOffset.TryParse(expirationTimeStr,
                    System.Globalization.CultureInfo.InvariantCulture,
                    System.Globalization.DateTimeStyles.AssumeUniversal,
                    out var parsedOffset))
                {
                    expirationTime = parsedOffset.UtcDateTime;
                    _logger.LogDebug("Fecha parseada con DateTimeOffset: {Original} -> UTC: {Parsed}",
                        expirationTimeStr, expirationTime);
                }
                // Si no tiene zona horaria, asumir que es hora de Argentina (UTC-3)
                else if (DateTime.TryParseExact(expirationTimeStr,
                    new[] { "yyyy-MM-ddTHH:mm:ss", "yyyy-MM-ddTHH:mm:ss.fff" },
                    System.Globalization.CultureInfo.InvariantCulture,
                    System.Globalization.DateTimeStyles.None,
                    out var parsedDate))
                {
                    // La fecha viene en hora Argentina (UTC-3), convertir a UTC sumando 3 horas
                    expirationTime = parsedDate.AddHours(3);
                    _logger.LogDebug("Fecha parseada sin zona (asumiendo Argentina): {Original} -> UTC: {Parsed}",
                        expirationTimeStr, expirationTime);
                }
                else
                {
                    _logger.LogWarning("No se pudo parsear la fecha de expiración: {FechaOriginal}, usando default +12h",
                        expirationTimeStr);
                }
            }

            _logger.LogInformation("Token AFIP obtenido exitosamente. Expira (UTC): {ExpirationTime}", expirationTime);

            return new AfipAuthToken
            {
                Token = token,
                Sign = sign,
                ExpirationTime = expirationTime
            };
        }
    }
}
