using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("ARTICULOS")]
    public class Articulo
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [StringLength(20)]
        [Column("artCod")]
        public string? ArtCod { get; set; } // Mantenido en BD por compatibilidad, no se usa en el sistema

        [Required]
        [StringLength(55)]
        [Column("artDesc")]
        public string? ArtDesc { get; set; }

        [Column("activo")]
        public byte[]? Activo { get; set; }

        [Column("artStock")]
        public decimal? ArtStock { get; set; }

        [Column("artUni")]
        public int ArtUni { get; set; }

        [Column("artStockMin")]
        public decimal? ArtStockMin { get; set; }

        [Column("artExist")]
        public bool? ArtExist { get; set; }

        [Column("rubCod")]
        public int RubCod { get; set; }

        [Column("srubCod")]
        public int SrubCod { get; set; }

        [Column("marCod")]
        public int MarCod { get; set; }

        [Column("ivaCod")]
        public int IvaCod { get; set; }

        [StringLength(18)]
        [Column("artAlt1")]
        public string? ArtAlt1 { get; set; }

        [StringLength(18)]
        [Column("artAlt2")]
        public string? ArtAlt2 { get; set; }

        [Column("artL1")]
        public decimal? ArtL1 { get; set; }

        [Column("artL2")]
        public decimal? ArtL2 { get; set; }

        [Column("artL3")]
        public decimal? ArtL3 { get; set; }

        [Column("artL4")]
        public decimal? ArtL4 { get; set; }

        [Column("artL5")]
        public decimal? ArtL5 { get; set; }

        [Column("proCod")]
        public int ProCod { get; set; }

        [Column("artCosto")]
        [Display(Name = "Costo Neto (sin IVA ni descuento)")]
        public decimal? ArtCost { get; set; }


        // Propiedades de Navegación
        [ForeignKey("MarCod")]
        public virtual Marca? Marca { get; set; }

        [ForeignKey("ProCod")]
        public virtual Proveedor? Proveedor { get; set; }

        [ForeignKey("IvaCod")]
        public virtual Iva? Iva { get; set; }

        // Propiedades Calculadas (No mapeadas a base de datos)

        /// <summary>
        /// Costo con descuento del proveedor aplicado (sin IVA)
        /// Fórmula: CostoNeto * (1 - DescuentoProveedor/100)
        /// </summary>
        [NotMapped]
        public decimal CostoConDescuento
        {
            get
            {
                if (ArtCost == null) return 0;

                decimal costoNeto = ArtCost.Value;
                decimal descuentoProveedor = Proveedor?.proDescuento ?? 0;

                return costoNeto * (1 - (descuentoProveedor / 100));
            }
        }

        /// <summary>
        /// Costo final con descuento e IVA aplicado
        /// Fórmula: CostoConDescuento * (1 + IVA/100)
        /// </summary>
        [NotMapped]
        public decimal CostoFinal
        {
            get
            {
                decimal costoConDesc = CostoConDescuento;
                decimal porcentajeIva = Iva?.Porcentaje ?? 0;

                return costoConDesc * (1 + (porcentajeIva / 100));
            }
        }

        /// <summary>
        /// Calcula el precio de venta según la lista de precios especificada
        /// </summary>
        /// <param name="listaPorcentaje">Porcentaje de ganancia de la lista (ej: 30 para 30%)</param>
        /// <returns>Precio de venta final</returns>
        public decimal CalcularPrecioVenta(decimal listaPorcentaje)
        {
            return CostoFinal * (1 + (listaPorcentaje / 100));
        }
    }
}