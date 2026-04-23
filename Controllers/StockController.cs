using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using comara.Data;
using Microsoft.EntityFrameworkCore;
using comara.Models;
using System.Globalization;

namespace comara.Controllers
{
    [Authorize]
    public class StockController : Controller
    {
        private readonly ApplicationDbContext _context;

        public StockController(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index(string searchTerm = "", int page = 1, int pageSize = 20)
        {
            // Asegurar valores válidos
            if (page < 1) page = 1;
            if (pageSize < 1) pageSize = 20;
            if (pageSize > 100) pageSize = 100;

            var query = _context.Articulos.AsQueryable();

            // Aplicar filtro de búsqueda si existe (optimizado para usar índices)
            if (!string.IsNullOrWhiteSpace(searchTerm))
            {
                query = query.Where(a =>
                    (a.ArtCod != null && EF.Functions.ILike(a.ArtCod, $"{searchTerm}%")) ||
                    (a.ArtCod != null && EF.Functions.ILike(a.ArtCod, $"%{searchTerm}%")) ||
                    (a.ArtDesc != null && EF.Functions.ILike(a.ArtDesc, $"{searchTerm}%")) ||
                    (a.ArtDesc != null && EF.Functions.ILike(a.ArtDesc, $"%{searchTerm}%")));
            }

            // Contar total para paginación
            var totalItems = await query.CountAsync();
            var totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            // Ajustar página si excede el total
            if (page > totalPages && totalPages > 0) page = totalPages;

            // Obtener artículos de la página actual
            var articulos = await query
                .OrderBy(a => a.ArtDesc)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            // Pasar información de paginación a la vista
            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.TotalItems = totalItems;
            ViewBag.PageSize = pageSize;
            ViewBag.SearchTerm = searchTerm;

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

            var viewModel = new ArticuloStock
            {
                Id = articulo.Id,
                ArtCod = articulo.ArtCod,
                ArtDesc = articulo.ArtDesc,
                ArtStock = articulo.ArtStock,
                ArtStockMin = articulo.ArtStockMin
            };

            return View(viewModel);
        }

        // POST: Stock/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,ArtCod,ArtDesc")] ArticuloStock model, string ArtStockStr, string ArtStockMinStr)
        {
            if (id != model.Id)
            {
                return NotFound();
            }

            var articulo = await _context.Articulos.FindAsync(id);
            if (articulo == null)
            {
                return NotFound();
            }

            // Normalizar separadores decimales: acepta tanto "," como "."
            var stockStr = ArtStockStr?.Replace(",", ".") ?? "0";
            var stockMinStr = ArtStockMinStr?.Replace(",", ".") ?? "0";

            if (!decimal.TryParse(stockStr, NumberStyles.Any, CultureInfo.InvariantCulture, out decimal stock))
            {
                ModelState.AddModelError("ArtStock", "El valor de Stock debe ser un número válido");
            }

            if (!decimal.TryParse(stockMinStr, NumberStyles.Any, CultureInfo.InvariantCulture, out decimal stockMin))
            {
                ModelState.AddModelError("ArtStockMin", "El valor de Stock mínimo debe ser un número válido");
            }

            if (!ModelState.IsValid)
            {
                model.ArtDesc = articulo.ArtDesc;
                return View(model);
            }

            articulo.ArtStock = stock;
            articulo.ArtStockMin = stockMin;
            _context.Update(articulo);
            await _context.SaveChangesAsync();

            return RedirectToAction(nameof(Index));
        }

        private bool ArticuloExists(int id)
        {
            return _context.Articulos.Any(e => e.Id == id);
        }
    }
}
