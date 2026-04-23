using Microsoft.AspNetCore.Mvc.Rendering;

namespace comara.Services
{
    public interface IDropdownService
    {
        Task<SelectList> GetClientesAsync(int? selectedId = null);
        Task<SelectList> GetMarcasAsync(int? selectedId = null);
        Task<SelectList> GetProveedoresAsync(int? selectedId = null);
        Task<SelectList> GetIvasAsync(int? selectedId = null);
        Task<SelectList> GetListasPreciosAsync(int? selectedId = null);
        Task<SelectList> GetEstadosVentaAsync(int? selectedId = null);
        Task<SelectList> GetMetodosPagoAsync(int? selectedId = null);
        Task<SelectList> GetTiposComprobanteAsync(int? selectedId = null);
        Task<SelectList> GetEstadosCotizacionAsync(int? selectedId = null);

        /// <summary>
        /// Carga múltiples dropdowns a la vez para optimizar consultas
        /// </summary>
        Task<DropdownsVenta> GetDropdownsVentaAsync(int? clienteId = null, int? listaId = null, int? estadoId = null, int? metodoPagoId = null);

        /// <summary>
        /// Carga dropdowns para artículos
        /// </summary>
        Task<DropdownsArticulo> GetDropdownsArticuloAsync(int? marcaId = null, int? proveedorId = null, int? ivaId = null);
    }

    public class DropdownsVenta
    {
        public SelectList Clientes { get; set; } = null!;
        public SelectList Listas { get; set; } = null!;
        public SelectList Estados { get; set; } = null!;
        public SelectList MetodosPago { get; set; } = null!;
    }

    public class DropdownsArticulo
    {
        public SelectList Marcas { get; set; } = null!;
        public SelectList Proveedores { get; set; } = null!;
        public SelectList Ivas { get; set; } = null!;
    }
}
