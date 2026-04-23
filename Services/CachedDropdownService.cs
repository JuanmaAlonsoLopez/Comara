using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Caching.Memory;
using comara.Data;

namespace comara.Services
{
    /// <summary>
    /// Punto 12: Servicio de dropdowns con cache para datos de solo lectura.
    /// Cachea datos que cambian poco frecuentemente (IVAs, estados, tipos de comprobante, etc.)
    /// </summary>
    public class CachedDropdownService : IDropdownService
    {
        private readonly ApplicationDbContext _context;
        private readonly IMemoryCache _cache;
        private readonly ILogger<CachedDropdownService> _logger;

        // Claves de cache
        private const string CacheKeyIvas = "Dropdowns_Ivas";
        private const string CacheKeyEstadosVenta = "Dropdowns_EstadosVenta";
        private const string CacheKeyMetodosPago = "Dropdowns_MetodosPago";
        private const string CacheKeyTiposComprobante = "Dropdowns_TiposComprobante";
        private const string CacheKeyEstadosCotizacion = "Dropdowns_EstadosCotizacion";
        private const string CacheKeyListasPrecios = "Dropdowns_ListasPrecios";

        // Tiempo de expiración del cache (15 minutos para datos de referencia)
        private static readonly TimeSpan CacheExpiration = TimeSpan.FromMinutes(15);

        public CachedDropdownService(
            ApplicationDbContext context,
            IMemoryCache cache,
            ILogger<CachedDropdownService> logger)
        {
            _context = context;
            _cache = cache;
            _logger = logger;
        }

        public async Task<SelectList> GetClientesAsync(int? selectedId = null)
        {
            // Clientes NO se cachean porque pueden cambiar frecuentemente
            var clientes = await _context.Clientes
                .OrderBy(c => c.CliNombre)
                .Select(c => new { c.Id, c.CliNombre })
                .ToListAsync();
            return new SelectList(clientes, "Id", "CliNombre", selectedId);
        }

        public async Task<SelectList> GetMarcasAsync(int? selectedId = null)
        {
            // Marcas NO se cachean porque pueden cambiar
            var marcas = await _context.Marcas
                .OrderBy(m => m.marNombre)
                .ToListAsync();
            return new SelectList(marcas, "marCod", "marNombre", selectedId);
        }

        public async Task<SelectList> GetProveedoresAsync(int? selectedId = null)
        {
            // Proveedores NO se cachean porque pueden cambiar
            var proveedores = await _context.Proveedores
                .OrderBy(p => p.proNombre)
                .ToListAsync();
            return new SelectList(proveedores, "proCod", "proNombre", selectedId);
        }

        public async Task<SelectList> GetIvasAsync(int? selectedId = null)
        {
            // IVAs se cachean - cambian muy poco
            var ivas = await _cache.GetOrCreateAsync(CacheKeyIvas, async entry =>
            {
                entry.AbsoluteExpirationRelativeToNow = CacheExpiration;
                _logger.LogDebug("Cargando IVAs desde BD y cacheando");
                return await _context.Ivas
                    .OrderBy(i => i.Porcentaje)
                    .Select(i => new { i.Id, i.Porcentaje })
                    .ToListAsync();
            });
            return new SelectList(ivas, "Id", "Porcentaje", selectedId);
        }

        public async Task<SelectList> GetListasPreciosAsync(int? selectedId = null)
        {
            // Listas de precios se cachean con menor tiempo
            var listas = await _cache.GetOrCreateAsync(CacheKeyListasPrecios, async entry =>
            {
                entry.AbsoluteExpirationRelativeToNow = TimeSpan.FromMinutes(5);
                _logger.LogDebug("Cargando Listas de precios desde BD y cacheando");
                return await _context.Listas
                    .Where(l => l.ListStatus)
                    .OrderBy(l => l.ListCode)
                    .Select(l => new { l.ListCode, l.ListDesc })
                    .ToListAsync();
            });
            return new SelectList(listas, "ListCode", "ListDesc", selectedId);
        }

        public async Task<SelectList> GetEstadosVentaAsync(int? selectedId = null)
        {
            // Estados se cachean - cambian muy poco
            var estados = await _cache.GetOrCreateAsync(CacheKeyEstadosVenta, async entry =>
            {
                entry.AbsoluteExpirationRelativeToNow = CacheExpiration;
                _logger.LogDebug("Cargando Estados de venta desde BD y cacheando");
                return await _context.VentaTipoEstados
                    .OrderBy(e => e.Id)
                    .Select(e => new { e.Id, e.Descripcion })
                    .ToListAsync();
            });
            return new SelectList(estados, "Id", "Descripcion", selectedId);
        }

        public async Task<SelectList> GetMetodosPagoAsync(int? selectedId = null)
        {
            // Métodos de pago se cachean - cambian muy poco
            var metodos = await _cache.GetOrCreateAsync(CacheKeyMetodosPago, async entry =>
            {
                entry.AbsoluteExpirationRelativeToNow = CacheExpiration;
                _logger.LogDebug("Cargando Métodos de pago desde BD y cacheando");
                return await _context.VentaTipoMetodoPagos
                    .OrderBy(m => m.Id)
                    .Select(m => new { m.Id, m.Descripcion })
                    .ToListAsync();
            });
            return new SelectList(metodos, "Id", "Descripcion", selectedId);
        }

        public async Task<SelectList> GetTiposComprobanteAsync(int? selectedId = null)
        {
            // Tipos de comprobante se cachean - cambian muy poco
            var tipos = await _cache.GetOrCreateAsync(CacheKeyTiposComprobante, async entry =>
            {
                entry.AbsoluteExpirationRelativeToNow = CacheExpiration;
                _logger.LogDebug("Cargando Tipos de comprobante desde BD y cacheando");
                return await _context.TipoComprobantes
                    .Where(tc => tc.CodigoAfip <= 11)
                    .OrderBy(tc => tc.CodigoAfip)
                    .Select(tc => new { tc.CodigoAfip, tc.Descripcion })
                    .ToListAsync();
            });
            return new SelectList(tipos, "CodigoAfip", "Descripcion", selectedId);
        }

        public async Task<SelectList> GetEstadosCotizacionAsync(int? selectedId = null)
        {
            // Estados de cotización se cachean - cambian muy poco
            var estados = await _cache.GetOrCreateAsync(CacheKeyEstadosCotizacion, async entry =>
            {
                entry.AbsoluteExpirationRelativeToNow = CacheExpiration;
                _logger.LogDebug("Cargando Estados de cotización desde BD y cacheando");
                return await _context.CotizacionEstados
                    .OrderBy(e => e.Id)
                    .Select(e => new { e.Id, e.Descripcion })
                    .ToListAsync();
            });
            return new SelectList(estados, "Id", "Descripcion", selectedId);
        }

        public async Task<DropdownsVenta> GetDropdownsVentaAsync(
            int? clienteId = null,
            int? listaId = null,
            int? estadoId = null,
            int? metodoPagoId = null)
        {
            return new DropdownsVenta
            {
                Clientes = await GetClientesAsync(clienteId),
                Listas = await GetListasPreciosAsync(listaId),
                Estados = await GetEstadosVentaAsync(estadoId),
                MetodosPago = await GetMetodosPagoAsync(metodoPagoId)
            };
        }

        public async Task<DropdownsArticulo> GetDropdownsArticuloAsync(
            int? marcaId = null,
            int? proveedorId = null,
            int? ivaId = null)
        {
            return new DropdownsArticulo
            {
                Marcas = await GetMarcasAsync(marcaId),
                Proveedores = await GetProveedoresAsync(proveedorId),
                Ivas = await GetIvasAsync(ivaId)
            };
        }

        /// <summary>
        /// Invalida el cache de un tipo específico de dropdown
        /// </summary>
        public void InvalidateCache(string cacheKey)
        {
            _cache.Remove(cacheKey);
            _logger.LogInformation("Cache invalidado: {CacheKey}", cacheKey);
        }

        /// <summary>
        /// Invalida todo el cache de dropdowns
        /// </summary>
        public void InvalidateAllCache()
        {
            _cache.Remove(CacheKeyIvas);
            _cache.Remove(CacheKeyEstadosVenta);
            _cache.Remove(CacheKeyMetodosPago);
            _cache.Remove(CacheKeyTiposComprobante);
            _cache.Remove(CacheKeyEstadosCotizacion);
            _cache.Remove(CacheKeyListasPrecios);
            _logger.LogInformation("Todo el cache de dropdowns fue invalidado");
        }
    }
}
