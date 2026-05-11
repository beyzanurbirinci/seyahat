using Microsoft.EntityFrameworkCore;
using SeyahatBackend.Models;

namespace SeyahatBackend.Data
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options) { }

        public DbSet<Place> Places { get; set; }
        public DbSet<User> Users { get; set; }
        public DbSet<TravelHistory> TravelHistories { get; set; }
        public DbSet<Region> Regions { get; set; }
        public DbSet<City> Cities { get; set; } 

    }
}
