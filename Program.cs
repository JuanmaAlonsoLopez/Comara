using Microsoft.EntityFrameworkCore;
using comara.Data;
using comara.Services;
using comara.Services.AFIP;
using comara.Services.PDF;
using comara.Services.Logging;
using comara.Models.AFIP;
using comara.Filters;
using System.Text;
using System.Globalization;
using QuestPDF.Infrastructure;
using Microsoft.AspNetCore.Localization;
using Microsoft.AspNetCore.Http.Features;
using Serilog;
using Serilog.Events;
using Polly;
using Polly.Extensions.Http;

var builder = WebApplication.CreateBuilder(args);

// Punto 13: Validar y configurar credenciales sensibles
// Soporta: User Secrets (desarrollo), variables de entorno (producción/GCP)
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

// Google Cloud Run: Si existe DB_PASSWORD como variable de entorno, construir connection string
var dbPassword = Environment.GetEnvironmentVariable("DB_PASSWORD");
var cloudSqlInstance = Environment.GetEnvironmentVariable("CLOUD_SQL_INSTANCE");
if (!string.IsNullOrWhiteSpace(dbPassword) && string.IsNullOrWhiteSpace(connectionString))
{
    // Formato Cloud SQL con Unix socket
    var instance = cloudSqlInstance ?? "comara-produccion:us-central1:comara-db";
    connectionString = $"Host=/cloudsql/{instance};Database=comara;Username=postgres;Password={dbPassword}";
    Console.WriteLine($"INFO: Usando conexión Cloud SQL: /cloudsql/{instance}");
}

if (string.IsNullOrWhiteSpace(connectionString))
{
    Console.ForegroundColor = ConsoleColor.Red;
    Console.WriteLine("ERROR: No se encontró la cadena de conexión 'DefaultConnection'.");
    Console.WriteLine();
    Console.WriteLine("Para configurar User Secrets en desarrollo, ejecute:");
    Console.WriteLine("  dotnet user-secrets set \"ConnectionStrings:DefaultConnection\" \"Host=localhost;Database=comara;Username=postgres;Password=TU_PASSWORD\"");
    Console.WriteLine();
    Console.WriteLine("Para producción en Google Cloud Run, configure los secretos:");
    Console.WriteLine("  DB_PASSWORD (Secret Manager)");
    Console.WriteLine("  CLOUD_SQL_INSTANCE (opcional, default: comara-produccion:us-central1:comara-db)");
    Console.ResetColor();
    Environment.Exit(1);
}

// Sobrescribir configuración con el connection string construido/validado
builder.Configuration["ConnectionStrings:DefaultConnection"] = connectionString;

// AFIP: Leer password desde variable de entorno si existe
var afipPassword = Environment.GetEnvironmentVariable("AFIP_CERT_PASSWORD")
                   ?? builder.Configuration["Afip:CertificadoPassword"];
if (!string.IsNullOrWhiteSpace(Environment.GetEnvironmentVariable("AFIP_CERT_PASSWORD")))
{
    builder.Configuration["Afip:CertificadoPassword"] = afipPassword;
}

if (string.IsNullOrWhiteSpace(afipPassword) && builder.Configuration["Afip:UsarModoTesting"] != "true")
{
    Console.ForegroundColor = ConsoleColor.Yellow;
    Console.WriteLine("ADVERTENCIA: No se encontró 'Afip:CertificadoPassword'. La facturación AFIP no funcionará.");
    Console.WriteLine();
    Console.WriteLine("Para configurar User Secrets, ejecute:");
    Console.WriteLine("  dotnet user-secrets set \"Afip:CertificadoPassword\" \"TU_PASSWORD_CERTIFICADO\"");
    Console.WriteLine();
    Console.WriteLine("Para Google Cloud Run, configure el secreto: AFIP_CERT_PASSWORD");
    Console.ResetColor();
}

// Punto 11: Configurar Serilog para logging estructurado
Log.Logger = new LoggerConfiguration()
    .MinimumLevel.Information()
    .MinimumLevel.Override("Microsoft", LogEventLevel.Warning)
    .MinimumLevel.Override("Microsoft.EntityFrameworkCore", LogEventLevel.Warning)
    .Enrich.FromLogContext()
    .Enrich.WithMachineName()
    .Enrich.WithThreadId()
    .WriteTo.Console(outputTemplate: "[{Timestamp:HH:mm:ss} {Level:u3}] {Message:lj} {Properties:j}{NewLine}{Exception}")
    .WriteTo.File(
        path: "logs/comara-.log",
        rollingInterval: RollingInterval.Day,
        retainedFileCountLimit: 30,
        outputTemplate: "{Timestamp:yyyy-MM-dd HH:mm:ss.fff zzz} [{Level:u3}] {Message:lj} {Properties:j}{NewLine}{Exception}")
    .CreateLogger();

builder.Host.UseSerilog();

// Configurar cultura Argentina para formato de moneda
var cultureInfo = new CultureInfo("es-AR");
cultureInfo.NumberFormat.CurrencySymbol = "$";
cultureInfo.NumberFormat.CurrencyDecimalSeparator = ",";
cultureInfo.NumberFormat.CurrencyGroupSeparator = ".";
cultureInfo.NumberFormat.NumberDecimalSeparator = ",";
cultureInfo.NumberFormat.NumberGroupSeparator = ".";
CultureInfo.DefaultThreadCurrentCulture = cultureInfo;
CultureInfo.DefaultThreadCurrentUICulture = cultureInfo;

// Configurar licencia de QuestPDF (Community - gratis para uso no comercial o ingresos < $1M USD)
QuestPDF.Settings.License = LicenseType.Community;

// Configurar encoding UTF-8 globalmente
Encoding.RegisterProvider(CodePagesEncodingProvider.Instance);

// Punto 12: Agregar IMemoryCache para datos de solo lectura
builder.Services.AddMemoryCache();

// Punto 14: Configurar límite de tamaño de archivos (10 MB)
builder.Services.Configure<FormOptions>(options =>
{
    options.MultipartBodyLengthLimit = 10 * 1024 * 1024; // 10 MB
    options.ValueLengthLimit = 10 * 1024 * 1024;
    options.MultipartHeadersLengthLimit = 32 * 1024; // 32 KB para headers
});

// Add services to the container.
builder.Services.AddControllersWithViews(options =>
    {
        // Agregar filtro global de excepciones
        options.Filters.Add<GlobalExceptionFilter>();
    })
    .AddRazorOptions(options =>
    {
        // Asegurar UTF-8 en las vistas Razor
    });
builder.Services.AddHttpContextAccessor();

// Configurar sesiones para notificaciones
builder.Services.AddDistributedMemoryCache();
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});

// Configurar autenticación con cookies
builder.Services.AddAuthentication("CookieAuth")
    .AddCookie("CookieAuth", options =>
    {
        options.LoginPath = "/Account/Login";
        options.LogoutPath = "/Account/Logout";
        options.AccessDeniedPath = "/Account/AccessDenied";
        options.ExpireTimeSpan = TimeSpan.FromHours(8);
        options.SlidingExpiration = true;
        options.Cookie.Name = "COMARA.Auth";
        options.Cookie.HttpOnly = true;
        options.Cookie.SecurePolicy = CookieSecurePolicy.Always;
        options.Cookie.SameSite = SameSiteMode.Strict;
    });

builder.Services.AddAuthorization(options =>
{
    // Política para administradores
    options.AddPolicy("AdminOnly", policy =>
        policy.RequireClaim("Role", "admin"));

    // Política para usuarios autenticados
    options.AddPolicy("AuthenticatedUser", policy =>
        policy.RequireAuthenticatedUser());
});

builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("DefaultConnection")));

// Configurar AFIP
builder.Services.Configure<AfipConfig>(builder.Configuration.GetSection("AFIP"));

// Registrar HttpClientFactory para servicios AFIP con políticas de reintentos
// Política de reintentos: 3 intentos con backoff exponencial (1s, 2s, 4s)
var retryPolicy = HttpPolicyExtensions
    .HandleTransientHttpError() // Maneja HttpRequestException, 5XX y 408
    .OrResult(msg => msg.StatusCode == System.Net.HttpStatusCode.TooManyRequests) // 429
    .WaitAndRetryAsync(3, retryAttempt =>
        TimeSpan.FromSeconds(Math.Pow(2, retryAttempt - 1)), // 1s, 2s, 4s
        onRetry: (outcome, timespan, retryAttempt, context) =>
        {
            Log.Warning("AFIP: Reintento {RetryAttempt} después de {Delay}s. Razón: {Reason}",
                retryAttempt,
                timespan.TotalSeconds,
                outcome.Exception?.Message ?? outcome.Result?.StatusCode.ToString());
        });

// Política de circuit breaker: abre el circuito después de 5 fallos consecutivos
var circuitBreakerPolicy = HttpPolicyExtensions
    .HandleTransientHttpError()
    .CircuitBreakerAsync(5, TimeSpan.FromMinutes(1),
        onBreak: (outcome, timespan) =>
        {
            Log.Error("AFIP: Circuit breaker ABIERTO por {Duration}s. Razón: {Reason}",
                timespan.TotalSeconds,
                outcome.Exception?.Message ?? outcome.Result?.StatusCode.ToString());
        },
        onReset: () =>
        {
            Log.Information("AFIP: Circuit breaker CERRADO. Conexión restablecida.");
        });

builder.Services.AddHttpClient("AfipWSFE", client =>
{
    client.Timeout = TimeSpan.FromSeconds(30);
})
.ConfigurePrimaryHttpMessageHandler(() => new HttpClientHandler
{
    ServerCertificateCustomValidationCallback = HttpClientHandler.DangerousAcceptAnyServerCertificateValidator
})
.AddPolicyHandler(retryPolicy)
.AddPolicyHandler(circuitBreakerPolicy);

// Registrar servicios AFIP
var afipConfig = builder.Configuration.GetSection("AFIP").Get<AfipConfig>();
if (afipConfig?.UsarModoTesting == true)
{
    // Modo Testing: Usar servicios Mock que simulan AFIP
    Console.WriteLine("⚠️  MODO TESTING ACTIVADO - No se conectará a AFIP real");
    var mockService = new AfipMockService();
    builder.Services.AddSingleton<IAfipAuthService>(mockService);
    builder.Services.AddSingleton<IAfipFacturacionService>(mockService);
}
else
{
    // Modo Real: Usar servicios que se conectan a AFIP
    builder.Services.AddScoped<IAfipAuthService, AfipAuthService>();
    builder.Services.AddScoped<IAfipFacturacionService, AfipFacturacionService>();
}
builder.Services.AddScoped<IARCAApiService, ARCAApiService>();

// Registrar servicios de autenticación
builder.Services.AddScoped<IPasswordService, PasswordService>();
builder.Services.AddSingleton<ILoginRateLimiter, LoginRateLimiter>(); // Singleton para mantener estado en memoria
builder.Services.AddScoped<IAuthenticationService, AuthenticationService>();

// Registrar servicios de PDF
builder.Services.AddScoped<IFacturaPDFService, FacturaPDFService>();
builder.Services.AddScoped<IPresupuestoPDFService, PresupuestoPDFService>();

// Registrar servicio de Logging
builder.Services.AddScoped<IAfipLogService, AfipLogService>();

// Registrar servicio de validación de facturas
builder.Services.AddScoped<IFacturaValidacionService, FacturaValidacionService>();

// Registrar servicio de Caja
builder.Services.AddScoped<ICajaService, CajaService>();

// Punto 12: Registrar servicio de Dropdowns CON CACHE (centraliza carga de SelectLists)
builder.Services.AddScoped<IDropdownService, CachedDropdownService>();

var app = builder.Build();

// Configurar localización para Argentina
app.UseRequestLocalization(new RequestLocalizationOptions
{
    DefaultRequestCulture = new RequestCulture("es-AR"),
    SupportedCultures = new[] { cultureInfo },
    SupportedUICultures = new[] { cultureInfo }
});

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.

    app.UseHsts();
}

app.UseHttpsRedirection();
app.UseStaticFiles();

app.UseRouting();

app.UseSession(); // Habilitar sesiones

app.UseAuthentication(); // Habilitar autenticación (ANTES de UseAuthorization)
app.UseAuthorization();

app.MapControllerRoute(
    name: "default",
    pattern: "{controller=Home}/{action=Index}/{id?}");

app.Run();
