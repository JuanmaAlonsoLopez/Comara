using Microsoft.AspNetCore.Mvc;
using comara.Data;
using Microsoft.EntityFrameworkCore;
using comara.Models;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace comara.Controllers
{
    public class ArticulosController : Controller
    {
        private readonly ApplicationDbContext _context;

        public ArticulosController(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            var articulos = await _context.Articulos.Include(a => a.Marca).Include(a => a.Proveedor).ToListAsync();
            return View(articulos);
        }

        // GET: Articulos/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var articulo = await _context.Articulos
                .Include(a => a.Marca)
                .Include(a => a.Proveedor)
                .FirstOrDefaultAsync(m => m.ArtCod == id);
            if (articulo == null)
            {
                return NotFound();
            }

            return View(articulo);
        }

        // GET: Articulos/Create
        public async Task<IActionResult> Create()
        {
            ViewData["MarCod"] = new SelectList(await _context.Marcas.ToListAsync(), "marCod", "marNombre");
            ViewData["ProCod"] = new SelectList(await _context.Proveedores.ToListAsync(), "proCod", "proNombre");
            return View();
        }

        // POST: Articulos/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("ArtCod,ArtDesc,Activo,ArtStock,ArtUni,ArtStockMin,ArtExist,RubCod,SrubCod,MarCod,IvaCod,ArtAlt1,ArtAlt2,ArtL1,ArtL2,ArtL3,ArtL4,ArtL5,Coef1,Coef2,Coef3,ArtDestino,Iva,ImpInterno,ArtTalonario,ArtCbteNro,FechCom,FechMod,FechVto,ArtDesc2,Foto,Exento,Conjunto,ProCod")] Articulo articulo)
        {
            if (ModelState.IsValid)
            {
                _context.Add(articulo);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            ViewData["MarCod"] = new SelectList(await _context.Marcas.ToListAsync(), "marCod", "marNombre", articulo.MarCod);
            ViewData["ProCod"] = new SelectList(await _context.Proveedores.ToListAsync(), "proCod", "proNombre", articulo.ProCod);
            return View(articulo);
        }

        // GET: Articulos/Edit/5
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
            ViewData["MarCod"] = new SelectList(await _context.Marcas.ToListAsync(), "marCod", "marNombre", articulo.MarCod);
            ViewData["ProCod"] = new SelectList(await _context.Proveedores.ToListAsync(), "proCod", "proNombre", articulo.ProCod);
            return View(articulo);
        }

        // POST: Articulos/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("ArtCod,ArtDesc,Activo,ArtStock,ArtUni,ArtStockMin,ArtExist,RubCod,SrubCod,MarCod,IvaCod,ArtAlt1,ArtAlt2,ArtL1,ArtL2,ArtL3,ArtL4,ArtL5,Coef1,Coef2,Coef3,ArtDestino,Iva,ImpInterno,ArtTalonario,ArtCbteNro,FechCom,FechMod,FechVto,ArtDesc2,Foto,Exento,Conjunto,ProCod")] Articulo articulo)
        {
            if (id != articulo.ArtCod)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(articulo);
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
            ViewData["MarCod"] = new SelectList(await _context.Marcas.ToListAsync(), "marCod", "marNombre", articulo.MarCod);
            ViewData["ProCod"] = new SelectList(await _context.Proveedores.ToListAsync(), "proCod", "proNombre", articulo.ProCod);
            return View(articulo);
        }

        // GET: Articulos/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var articulo = await _context.Articulos
                .Include(a => a.Marca)
                .Include(a => a.Proveedor)
                .FirstOrDefaultAsync(m => m.ArtCod == id);
            if (articulo == null)
            {
                return NotFound();
            }

            return View(articulo);
        }

        // POST: Articulos/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var articulo = await _context.Articulos.FindAsync(id);
            _context.Articulos.Remove(articulo);
            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool ArticuloExists(int id)
        {
            return _context.Articulos.Any(e => e.ArtCod == id);
        }
    }
}