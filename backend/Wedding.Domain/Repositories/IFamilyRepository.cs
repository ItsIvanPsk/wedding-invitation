using System.Threading.Tasks;
using Wedding.Domain.Entities;

namespace Wedding.Domain.Repositories
{
    public interface IFamilyRepository
    {
        Task<Family?> GetByTokenAsync(string token);
        Task<Family?> GetByIdAsync(int id);
        Task<List<Family>> GetAllAsync();
        Task AddAsync(Family family);
        Task SaveChangesAsync();
    }
}
