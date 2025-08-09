using Microsoft.AspNetCore.Mvc;
using comara.Data;
using Microsoft.EntityFrameworkCore;
using comara.Models;

namespace comara.Controllers
{
    public class StockController : Controller
    {
        private readonly ApplicationDbContext _context;

        public StockController(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            var articulos = await _context.Articulos.ToListAsync();
            return View(articulos);
        }

        // GET: Stock/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var articulo = await _context.Articulos.FindAsync(id);
            if (articulo == null)
            {
                return NotFound();
            }
            return View(articulo);
        }

        // POST: Stock/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("ArtCod,ArtStock,ArtStockMin")] Articulo articulo)
        {
            if (id != articulo.ArtCod)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    var existingArticulo = await _context.Articulos.FindAsync(id);
                    existingArticulo.ArtStock = articulo.ArtStock;
                    existingArticulo.ArtStockMin = articulo.ArtStockMin;
                    _context.Update(existingArticulo);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ArticuloExists(articulo.ArtCod))
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
            return View(articulo);
        }

        private bool ArticuloExists(int id)
        {
            return _context.Articulos.Any(e => e.ArtCod == id);
        }
    }
}
