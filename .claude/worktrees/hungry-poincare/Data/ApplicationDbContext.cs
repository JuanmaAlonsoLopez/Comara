using Microsoft.EntityFrameworkCore;
using comara.Models; // Asegúrate de que tus modelos están en este namespace

namespace comara.Data
{
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        // --- DbSet para CADA tabla de tu base de datos ---
        public DbSet<Articulo> Articulos { get; set; }
        public DbSet<Cliente> Clientes { get; set; }
        public DbSet<Cobro> Cobros { get; set; }
        public DbSet<Cotizacion> Cotizaciones { get; set; }
        public DbSet<CuentaCorriente> CuentasCorrientes { get; set; }
        public DbSet<DetalleCotizacion> DetalleCotizaciones { get; set; }
        public DbSet<DetalleVenta> DetalleVentas { get; set; }
        public DbSet<Marca> Marcas { get; set; }
        public DbSet<Proveedor> Proveedores { get; set; }
        public DbSet<Venta> Ventas { get; set; }

        // --- Método para configurar el modelo (mapeo) ---
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // --- Mapeo explícito de Entidades a Tablas y Claves Primarias ---

            // Tabla ARTICULOS
            modelBuilder.Entity<Articulo>(entity =>
            {
                entity.ToTable("ARTICULOS");
                entity.HasKey(e => e.ArtCod);
            });

            // Tabla CLIENTES
            modelBuilder.Entity<Cliente>(entity =>
            {
                entity.ToTable("CLIENTES");
                entity.HasKey(e => e.CliCod);
            });

            // Tabla COBROS
            modelBuilder.Entity<Cobro>(entity =>
            {
                entity.ToTable("COBROS");
                entity.HasKey(e => e.CobCod);
            });

            // Tabla COTIZACIONES
            modelBuilder.Entity<Cotizacion>(entity =>
            {
                entity.ToTable("COTIZACIONES");
                entity.HasKey(e => e.CotCod);
            });

            // Tabla CUENTAS_CORRIENTES
            modelBuilder.Entity<CuentaCorriente>(entity =>
            {
                entity.ToTable("CUENTAS_CORRIENTES");
                entity.HasKey(e => e.CctaCod);
            });

            // Tabla DETALLE_COTIZACIONES
            modelBuilder.Entity<DetalleCotizacion>(entity =>
            {
                entity.ToTable("DETALLE_COTIZACIONES");
                entity.HasKey(e => e.DetCotCod);
            });

            // Tabla DETALLE_VENTAS
            modelBuilder.Entity<DetalleVenta>(entity =>
            {
                entity.ToTable("DETALLE_VENTAS");
                entity.HasKey(e => e.DetCod);
            });

            // Tabla MARCAS
            modelBuilder.Entity<Marca>(entity =>
            {
                entity.ToTable("MARCAS");
                entity.HasKey(e => e.marCod);
            });

            // Tabla PROVEEDORES
            modelBuilder.Entity<Proveedor>(entity =>
            {
                entity.ToTable("PROVEEDORES");
                entity.HasKey(e => e.proCod);
            });

            // Tabla VENTAS
            modelBuilder.Entity<Venta>(entity =>
            {
                entity.ToTable("VENTAS");
                entity.HasKey(e => e.VenCod);
            });

            // --- Definición de Relaciones (claves foráneas) ---
            // Entity Framework es bueno infiriendo esto, pero podemos ser explícitos.
            // Por ejemplo, para la relación entre Articulo y Marca:
            modelBuilder.Entity<Articulo>()
                .HasOne(a => a.Marca)
                .WithMany()
                .HasForeignKey(a => a.MarCod);

            // (Puedes agregar más definiciones de relaciones aquí si es necesario)
        }
    }
}