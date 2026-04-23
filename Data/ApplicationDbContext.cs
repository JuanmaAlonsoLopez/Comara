using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.ChangeTracking;
using comara.Models;
using System.Text.Json;
using System.Security.Claims;

namespace comara.Data
{
    public class ApplicationDbContext : DbContext
    {
        private readonly IHttpContextAccessor? _httpContextAccessor;

        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options)
            : base(options)
        {
        }

        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options, IHttpContextAccessor httpContextAccessor)
            : base(options)
        {
            _httpContextAccessor = httpContextAccessor;
        }

        // --- DbSet para CADA tabla de tu base de datos ---
        public DbSet<Articulo> Articulos { get; set; }
        public DbSet<Cliente> Clientes { get; set; }
        public DbSet<Cobro> Cobros { get; set; }
        public DbSet<Cotizacion> Cotizaciones { get; set; }
        public DbSet<CotizacionEstado> CotizacionEstados { get; set; }
        public DbSet<TipoRazonCrea> TipoRazonCreas { get; set; }
        public DbSet<CuentaCorriente> CuentasCorrientes { get; set; }
        public DbSet<DetalleCotizacion> DetalleCotizaciones { get; set; }
        public DbSet<DetalleVenta> DetalleVentas { get; set; }
        public DbSet<Marca> Marcas { get; set; }
        public DbSet<Proveedor> Proveedores { get; set; }
        public DbSet<Venta> Ventas { get; set; }
        public DbSet<Lista> Listas { get; set; }
        public DbSet<Iva> Ivas { get; set; }
        public DbSet<VentaTipoEstado> VentaTipoEstados { get; set; }
        public DbSet<VentaTipoMetodoPago> VentaTipoMetodoPagos { get; set; }
        public DbSet<VentaEstadoPago> VentaEstadoPagos { get; set; }
        public DbSet<Pago> Pagos { get; set; }

        // Entidades AFIP
        public DbSet<TipoDocumento> TipoDocumentos { get; set; }
        public DbSet<CondicionIVA> CondicionesIVA { get; set; }
        public DbSet<TipoComprobante> TipoComprobantes { get; set; }
        public DbSet<AfipLog> AfipLogs { get; set; }
        public DbSet<Models.AFIP.AfipAuthTicket> AfipAuthTickets { get; set; }

        // Entidades de Cliente
        public DbSet<ClienteTipoFormaPago> ClienteTipoFormaPagos { get; set; }

        // Entidades de Caja
        public DbSet<Cheque> Cheques { get; set; }
        public DbSet<MovimientoCaja> MovimientosCaja { get; set; }
        public DbSet<TipoMovimientoCaja> TipoMovimientosCaja { get; set; }

        // Entidades de Autenticación
        public DbSet<Usuario> Usuarios { get; set; }

        // Auditoría
        public DbSet<AuditLog> AuditLogs { get; set; }

        // --- Método para configurar el modelo (mapeo) ---
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // --- Mapeo explícito de Entidades a Tablas y Claves Primarias ---

            // Tabla ARTICULOS
            modelBuilder.Entity<Articulo>(entity =>
            {
                entity.ToTable("ARTICULOS");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
                entity.HasIndex(e => e.ArtCod).IsUnique();
            });

            // Tabla CLIENTES
            modelBuilder.Entity<Cliente>(entity =>
            {
                entity.ToTable("CLIENTES");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
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

                // Mapear explicitamente la columna FK razonCrea para evitar propiedades "shadow"
                entity.Property(e => e.RazonCreaId).HasColumnName("razonCrea");
            });

            // Tabla cotizacionEstados
            modelBuilder.Entity<CotizacionEstado>(entity =>
            {
                entity.ToTable("cotizacionEstados");
                entity.HasKey(e => e.Id);
            });

            // Tabla tipoRazonCrea
            modelBuilder.Entity<TipoRazonCrea>(entity =>
            {
                entity.ToTable("tipoRazonCrea");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
                entity.Property(e => e.NombreRazon).HasColumnName("nombre_razon").HasMaxLength(50).IsRequired();
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

            // Tabla LISTAS
            modelBuilder.Entity<Lista>(entity =>
            {
                entity.ToTable("LISTAS");
                entity.HasKey(e => e.ListCode);
            });

            // Tabla IVA
            modelBuilder.Entity<Iva>(entity =>
            {
                entity.ToTable("IVA");
                entity.HasKey(e => e.Id);
            });

            // Tabla ventaTipoEstado
            modelBuilder.Entity<VentaTipoEstado>(entity =>
            {
                entity.ToTable("ventaTipoEstado");
                entity.HasKey(e => e.Id);
            });

            // Tabla ventaTipoMetodoPagos
            modelBuilder.Entity<VentaTipoMetodoPago>(entity =>
            {
                entity.ToTable("ventaTipoMetodoPagos");
                entity.HasKey(e => e.Id);
            });

            // Tabla ventaEstadoPago
            modelBuilder.Entity<VentaEstadoPago>(entity =>
            {
                entity.ToTable("ventaEstadoPago");
                entity.HasKey(e => e.Id);
            });

            // Tabla clienteTipoFormaPago
            modelBuilder.Entity<ClienteTipoFormaPago>(entity =>
            {
                entity.ToTable("clienteTipoFormaPago");
                entity.HasKey(e => e.Id);
            });

            // --- Definición de Relaciones (claves foráneas) ---
            // Entity Framework es bueno infiriendo esto, pero podemos ser explícitos.
            // Por ejemplo, para la relación entre Articulo y Marca:
            modelBuilder.Entity<Articulo>()
                .HasOne(a => a.Marca)
                .WithMany()
                .HasForeignKey(a => a.MarCod);

            // Relación entre Articulo e Iva
            modelBuilder.Entity<Articulo>()
                .HasOne(a => a.Iva)
                .WithMany()
                .HasForeignKey(a => a.IvaCod);

            // Relación entre Venta y Cliente (usando Id)
            modelBuilder.Entity<Venta>()
                .HasOne(v => v.Cliente)
                .WithMany()
                .HasForeignKey(v => v.CliCod);

            // Relación entre Cotizacion y Cliente (usando Id)
            modelBuilder.Entity<Cotizacion>()
                .HasOne(c => c.Cliente)
                .WithMany()
                .HasForeignKey(c => c.CliCod);

            // Relación entre Cotizacion y CotizacionEstado
            modelBuilder.Entity<Cotizacion>()
                .HasOne(c => c.Estado)
                .WithMany()
                .HasForeignKey(c => c.CotEstadoId);

            // Relación entre Cotizacion y Lista de precios
            modelBuilder.Entity<Cotizacion>()
                .HasOne(c => c.Lista)
                .WithMany()
                .HasForeignKey(c => c.ListaCod)
                .HasPrincipalKey(l => l.ListCode)
                .IsRequired(false);

            // Relación entre Cotizacion y TipoRazonCrea
            modelBuilder.Entity<Cotizacion>()
                .HasOne(c => c.RazonCrea)
                .WithMany(t => t.Cotizaciones)
                .HasForeignKey(c => c.RazonCreaId)
                .OnDelete(DeleteBehavior.SetNull);

            // Relación entre DetalleVenta y Articulo (usando Id)
            modelBuilder.Entity<DetalleVenta>()
                .HasOne(d => d.Articulo)
                .WithMany()
                .HasForeignKey(d => d.ArtCod)
                .HasPrincipalKey(a => a.Id);

            // Relación entre DetalleCotizacion y Articulo (usando Id)
            modelBuilder.Entity<DetalleCotizacion>()
                .HasOne(d => d.Articulo)
                .WithMany()
                .HasForeignKey(d => d.ArtCod)
                .HasPrincipalKey(a => a.Id);

            // Relación entre Venta y VentaTipoEstado
            modelBuilder.Entity<Venta>()
                .HasOne(v => v.TipoEstado)
                .WithMany()
                .HasForeignKey(v => v.VenEstado);

            // Relación entre Venta y VentaTipoMetodoPago
            modelBuilder.Entity<Venta>()
                .HasOne(v => v.TipoMetodoPago)
                .WithMany()
                .HasForeignKey(v => v.VenMetodoPago);

            // --- Configuración de Entidades AFIP ---

            // Tabla tipoDocumento
            modelBuilder.Entity<TipoDocumento>(entity =>
            {
                entity.ToTable("tipoDocumento");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
            });

            // Tabla condicionIVA
            modelBuilder.Entity<CondicionIVA>(entity =>
            {
                entity.ToTable("condicionIVA");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
            });

            // Tabla tipoComprobante
            modelBuilder.Entity<TipoComprobante>(entity =>
            {
                entity.ToTable("tipoComprobante");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
            });

            // Relación entre Cliente y TipoDocumento
            modelBuilder.Entity<Cliente>()
                .HasOne(c => c.TipoDocumento)
                .WithMany(t => t.Clientes)
                .HasForeignKey(c => c.CliTipoDoc);

            // Relación entre Cliente y CondicionIVA
            modelBuilder.Entity<Cliente>()
                .HasOne(c => c.CondicionIVA)
                .WithMany(ci => ci.Clientes)
                .HasForeignKey(c => c.CliCondicionIVA);

            // Relación entre Cliente y ClienteTipoFormaPago
            modelBuilder.Entity<Cliente>()
                .HasOne(c => c.TipoFormaPago)
                .WithMany()
                .HasForeignKey(c => c.CliFormaPago);

            // Relación entre Venta y TipoComprobante
            // VenTipoCbte almacena el CodigoAfip (no el Id de la tabla)
            modelBuilder.Entity<Venta>()
                .HasOne(v => v.TipoComprobante)
                .WithMany(tc => tc.Ventas)
                .HasForeignKey(v => v.VenTipoCbte)
                .HasPrincipalKey(tc => tc.CodigoAfip)
                .IsRequired(false);

            // Tabla AfipLog
            modelBuilder.Entity<AfipLog>(entity =>
            {
                entity.ToTable("afipLogs");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
                entity.Property(e => e.Fecha).HasDefaultValueSql("CURRENT_TIMESTAMP");
            });

            // Relación entre AfipLog y Venta
            modelBuilder.Entity<AfipLog>()
                .HasOne(a => a.Venta)
                .WithMany()
                .HasForeignKey(a => a.VenCod)
                .OnDelete(DeleteBehavior.SetNull);

            // Tabla afip_auth_tickets
            modelBuilder.Entity<Models.AFIP.AfipAuthTicket>(entity =>
            {
                entity.ToTable("afip_auth_tickets");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
                entity.HasIndex(e => new { e.CuitRepresentado, e.Environment, e.ExpirationTime })
                    .HasDatabaseName("idx_afip_tickets_expiration");
            });

            // Tabla PAGOS
            modelBuilder.Entity<Pago>(entity =>
            {
                entity.ToTable("PAGOS");
                entity.HasKey(e => e.PagCod);
            });

            // Relación entre Pago y Cliente
            modelBuilder.Entity<Pago>()
                .HasOne(p => p.Cliente)
                .WithMany()
                .HasForeignKey(p => p.CliCod);

            // Relación entre Pago y VentaTipoMetodoPago
            modelBuilder.Entity<Pago>()
                .HasOne(p => p.TipoMetodoPago)
                .WithMany()
                .HasForeignKey(p => p.PagMetodoPago);

            // Relación entre Pago y CuentaCorriente
            modelBuilder.Entity<Pago>()
                .HasOne(p => p.CuentaCorriente)
                .WithMany()
                .HasForeignKey(p => p.CctaCod);

            // Relación entre Pago y Venta
            modelBuilder.Entity<Pago>()
                .HasOne(p => p.Venta)
                .WithMany(v => v.Pagos)
                .HasForeignKey(p => p.VenCod)
                .OnDelete(DeleteBehavior.SetNull);

            // Relación entre Venta y VentaEstadoPago
            modelBuilder.Entity<Venta>()
                .HasOne(v => v.EstadoPago)
                .WithMany()
                .HasForeignKey(v => v.VenEstadoPago);

            // --- Configuración de Entidades de Caja ---

            // Tabla CHEQUES
            modelBuilder.Entity<Cheque>(entity =>
            {
                entity.ToTable("CHEQUES");
                entity.HasKey(e => e.ChqCod);
            });

            // Relación entre Cheque y Pago
            modelBuilder.Entity<Cheque>()
                .HasOne(c => c.Pago)
                .WithMany()
                .HasForeignKey(c => c.PagCod);

            // Tabla MOVIMIENTOS_CAJA
            modelBuilder.Entity<MovimientoCaja>(entity =>
            {
                entity.ToTable("MOVIMIENTOS_CAJA");
                entity.HasKey(e => e.MovCod);
            });

            // Relación entre MovimientoCaja y TipoMovimientoCaja
            modelBuilder.Entity<MovimientoCaja>()
                .HasOne(m => m.TipoMovimiento)
                .WithMany()
                .HasForeignKey(m => m.MovTipo);

            // Relación entre MovimientoCaja y VentaTipoMetodoPago
            modelBuilder.Entity<MovimientoCaja>()
                .HasOne(m => m.TipoMetodoPago)
                .WithMany()
                .HasForeignKey(m => m.MovMetodoPago);

            // Relación entre MovimientoCaja y Cheque
            modelBuilder.Entity<MovimientoCaja>()
                .HasOne(m => m.Cheque)
                .WithMany()
                .HasForeignKey(m => m.ChqCod);

            // Tabla tipoMovimientoCaja
            modelBuilder.Entity<TipoMovimientoCaja>(entity =>
            {
                entity.ToTable("tipoMovimientoCaja");
                entity.HasKey(e => e.Id);
            });

            // --- Configuración de Autenticación ---

            // Tabla USUARIOS
            modelBuilder.Entity<Usuario>(entity =>
            {
                entity.ToTable("USUARIOS");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
                entity.HasIndex(e => e.UsuUsername).IsUnique();
                entity.HasIndex(e => e.UsuActivo);
                entity.HasIndex(e => e.UsuRole);
            });

            // Self-referencing relationship for audit (optional)
            modelBuilder.Entity<Usuario>()
                .HasOne(u => u.CreadoPor)
                .WithMany()
                .HasForeignKey(u => u.UsuCreadoPor)
                .OnDelete(DeleteBehavior.SetNull);

            // --- Configuración de Auditoría ---
            modelBuilder.Entity<AuditLog>(entity =>
            {
                entity.ToTable("AUDIT_LOG");
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Id).ValueGeneratedOnAdd();
                entity.Property(e => e.Fecha).HasDefaultValueSql("CURRENT_TIMESTAMP");
            });
        }

        // --- Tablas a auditar ---
        private static readonly HashSet<string> TablasAuditadas = new()
        {
            "ARTICULOS", "CLIENTES", "VENTAS", "COTIZACIONES",
            "PROVEEDORES", "MARCAS", "USUARIOS", "PAGOS", "CHEQUES"
        };

        public override async Task<int> SaveChangesAsync(CancellationToken cancellationToken = default)
        {
            var auditEntries = OnBeforeSaveChanges();
            var result = await base.SaveChangesAsync(cancellationToken);
            await OnAfterSaveChanges(auditEntries);
            return result;
        }

        private List<AuditEntry> OnBeforeSaveChanges()
        {
            ChangeTracker.DetectChanges();
            var auditEntries = new List<AuditEntry>();

            foreach (var entry in ChangeTracker.Entries())
            {
                if (entry.Entity is AuditLog || entry.State == EntityState.Detached || entry.State == EntityState.Unchanged)
                    continue;

                var tableName = entry.Metadata.GetTableName();
                if (tableName == null || !TablasAuditadas.Contains(tableName))
                    continue;

                var auditEntry = new AuditEntry(entry)
                {
                    TableName = tableName,
                    UserId = GetCurrentUserId(),
                    UserName = GetCurrentUserName(),
                    IpAddress = GetClientIpAddress()
                };

                auditEntries.Add(auditEntry);

                foreach (var property in entry.Properties)
                {
                    if (property.IsTemporary)
                    {
                        auditEntry.TemporaryProperties.Add(property);
                        continue;
                    }

                    string propertyName = property.Metadata.Name;
                    if (property.Metadata.IsPrimaryKey())
                    {
                        auditEntry.KeyValues[propertyName] = property.CurrentValue;
                        continue;
                    }

                    switch (entry.State)
                    {
                        case EntityState.Added:
                            auditEntry.Action = "INSERT";
                            auditEntry.NewValues[propertyName] = property.CurrentValue;
                            break;

                        case EntityState.Deleted:
                            auditEntry.Action = "DELETE";
                            auditEntry.OldValues[propertyName] = property.OriginalValue;
                            break;

                        case EntityState.Modified:
                            if (property.IsModified)
                            {
                                auditEntry.Action = "UPDATE";
                                auditEntry.OldValues[propertyName] = property.OriginalValue;
                                auditEntry.NewValues[propertyName] = property.CurrentValue;
                            }
                            break;
                    }
                }
            }

            return auditEntries;
        }

        private async Task OnAfterSaveChanges(List<AuditEntry> auditEntries)
        {
            if (auditEntries.Count == 0)
                return;

            foreach (var auditEntry in auditEntries)
            {
                foreach (var prop in auditEntry.TemporaryProperties)
                {
                    if (prop.Metadata.IsPrimaryKey())
                        auditEntry.KeyValues[prop.Metadata.Name] = prop.CurrentValue;
                    else
                        auditEntry.NewValues[prop.Metadata.Name] = prop.CurrentValue;
                }

                AuditLogs.Add(auditEntry.ToAuditLog());
            }

            await base.SaveChangesAsync();
        }

        private int? GetCurrentUserId()
        {
            var userIdClaim = _httpContextAccessor?.HttpContext?.User?.FindFirst(ClaimTypes.NameIdentifier);
            return userIdClaim != null && int.TryParse(userIdClaim.Value, out int userId) ? userId : null;
        }

        private string? GetCurrentUserName()
        {
            return _httpContextAccessor?.HttpContext?.User?.Identity?.Name;
        }

        private string? GetClientIpAddress()
        {
            return _httpContextAccessor?.HttpContext?.Connection?.RemoteIpAddress?.ToString();
        }
    }

    // Clase auxiliar para construir entradas de auditoría
    public class AuditEntry
    {
        public AuditEntry(EntityEntry entry)
        {
            Entry = entry;
        }

        public EntityEntry Entry { get; }
        public string TableName { get; set; } = string.Empty;
        public string Action { get; set; } = string.Empty;
        public int? UserId { get; set; }
        public string? UserName { get; set; }
        public string? IpAddress { get; set; }
        public Dictionary<string, object?> KeyValues { get; } = new();
        public Dictionary<string, object?> OldValues { get; } = new();
        public Dictionary<string, object?> NewValues { get; } = new();
        public List<PropertyEntry> TemporaryProperties { get; } = new();

        public AuditLog ToAuditLog()
        {
            return new AuditLog
            {
                Tabla = TableName,
                RegistroId = JsonSerializer.Serialize(KeyValues),
                Accion = Action,
                UsuarioId = UserId,
                UsuarioNombre = UserName,
                Fecha = DateTime.UtcNow,
                ValoresAnteriores = OldValues.Count > 0 ? JsonSerializer.Serialize(OldValues) : null,
                ValoresNuevos = NewValues.Count > 0 ? JsonSerializer.Serialize(NewValues) : null,
                IpAddress = IpAddress
            };
        }
    }
}