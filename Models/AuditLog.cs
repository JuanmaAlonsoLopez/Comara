using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace comara.Models
{
    [Table("AUDIT_LOG")]
    public class AuditLog
    {
        [Key]
        [Column("id")]
        public int Id { get; set; }

        [Required]
        [StringLength(100)]
        [Column("tabla")]
        public string Tabla { get; set; } = string.Empty;

        [Required]
        [StringLength(50)]
        [Column("registro_id")]
        public string RegistroId { get; set; } = string.Empty;

        [Required]
        [StringLength(10)]
        [Column("accion")]
        public string Accion { get; set; } = string.Empty; // INSERT, UPDATE, DELETE

        [Column("usuario_id")]
        public int? UsuarioId { get; set; }

        [StringLength(100)]
        [Column("usuario_nombre")]
        public string? UsuarioNombre { get; set; }

        [Column("fecha")]
        public DateTime Fecha { get; set; } = DateTime.UtcNow;

        [Column("valores_anteriores", TypeName = "jsonb")]
        public string? ValoresAnteriores { get; set; }

        [Column("valores_nuevos", TypeName = "jsonb")]
        public string? ValoresNuevos { get; set; }

        [StringLength(45)]
        [Column("ip_address")]
        public string? IpAddress { get; set; }
    }
}
