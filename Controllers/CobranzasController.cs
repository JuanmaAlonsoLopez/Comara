using Microsoft.AspNetCore.Mvc;
using comara.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.AspNetCore.Mvc.Rendering;
using comara.Models;

namespace comara.Controllers
{
    public class CobranzasController : Controller
    {
        private readonly ApplicationDbContext _context;

        public CobranzasController(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            var cobros = await _context.Cobros.Include(c => c.Cliente).ToListAsync();
            return View(cobros);
        }

        // GET: Cobranzas/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var cobro = await _context.Cobros
                .Include(c => c.Cliente)
                .FirstOrDefaultAsync(m => m.CobCod == id);
            if (cobro == null)
            {
                return NotFound();
            }

            return View(cobro);
        }

        // GET: Cobranzas/Create
        public IActionResult Create()
        {
            ViewData["cliCod"] = new SelectList(_context.Clientes, "cliCod", "cliNombre");
            return View();
        }

        // POST: Cobranzas/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("CobCod,CliCod,CobFech,CobMonto,CobMetodo")] Cobro cobro)
        {
            if (ModelState.IsValid)
            {
                _context.Add(cobro);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["cliCod"] = new SelectList(_context.Clientes, "cliCod", "cliNombre", cobro.CliCod);
            return View(cobro);
        }

        // GET: Cobranzas/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var cobro = await _context.Cobros.FindAsync(id);
            if (cobro == null)
            {
                return NotFound();
            }
            ViewData["cliCod"] = new SelectList(_context.Clientes, "cliCod", "cliNombre", cobro.CliCod);
            return View(cobro);
        }

        // POST: Cobranzas/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("CobCod,CliCod,CobFech,CobMonto,CobMetodo")] Cobro cobro)
        {
            if (id != cobro.CobCod)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(cobro);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!CobroExists(cobro.CobCod))
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
            ViewData["cliCod"] = new SelectList(_context.Clientes, "cliCod", "cliNombre", cobro.CliCod);
            return View(cobro);
        }

        private bool CobroExists(int id)
        {
            return _context.Cobros.Any(e => e.CobCod == id);
        }

        // GET: Cobranzas/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var cobro = await _context.Cobros
                .Include(c => c.Cliente)
                .FirstOrDefaultAsync(m => m.CobCod == id);
            if (cobro == null)
            {
                return NotFound();
            }

            return View(cobro);
        }

        // POST: Cobranzas/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var cobro = await _context.Cobros.FindAsync(id);
            _context.Cobros.Remove(cobro);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }
    }
}