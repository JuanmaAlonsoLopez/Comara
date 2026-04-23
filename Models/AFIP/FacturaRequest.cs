namespace comara.Models.AFIP
{
    public class FacturaRequest
    {
        public int TipoComprobante { get; set; } // 1=A, 6=B, 11=C
        public int PuntoVenta { get; set; }
        public long NumeroComprobante { get; set; }
        public DateTime Fecha { get; set; }
        public int TipoDocCliente { get; set; } // 80=CUIT, 96=DNI, etc.
        public long NumeroDocCliente { get; set; }
        public int CondicionIVAReceptor { get; set; } // 1=RI, 4=Exento, 5=CF, 6=Monotributo, etc.
        public decimal ImporteTotal { get; set; }
        public decimal ImporteNeto { get; set; } // Base imponible gravada
        public decimal ImporteIVA { get; set; }
        public decimal ImporteExento { get; set; } // Operaciones exentas (código IVA 2)
        public decimal ImporteNoGravado { get; set; } // Operaciones no gravadas (código IVA 3) - ImpTotConc en AFIP
        public decimal ImporteTributos { get; set; }
        public string Concepto { get; set; } = "Productos"; // Productos, Servicios, Productos y Servicios
        public int MonedaId { get; set; } = 1; // 1 = Peso (PES)
        public decimal MonedaCotizacion { get; set; } = 1;

        // Detalles de IVA
        public List<FacturaIVAItem> ItemsIVA { get; set; } = new List<FacturaIVAItem>();

        // Detalles de items (opcional según implementación)
        public List<FacturaLineItem> Items { get; set; } = new List<FacturaLineItem>();
    }

    public class FacturaIVAItem
    {
        public int CodigoIVA { get; set; } // 3=0%, 4=10.5%, 5=21%, 6=27%
        public decimal BaseImponible { get; set; }
        public decimal Importe { get; set; }
    }

    public class FacturaLineItem
    {
        public string Descripcion { get; set; } = string.Empty;
        public decimal Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }
        public decimal Subtotal { get; set; }
        public decimal AlicuotaIVA { get; set; }
    }
}
