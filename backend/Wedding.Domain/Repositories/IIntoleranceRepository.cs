using System.Collections.Generic;
using System.Threading.Tasks;
using Wedding.Domain.Entities;

namespace Wedding.Domain.Repositories
{
    public interface IIntoleranceRepository
    {
        Task<List<Intolerance>> GetAllAsync();
    }
}
