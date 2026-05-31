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

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            // C# tarafındaki TravelHistories setini, SQL'deki tekil "TravelHistory" tablosuna eşliyoruz:
            modelBuilder.Entity<TravelHistory>().ToTable("TravelHistory");

            // Places tablosundaki Enlem ve Boylam sütunları için 
            // SQL'deki decimal(9, 6) yapısına uygun hassasiyet ayarı
            modelBuilder.Entity<Place>()
                .Property(p => p.Enlem)
                .HasPrecision(9, 6);

            modelBuilder.Entity<Place>()
                .Property(p => p.Boylam)
                .HasPrecision(9, 6);
        }
    }
}