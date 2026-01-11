using Microsoft.EntityFrameworkCore;
using Wedding.Domain.Entities;
using Wedding.Domain.Repositories;
using Wedding.Infrastructure.Data.Persistence;

namespace Wedding.Infrastructure.Repositories.Repositories
{
    public class FamilyRepository : IFamilyRepository
    {
        private readonly WeddingDbContext _context;

        public FamilyRepository(WeddingDbContext context)
        {
            _context = context;
        }

        public async Task<Family?> GetByTokenAsync(string token)
        {
            return await _context.Families
                .Include(f => f.Guests)
                    .ThenInclude(g => g.GuestIntolerances)
                .FirstOrDefaultAsync(f => f.Token == token);
        }

        public async Task<Family?> GetByIdAsync(int id)
        {
             return await _context.Families
                .Include(f => f.Guests)
                    .ThenInclude(g => g.GuestIntolerances)
                .FirstOrDefaultAsync(f => f.Id == id);
        }

        public async Task<List<Family>> GetAllAsync()
        {
            return await _context.Families
                .Include(f => f.Guests)
                    .ThenInclude(g => g.GuestIntolerances)
                .ToListAsync();
        }

        public async Task AddAsync(Family family)
        {
            await _context.Families.AddAsync(family);
        }

        public async Task SaveChangesAsync()
        {
            await _context.SaveChangesAsync();
        }
    }
}
