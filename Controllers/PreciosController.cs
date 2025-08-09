using Microsoft.AspNetCore.Mvc;
using comara.Data;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using Microsoft.AspNetCore.Mvc.Rendering;

namespace comara.Controllers
{
    public class PreciosController : Controller
    {
        private readonly ApplicationDbContext _context;

        public PreciosController(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index()
        {
            var articulos = await _context.Articulos.ToListAsync();
            return View(articulos);
        }

        // GET: Precios/AumentarPrecios
        public async Task<IActionResult> AumentarPrecios()
        {
            var marcas = await _context.Marcas.Select(m => new SelectListItem { Value = m.marCod.ToString(), Text = m.marNombre }).ToListAsync();
            ViewBag.Marcas = marcas;

            var proveedores = await _context.Proveedores.Select(p => new SelectListItem { Value = p.proCod.ToString(), Text = p.proNombre }).ToListAsync();
            ViewBag.Proveedores = proveedores;
            return View();
        }

        // POST: Precios/AumentarPrecios
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AumentarPrecios(string tipoAumento, float porcentaje, int? marCod, int? proCod)
        {
            var articulosToUpdate = _context.Articulos.AsQueryable();

            if (tipoAumento == "marca" && marCod.HasValue)
            {
                articulosToUpdate = articulosToUpdate.Where(a => a.MarCod == marCod.Value);
            }
            // Assuming you have a way to link Articulos to Proveedores (e.g., through a navigation property or a join)
            // For now, I'll skip the proveedor filter as it's not directly available in the Articulo model based on backup.sql
            // If you have a ProveedorId in Articulo, you can add: 
            // if (proCod.HasValue) { articulosToUpdate = articulosToUpdate.Where(a => a.ProCod == proCod.Value); }

            foreach (var articulo in articulosToUpdate)
            {
                articulo.ArtL1 *= (1 + porcentaje / 100);
                articulo.ArtL2 *= (1 + porcentaje / 100);
                articulo.ArtL3 *= (1 + porcentaje / 100);
                articulo.ArtL4 *= (1 + porcentaje / 100);
                articulo.ArtL5 = (int?)(articulo.ArtL5 * (1 + porcentaje / 100));
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }
    }
}