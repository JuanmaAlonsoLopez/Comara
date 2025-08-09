using System.ComponentModel.DataAnnotations;

namespace comara.Models
{
    public class Cliente
    {
        [Key]
        public int cliCod { get; set; }
        public string cliNombre { get; set; }
        public string? cliCUIT { get; set; }
        public string? cliDireccion { get; set; }
        public string? cliTelefono { get; set; }
        public string? cliEmail { get; set; }
    }
}
