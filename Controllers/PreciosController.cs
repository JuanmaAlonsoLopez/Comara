using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using comara.Data;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using Microsoft.AspNetCore.Mvc.Rendering;
using Npgsql;

namespace comara.Controllers
{
    [Authorize]
    public class PreciosController : Controller
    {
        private readonly ApplicationDbContext _context;

        public PreciosController(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<IActionResult> Index(int page = 1, int pageSize = 50)
        {
            // Paginación para evitar cargar todos los artículos en memoria
            if (page < 1) page = 1;
            if (pageSize < 1) pageSize = 50;
            if (pageSize > 200) pageSize = 200;

            var query = _context.Articulos.AsQueryable();
            var totalItems = await query.CountAsync();
            var totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            if (page > totalPages && totalPages > 0) page = totalPages;

            var articulos = await query
                .OrderBy(a => a.ArtDesc)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.TotalItems = totalItems;
            ViewBag.PageSize = pageSize;

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
        // OPTIMIZADO: Usa SQL directo (bulk update) en lugar de cargar todo en memoria
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> AumentarPrecios(string tipoAumento, decimal porcentaje, int? marCod, int? proCod)
        {
            // Punto 25: Validar porcentaje para evitar corrupción de datos
            if (porcentaje <= -100)
            {
                TempData["Error"] = "El porcentaje no puede ser menor o igual a -100% (eliminaría los precios)";
                return RedirectToAction(nameof(AumentarPrecios));
            }

            if (porcentaje > 1000)
            {
                TempData["Error"] = "El porcentaje no puede ser mayor a 1000%";
                return RedirectToAction(nameof(AumentarPrecios));
            }

            if (string.IsNullOrEmpty(tipoAumento) || (tipoAumento != "todos" && tipoAumento != "marca" && tipoAumento != "proveedor"))
            {
                TempData["Error"] = "Debe seleccionar un tipo de aumento válido";
                return RedirectToAction(nameof(AumentarPrecios));
            }

            // Usar decimal para cálculos financieros (precisión)
            var multiplicador = 1 + (porcentaje / 100m);

            // OPTIMIZACIÓN: Usar SQL directo para bulk update (mucho más eficiente)
            // En lugar de cargar N artículos en memoria y hacer N updates individuales,
            // hacemos 1 solo UPDATE que afecta a todas las filas necesarias
            var sql = @"UPDATE ""ARTICULOS"" SET
                ""artL1"" = CASE WHEN ""artL1"" IS NOT NULL THEN ROUND(""artL1"" * @mult, 2) ELSE ""artL1"" END,
                ""artL2"" = CASE WHEN ""artL2"" IS NOT NULL THEN ROUND(""artL2"" * @mult, 2) ELSE ""artL2"" END,
                ""artL3"" = CASE WHEN ""artL3"" IS NOT NULL THEN ROUND(""artL3"" * @mult, 2) ELSE ""artL3"" END,
                ""artL4"" = CASE WHEN ""artL4"" IS NOT NULL THEN ROUND(""artL4"" * @mult, 2) ELSE ""artL4"" END,
                ""artL5"" = CASE WHEN ""artL5"" IS NOT NULL THEN ROUND(""artL5"" * @mult, 2) ELSE ""artL5"" END,
                ""artCost"" = CASE WHEN ""artCost"" IS NOT NULL THEN ROUND(""artCost"" * @mult, 2) ELSE ""artCost"" END
                WHERE 1=1";

            var parameters = new List<NpgsqlParameter>
            {
                new NpgsqlParameter("@mult", multiplicador)
            };

            if (tipoAumento == "marca" && marCod.HasValue)
            {
                sql += @" AND ""marCod"" = @marCod";
                parameters.Add(new NpgsqlParameter("@marCod", marCod.Value));
            }
            else if (tipoAumento == "proveedor" && proCod.HasValue)
            {
                sql += @" AND ""proCod"" = @proCod";
                parameters.Add(new NpgsqlParameter("@proCod", proCod.Value));
            }

            var rowsAffected = await _context.Database.ExecuteSqlRawAsync(sql, parameters.ToArray());

            TempData["Success"] = $"Se actualizaron los precios de {rowsAffected} artículo(s) con un {(porcentaje >= 0 ? "aumento" : "descuento")} del {Math.Abs(porcentaje)}%";
            return RedirectToAction("Index", "Listas");
        }
    }
}