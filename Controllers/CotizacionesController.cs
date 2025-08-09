using Microsoft.AspNetCore.Mvc;
using comara.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Mvc.Rendering;
using comara.Models;

namespace comara.Controllers
{
    public class CotizacionesController : Controller
    {
        private readonly ApplicationDbContext _context;

        public CotizacionesController(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            var cotizaciones = await _context.Cotizaciones.Include(c => c.Cliente).ToListAsync();
            return View(cotizaciones);
        }

        // GET: Cotizaciones/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var cotizacion = await _context.Cotizaciones
                .Include(c => c.Cliente)
                .FirstOrDefaultAsync(m => m.cotCod == id);
            if (cotizacion == null)
            {
                return NotFound();
            }

            return View(cotizacion);
        }

        // GET: Cotizaciones/Create
        public IActionResult Create()
        {
            ViewData["cliCod"] = new SelectList(_context.Clientes, "cliCod", "cliNombre");
            return View();
        }

        // POST: Cotizaciones/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("cotCod,cotFech,cliCod,cotTotal,cotEstado")] Cotizacion cotizacion)
        {
            if (ModelState.IsValid)
            {
                _context.Add(cotizacion);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["cliCod"] = new SelectList(_context.Clientes, "cliCod", "cliNombre", cotizacion.cliCod);
            return View(cotizacion);
        }

        // GET: Cotizaciones/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var cotizacion = await _context.Cotizaciones.FindAsync(id);
            if (cotizacion == null)
            {
                return NotFound();
            }
            ViewData["cliCod"] = new SelectList(_context.Clientes, "cliCod", "cliNombre", cotizacion.cliCod);
            return View(cotizacion);
        }

        // POST: Cotizaciones/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("cotCod,cotFech,cliCod,cotTotal,cotEstado")] Cotizacion cotizacion)
        {
            if (id != cotizacion.cotCod)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(cotizacion);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!CotizacionExists(cotizacion.cotCod))
                    {
                        return NotFound();
                    }
                    else
                    {
                        throw;
                    }
                }
                return RedirectToAction(nameof(Index));
            }
            ViewData["cliCod"] = new SelectList(_context.Clientes, "cliCod", "cliNombre", cotizacion.cliCod);
            return View(cotizacion);
        }

        private bool CotizacionExists(int id)
        {
            return _context.Cotizaciones.Any(e => e.cotCod == id);
        }

        // GET: Cotizaciones/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var cotizacion = await _context.Cotizaciones
                .Include(c => c.Cliente)
                .FirstOrDefaultAsync(m => m.cotCod == id);
            if (cotizacion == null)
            {
                return NotFound();
            }

            return View(cotizacion);
        }

        // POST: Cotizaciones/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var cotizacion = await _context.Cotizaciones.FindAsync(id);
            _context.Cotizaciones.Remove(cotizacion);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }
    }
}