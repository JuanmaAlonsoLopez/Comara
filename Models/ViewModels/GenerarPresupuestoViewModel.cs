using System.ComponentModel.DataAnnotations;

namespace comara.Models.ViewModels
{
    public class GenerarPresupuestoViewModel
    {
        public int VenCod { get; set; }

        [Required(ErrorMessage = "Debe seleccionar un método de pago")]
        [Display(Name = "Método de Pago")]
        public int MetodoPago { get; set; }

        // Datos de la venta para mostrar en la vista
        public Venta? Venta { get; set; }
    }
}
