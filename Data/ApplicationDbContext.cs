// Data/ApplicationDbContext.cs
using Microsoft.EntityFrameworkCore;
using comara.Models; // Asegúrate de usar tu namespace

namespace comara.Data
{ 
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }
    
                public DbSet<Articulo> Articulos { get; set; }
        public DbSet<Cliente> Clientes { get; set; }
        public DbSet<Cobro> Cobros { get; set; }
        public DbSet<Cotizacion> Cotizaciones { get; set; }
        public DbSet<CuentaCorriente> CuentasCorrientes { get; set; }
        public DbSet<DetalleCotizacion> DetallesCotizaciones { get; set; }
        public DbSet<DetalleVenta> DetallesVentas { get; set; }
        public DbSet<Marca> Marcas { get; set; }
        public DbSet<Proveedor> Proveedores { get; set; }
        public DbSet<Venta> Ventas { get; set; }
    
    }
}