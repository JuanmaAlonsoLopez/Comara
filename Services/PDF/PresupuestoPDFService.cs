using comara.Data;
using comara.Models;
using Microsoft.EntityFrameworkCore;
using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;

namespace comara.Services.PDF
{
    public class PresupuestoPDFService : IPresupuestoPDFService
    {
        private readonly ApplicationDbContext _context;
        private readonly ILogger<PresupuestoPDFService> _logger;

        public PresupuestoPDFService(
            ApplicationDbContext context,
            ILogger<PresupuestoPDFService> logger)
        {
            _context = context;
            _logger = logger;
        }

        public async Task<byte[]> GenerarPDFPresupuestoAsync(int ventaId)
        {
            try
            {
                // Cargar la venta con todas sus relaciones
                var venta = await _context.Ventas
                    .Include(v => v.Cliente)
                        .ThenInclude(c => c!.TipoDocumento)
                    .Include(v => v.Cliente)
                        .ThenInclude(c => c!.CondicionIVA)
                    .Include(v => v.TipoMetodoPago)
                    .Include(v => v.DetalleVentas)
                        .ThenInclude(d => d.Articulo)
                            .ThenInclude(a => a!.Marca)
                    .Include(v => v.DetalleVentas)
                        .ThenInclude(d => d.Articulo)
                            .ThenInclude(a => a!.Iva)
                    .FirstOrDefaultAsync(v => v.VenCod == ventaId);

                if (venta == null)
                {
                    throw new Exception($"Venta {ventaId} no encontrada");
                }

                // Generar el PDF usando QuestPDF
                var pdfBytes = Document.Create(container =>
                {
                    container.Page(page =>
                    {
                        page.Size(PageSizes.A4);
                        page.Margin(2, Unit.Centimetre);
                        page.DefaultTextStyle(x => x.FontSize(10));

                        page.Header().Element(ComposeHeader);
                        page.Content().Element(c => ComposeContent(c, venta));
                        page.Footer().AlignCenter().Text(x =>
                        {
                            x.CurrentPageNumber();
                            x.Span(" / ");
                            x.TotalPages();
                        });
                    });
                }).GeneratePdf();

                return pdfBytes;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, $"Error al generar PDF de presupuesto para venta {ventaId}");
                throw;
            }
        }

        private void ComposeHeader(IContainer container)
        {
            container.Column(column =>
            {
                // COMARA centrado
                column.Item().AlignCenter().Text("COMARA").Bold().FontSize(24);

                // PRESUPUESTO centrado
                column.Item().PaddingTop(5).AlignCenter().Text("PRESUPUESTO").Bold().FontSize(18);

                // Espacio
                column.Item().PaddingTop(15);
            });
        }

        private void ComposeContent(IContainer container, Venta venta)
        {
            container.Column(column =>
            {
                // Cliente (alineado a la izquierda)
                column.Item().Text(text =>
                {
                    text.Span("Cliente: ").Bold().FontSize(12);
                    text.Span(venta.Cliente?.CliNombre ?? "Sin especificar").FontSize(12);
                });

                column.Item().PaddingVertical(10);

                // Tabla de productos
                column.Item().Element(c => ComposeTablaProductos(c, venta));

                column.Item().PaddingVertical(10);

                // Total
                column.Item().Element(c => ComposeTotales(c, venta));
            });
        }


        private void ComposeTablaProductos(IContainer container, Venta venta)
        {
            container.Table(table =>
            {
                // Definir columnas: Cantidad, Descripción, Marca, Precio Unit., Subtotal
                table.ColumnsDefinition(columns =>
                {
                    columns.ConstantColumn(60);   // Cantidad
                    columns.RelativeColumn(3);     // Descripción
                    columns.RelativeColumn(1);     // Marca
                    columns.ConstantColumn(80);    // Precio Unit.
                    columns.ConstantColumn(80);    // Subtotal
                });

                // Encabezado
                table.Header(header =>
                {
                    header.Cell().Element(HeaderCellStyle).Text("Cantidad").Bold();
                    header.Cell().Element(HeaderCellStyle).Text("Descripción").Bold();
                    header.Cell().Element(HeaderCellStyle).Text("Marca").Bold();
                    header.Cell().Element(HeaderCellStyle).AlignRight().Text("Precio Unit.").Bold();
                    header.Cell().Element(HeaderCellStyle).AlignRight().Text("Subtotal").Bold();

                    static IContainer HeaderCellStyle(IContainer container)
                    {
                        return container.DefaultTextStyle(x => x.SemiBold().FontSize(11))
                            .PaddingVertical(8)
                            .BorderBottom(2)
                            .BorderColor(Colors.Black)
                            .Background(Colors.Grey.Lighten3);
                    }
                });

                // Filas de productos
                foreach (var detalle in venta.DetalleVentas ?? Enumerable.Empty<DetalleVenta>())
                {
                    table.Cell().Element(BodyCellStyle).Text(detalle.DetCant.ToString("N0"));
                    table.Cell().Element(BodyCellStyle).Text(detalle.Articulo?.ArtDesc ?? "Sin descripción");
                    table.Cell().Element(BodyCellStyle).Text(detalle.Articulo?.Marca?.marNombre ?? "-");
                    table.Cell().Element(BodyCellStyle).AlignRight().Text($"${detalle.DetPrecio:N2}");
                    table.Cell().Element(BodyCellStyle).AlignRight().Text($"${detalle.DetSubtotal:N2}");

                    static IContainer BodyCellStyle(IContainer container)
                    {
                        return container.BorderBottom(1)
                            .BorderColor(Colors.Grey.Lighten2)
                            .PaddingVertical(6)
                            .PaddingHorizontal(4);
                    }
                }
            });
        }

        private void ComposeTotales(IContainer container, Venta venta)
        {
            container.AlignRight().Column(column =>
            {
                column.Item().Width(250).Row(row =>
                {
                    row.RelativeItem().Text("TOTAL:").Bold().FontSize(16);
                    row.RelativeItem().AlignRight().Text($"${venta.VenTotal:N2}").Bold().FontSize(16);
                });
            });
        }
    }
}
