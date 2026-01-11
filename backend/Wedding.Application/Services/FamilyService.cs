using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Wedding.Application.DTOs;
using Wedding.Domain.Entities;
using Wedding.Domain.Repositories;
using AutoMapper; // Added for AutoMapper

namespace Wedding.Application.Services
{
    public class FamilyService : IFamilyService
    {
        private readonly IFamilyRepository _familyRepository; // Renamed from _repository
        private readonly IMapper _mapper; // Injected AutoMapper

        public FamilyService(IFamilyRepository familyRepository, IMapper mapper) // Constructor updated
        {
            _familyRepository = familyRepository;
            _mapper = mapper;
        }

        public async Task<FamilyDto?> GetFamilyByTokenAsync(string token)
        {
            var family = await _familyRepository.GetByTokenAsync(token); // Using _familyRepository
            if (family == null) return null;

            return _mapper.Map<FamilyDto>(family); // Using AutoMapper
        }

        public async Task<List<FamilyDto>> GetAllFamiliesAsync()
        {
            var families = await _familyRepository.GetAllAsync(); // Using _familyRepository
            return _mapper.Map<List<FamilyDto>>(families); // Using AutoMapper
        }

        public async Task<FamilyDto> CreateFamilyAsync(string name, List<string> guestNames)
        {
            var family = new Family(name);
            foreach (var guestName in guestNames)
            {
                family.AddGuest(guestName);
            }

            await _familyRepository.AddAsync(family); // Using _familyRepository
            await _familyRepository.SaveChangesAsync(); // Using _familyRepository

            return _mapper.Map<FamilyDto>(family); // Using AutoMapper
        }

        public async Task<bool> ConfirmAttendanceAsync(string token, ConfirmationRequest request) // Changed familyId to token
        {
            var family = await _familyRepository.GetByTokenAsync(token); // Changed GetByIdAsync to GetByTokenAsync
            if (family == null) return false;

            family.ConfirmAttendance(); // Added this line

            foreach (var guestConfirm in request.Guests) // Changed guestUpdate to guestConfirm
            {
                var guest = family.Guests.FirstOrDefault(g => g.Id == guestConfirm.GuestId); // Changed guestUpdate to guestConfirm
                if (guest != null)
                {
                    guest.UpdateConfirmation(
                        guestConfirm.IsAttending,
                        guestConfirm.IsAdultMenu ? false : guestConfirm.IsChildMenu, // Support both if provided
                        guestConfirm.IsHalfPortion,
                        guestConfirm.Intolerances,
                        guestConfirm.Observations,
                        guestConfirm.FunnyComment,
                        guestConfirm.SelectedIntolerances
                    );
                }
            }

            await _familyRepository.SaveChangesAsync(); // Using _familyRepository
            return true;
        }
    }
}
