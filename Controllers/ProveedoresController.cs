using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using comara.Data;
using Microsoft.EntityFrameworkCore;
using comara.Models;
using OfficeOpenXml;

namespace comara.Controllers
{
    [Authorize]
    public class ProveedoresController : Controller
    {
        private readonly ApplicationDbContext _context;

        public ProveedoresController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Proveedores
        public async Task<IActionResult> Index(string searchTerm = "", int page = 1, int pageSize = 20)
        {
            // Asegurar valores válidos
            if (page < 1) page = 1;
            if (pageSize < 1) pageSize = 20;
            if (pageSize > 100) pageSize = 100;

            var query = _context.Proveedores.AsQueryable();

            // Aplicar filtro de búsqueda si existe
            if (!string.IsNullOrWhiteSpace(searchTerm))
            {
                var term = searchTerm.ToLower();
                query = query.Where(p =>
                    p.proNombre.ToLower().Contains(term) ||
                    (p.proCUIT != null && p.proCUIT.ToLower().Contains(term)) ||
                    (p.proContacto != null && p.proContacto.ToLower().Contains(term)) ||
                    (p.proEmail != null && p.proEmail.ToLower().Contains(term))
                );
            }

            // Contar total para paginación
            var totalItems = await query.CountAsync();
            var totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            // Ajustar página si excede el total
            if (page > totalPages && totalPages > 0) page = totalPages;

            // Obtener proveedores de la página actual
            var proveedores = await query
                .OrderBy(p => p.proNombre)
                .Skip((page - 1) * pageSize)
                .Take(pageSize)
                .ToListAsync();

            // Pasar información de paginación a la vista
            ViewBag.CurrentPage = page;
            ViewBag.TotalPages = totalPages;
            ViewBag.TotalItems = totalItems;
            ViewBag.PageSize = pageSize;
            ViewBag.SearchTerm = searchTerm;

            return View(proveedores);
        }

        // GET: Proveedores/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var proveedor = await _context.Proveedores
                .FirstOrDefaultAsync(m => m.proCod == id);
            if (proveedor == null)
            {
                return NotFound();
            }

            return View(proveedor);
        }

        // GET: Proveedores/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: Proveedores/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("proNombre,proCUIT,proContacto,proDescuento,proEmail,proCelular")] Proveedor proveedor)
        {
            // Validar CUIT duplicado (normalizado sin guiones)
            if (!string.IsNullOrWhiteSpace(proveedor.proCUIT))
            {
                var cuitNormalizado = NormalizarCuit(proveedor.proCUIT);
                var cuitExistente = await _context.Proveedores
                    .AnyAsync(p => p.proCUIT != null &&
                        p.proCUIT.Replace("-", "") == cuitNormalizado);

                if (cuitExistente)
                {
                    ModelState.AddModelError("proCUIT", "Ya existe un proveedor con este CUIT.");
                }
            }

            if (ModelState.IsValid)
            {
                _context.Add(proveedor);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(proveedor);
        }

        // GET: Proveedores/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var proveedor = await _context.Proveedores.FindAsync(id);
            if (proveedor == null)
            {
                return NotFound();
            }
            return View(proveedor);
        }

        // POST: Proveedores/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("proCod,proNombre,proCUIT,proContacto,proDescuento,proEmail,proCelular")] Proveedor proveedor)
        {
            if (id != proveedor.proCod)
            {
                return NotFound();
            }

            // Validar CUIT duplicado (normalizado sin guiones, excluyendo el proveedor actual)
            if (!string.IsNullOrWhiteSpace(proveedor.proCUIT))
            {
                var cuitNormalizado = NormalizarCuit(proveedor.proCUIT);
                var cuitExistente = await _context.Proveedores
                    .AnyAsync(p => p.proCUIT != null &&
                        p.proCUIT.Replace("-", "") == cuitNormalizado &&
                        p.proCod != id);

                if (cuitExistente)
                {
                    ModelState.AddModelError("proCUIT", "Ya existe otro proveedor con este CUIT.");
                }
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(proveedor);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ProveedorExists(proveedor.proCod))
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
            return View(proveedor);
        }

        // GET: Proveedores/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var proveedor = await _context.Proveedores
                .FirstOrDefaultAsync(m => m.proCod == id);
            if (proveedor == null)
            {
                return NotFound();
            }

            return View(proveedor);
        }

        // POST: Proveedores/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var proveedor = await _context.Proveedores.FindAsync(id);
            if (proveedor != null)
            {
                _context.Proveedores.Remove(proveedor);
                await _context.SaveChangesAsync();
            }
            return RedirectToAction(nameof(Index));
        }

        private bool ProveedorExists(int id)
        {
            return _context.Proveedores.Any(e => e.proCod == id);
        }

        // Normaliza el CUIT quitando guiones y espacios
        private string NormalizarCuit(string cuit)
        {
            if (string.IsNullOrWhiteSpace(cuit)) return string.Empty;
            return cuit.Replace("-", "").Replace(" ", "").Trim();
        }

        // GET: Proveedores/VerificarCuit
        [HttpGet]
        public async Task<IActionResult> VerificarCuit(string cuit, int? excludeId = null)
        {
            if (string.IsNullOrWhiteSpace(cuit))
            {
                return Json(new { existe = false });
            }

            var cuitNormalizado = NormalizarCuit(cuit);

            var query = _context.Proveedores
                .Where(p => p.proCUIT != null &&
                    p.proCUIT.Replace("-", "") == cuitNormalizado);

            if (excludeId.HasValue)
            {
                query = query.Where(p => p.proCod != excludeId.Value);
            }

            var existe = await query.AnyAsync();
            var proveedor = existe ? await query.Select(p => p.proNombre).FirstOrDefaultAsync() : null;

            return Json(new { existe, proveedor });
        }

        // GET: Proveedores/DownloadTemplate
        public IActionResult DownloadTemplate()
        {
            ExcelPackage.LicenseContext = LicenseContext.NonCommercial;

            using (var package = new ExcelPackage())
            {
                var worksheet = package.Workbook.Worksheets.Add("Proveedores");

                var headers = new[]
                {
                    "Nombre", "CUIT", "Contacto", "Descuento (%)", "Email", "Celular"
                };

                for (int i = 0; i < headers.Length; i++)
                {
                    worksheet.Cells[1, i + 1].Value = headers[i];
                    worksheet.Cells[1, i + 1].Style.Font.Bold = true;
                    worksheet.Cells[1, i + 1].Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                    worksheet.Cells[1, i + 1].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightBlue);
                }

                // Fila de ejemplo
                worksheet.Cells[2, 1].Value = "Proveedor Ejemplo S.A.";
                worksheet.Cells[2, 2].Value = "20-12345678-9";
                worksheet.Cells[2, 3].Value = "Juan Pérez";
                worksheet.Cells[2, 4].Value = 10;
                worksheet.Cells[2, 5].Value = "contacto@ejemplo.com";
                worksheet.Cells[2, 6].Value = "+54 9 11 1234-5678";

                worksheet.Cells.AutoFitColumns();

                var stream = new MemoryStream();
                package.SaveAs(stream);
                stream.Position = 0;

                var fileName = $"Plantilla_Proveedores_{DateTime.Now:yyyyMMdd}.xlsx";
                return File(stream, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", fileName);
            }
        }

        // POST: Proveedores/ImportExcel
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

            int rowsImported = 0;
            int rowsWithErrors = 0;
            int rowsSkippedDuplicate = 0;
            List<string> errors = new List<string>();

            try
            {
                // Obtener todos los CUITs existentes en la base de datos (normalizados)
                var cuitsExistentes = await _context.Proveedores
                    .Where(p => p.proCUIT != null)
                    .Select(p => p.proCUIT!.Replace("-", ""))
                    .ToListAsync();
                var cuitsExistentesSet = new HashSet<string>(cuitsExistentes, StringComparer.OrdinalIgnoreCase);

                // Set para detectar duplicados dentro del mismo archivo
                var cuitsEnArchivo = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

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

                        for (int row = 2; row <= rowCount; row++)
                        {
                            try
                            {
                                var proNombre = worksheet.Cells[row, 1].Value?.ToString();

                                if (string.IsNullOrWhiteSpace(proNombre))
                                {
                                    errors.Add($"Fila {row}: El nombre del proveedor es obligatorio");
                                    rowsWithErrors++;
                                    continue;
                                }

                                var proCuit = worksheet.Cells[row, 2].Value?.ToString();
                                var cuitNormalizado = NormalizarCuit(proCuit ?? "");

                                // Validar CUIT duplicado en base de datos
                                if (!string.IsNullOrEmpty(cuitNormalizado))
                                {
                                    if (cuitsExistentesSet.Contains(cuitNormalizado))
                                    {
                                        errors.Add($"Fila {row}: El CUIT {proCuit} ya existe en la base de datos");
                                        rowsSkippedDuplicate++;
                                        continue;
                                    }

                                    // Validar CUIT duplicado dentro del archivo
                                    if (cuitsEnArchivo.Contains(cuitNormalizado))
                                    {
                                        errors.Add($"Fila {row}: El CUIT {proCuit} esta duplicado en el archivo");
                                        rowsSkippedDuplicate++;
                                        continue;
                                    }

                                    cuitsEnArchivo.Add(cuitNormalizado);
                                }

                                var proveedor = new Proveedor
                                {
                                    proNombre = proNombre,
                                    proCUIT = proCuit,
                                    proContacto = worksheet.Cells[row, 3].Value?.ToString(),
                                    proDescuento = decimal.TryParse(worksheet.Cells[row, 4].Value?.ToString(), out decimal descuento) ? descuento : null,
                                    proEmail = worksheet.Cells[row, 5].Value?.ToString(),
                                    proCelular = worksheet.Cells[row, 6].Value?.ToString()
                                };

                                _context.Proveedores.Add(proveedor);
                                rowsImported++;
                            }
                            catch (Exception ex)
                            {
                                errors.Add($"Fila {row}: {ex.Message}");
                                rowsWithErrors++;
                            }
                        }

                        if (rowsImported > 0)
                        {
                            await _context.SaveChangesAsync();
                        }
                    }
                }

                // Construir mensaje de resultado
                var mensajes = new List<string>();
                if (rowsImported > 0)
                    mensajes.Add($"Se importaron {rowsImported} proveedores correctamente");
                if (rowsSkippedDuplicate > 0)
                    mensajes.Add($"{rowsSkippedDuplicate} omitidos por CUIT duplicado");
                if (rowsWithErrors > 0)
                    mensajes.Add($"{rowsWithErrors} filas con errores");

                if (rowsImported > 0)
                {
                    TempData["ImportMessage"] = string.Join(". ", mensajes) + ".";
                    TempData["ImportSuccess"] = true;
                }
                else
                {
                    TempData["ImportMessage"] = "No se importaron proveedores. " + string.Join("; ", errors.Take(5));
                    TempData["ImportSuccess"] = false;
                }

                // Guardar errores detallados para mostrar
                if (errors.Any())
                {
                    TempData["ImportErrors"] = string.Join("\n", errors.Take(10));
                }
            }
            catch (Exception ex)
            {
                TempData["ImportMessage"] = $"Error al importar: {ex.Message}";
                TempData["ImportSuccess"] = false;
            }

            return RedirectToAction(nameof(Index));
        }
    }
}
