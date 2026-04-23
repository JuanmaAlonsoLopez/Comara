using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using comara.Data;
using Microsoft.EntityFrameworkCore;
using comara.Models;
using OfficeOpenXml;

namespace comara.Controllers
{
    [Authorize]
    public class ClientesController : Controller
    {
        private readonly ApplicationDbContext _context;

        public ClientesController(ApplicationDbContext context)
        {
            _context = context;
        }

        // GET: Clientes
        public async Task<IActionResult> Index()
        {
            var clientes = await _context.Clientes
                .Include(c => c.TipoFormaPago)
                .Include(c => c.TipoDocumento)
                .Include(c => c.CondicionIVA)
                .ToListAsync();
            return View(clientes);
        }

        // GET: Clientes/Details/5
        public async Task<IActionResult> Details(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var cliente = await _context.Clientes
                .Include(c => c.TipoFormaPago)
                .Include(c => c.TipoDocumento)
                .Include(c => c.CondicionIVA)
                .FirstOrDefaultAsync(m => m.Id == id);
            if (cliente == null)
            {
                return NotFound();
            }

            return View(cliente);
        }

        // GET: Clientes/Create
        public IActionResult Create()
        {
            return View();
        }

        // POST: Clientes/Create
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Create([Bind("CliNombre,CliDireccion,CliTelefono,CliEmail,CliTipoDoc,CliNumDoc,CliCondicionIVA,CliFormaPago")] Cliente cliente)
        {
            if (ModelState.IsValid)
            {
                _context.Add(cliente);
                await _context.SaveChangesAsync();
                return RedirectToAction(nameof(Index));
            }
            return View(cliente);
        }

        // GET: Clientes/Edit/5
        public async Task<IActionResult> Edit(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var cliente = await _context.Clientes.FindAsync(id);
            if (cliente == null)
            {
                return NotFound();
            }
            return View(cliente);
        }

        // POST: Clientes/Edit/5
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Edit(int id, [Bind("Id,CliNombre,CliDireccion,CliTelefono,CliEmail,CliTipoDoc,CliNumDoc,CliCondicionIVA,CliFormaPago")] Cliente cliente)
        {
            if (id != cliente.Id)
            {
                return NotFound();
            }

            if (ModelState.IsValid)
            {
                try
                {
                    _context.Update(cliente);
                    await _context.SaveChangesAsync();
                }
                catch (DbUpdateConcurrencyException)
                {
                    if (!ClienteExists(cliente.Id))
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
            return View(cliente);
        }

        // GET: Clientes/Delete/5
        public async Task<IActionResult> Delete(int? id)
        {
            if (id == null)
            {
                return NotFound();
            }

            var cliente = await _context.Clientes
                .FirstOrDefaultAsync(m => m.Id == id);
            if (cliente == null)
            {
                return NotFound();
            }

            // Verificar si el cliente tiene ventas asociadas
            var tieneVentas = await _context.Ventas.AnyAsync(v => v.CliCod == id);
            ViewBag.TieneVentas = tieneVentas;

            return View(cliente);
        }

        // POST: Clientes/Delete/5
        [HttpPost, ActionName("Delete")]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> DeleteConfirmed(int id)
        {
            var cliente = await _context.Clientes.FindAsync(id);
            if (cliente != null)
            {
                // Verificar si el cliente tiene ventas asociadas
                var tieneVentas = await _context.Ventas.AnyAsync(v => v.CliCod == id);
                if (tieneVentas)
                {
                    TempData["Error"] = "No se puede eliminar el cliente porque tiene ventas asociadas.";
                    return RedirectToAction(nameof(Delete), new { id });
                }

                _context.Clientes.Remove(cliente);
                await _context.SaveChangesAsync();
            }
            return RedirectToAction(nameof(Index));
        }

        // GET: Clientes/DownloadTemplate
        public IActionResult DownloadTemplate()
        {
            // Configurar licencia de EPPlus
            ExcelPackage.LicenseContext = LicenseContext.NonCommercial;

            using (var package = new ExcelPackage())
            {
                var worksheet = package.Workbook.Worksheets.Add("Clientes");

                // Configurar encabezados
                var headers = new[] { "Nombre", "Número Documento", "Dirección", "Teléfono", "Email" };

                for (int i = 0; i < headers.Length; i++)
                {
                    worksheet.Cells[1, i + 1].Value = headers[i];
                    worksheet.Cells[1, i + 1].Style.Font.Bold = true;
                    worksheet.Cells[1, i + 1].Style.Fill.PatternType = OfficeOpenXml.Style.ExcelFillStyle.Solid;
                    worksheet.Cells[1, i + 1].Style.Fill.BackgroundColor.SetColor(System.Drawing.Color.LightGreen);
                }

                // Agregar filas de ejemplo
                worksheet.Cells[2, 1].Value = "Ejemplo: Juan Pérez";
                worksheet.Cells[2, 2].Value = "20-12345678-9";
                worksheet.Cells[2, 3].Value = "Av. Libertador 1234";
                worksheet.Cells[2, 4].Value = "011-4567-8900";
                worksheet.Cells[2, 5].Value = "jperez@email.com";

                worksheet.Cells[3, 1].Value = "Ejemplo: Empresa ABC S.A.";
                worksheet.Cells[3, 2].Value = "30-98765432-1";
                worksheet.Cells[3, 3].Value = "Calle Falsa 456";
                worksheet.Cells[3, 4].Value = "011-9876-5432";
                worksheet.Cells[3, 5].Value = "contacto@abc.com";

                // Ajustar ancho de columnas
                worksheet.Cells.AutoFitColumns();

                var stream = new MemoryStream();
                package.SaveAs(stream);
                stream.Position = 0;

                var fileName = $"Plantilla_Clientes_{DateTime.Now:yyyyMMdd}.xlsx";
                return File(stream, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", fileName);
            }
        }

        // POST: Clientes/ImportExcel
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

            int rowsImported = 0;
            int rowsWithErrors = 0;
            List<string> errors = new List<string>();

            try
            {
                using (var stream = new MemoryStream())
                {
                    await excelFile.CopyToAsync(stream);
                    using (var package = new ExcelPackage(stream))
                    {
                        var worksheet = package.Workbook.Worksheets[0]; // Primera hoja
                        var rowCount = worksheet.Dimension?.Rows ?? 0;

                        if (rowCount < 2)
                        {
                            TempData["ImportMessage"] = "El archivo Excel está vacío o no tiene datos.";
                            TempData["ImportSuccess"] = false;
                            return RedirectToAction(nameof(Index));
                        }

                        // Comenzar desde la fila 2 (la fila 1 son los encabezados)
                        for (int row = 2; row <= rowCount; row++)
                        {
                            try
                            {
                                // Leer valores de las celdas
                                var cliNombre = worksheet.Cells[row, 1].Value?.ToString();
                                var cliNumDoc = worksheet.Cells[row, 2].Value?.ToString();

                                if (string.IsNullOrWhiteSpace(cliNombre))
                                {
                                    errors.Add($"Fila {row}: El nombre es obligatorio");
                                    rowsWithErrors++;
                                    continue;
                                }

                                var cliente = new Cliente
                                {
                                    CliNombre = cliNombre,
                                    CliNumDoc = cliNumDoc,
                                    CliDireccion = worksheet.Cells[row, 3].Value?.ToString(),
                                    CliTelefono = worksheet.Cells[row, 4].Value?.ToString(),
                                    CliEmail = worksheet.Cells[row, 5].Value?.ToString()
                                };

                                _context.Clientes.Add(cliente);
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

                if (rowsImported > 0)
                {
                    var message = $"Se importaron {rowsImported} clientes correctamente.";
                    if (rowsWithErrors > 0)
                    {
                        message += $" {rowsWithErrors} filas con errores.";
                    }
                    TempData["ImportMessage"] = message;
                    TempData["ImportSuccess"] = true;
                }
                else
                {
                    TempData["ImportMessage"] = "No se pudo importar ningún cliente. Verifique el formato del archivo.";
                    TempData["ImportSuccess"] = false;
                }
            }
            catch (DbUpdateException dbEx) when (dbEx.InnerException?.Message.Contains("23505") == true ||
                                                   dbEx.InnerException?.Message.Contains("llave duplicada") == true ||
                                                   dbEx.InnerException?.Message.Contains("duplicate key") == true)
            {
                TempData["ImportMessage"] = "Error: Ya existe un cliente con uno de los datos ingresados (posiblemente número de documento duplicado).";
                TempData["ImportSuccess"] = false;
            }
            catch (Exception ex)
            {
                TempData["ImportMessage"] = $"Error al procesar el archivo: {ex.Message}";
                TempData["ImportSuccess"] = false;
            }

            return RedirectToAction(nameof(Index));
        }

        private bool ClienteExists(int id)
        {
            return _context.Clientes.Any(e => e.Id == id);
        }
    }
}
