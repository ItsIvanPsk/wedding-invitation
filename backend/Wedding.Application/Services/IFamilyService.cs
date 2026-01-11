using System.Threading.Tasks;
using Wedding.Application.DTOs;

namespace Wedding.Application.Services
{
    public interface IFamilyService
    {
        Task<FamilyDto?> GetFamilyByTokenAsync(string token);
        Task<List<FamilyDto>> GetAllFamiliesAsync();
        Task<bool> ConfirmAttendanceAsync(string token, ConfirmationRequest request);
        Task<FamilyDto> CreateFamilyAsync(string name, List<string> guestNames);
    }
}
