using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("ARTICULOS")]
    public class Articulo
    {
        [Key]
        [Column("artCod")]
        public int ArtCod { get; set; }

        [Required]
        [StringLength(40)]
        [Column("artDesc")]
        public string? ArtDesc { get; set; }

        [Column("activo")]
        public byte[]? Activo { get; set; }

        [Column("artStock")]
        public float? ArtStock { get; set; }

        [Column("artUni")]
        public int ArtUni { get; set; }

        [Column("artStockMin")]
        public float? ArtStockMin { get; set; }

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
        public float? ArtL1 { get; set; }

        [Column("artL2")]
        public float? ArtL2 { get; set; }

        [Column("artL3")]
        public float? ArtL3 { get; set; }

        [Column("artL4")]
        public float? ArtL4 { get; set; }

        [Column("artL5")]
        public float? ArtL5 { get; set; }

        [Column("proCod")]
        public int ProCod { get; set; }


        // Propiedades de Navegación
        [ForeignKey("MarCod")]
        public virtual Marca? Marca { get; set; }

        [ForeignKey("ProCod")]
        public virtual Proveedor? Proveedor { get; set; }
    }
}