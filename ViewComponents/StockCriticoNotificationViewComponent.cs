using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using comara.Data;
using comara.Models;

namespace comara.ViewComponents
{
    public class StockCriticoNotificationViewComponent : ViewComponent
    {
        private readonly ApplicationDbContext _context;

        public StockCriticoNotificationViewComponent(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IViewComponentResult> InvokeAsync()
        {
            // Punto 28: Usar constante SessionKeys en lugar de string mágico
            var notificationViewed = HttpContext.Session.GetString(SessionKeys.StockCriticoViewed);

            if (notificationViewed == "true")
            {
                return View(0); // No hay notificaciones pendientes
            }

            // Contar artículos en stock crítico
            var count = await _context.Articulos
                .CountAsync(a => a.ArtStock <= a.ArtStockMin);

            return View(count);
        }
    }
}
