using System.ComponentModel.DataAnnotations;

namespace comara.Models
{
    public class Marca
    {
        [Key]
        public int marCod { get; set; }
        public string marNombre { get; set; }
    }
}
