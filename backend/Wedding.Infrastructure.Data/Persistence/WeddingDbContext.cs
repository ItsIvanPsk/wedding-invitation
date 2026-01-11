using Microsoft.EntityFrameworkCore;
using Wedding.Domain.Entities;

namespace Wedding.Infrastructure.Data.Persistence
{
    public class WeddingDbContext : DbContext
    {
        public WeddingDbContext(DbContextOptions<WeddingDbContext> options) : base(options) { }

        public DbSet<Family> Families { get; set; }
        public DbSet<Guest> Guests { get; set; }
        public DbSet<Intolerance> Intolerances { get; set; }
        public DbSet<GuestIntolerance> GuestIntolerances { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Family>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.HasIndex(e => e.Token).IsUnique(); // Ensure tokens are unique
                entity.Property(e => e.Name).IsRequired();
                
                // Configure one-to-many relationship
                entity.HasMany(e => e.Guests)
                      .WithOne()
                      .HasForeignKey(g => g.FamilyId)
                      .OnDelete(DeleteBehavior.Cascade);
            });

            modelBuilder.Entity<Guest>(entity =>
            {
                entity.HasKey(e => e.Id);
                entity.Property(e => e.Name).IsRequired();
            });

            modelBuilder.Entity<GuestIntolerance>(entity =>
            {
                entity.HasKey(gi => new { gi.GuestId, gi.IntoleranceId });

                entity.HasOne(gi => gi.Guest)
                      .WithMany(g => g.GuestIntolerances)
                      .HasForeignKey(gi => gi.GuestId);

                entity.HasOne(gi => gi.Intolerance)
                      .WithMany()
                      .HasForeignKey(gi => gi.IntoleranceId);
            });
        }
    }
}
