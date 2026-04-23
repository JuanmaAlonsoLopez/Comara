using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models.AFIP
{
    /// <summary>
    /// Entidad que mapea a la tabla afip_auth_tickets en PostgreSQL
    /// Almacena los tickets de autenticación de AFIP para caché
    /// </summary>
    [Table("afip_auth_tickets")]
    public class AfipAuthTicket
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Required]
        [Column("cuit_representado")]
        [MaxLength(11)]
        public string CuitRepresentado { get; set; } = string.Empty;

        [Required]
        [Column("token")]
        public string Token { get; set; } = string.Empty;

        [Required]
        [Column("sign")]
        public string Sign { get; set; } = string.Empty;

        [Required]
        [Column("generated_at")]
        public DateTime GeneratedAt { get; set; }

        [Required]
        [Column("expiration_time")]
        public DateTime ExpirationTime { get; set; }

        [Required]
        [Column("environment")]
        [MaxLength(20)]
        public string Environment { get; set; } = string.Empty;

        /// <summary>
        /// Verifica si el ticket es válido considerando un margen de seguridad de 10 minutos
        /// </summary>
        public bool IsValid(int minutosMargen = 10)
        {
            return !string.IsNullOrEmpty(Token)
                   && !string.IsNullOrEmpty(Sign)
                   && ExpirationTime > DateTime.UtcNow.AddMinutes(minutosMargen);
        }
    }
}
