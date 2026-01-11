using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Threading.Tasks;
using Wedding.Domain.Entities;
using Wedding.Domain.Repositories;
using Wedding.Infrastructure.Data.Persistence;

namespace Wedding.Infrastructure.Repositories
{
    public class IntoleranceRepository : IIntoleranceRepository
    {
        private readonly WeddingDbContext _context;

        public IntoleranceRepository(WeddingDbContext context)
        {
            _context = context;
        }

        public async Task<List<Intolerance>> GetAllAsync()
        {
            return await _context.Intolerances.ToListAsync();
        }
    }
}
