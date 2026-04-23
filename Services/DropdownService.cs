using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.EntityFrameworkCore;
using comara.Data;

namespace comara.Services
{
    public class DropdownService : IDropdownService
    {
        private readonly ApplicationDbContext _context;

        public DropdownService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<SelectList> GetClientesAsync(int? selectedId = null)
        {
            var clientes = await _context.Clientes
                .OrderBy(c => c.CliNombre)
                .Select(c => new { c.Id, c.CliNombre })
                .ToListAsync();
            return new SelectList(clientes, "Id", "CliNombre", selectedId);
        }

        public async Task<SelectList> GetMarcasAsync(int? selectedId = null)
        {
            var marcas = await _context.Marcas
                .OrderBy(m => m.marNombre)
                .ToListAsync();
            return new SelectList(marcas, "marCod", "marNombre", selectedId);
        }

        public async Task<SelectList> GetProveedoresAsync(int? selectedId = null)
        {
            var proveedores = await _context.Proveedores
                .OrderBy(p => p.proNombre)
                .ToListAsync();
            return new SelectList(proveedores, "proCod", "proNombre", selectedId);
        }

        public async Task<SelectList> GetIvasAsync(int? selectedId = null)
        {
            var ivas = await _context.Ivas
                .OrderBy(i => i.Porcentaje)
                .ToListAsync();
            return new SelectList(ivas, "Id", "Porcentaje", selectedId);
        }

        public async Task<SelectList> GetListasPreciosAsync(int? selectedId = null)
        {
            var listas = await _context.Listas
                .Where(l => l.ListStatus)
                .OrderBy(l => l.ListCode)
                .ToListAsync();
            return new SelectList(listas, "ListCode", "ListDesc", selectedId);
        }

        public async Task<SelectList> GetEstadosVentaAsync(int? selectedId = null)
        {
            var estados = await _context.VentaTipoEstados
                .OrderBy(e => e.Id)
                .ToListAsync();
            return new SelectList(estados, "Id", "Descripcion", selectedId);
        }

        public async Task<SelectList> GetMetodosPagoAsync(int? selectedId = null)
        {
            var metodos = await _context.VentaTipoMetodoPagos
                .OrderBy(m => m.Id)
                .ToListAsync();
            return new SelectList(metodos, "Id", "Descripcion", selectedId);
        }

        public async Task<SelectList> GetTiposComprobanteAsync(int? selectedId = null)
        {
            var tipos = await _context.TipoComprobantes
                .Where(tc => tc.CodigoAfip <= 11) // Solo facturas, no NC
                .OrderBy(tc => tc.CodigoAfip)
                .ToListAsync();
            return new SelectList(tipos, "CodigoAfip", "Descripcion", selectedId);
        }

        public async Task<SelectList> GetEstadosCotizacionAsync(int? selectedId = null)
        {
            var estados = await _context.CotizacionEstados
                .OrderBy(e => e.Id)
                .ToListAsync();
            return new SelectList(estados, "Id", "Descripcion", selectedId);
        }

        public async Task<DropdownsVenta> GetDropdownsVentaAsync(
            int? clienteId = null,
            int? listaId = null,
            int? estadoId = null,
            int? metodoPagoId = null)
        {
            // DbContext no es thread-safe, ejecutar secuencialmente
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
            // DbContext no es thread-safe, ejecutar secuencialmente
            return new DropdownsArticulo
            {
                Marcas = await GetMarcasAsync(marcaId),
                Proveedores = await GetProveedoresAsync(proveedorId),
                Ivas = await GetIvasAsync(ivaId)
            };
        }
    }
}
