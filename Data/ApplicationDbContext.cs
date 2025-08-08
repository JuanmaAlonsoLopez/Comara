// Data/ApplicationDbContext.cs
using Microsoft.EntityFrameworkCore;
using comara.Models; // Asegúrate de usar tu namespace

namespace comara.Data
{ 
    public class ApplicationDbContext : DbContext
    {
        public ApplicationDbContext(DbContextOptions<ApplicationDbContext> options) : base(options)
        {
        }
    
        public DbSet<Articulo> Articulos { get; set; }
    
    }
}