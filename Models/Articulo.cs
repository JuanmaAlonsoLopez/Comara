namespace comara.Models;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
[Table("ARTICULOS")] // Le dice a EF Core que esta clase se mapea a la tabla "ARTICULOS"
public class Articulo
{
    [Key] // Marca esta propiedad como la Clave Primaria (Primary Key)
    [Column("artCod")] // Mapea esta propiedad a la columna "artCod"
    public int ArtCod { get; set; }

    [Required] // Equivalente a NOT NULL
    [StringLength(40)]
    [Column("artDesc")]
    public required string ArtDesc { get; set; }

    [Column("activo")]
    public byte[]? Activo { get; set; } // bytea se mapea a un array de bytes

    [Column("artStock")]
    public double? ArtStock { get; set; } // real se mapea a double (o float)

    [Column("artUni")]
    public int ArtUni { get; set; }

    [Column("artStockMin")]
    public double? ArtStockMin { get; set; }

    [Column("artExist")]
    public bool? ArtExist { get; set; } // boolean se mapea a bool

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
    public double? ArtL1 { get; set; }

    [Column("artL2")]
    public double? ArtL2 { get; set; }

    [Column("artL3")]
    public double? ArtL3 { get; set; }

    [Column("artL4")]
    public double? ArtL4 { get; set; }

    [Column("artL5")]
    public int? ArtL5 { get; set; }

    [Column("coef1")]
    public double? Coef1 { get; set; }

    [Column("coef2")]
    public double? Coef2 { get; set; }

    [Column("coef3")]
    public double? Coef3 { get; set; }

    [Column("artDestino")]
    public int ArtDestino { get; set; }

    [Column("iva")]
    public double? Iva { get; set; }

    [Column("imp_interno")]
    public double? ImpInterno { get; set; }

    [Column("artTalonario")]
    public int? ArtTalonario { get; set; }

    [Column("artCbteNro")]
    public int? ArtCbteNro { get; set; }

    [Column("FechCom")]
    public DateTime? FechCom { get; set; } // date se mapea a DateTime

    [Column("FechMod")]
    public DateTime? FechMod { get; set; }

    [Column("FechVto")]
    public DateTime? FechVto { get; set; }

    [Column("artDesc2")]
    public string? ArtDesc2 { get; set; }

    [Column("Foto")]
    public string? Foto { get; set; } // Asumo que guardas la ruta a la foto, no la foto en sí

    [Column("exento")]
    public int? Exento { get; set; }

    [Column("conjunto")]
    public string? Conjunto { get; set; }
}
