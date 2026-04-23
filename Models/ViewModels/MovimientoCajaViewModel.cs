using System;
using System.ComponentModel.DataAnnotations;

namespace comara.Models.ViewModels
{
    public class MovimientoCajaViewModel
    {
        [Required(ErrorMessage = "La fecha es requerida")]
        [Display(Name = "Fecha")]
        [DataType(DataType.Date)]
        public DateTime MovFecha { get; set; } = DateTime.Now;

        [Required(ErrorMessage = "El tipo de movimiento es requerido")]
        [Display(Name = "Tipo de Movimiento")]
        public int MovTipo { get; set; }

        [Required(ErrorMessage = "El método de pago es requerido")]
        [Display(Name = "Método de Pago")]
        public int MovMetodoPago { get; set; }

        [Required(ErrorMessage = "El monto es requerido")]
        [Display(Name = "Monto")]
        [Range(0.01, double.MaxValue, ErrorMessage = "El monto debe ser mayor a 0")]
        public decimal MovMonto { get; set; }

        [Display(Name = "Descripción")]
        [StringLength(255)]
        public string? MovDescripcion { get; set; }

        // Para movimientos de cheques (salida)
        [Display(Name = "Cheque")]
        public int? ChqCod { get; set; }
    }
}
