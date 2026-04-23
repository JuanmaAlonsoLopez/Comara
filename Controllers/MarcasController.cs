using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using comara.Data;
using Microsoft.EntityFrameworkCore;
using comara.Models;
using System.Threading.Tasks;
using OfficeOpenXml;

namespace comara.Controllers
{
    [Authorize]
    public class MarcasController : Controller
    {
        private readonly ApplicationDbContext _context;

        public MarcasController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Marcas
        public async Task<IActionResult> Index(string searchTerm = "", int page = 1, int pageSize = 20)
        {
            // Asegurar valores válidos
            if (page < 1) page = 1;
            if (pageSize < 1) pageSize = 20;
            if (pageSize > 100) pageSize = 100;

            var query = _context.Marcas.AsQueryable();

            // Aplicar filtro de búsqueda si existe
            if (!string.IsNullOrWhiteSpace(searchTerm))
            {
                var term = searchTerm.ToLower();
                query = query.Where(m => m.marNombre.ToLower().Contains(term));
            }

            // Contar total para paginación
            var totalItems = await query.CountAsync();
            var totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            // Ajustar página si excede el total
            if (page > totalPages && totalPages > 0) page = totalPages;

            // Obtener marcas de la página actual
            var marcas = await query
                .OrderBy(m => m.marNombre)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            // Pasar información de paginación a la vista
            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.TotalItems = totalItems;
            ViewBag.PageSize = pageSize;
            ViewBag.SearchTerm = searchTerm;

            return View(marcas);
        }

        // GET: Marcas/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var marca = await _context.Marcas
                .FirstOrDefaultAsync(m => m.marCod == id);
            if (marca == null)
            {
                return NotFound();
            }

            return View(marca);
        }

        // GET: Marcas/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: Marcas/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("marNombre")] Marca marca, bool confirmarSimilar = false)
        {
            // Validar nombre duplicado exacto (case insensitive)
            if (!string.IsNullOrWhiteSpace(marca.marNombre))
            {
                var nombreNormalizado = marca.marNombre.Trim().ToLower();
                var existeExacta = await _context.Marcas
                    .AnyAsync(m => m.marNombre.ToLower() == nombreNormalizado);

                if (existeExacta)
                {
                    ModelState.AddModelError("marNombre", "Ya existe una marca con este nombre.");
                }
                // Verificar nombres similares solo si no hay duplicado exacto y no se confirmo
                else if (!confirmarSimilar)
                {
                    var marcasSimilares = await ObtenerMarcasSimilares(marca.marNombre, null);
                    if (marcasSimilares.Any())
                    {
                        ViewBag.MarcasSimilares = marcasSimilares;
                        ViewBag.MostrarConfirmacion = true;
                        return View(marca);
                    }
                }
            }

            if (ModelState.IsValid)
            {
                _context.Add(marca);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(marca);
        }

        // GET: Marcas/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var marca = await _context.Marcas.FindAsync(id);
            if (marca == null)
            {
                return NotFound();
            }

            // Verificar si hay artículos que usen esta marca
            var articulosAsociados = await _context.Articulos.CountAsync(a => a.MarCod == id);
            ViewBag.ArticulosAsociados = articulosAsociados;

            return View(marca);
        }

        // POST: Marcas/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("marCod,marNombre")] Marca marca, bool confirmarSimilar = false, bool confirmarEnUso = false)
        {
            if (id != marca.marCod)
            {
                return NotFound();
            }

            // Verificar si hay artículos asociados (para mostrar en la vista si es necesario)
            var articulosAsociados = await _context.Articulos.CountAsync(a => a.MarCod == id);
            ViewBag.ArticulosAsociados = articulosAsociados;

            // Validar nombre duplicado exacto (excluyendo la marca actual)
            if (!string.IsNullOrWhiteSpace(marca.marNombre))
            {
                var nombreNormalizado = marca.marNombre.Trim().ToLower();
                var existeExacta = await _context.Marcas
                    .AnyAsync(m => m.marNombre.ToLower() == nombreNormalizado && m.marCod != id);

                if (existeExacta)
                {
                    ModelState.AddModelError("marNombre", "Ya existe otra marca con este nombre.");
                }
                // Verificar nombres similares solo si no hay duplicado exacto y no se confirmo
                else if (!confirmarSimilar)
                {
                    var marcasSimilares = await ObtenerMarcasSimilares(marca.marNombre, id);
                    if (marcasSimilares.Any())
                    {
                        ViewBag.MarcasSimilares = marcasSimilares;
                        ViewBag.MostrarConfirmacion = true;
                        return View(marca);
                    }
                }
            }

            // Verificar si la marca está en uso y no se ha confirmado
            if (articulosAsociados > 0 && !confirmarEnUso)
            {
                ViewBag.MostrarConfirmacionEnUso = true;
                return View(marca);
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(marca);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!MarcaExists(marca.marCod))
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
            return View(marca);
        }

        // GET: Marcas/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var marca = await _context.Marcas
                .FirstOrDefaultAsync(m => m.marCod == id);
            if (marca == null)
            {
                return NotFound();
            }

            // Contar articulos asociados a esta marca
            var articulosAsociados = await _context.Articulos.CountAsync(a => a.MarCod == id);
            ViewBag.ArticulosAsociados = articulosAsociados;

            return View(marca);
        }

        // POST: Marcas/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var marca = await _context.Marcas.FindAsync(id);
            if (marca != null)
            {
                _context.Marcas.Remove(marca);
            }

            await _context.SaveChangesAsync();
            return RedirectToAction(nameof(Index));
        }

        private bool MarcaExists(int id)
        {
            return _context.Marcas.Any(e => e.marCod == id);
        }

        // Metodo para calcular distancia de Levenshtein (similitud entre strings)
        private int CalcularDistanciaLevenshtein(string s1, string s2)
        {
            if (string.IsNullOrEmpty(s1)) return s2?.Length ?? 0;
            if (string.IsNullOrEmpty(s2)) return s1.Length;

            s1 = s1.ToLower();
            s2 = s2.ToLower();

            int[,] d = new int[s1.Length + 1, s2.Length + 1];

            for (int i = 0; i <= s1.Length; i++) d[i, 0] = i;
            for (int j = 0; j <= s2.Length; j++) d[0, j] = j;

            for (int i = 1; i <= s1.Length; i++)
            {
                for (int j = 1; j <= s2.Length; j++)
                {
                    int cost = (s2[j - 1] == s1[i - 1]) ? 0 : 1;
                    d[i, j] = Math.Min(
                        Math.Min(d[i - 1, j] + 1, d[i, j - 1] + 1),
                        d[i - 1, j - 1] + cost);
                }
            }
            return d[s1.Length, s2.Length];
        }

        // Metodo para obtener marcas con nombres similares
        private async Task<List<string>> ObtenerMarcasSimilares(string nombre, int? excludeId)
        {
            var marcasSimilares = new List<string>();
            if (string.IsNullOrWhiteSpace(nombre)) return marcasSimilares;

            var todasLasMarcas = await _context.Marcas
                .Where(m => excludeId == null || m.marCod != excludeId)
                .Select(m => m.marNombre)
                .ToListAsync();

            var nombreNormalizado = nombre.Trim().ToLower();
            int umbralSimilitud = Math.Max(2, nombre.Length / 4); // Umbral dinamico

            foreach (var marcaNombre in todasLasMarcas)
            {
                if (string.IsNullOrEmpty(marcaNombre)) continue;

                var distancia = CalcularDistanciaLevenshtein(nombreNormalizado, marcaNombre);

                // Si la distancia es pequena (nombres similares) pero no es exacta
                if (distancia > 0 && distancia <= umbralSimilitud)
                {
                    marcasSimilares.Add(marcaNombre);
                }
                // Tambien verificar si uno contiene al otro
                else if (nombreNormalizado.Contains(marcaNombre.ToLower()) ||
                         marcaNombre.ToLower().Contains(nombreNormalizado))
                {
                    if (!nombreNormalizado.Equals(marcaNombre.ToLower()))
                    {
                        marcasSimilares.Add(marcaNombre);
                    }
                }
            }

            return marcasSimilares.Take(5).ToList(); // Limitar a 5 sugerencias
        }

        // GET: Marcas/VerificarNombre
        [HttpGet]
        public async Task<IActionResult> VerificarNombre(string nombre, int? excludeId = null)
        {
            if (string.IsNullOrWhiteSpace(nombre))
            {
                return Json(new { existe = false, similares = new List<string>() });
            }

            var nombreNormalizado = nombre.Trim().ToLower();

            // Verificar duplicado exacto
            var query = _context.Marcas.Where(m => m.marNombre.ToLower() == nombreNormalizado);
            if (excludeId.HasValue)
            {
                query = query.Where(m => m.marCod != excludeId.Value);
            }
            var existe = await query.AnyAsync();

            // Buscar similares solo si no hay duplicado exacto
            var similares = new List<string>();
            if (!existe)
            {
                similares = await ObtenerMarcasSimilares(nombre, excludeId);
            }

            return Json(new { existe, similares });
        }

        // GET: Marcas/DownloadTemplate
        public IActionResult DownloadTemplate()
        {
            ExcelPackage.LicenseContext = LicenseContext.NonCommercial;

            using (var package = new ExcelPackage())
            {
                var worksheet = package.Workbook.Worksheets.Add("Marcas");

                var headers = new[] { "Nombre" };

                for (int i = 0; i < headers.Length; i++)
                {
                    worksheet.Cells[1, i + 1].Value = headers[i];
                    worksheet.Cells[1, i + 1].Style.Font.Bold = true;
                    worksheet.Cells[1, i + 1].Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                    worksheet.Cells[1, i + 1].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightGreen);
                }

                // Fila de ejemplo
                worksheet.Cells[2, 1].Value = "Marca Ejemplo S.A.";

                worksheet.Cells.AutoFitColumns();

                var stream = new MemoryStream();
                package.SaveAs(stream);
                stream.Position = 0;

                var fileName = $"Plantilla_Marcas_{DateTime.Now:yyyyMMdd}.xlsx";
                return File(stream, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", fileName);
            }
        }

        // POST: Marcas/ImportExcel
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> ImportExcel(IFormFile excelFile)
        {
            if (excelFile == null || excelFile.Length == 0)
            {
                TempData["ImportMessage"] = "Por favor seleccione un archivo Excel válido.";
                TempData["ImportSuccess"] = false;
                return RedirectToAction(nameof(Index));
            }

            if (!excelFile.FileName.EndsWith(".xlsx", StringComparison.OrdinalIgnoreCase))
            {
                TempData["ImportMessage"] = "El archivo debe ser formato .xlsx";
                TempData["ImportSuccess"] = false;
                return RedirectToAction(nameof(Index));
            }

            ExcelPackage.LicenseContext = LicenseContext.NonCommercial;

            List<string> erroresCriticos = new List<string>();
            List<MarcaImportData> marcasAImportar = new List<MarcaImportData>();

            try
            {
                // Obtener todas las marcas existentes con ID y nombre
                var marcasExistentes = await _context.Marcas
                    .Select(m => new { m.marCod, m.marNombre })
                    .ToListAsync();
                var nombresExistentesSet = new HashSet<string>(
                    marcasExistentes.Select(m => m.marNombre.ToLower().Trim()),
                    StringComparer.OrdinalIgnoreCase);

                // Diccionario para detectar duplicados dentro del archivo (nombre -> primera fila donde aparece)
                var nombresEnArchivo = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);

                using (var stream = new MemoryStream())
                {
                    await excelFile.CopyToAsync(stream);
                    using (var package = new ExcelPackage(stream))
                    {
                        var worksheet = package.Workbook.Worksheets[0];
                        var rowCount = worksheet.Dimension?.Rows ?? 0;

                        if (rowCount < 2)
                        {
                            TempData["ImportMessage"] = "El archivo Excel está vacío o no tiene datos.";
                            TempData["ImportSuccess"] = false;
                            return RedirectToAction(nameof(Index));
                        }

                        // PRIMERA PASADA: Validar todo sin guardar nada
                        for (int row = 2; row <= rowCount; row++)
                        {
                            var marNombre = worksheet.Cells[row, 1].Value?.ToString()?.Trim();

                            // Las filas vacías se saltan silenciosamente
                            if (string.IsNullOrWhiteSpace(marNombre))
                            {
                                continue;
                            }

                            var nombreNormalizado = marNombre.ToLower();

                            // Validar nombre duplicado exacto en base de datos
                            if (nombresExistentesSet.Contains(nombreNormalizado))
                            {
                                erroresCriticos.Add($"Fila {row}: La marca '{marNombre}' ya existe en la base de datos");
                                continue;
                            }

                            // Validar nombre duplicado dentro del archivo
                            if (nombresEnArchivo.TryGetValue(nombreNormalizado, out int primeraFila))
                            {
                                erroresCriticos.Add($"Fila {row}: La marca '{marNombre}' está duplicada en el archivo (también en fila {primeraFila})");
                                continue;
                            }

                            // Buscar nombres similares para advertencias
                            var similares = new List<(int id, string nombre)>();
                            foreach (var existente in marcasExistentes)
                            {
                                if (EsNombreSimilar(marNombre, existente.marNombre))
                                {
                                    similares.Add((existente.marCod, existente.marNombre));
                                }
                            }

                            nombresEnArchivo[nombreNormalizado] = row;
                            marcasAImportar.Add(new MarcaImportData
                            {
                                Nombre = marNombre,
                                FilaExcel = row,
                                MarcasSimilares = similares.Take(3).ToList()
                            });
                        }

                        // Si hay errores críticos, NO guardar nada
                        if (erroresCriticos.Any())
                        {
                            TempData["ImportMessage"] = $"No se importó ninguna marca debido a {erroresCriticos.Count} error(es) crítico(s).";
                            TempData["ImportSuccess"] = false;
                            TempData["ImportErrors"] = string.Join("<br/>", erroresCriticos);
                            return RedirectToAction(nameof(Index));
                        }

                        // Si no hay marcas válidas para importar
                        if (!marcasAImportar.Any())
                        {
                            TempData["ImportMessage"] = "No se encontraron marcas válidas para importar en el archivo.";
                            TempData["ImportSuccess"] = false;
                            return RedirectToAction(nameof(Index));
                        }

                        // SEGUNDA PASADA: Guardar las marcas (ya que no hay errores críticos)
                        var marcasGuardadas = new List<(Marca marca, MarcaImportData datos)>();
                        foreach (var datos in marcasAImportar)
                        {
                            var marca = new Marca { marNombre = datos.Nombre };
                            _context.Marcas.Add(marca);
                            marcasGuardadas.Add((marca, datos));
                        }

                        await _context.SaveChangesAsync();

                        // Generar advertencias con IDs reales
                        var advertencias = new List<string>();
                        foreach (var (marca, datos) in marcasGuardadas)
                        {
                            if (datos.MarcasSimilares.Any())
                            {
                                var similaresStr = string.Join(", ", datos.MarcasSimilares.Select(s => $"{s.nombre} (ID: {s.id})"));
                                advertencias.Add($"Marca '{datos.Nombre}' (ID: {marca.marCod}) tiene nombre similar a: {similaresStr}");
                            }
                        }

                        // Mensaje de éxito
                        TempData["ImportMessage"] = $"Se importaron {marcasAImportar.Count} marca(s) correctamente.";
                        TempData["ImportSuccess"] = true;

                        // Guardar advertencias si las hay
                        if (advertencias.Any())
                        {
                            TempData["ImportWarnings"] = string.Join("<br/>", advertencias);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                TempData["ImportMessage"] = $"Error al importar: {ex.Message}";
                TempData["ImportSuccess"] = false;
            }

            return RedirectToAction(nameof(Index));
        }

        // Clase auxiliar para datos de importación
        private class MarcaImportData
        {
            public string Nombre { get; set; } = string.Empty;
            public int FilaExcel { get; set; }
            public List<(int id, string nombre)> MarcasSimilares { get; set; } = new();
        }

        // Verifica si dos nombres son similares (pero no iguales)
        private bool EsNombreSimilar(string nombre1, string nombre2)
        {
            if (string.IsNullOrWhiteSpace(nombre1) || string.IsNullOrWhiteSpace(nombre2))
                return false;

            var n1 = nombre1.Trim().ToLower();
            var n2 = nombre2.Trim().ToLower();

            // Si son iguales, no es "similar" (es duplicado)
            if (n1 == n2) return false;

            // Verificar distancia de Levenshtein
            var distancia = CalcularDistanciaLevenshtein(n1, n2);
            int umbral = Math.Max(2, nombre1.Length / 4);

            if (distancia > 0 && distancia <= umbral)
                return true;

            // Verificar si uno contiene al otro
            if (n1.Contains(n2) || n2.Contains(n1))
                return true;

            return false;
        }

        // Busca nombres similares en una lista existente (para importacion masiva)
        private List<string> BuscarNombresSimilaresEnLista(string nombre, List<string> listaExistente)
        {
            var similares = new List<string>();
            if (string.IsNullOrWhiteSpace(nombre)) return similares;

            var nombreNormalizado = nombre.Trim().ToLower();
            int umbralSimilitud = Math.Max(2, nombre.Length / 4);

            foreach (var existente in listaExistente)
            {
                if (string.IsNullOrEmpty(existente)) continue;

                var distancia = CalcularDistanciaLevenshtein(nombreNormalizado, existente);

                // Si la distancia es pequena pero no es exacta
                if (distancia > 0 && distancia <= umbralSimilitud)
                {
                    similares.Add(existente);
                }
                // Verificar si uno contiene al otro
                else if (nombreNormalizado.Contains(existente.ToLower()) ||
                         existente.ToLower().Contains(nombreNormalizado))
                {
                    if (!nombreNormalizado.Equals(existente.ToLower()))
                    {
                        similares.Add(existente);
                    }
                }
            }

            return similares.Take(5).ToList();
        }
    }
}
