using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using comara.Data;
using Microsoft.EntityFrameworkCore;
using comara.Models;
using Microsoft.AspNetCore.Mvc.Rendering;
using OfficeOpenXml;
using System.Globalization;
using comara.Services;

namespace comara.Controllers
{
    [Authorize]
    public class ArticulosController : Controller
    {
        private readonly ApplicationDbContext _context;
        private readonly IDropdownService _dropdownService;

        public ArticulosController(ApplicationDbContext context, IDropdownService dropdownService)
        {
            _context = context;
            _dropdownService = dropdownService;
        }

        public async Task<IActionResult> Index(string searchTerm = "", int page = 1, int pageSize = 20)
        {
            // Asegurar valores válidos
            if (page < 1) page = 1;
            if (pageSize < 1) pageSize = 20;
            if (pageSize > 100) pageSize = 100; // Límite máximo

            var query = _context.Articulos
                .Include(a => a.Marca)
                .Include(a => a.Proveedor)
                .Include(a => a.Iva)
                .AsQueryable();

            // Aplicar filtro de búsqueda si existe
            if (!string.IsNullOrWhiteSpace(searchTerm))
            {
                int? idBusqueda = int.TryParse(searchTerm.Trim(), out int parsed) ? parsed : (int?)null;
                query = query.Where(a =>
                    (idBusqueda.HasValue && a.Id == idBusqueda.Value) ||
                    (a.ArtDesc != null && EF.Functions.ILike(a.ArtDesc, $"{searchTerm}%")) ||
                    (a.ArtDesc != null && EF.Functions.ILike(a.ArtDesc, $"%{searchTerm}%")) ||
                    (a.Marca != null && a.Marca.marNombre != null && EF.Functions.ILike(a.Marca.marNombre, $"%{searchTerm}%")) ||
                    (a.Proveedor != null && a.Proveedor.proNombre != null && EF.Functions.ILike(a.Proveedor.proNombre, $"%{searchTerm}%"))
                );
            }

            // Contar total para paginación
            var totalItems = await query.CountAsync();
            var totalPages = (int)Math.Ceiling(totalItems / (double)pageSize);

            // Ajustar página si excede el total
            if (page > totalPages && totalPages > 0) page = totalPages;

            // Obtener artículos de la página actual
            var articulos = await query
                .OrderBy(a => a.Id)
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

        // API: Articulos/Search
        [HttpGet]
        public async Task<IActionResult> Search(string searchTerm = "", int offset = 0, int limit = 15)
        {
            var query = _context.Articulos
                .Include(a => a.Marca)
                .Include(a => a.Proveedor)
                .Include(a => a.Iva)
                .AsQueryable();

            if (!string.IsNullOrWhiteSpace(searchTerm))
            {
                int? idBusqueda = int.TryParse(searchTerm.Trim(), out int parsed) ? parsed : (int?)null;
                query = query.Where(a =>
                    (idBusqueda.HasValue && a.Id == idBusqueda.Value) ||
                    (a.ArtDesc != null && EF.Functions.ILike(a.ArtDesc, $"{searchTerm}%")) ||
                    (a.ArtDesc != null && EF.Functions.ILike(a.ArtDesc, $"%{searchTerm}%")) ||
                    (a.Marca != null && a.Marca.marNombre != null && EF.Functions.ILike(a.Marca.marNombre, $"%{searchTerm}%")) ||
                    (a.Proveedor != null && a.Proveedor.proNombre != null && EF.Functions.ILike(a.Proveedor.proNombre, $"%{searchTerm}%"))
                );
            }

            var total = await query.CountAsync();
            var articulos = await query
                .OrderBy(a => a.Id)
                .Skip(offset)
                .Take(limit)
                .Select(a => new
                {
                    a.Id,
                    a.ArtCod,
                    a.ArtDesc,
                    ArtCost = a.ArtCost ?? 0,
                    CostoConDescuento = a.CostoConDescuento,
                    CostoFinal = a.CostoFinal,
                    a.ArtStock,
                    MarcaNombre = a.Marca != null ? a.Marca.marNombre : "",
                    ProveedorNombre = a.Proveedor != null ? a.Proveedor.proNombre : "",
                    ProveedorDescuento = a.Proveedor != null ? a.Proveedor.proDescuento : 0,
                    IvaPorcentaje = a.Iva != null ? a.Iva.Porcentaje : 0
                })
                .ToListAsync();

            return Json(new { articulos, total, hasMore = (offset + limit) < total });
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
                .Include(a => a.Iva)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (articulo == null)
            {
                return NotFound();
            }

            // Cargar listas activas para calcular precios
            ViewBag.Listas = await _context.Listas
                .Where(l => l.ListStatus)
                .OrderBy(l => l.ListCode)
                .ToListAsync();

            return View(articulo);
        }

        // GET: Articulos/Create
        public async Task<IActionResult> Create()
        {
            var dropdowns = await _dropdownService.GetDropdownsArticuloAsync();
            ViewData["MarCod"] = dropdowns.Marcas;
            ViewData["ProCod"] = dropdowns.Proveedores;
            ViewData["IvaCod"] = dropdowns.Ivas;
            return View();
        }

        // POST: Articulos/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("ArtDesc,Activo,ArtUni,ArtExist,RubCod,SrubCod,MarCod,IvaCod,ArtAlt1,ArtAlt2,ArtL1,ArtL2,ArtL3,ArtL4,ArtL5,ProCod")] Articulo articulo, string ArtStockStr, string ArtStockMinStr, string ArtCostStr)
        {
            // Normalizar separadores decimales: acepta tanto "," como "."
            var stockStr = ArtStockStr?.Replace(",", ".") ?? "0";
            var stockMinStr = ArtStockMinStr?.Replace(",", ".") ?? "0";
            var costStr = ArtCostStr?.Replace(",", ".") ?? "0";

            if (!decimal.TryParse(stockStr, NumberStyles.Any, CultureInfo.InvariantCulture, out decimal stock))
            {
                ModelState.AddModelError("ArtStock", "El valor de Stock debe ser un número válido");
            }
            else
            {
                articulo.ArtStock = stock;
            }

            if (!decimal.TryParse(stockMinStr, NumberStyles.Any, CultureInfo.InvariantCulture, out decimal stockMin))
            {
                ModelState.AddModelError("ArtStockMin", "El valor de Stock crítico debe ser un número válido");
            }
            else
            {
                articulo.ArtStockMin = stockMin;
            }

            if (!decimal.TryParse(costStr, NumberStyles.Any, CultureInfo.InvariantCulture, out decimal cost))
            {
                ModelState.AddModelError("ArtCost", "El valor de Costo debe ser un número válido");
            }
            else
            {
                articulo.ArtCost = cost;
            }

            if (ModelState.IsValid)
            {
                // Asignar valor temporal a ArtCod para cumplir restricción NOT NULL
                articulo.ArtCod = Guid.NewGuid().ToString("N").Substring(0, 20);

                _context.Add(articulo);
                await _context.SaveChangesAsync();

                // Actualizar ArtCod con el Id generado
                articulo.ArtCod = articulo.Id.ToString();
                await _context.SaveChangesAsync();

                // Verificar si hay otros artículos con la misma descripción
                if (!string.IsNullOrWhiteSpace(articulo.ArtDesc))
                {
                    var articulosMismaDescripcion = await _context.Articulos
                        .Where(a => a.ArtDesc != null && a.ArtDesc.ToLower() == articulo.ArtDesc.ToLower())
                        .Select(a => a.Id)
                        .ToListAsync();

                    if (articulosMismaDescripcion.Count > 1)
                    {
                        var ids = string.Join(", ", articulosMismaDescripcion);
                        TempData["WarningMessage"] = $"Advertencia: Existen artículos con la misma descripción '{articulo.ArtDesc}'. IDs: {ids}";
                    }
                }

                return RedirectToAction(nameof(Index));
            }
            var dropdowns = await _dropdownService.GetDropdownsArticuloAsync(articulo.MarCod, articulo.ProCod, articulo.IvaCod);
            ViewData["MarCod"] = dropdowns.Marcas;
            ViewData["ProCod"] = dropdowns.Proveedores;
            ViewData["IvaCod"] = dropdowns.Ivas;
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
            var dropdowns = await _dropdownService.GetDropdownsArticuloAsync(articulo.MarCod, articulo.ProCod, articulo.IvaCod);
            ViewData["MarCod"] = dropdowns.Marcas;
            ViewData["ProCod"] = dropdowns.Proveedores;
            ViewData["IvaCod"] = dropdowns.Ivas;
            return View(articulo);
        }

        // POST: Articulos/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,ArtCod,ArtDesc,Activo,ArtUni,ArtExist,RubCod,SrubCod,MarCod,IvaCod,ArtAlt1,ArtAlt2,ArtL1,ArtL2,ArtL3,ArtL4,ArtL5,ProCod")] Articulo articulo, string ArtStockStr, string ArtStockMinStr, string ArtCostStr)
        {
            if (id != articulo.Id)
            {
                return NotFound();
            }

            // Normalizar separadores decimales: acepta tanto "," como "."
            var stockStr = ArtStockStr?.Replace(",", ".") ?? "0";
            var stockMinStr = ArtStockMinStr?.Replace(",", ".") ?? "0";
            var costStr = ArtCostStr?.Replace(",", ".") ?? "0";

            if (!decimal.TryParse(stockStr, NumberStyles.Any, CultureInfo.InvariantCulture, out decimal stock))
            {
                ModelState.AddModelError("ArtStock", "El valor de Stock debe ser un número válido");
            }
            else
            {
                articulo.ArtStock = stock;
            }

            if (!decimal.TryParse(stockMinStr, NumberStyles.Any, CultureInfo.InvariantCulture, out decimal stockMin))
            {
                ModelState.AddModelError("ArtStockMin", "El valor de Stock crítico debe ser un número válido");
            }
            else
            {
                articulo.ArtStockMin = stockMin;
            }

            if (!decimal.TryParse(costStr, NumberStyles.Any, CultureInfo.InvariantCulture, out decimal cost))
            {
                ModelState.AddModelError("ArtCost", "El valor de Costo debe ser un número válido");
            }
            else
            {
                articulo.ArtCost = cost;
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
                    if (!ArticuloExists(articulo.Id))
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
            var dropdowns = await _dropdownService.GetDropdownsArticuloAsync(articulo.MarCod, articulo.ProCod, articulo.IvaCod);
            ViewData["MarCod"] = dropdowns.Marcas;
            ViewData["ProCod"] = dropdowns.Proveedores;
            ViewData["IvaCod"] = dropdowns.Ivas;
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
                .Include(a => a.Iva)
                .FirstOrDefaultAsync(m => m.Id == id);
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
            if (articulo == null)
            {
                TempData["ErrorMessage"] = "El artículo no fue encontrado.";
                return RedirectToAction(nameof(Index));
            }

            try
            {
                _context.Articulos.Remove(articulo);
                await _context.SaveChangesAsync();
                TempData["SuccessMessage"] = $"Artículo '{articulo.ArtDesc}' eliminado correctamente.";
            }
            catch (DbUpdateException ex)
            {
                var innerMessage = ex.InnerException?.Message ?? ex.Message;
                TempData["ErrorMessage"] = $"No se pudo eliminar: {innerMessage}";
            }
            catch (Exception ex)
            {
                TempData["ErrorMessage"] = $"Error inesperado: {ex.Message}";
            }

            return RedirectToAction(nameof(Index));
        }

        // GET: Articulos/DownloadTemplate
        public IActionResult DownloadTemplate()
        {
            // Configurar licencia de EPPlus
            ExcelPackage.LicenseContext = LicenseContext.NonCommercial;

            using (var package = new ExcelPackage())
            {
                // Hoja principal de Artículos
                var worksheet = package.Workbook.Worksheets.Add("Artículos");

                // Configurar encabezados - columnas actualizadas (sin Unidad, Código Rubro, Código Subrubro)
                var headers = new[]
                {
                    "Código Artículo", "Descripción", "Stock", "Stock Mínimo",
                    "Código Marca", "Código IVA", "Código Proveedor", "Costo"
                };

                for (int i = 0; i < headers.Length; i++)
                {
                    worksheet.Cells[1, i + 1].Value = headers[i];
                    worksheet.Cells[1, i + 1].Style.Font.Bold = true;
                    worksheet.Cells[1, i + 1].Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                    worksheet.Cells[1, i + 1].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightBlue);
                }

                // Agregar una fila de ejemplo
                worksheet.Cells[2, 1].Value = 12345;
                worksheet.Cells[2, 2].Value = "Ejemplo: Tornillo M8 x 20mm";
                worksheet.Cells[2, 3].Value = 100;
                worksheet.Cells[2, 4].Value = 10;
                worksheet.Cells[2, 5].Value = 1;
                worksheet.Cells[2, 6].Value = 1;
                worksheet.Cells[2, 7].Value = 1;
                worksheet.Cells[2, 8].Value = 1100;

                // Ajustar ancho de columnas
                worksheet.Cells.AutoFitColumns();

                // Hoja de ayuda con códigos de IVA
                var helpSheet = package.Workbook.Worksheets.Add("Ayuda - Códigos IVA");

                // Encabezados de la hoja de ayuda
                helpSheet.Cells[1, 1].Value = "Código";
                helpSheet.Cells[1, 2].Value = "Porcentaje";
                helpSheet.Cells[1, 1].Style.Font.Bold = true;
                helpSheet.Cells[1, 2].Style.Font.Bold = true;
                helpSheet.Cells[1, 1].Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                helpSheet.Cells[1, 1].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightGreen);
                helpSheet.Cells[1, 2].Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                helpSheet.Cells[1, 2].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightGreen);

                // Datos de IVA
                helpSheet.Cells[2, 1].Value = 3;
                helpSheet.Cells[2, 2].Value = "0.00";
                helpSheet.Cells[3, 1].Value = 4;
                helpSheet.Cells[3, 2].Value = "10.50";
                helpSheet.Cells[4, 1].Value = 5;
                helpSheet.Cells[4, 2].Value = "21.00";
                helpSheet.Cells[5, 1].Value = 6;
                helpSheet.Cells[5, 2].Value = "27.00";

                // Ajustar ancho de columnas de la hoja de ayuda
                helpSheet.Cells.AutoFitColumns();

                var stream = new MemoryStream();
                package.SaveAs(stream);
                stream.Position = 0;

                var fileName = $"Plantilla_Articulos_{DateTime.Now:yyyyMMdd}.xlsx";
                return File(stream, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", fileName);
            }
        }

        // POST: Articulos/ImportExcel
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

            // Configurar licencia de EPPlus (uso no comercial)
            ExcelPackage.LicenseContext = LicenseContext.NonCommercial;

            try
            {
                // FASE 1: Cargar datos de referencia de la BD
                var marcasValidas = await _context.Marcas.Select(m => m.marCod).ToListAsync();
                var marcasValidasSet = new HashSet<int>(marcasValidas);

                var proveedoresValidos = await _context.Proveedores.Select(p => p.proCod).ToListAsync();
                var proveedoresValidosSet = new HashSet<int>(proveedoresValidos);

                var ivasValidos = await _context.Ivas.Select(i => i.Id).ToListAsync();
                var ivasValidosSet = new HashSet<int>(ivasValidos);

                var codigosExistentes = await _context.Articulos.Select(a => a.ArtCod).ToListAsync();
                var codigosExistentesSet = new HashSet<string>(codigosExistentes, StringComparer.OrdinalIgnoreCase);

                var descripcionesExistentes = await _context.Articulos
                    .Select(a => new { a.ArtCod, a.ArtDesc })
                    .ToListAsync();
                var descripcionesBD = descripcionesExistentes
                    .GroupBy(a => a.ArtDesc?.ToUpperInvariant() ?? "")
                    .ToDictionary(g => g.Key, g => g.Select(a => a.ArtCod).ToList());

                // Listas para validación
                var articulosAImportar = new List<(Articulo articulo, int fila)>();
                var codigosEnExcel = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase); // codigo -> primera fila
                var descripcionesEnExcel = new Dictionary<string, List<(string codigo, int fila)>>(StringComparer.OrdinalIgnoreCase); // desc -> lista de (codigo, fila)
                var erroresCriticos = new List<string>();
                var advertencias = new List<string>();

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

                        // FASE 2: Primera pasada - Leer y validar datos del Excel
                        for (int row = 2; row <= rowCount; row++)
                        {
                            // Leer valores de las celdas
                            // Columnas: 1=Código, 2=Descripción, 3=Stock, 4=StockMin, 5=Marca, 6=IVA, 7=Proveedor, 8=Costo
                            var artCod = worksheet.Cells[row, 1].Value?.ToString()?.Trim();
                            var artDesc = worksheet.Cells[row, 2].Value?.ToString()?.Trim();

                            // Ignorar filas completamente vacías
                            if (string.IsNullOrWhiteSpace(artCod) && string.IsNullOrWhiteSpace(artDesc))
                            {
                                continue;
                            }

                            // Validar campos obligatorios
                            if (string.IsNullOrWhiteSpace(artCod))
                            {
                                erroresCriticos.Add($"Fila {row}: El código de artículo es obligatorio");
                                continue;
                            }

                            if (string.IsNullOrWhiteSpace(artDesc))
                            {
                                erroresCriticos.Add($"Fila {row}: La descripción es obligatoria");
                                continue;
                            }

                            // Validar código duplicado dentro del Excel
                            if (codigosEnExcel.TryGetValue(artCod, out int primeraFila))
                            {
                                erroresCriticos.Add($"Fila {row}: El código '{artCod}' está duplicado en la planilla (también en fila {primeraFila})");
                                continue;
                            }
                            codigosEnExcel[artCod] = row;

                            // Validar código no existe en BD
                            if (codigosExistentesSet.Contains(artCod))
                            {
                                erroresCriticos.Add($"Fila {row}: El código '{artCod}' ya existe en la base de datos");
                                continue;
                            }

                            // Parsear valores numéricos
                            int marCod = int.TryParse(worksheet.Cells[row, 5].Value?.ToString(), out int m) ? m : 0;
                            int ivaCod = int.TryParse(worksheet.Cells[row, 6].Value?.ToString(), out int i) ? i : 0;
                            int proCod = int.TryParse(worksheet.Cells[row, 7].Value?.ToString(), out int p) ? p : 0;

                            // Validar marca existe
                            if (marCod != 0 && !marcasValidasSet.Contains(marCod))
                            {
                                erroresCriticos.Add($"Fila {row}: La marca con código '{marCod}' no existe");
                                continue;
                            }

                            // Validar IVA existe
                            if (ivaCod != 0 && !ivasValidosSet.Contains(ivaCod))
                            {
                                erroresCriticos.Add($"Fila {row}: El IVA con código '{ivaCod}' no existe. Use: 3 (0%), 4 (10.5%), 5 (21%), 6 (27%)");
                                continue;
                            }

                            // Validar proveedor existe
                            if (proCod != 0 && !proveedoresValidosSet.Contains(proCod))
                            {
                                erroresCriticos.Add($"Fila {row}: El proveedor con código '{proCod}' no existe");
                                continue;
                            }

                            // Registrar descripción para detección de duplicados
                            var descKey = artDesc.ToUpperInvariant();
                            if (!descripcionesEnExcel.ContainsKey(descKey))
                            {
                                descripcionesEnExcel[descKey] = new List<(string, int)>();
                            }
                            descripcionesEnExcel[descKey].Add((artCod, row));

                            // Crear artículo válido
                            // Normalizar separadores decimales: acepta tanto "," como "."
                            var stockStr = worksheet.Cells[row, 3].Value?.ToString()?.Replace(",", ".") ?? "0";
                            var stockMinStr = worksheet.Cells[row, 4].Value?.ToString()?.Replace(",", ".") ?? "0";
                            var costoStr = worksheet.Cells[row, 8].Value?.ToString()?.Replace(",", ".") ?? "0";

                            var articulo = new Articulo
                            {
                                ArtCod = artCod,
                                ArtDesc = artDesc,
                                ArtStock = decimal.TryParse(stockStr, NumberStyles.Any, CultureInfo.InvariantCulture, out decimal stock) ? stock : 0,
                                ArtStockMin = decimal.TryParse(stockMinStr, NumberStyles.Any, CultureInfo.InvariantCulture, out decimal stockMin) ? stockMin : 0,
                                MarCod = marCod != 0 ? marCod : 1,
                                IvaCod = ivaCod != 0 ? ivaCod : 5, // Default: 21%
                                ProCod = proCod != 0 ? proCod : 1,
                                ArtCost = decimal.TryParse(costoStr, NumberStyles.Any, CultureInfo.InvariantCulture, out decimal artCost) ? artCost : 0,
                                ArtUni = 0,
                                RubCod = 0,
                                SrubCod = 0
                            };

                            articulosAImportar.Add((articulo, row));
                        }
                    }
                }

                // FASE 3: Si hay errores críticos, no guardar nada
                if (erroresCriticos.Any())
                {
                    TempData["ImportMessage"] = "No se importaron artículos debido a los siguientes errores:<br/><br/>" +
                        string.Join("<br/>", erroresCriticos);
                    TempData["ImportSuccess"] = false;
                    return RedirectToAction(nameof(Index));
                }

                // Verificar si hay artículos para importar
                if (!articulosAImportar.Any())
                {
                    TempData["ImportMessage"] = "No se encontraron artículos válidos para importar en el archivo.";
                    TempData["ImportSuccess"] = false;
                    return RedirectToAction(nameof(Index));
                }

                // FASE 4: Generar advertencias de descripciones duplicadas
                // Duplicados dentro del Excel
                foreach (var kvp in descripcionesEnExcel.Where(d => d.Value.Count > 1))
                {
                    var codigos = string.Join(", ", kvp.Value.Select(x => $"'{x.codigo}'"));
                    advertencias.Add($"Descripción duplicada en planilla '{kvp.Value.First().codigo.ToUpperInvariant()}...': códigos {codigos}");
                }

                // Duplicados contra la BD
                foreach (var kvp in descripcionesEnExcel)
                {
                    if (descripcionesBD.TryGetValue(kvp.Key, out var codigosBD))
                    {
                        var nuevos = string.Join(", ", kvp.Value.Select(x => $"'{x.codigo}'"));
                        var existentes = string.Join(", ", codigosBD.Take(3).Select(c => $"'{c}'")); // Mostrar máximo 3
                        if (codigosBD.Count > 3)
                            existentes += $" (y {codigosBD.Count - 3} más)";
                        advertencias.Add($"La descripción '{kvp.Key}' ya existe en BD con códigos: {existentes}. Nuevos: {nuevos}");
                    }
                }

                // FASE 5: Guardar todos los artículos
                foreach (var (articulo, _) in articulosAImportar)
                {
                    _context.Articulos.Add(articulo);
                }
                await _context.SaveChangesAsync();

                // FASE 6: Construir mensaje de éxito
                var mensaje = $"Se importaron {articulosAImportar.Count} artículos correctamente.";

                if (advertencias.Any())
                {
                    TempData["ImportMessage"] = mensaje;
                    TempData["ImportSuccess"] = true;
                    TempData["ImportWarnings"] = string.Join("<br/>", advertencias);
                }
                else
                {
                    TempData["ImportMessage"] = mensaje;
                    TempData["ImportSuccess"] = true;
                }
            }
            catch (Exception ex)
            {
                TempData["ImportMessage"] = $"Error al procesar el archivo: {ex.Message}";
                TempData["ImportSuccess"] = false;
            }

            return RedirectToAction(nameof(Index));
        }

        private bool ArticuloExists(int id)
        {
            return _context.Articulos.Any(e => e.Id == id);
        }
    }
}