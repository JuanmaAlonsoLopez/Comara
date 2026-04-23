using Microsoft.AspNetCore.Mvc;
using comara.Data;
using Microsoft.EntityFrameworkCore;

namespace comara.Controllers
{
    public class ReportesController : Controller
    {
        private readonly ApplicationDbContext _context;

        public ReportesController(ApplicationDbContext context)
        {
            _context = context;
        }

        public IActionResult Index()
        {
            return View();
        }

        public async Task<IActionResult> Ventas()
        {
            var ventas = await _context.Ventas.Include(v => v.Cliente).ToListAsync();
            return View(ventas);
        }

        public async Task<IActionResult> StockCritico()
        {
            var stockCritico = await _context.Articulos.Where(a => a.ArtStock <= a.ArtStockMin).ToListAsync();
            return View(stockCritico);
        }

        public async Task<IActionResult> CuentasCorrientes()
        {
            var cuentasCorrientes = await _context.CuentasCorrientes.Include(cc => cc.Cliente).ToListAsync();
            return View(cuentasCorrientes);
        }
    }
}
