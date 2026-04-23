using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.AspNetCore.Mvc.ViewFeatures;

namespace comara.Filters
{
    /// <summary>
    /// Filtro global para manejo consistente de excepciones en todos los controllers
    /// </summary>
    public class GlobalExceptionFilter : IExceptionFilter
    {
        private readonly ILogger<GlobalExceptionFilter> _logger;
        private readonly IWebHostEnvironment _env;

        public GlobalExceptionFilter(ILogger<GlobalExceptionFilter> logger, IWebHostEnvironment env)
        {
            _logger = logger;
            _env = env;
        }

        public void OnException(ExceptionContext context)
        {
            _logger.LogError(context.Exception,
                "Error no manejado en {Controller}/{Action}: {Message}",
                context.RouteData.Values["controller"],
                context.RouteData.Values["action"],
                context.Exception.Message);

            // Si es una petición AJAX/API, devolver JSON
            if (IsAjaxRequest(context.HttpContext.Request))
            {
                context.Result = new JsonResult(new
                {
                    success = false,
                    error = _env.IsDevelopment()
                        ? context.Exception.Message
                        : "Ha ocurrido un error. Por favor intente nuevamente.",
                    details = _env.IsDevelopment() ? context.Exception.StackTrace : null
                })
                {
                    StatusCode = 500
                };
                context.ExceptionHandled = true;
                return;
            }

            // Para peticiones normales, guardar mensaje en TempData y redirigir
            var tempDataFactory = context.HttpContext.RequestServices
                .GetRequiredService<ITempDataDictionaryFactory>();
            var tempData = tempDataFactory.GetTempData(context.HttpContext);

            tempData["ErrorMessage"] = _env.IsDevelopment()
                ? $"Error: {context.Exception.Message}"
                : "Ha ocurrido un error inesperado. Por favor intente nuevamente.";

            // Si hay un Referer, volver a esa página
            var referer = context.HttpContext.Request.Headers["Referer"].ToString();
            if (!string.IsNullOrEmpty(referer))
            {
                context.Result = new RedirectResult(referer);
            }
            else
            {
                // Si no, ir al Home
                context.Result = new RedirectToActionResult("Index", "Home", null);
            }

            context.ExceptionHandled = true;
        }

        private static bool IsAjaxRequest(HttpRequest request)
        {
            return request.Headers["X-Requested-With"] == "XMLHttpRequest"
                || request.Headers["Accept"].ToString().Contains("application/json")
                || request.Path.StartsWithSegments("/api");
        }
    }
}
