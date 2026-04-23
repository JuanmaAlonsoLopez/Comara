using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;
using QRCoder;
using comara.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using System.Drawing;
using System.Drawing.Imaging;
using comara.Models.ViewModels;

namespace comara.Services.PDF
{
    public class FacturaPDFService : IFacturaPDFService
    {
        private readonly ApplicationDbContext _context;
        private readonly IConfiguration _configuration;

        public FacturaPDFService(ApplicationDbContext context, IConfiguration configuration)
        {
            _context = context;
            _configuration = configuration;
            // Configurar licencia de QuestPDF (Community para desarrollo)
            QuestPDF.Settings.License = LicenseType.Community;
        }

        public byte[] GenerarPDFFactura(int ventaId)
        {
            return GenerarPDFFacturaAsync(ventaId).GetAwaiter().GetResult();
        }

        public async Task<byte[]> GenerarPDFFacturaAsync(int ventaId)
        {
            // Obtener la venta con todos los datos necesarios
            var venta = await _context.Ventas
                .Include(v => v.Cliente)
                    .ThenInclude(c => c.TipoDocumento)
                .Include(v => v.Cliente)
                    .ThenInclude(c => c.CondicionIVA)
                .Include(v => v.TipoComprobante)
                .Include(v => v.DetalleVentas)
                    .ThenInclude(d => d.Articulo)
                        .ThenInclude(a => a.Iva)
                .FirstOrDefaultAsync(v => v.VenCod == ventaId);

            if (venta == null)
                throw new ArgumentException($"No se encontró la venta con ID {ventaId}");

            if (string.IsNullOrEmpty(venta.VenCAE))
                throw new InvalidOperationException("La venta no tiene CAE autorizado");

            // Generar código QR
            byte[] qrImageBytes = GenerarCodigoQR(venta);

            // Generar el PDF
            var document = Document.Create(container =>
            {
                container.Page(page =>
                {
                    page.Size(PageSizes.A4);
                    page.Margin(2, Unit.Centimetre);
                    page.PageColor(Colors.White);
                    page.DefaultTextStyle(x => x.FontSize(10).FontFamily("Arial"));

                    page.Header()
                        .Element(c => ComposeHeader(c, venta));

                    page.Content()
                        .Element(c => ComposeContent(c, venta));

                    page.Footer()
                        .Element(c => ComposeFooter(c, venta, qrImageBytes));
                });
            });

            return document.GeneratePdf();
        }

        private void ComposeHeader(IContainer container, Models.Venta venta)
        {
            var cuit = _configuration["Afip:CuitRepresentado"] ?? "20-12345678-9";
            var razonSocial = _configuration["Empresa:RazonSocial"] ?? "COMARA S.A.";
            var condicionIVA = _configuration["Empresa:CondicionIVA"] ?? "Responsable Inscripto";
            var direccion = _configuration["Empresa:Direccion"] ?? "Av. Principal 1234 - CABA";

            container.Column(mainColumn =>
            {
                // Título "ORIGINAL"
                mainColumn.Item().Border(1).BorderColor(Colors.Black)
                    .Padding(5).AlignCenter()
                    .Text("ORIGINAL").Bold().FontSize(14);

                // Fila principal con datos del emisor y tipo de comprobante
                mainColumn.Item().Border(1).BorderColor(Colors.Black).Row(row =>
                {
                    // Columna izquierda - Datos del emisor
                    row.RelativeItem(3).BorderRight(1).BorderColor(Colors.Black)
                        .Padding(10).Column(column =>
                        {
                            column.Item().Text("COMARA").Bold().FontSize(18);
                            column.Item().PaddingTop(5).Text(txt =>
                            {
                                txt.Span("Razón Social: ").Bold().FontSize(10);
                                txt.Span(razonSocial).FontSize(10);
                            });
                            column.Item().Text(txt =>
                            {
                                txt.Span("Condición IVA: ").Bold().FontSize(10);
                                txt.Span(condicionIVA).FontSize(10);
                            });
                            column.Item().Text(txt =>
                            {
                                txt.Span("Domicilio: ").Bold().FontSize(10);
                                txt.Span(direccion).FontSize(10);
                            });
                        });

                    // Columna derecha - Letra del comprobante y datos
                    row.RelativeItem(3).Padding(10).Column(column =>
                    {
                        // Letra grande del comprobante (A, B, C)
                        var letraComprobante = venta.TipoComprobante?.CodigoAfip switch
                        {
                            1 => "A",
                            6 => "B",
                            11 => "C",
                            _ => "X"
                        };

                        column.Item().Row(letterRow =>
                        {
                            letterRow.RelativeItem(1).Border(2).BorderColor(Colors.Black)
                                .Padding(5).AlignCenter().AlignMiddle()
                                .Text(letraComprobante).Bold().FontSize(36);

                            letterRow.RelativeItem(4).PaddingLeft(10).Column(detailColumn =>
                            {
                                var tipoCbteText = venta.TipoComprobante?.Descripcion ?? "FACTURA";
                                detailColumn.Item().Text(tipoCbteText).Bold().FontSize(12);

                                detailColumn.Item().PaddingTop(3).Text(txt =>
                                {
                                    txt.Span("Fecha emisión: ").Bold().FontSize(9);
                                    txt.Span($"{venta.VenFech:dd/MM/yyyy}").FontSize(9);
                                });

                                detailColumn.Item().Text(txt =>
                                {
                                    txt.Span("Punto Venta / Número: ").Bold().FontSize(9);
                                    txt.Span($"{venta.VenPuntoVenta:D4}-{venta.VenNumComprobante:D8}").FontSize(9);
                                });
                            });
                        });

                        column.Item().PaddingTop(10).Text(txt =>
                        {
                            txt.Span("C.U.I.T: ").Bold().FontSize(10);
                            txt.Span(cuit).FontSize(10);
                        });

                        column.Item().Text(txt =>
                        {
                            txt.Span("Insc. Ing. Brutos: ").Bold().FontSize(10);
                            txt.Span(cuit).FontSize(10);
                        });

                        column.Item().Text(txt =>
                        {
                            txt.Span("Inicio Actividades: ").Bold().FontSize(10);
                            txt.Span(_configuration["Empresa:InicioActividades"] ?? "01/01/2020").FontSize(10);
                        });
                    });
                });
            });
        }

        private void ComposeContent(IContainer container, Models.Venta venta)
        {
            container.Column(column =>
            {
                // Datos del cliente con formato de replica
                column.Item().Border(1).BorderColor(Colors.Black).Padding(10).Row(row =>
                {
                    // Columna izquierda
                    row.RelativeItem().Column(col =>
                    {
                        col.Item().Text(txt =>
                        {
                            txt.Span("Nombre: ").Bold().FontSize(10);
                            txt.Span(venta.Cliente?.CliNombre ?? "").FontSize(10);
                        });

                        col.Item().PaddingTop(3).Text(txt =>
                        {
                            txt.Span("Domicilio: ").Bold().FontSize(10);
                            txt.Span(venta.Cliente?.CliDireccion ?? "").FontSize(10);
                        });

                        col.Item().PaddingTop(3).Text(txt =>
                        {
                            txt.Span("Condición de Venta: ").Bold().FontSize(10);
                            txt.Span(venta.TipoMetodoPago?.Descripcion ?? "Cuenta Corriente").FontSize(10);
                        });
                    });

                    // Columna derecha
                    row.RelativeItem().Column(col =>
                    {
                        col.Item().Text(txt =>
                        {
                            txt.Span("C.U.I.T.: ").Bold().FontSize(10);
                            txt.Span(venta.Cliente?.CliNumDoc ?? "").FontSize(10);
                        });

                        col.Item().PaddingTop(3).Text(txt =>
                        {
                            txt.Span("Condición de IVA: ").Bold().FontSize(10);
                            txt.Span(venta.Cliente?.CondicionIVA?.Descripcion ?? "").FontSize(10);
                        });

                        col.Item().PaddingTop(3).Text(txt =>
                        {
                            txt.Span("Remito: ").Bold().FontSize(10);
                            txt.Span("").FontSize(10);
                        });
                    });
                });

                // Tabla de items con formato de replica
                var ivaData = FacturaIvaCalculadorService.CalcularIvaDiscriminado(venta);

                column.Item().Table(table =>
                {
                    if (ivaData.DiscriminarIva)
                    {
                        // Factura Tipo A - Formato replica
                        table.ColumnsDefinition(columns =>
                        {
                            columns.ConstantColumn(50);  // Código
                            columns.RelativeColumn(3);   // Producto/Servicio
                            columns.ConstantColumn(50);  // Cantidad
                            columns.ConstantColumn(60);  // U.Medida
                            columns.ConstantColumn(70);  // Precio unit.
                            columns.ConstantColumn(70);  // Importe
                            columns.ConstantColumn(50);  // % IVA
                            columns.ConstantColumn(75);  // Subtotal
                        });

                        // Header
                        table.Header(header =>
                        {
                            header.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignCenter().Text("Código").Bold().FontSize(9);
                            header.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignCenter().Text("Producto / Servicio").Bold().FontSize(9);
                            header.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignCenter().Text("Cantidad").Bold().FontSize(9);
                            header.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignCenter().Text("U.Medida").Bold().FontSize(9);
                            header.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignCenter().Text("Precio unit.").Bold().FontSize(9);
                            header.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignCenter().Text("Importe").Bold().FontSize(9);
                            header.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignCenter().Text("% IVA").Bold().FontSize(9);
                            header.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignCenter().Text("Subtotal").Bold().FontSize(9);
                        });

                        // Items
                        foreach (var detalle in ivaData.Detalles)
                        {
                            table.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignCenter().Text(detalle.Codigo ?? "").FontSize(9);
                            table.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignLeft().Text(detalle.Descripcion ?? "").FontSize(9);
                            table.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignCenter().Text(detalle.Cantidad.ToString("N0")).FontSize(9);
                            table.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignCenter().Text("UNIDAD").FontSize(9);
                            table.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignRight().Text($"{detalle.PrecioUnitarioSinIva:N2}").FontSize(9);
                            table.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignRight().Text($"{detalle.SubtotalSinIva:N2}").FontSize(9);
                            table.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignCenter().Text($"{detalle.PorcentajeIva:N2}").FontSize(9);
                            table.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignRight().Text($"{detalle.SubtotalConIva:N2}").FontSize(9);
                        }
                    }
                    else
                    {
                        // Factura Tipo B, C - Formato simplificado
                        table.ColumnsDefinition(columns =>
                        {
                            columns.ConstantColumn(50);  // Código
                            columns.RelativeColumn(3);   // Producto/Servicio
                            columns.ConstantColumn(50);  // Cantidad
                            columns.ConstantColumn(60);  // U.Medida
                            columns.ConstantColumn(80);  // Precio unit.
                            columns.ConstantColumn(80);  // Subtotal
                        });

                        // Header
                        table.Header(header =>
                        {
                            header.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignCenter().Text("Código").Bold().FontSize(9);
                            header.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignCenter().Text("Producto / Servicio").Bold().FontSize(9);
                            header.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignCenter().Text("Cantidad").Bold().FontSize(9);
                            header.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignCenter().Text("U.Medida").Bold().FontSize(9);
                            header.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignCenter().Text("Precio unit.").Bold().FontSize(9);
                            header.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignCenter().Text("Subtotal").Bold().FontSize(9);
                        });

                        // Items
                        foreach (var detalle in ivaData.Detalles)
                        {
                            table.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignCenter().Text(detalle.Codigo ?? "").FontSize(9);
                            table.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignLeft().Text(detalle.Descripcion ?? "").FontSize(9);
                            table.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignCenter().Text(detalle.Cantidad.ToString("N0")).FontSize(9);
                            table.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignCenter().Text("UNIDAD").FontSize(9);
                            table.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignRight().Text($"{detalle.PrecioUnitarioConIva:N2}").FontSize(9);
                            table.Cell().Border(1).BorderColor(Colors.Black).Padding(3)
                                .AlignRight().Text($"{detalle.SubtotalConIva:N2}").FontSize(9);
                        }
                    }
                });

                // Totales - Formato simplificado
                column.Item().PaddingTop(10).Table(totalesTable =>
                {
                    totalesTable.ColumnsDefinition(columns =>
                    {
                        columns.RelativeColumn();
                        columns.ConstantColumn(150);
                    });

                    if (ivaData.DiscriminarIva)
                    {
                        // Factura Tipo A - Subtotal sin IVA
                        totalesTable.Cell().Text("");
                        totalesTable.Cell().Border(1).BorderColor(Colors.Black).Padding(5).Row(row =>
                        {
                            row.RelativeItem().Text("Subtotal:").Bold().FontSize(10);
                            row.ConstantItem(80).AlignRight().Text($"${ivaData.SubtotalNeto:N2}").FontSize(10);
                        });

                        // Total con IVA
                        totalesTable.Cell().Text("");
                        totalesTable.Cell().Border(1).BorderColor(Colors.Black).Padding(5).Row(row =>
                        {
                            row.RelativeItem().Text("Importe Total:").Bold().FontSize(11);
                            row.ConstantItem(80).AlignRight().Text($"${ivaData.Total:N2}").Bold().FontSize(11);
                        });
                    }
                    else
                    {
                        // Factura Tipo B, C - Solo total
                        totalesTable.Cell().Text("");
                        totalesTable.Cell().Border(1).BorderColor(Colors.Black).Padding(5).Row(row =>
                        {
                            row.RelativeItem().Text("Importe Total:").Bold().FontSize(11);
                            row.ConstantItem(80).AlignRight().Text($"${venta.VenTotal:N2}").Bold().FontSize(11);
                        });
                    }
                });
            });
        }

        private void ComposeFooter(IContainer container, Models.Venta venta, byte[] qrImageBytes)
        {
            container.PaddingTop(15).Column(column =>
            {
                // CAE y datos de autorización
                column.Item().Border(1).BorderColor(Colors.Black).Padding(8).Row(row =>
                {
                    // Datos del CAE
                    row.RelativeItem().Column(caeColumn =>
                    {
                        caeColumn.Item().Text("COMPROBANTE AUTORIZADO").Bold().FontSize(10);

                        caeColumn.Item().PaddingTop(5).Text(txt =>
                        {
                            txt.Span("CAE N°: ").Bold().FontSize(9);
                            txt.Span(venta.VenCAE ?? "").FontSize(9);
                        });

                        caeColumn.Item().Text(txt =>
                        {
                            txt.Span("Fecha de Vto. de CAE: ").Bold().FontSize(9);
                            txt.Span(venta.VenCAEVencimiento?.ToString("dd/MM/yyyy") ?? "").FontSize(9);
                        });
                    });

                    // Código QR
                    row.ConstantItem(80).Column(qrColumn =>
                    {
                        qrColumn.Item().AlignCenter().PaddingBottom(3)
                            .Text("Código QR").FontSize(7);
                        qrColumn.Item().Image(qrImageBytes).FitArea();
                    });
                });

                // Nota final
                column.Item().PaddingTop(5).AlignCenter()
                    .Text("Comprobante Autorizado por AFIP - Controlá tu factura en www.afip.gob.ar")
                    .FontSize(8).Italic();
            });
        }

        private byte[] GenerarCodigoQR(Models.Venta venta)
        {
            // Formato del QR según AFIP
            // {"ver":1,"fecha":"2021-10-13","cuit":20409378472,"ptoVta":10,"tipoCmp":1,"nroCmp":94,"importe":12100.00,"moneda":"PES","ctz":1.000000,"tipoDocRec":80,"nroDocRec":20111111112,"tipoCodAut":"E","codAut":71093423427891}

            // Leer CUIT desde configuración
            var cuitStr = _configuration["Afip:CuitRepresentado"] ?? "20409378472";
            var cuit = long.TryParse(cuitStr, out var cuitNum) ? cuitNum : 20409378472;

            var qrData = new
            {
                ver = 1,
                fecha = venta.VenFech.ToString("yyyy-MM-dd"),
                cuit = cuit, // CUIT desde configuración
                ptoVta = venta.VenPuntoVenta ?? 1,
                tipoCmp = venta.TipoComprobante?.CodigoAfip ?? 11, // USAR CODIGO AFIP, NO ID LOCAL
                nroCmp = venta.VenNumComprobante ?? 0,
                importe = (double)venta.VenTotal,
                moneda = "PES",
                ctz = 1.000000,
                tipoDocRec = venta.Cliente?.TipoDocumento?.CodigoAfip ?? 99, // USAR CODIGO AFIP, NO ID LOCAL
                nroDocRec = long.TryParse(venta.Cliente?.CliNumDoc, out var doc) ? doc : 0,
                tipoCodAut = "E",
                codAut = venta.VenCAE ?? ""
            };

            string jsonQR = System.Text.Json.JsonSerializer.Serialize(qrData);
            string base64QR = Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(jsonQR));
            string urlQR = $"https://www.afip.gob.ar/fe/qr/?p={base64QR}";

            using var qrGenerator = new QRCodeGenerator();
            var qrCodeData = qrGenerator.CreateQrCode(urlQR, QRCodeGenerator.ECCLevel.Q);
            using var qrCode = new QRCode(qrCodeData);
            using var qrBitmap = qrCode.GetGraphic(20);

            using var ms = new MemoryStream();
            qrBitmap.Save(ms, System.Drawing.Imaging.ImageFormat.Png);
            return ms.ToArray();
        }
    }
}
