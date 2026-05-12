using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Wedding.Application.DTOs;
using Wedding.Domain.Entities;
using Wedding.Domain.Repositories;
using AutoMapper; // Added for AutoMapper

namespace Wedding.Application.Services
{
    public class FamilyService : IFamilyService
    {
        private readonly IFamilyRepository _familyRepository;
        private readonly IMapper _mapper;
        private readonly IEmailService _emailService;

        public FamilyService(IFamilyRepository familyRepository, IMapper mapper, IEmailService emailService)
        {
            _familyRepository = familyRepository;
            _mapper = mapper;
            _emailService = emailService;
        }

        public async Task<FamilyDto?> GetFamilyByTokenAsync(string token)
        {
            var family = await _familyRepository.GetByTokenAsync(token);
            if (family == null) return null;

            return _mapper.Map<FamilyDto>(family);
        }

        public async Task<List<FamilyDto>> GetAllFamiliesAsync()
        {
            var families = await _familyRepository.GetAllAsync();
            return _mapper.Map<List<FamilyDto>>(families);
        }

        public async Task<FamilyDto> CreateFamilyAsync(string name, List<string> guestNames)
        {
            var family = new Family(name);
            foreach (var guestName in guestNames)
            {
                family.AddGuest(guestName);
            }

            await _familyRepository.AddAsync(family);
            await _familyRepository.SaveChangesAsync();

            return _mapper.Map<FamilyDto>(family);
        }

        public async Task<bool> ConfirmAttendanceAsync(string token, ConfirmationRequest request)
        {
            var family = await _familyRepository.GetByTokenAsync(token);
            if (family == null) return false;

            family.ConfirmAttendance();

            var detailsSb = new StringBuilder();
            detailsSb.Append("<ul>");
            int attendingCount = 0;

            foreach (var guestConfirm in request.Guests)
            {
                var guest = family.Guests.FirstOrDefault(g => g.Id == guestConfirm.GuestId);
                if (guest != null)
                {
                    guest.UpdateConfirmation(
                        guestConfirm.IsAttending,
                        guestConfirm.IsAdultMenu ? false : guestConfirm.IsChildMenu,
                        guestConfirm.IsHalfPortion,
                        guestConfirm.Intolerances,
                        guestConfirm.Observations,
                        guestConfirm.FunnyComment,
                        guestConfirm.SelectedIntolerances
                    );

                    string status = guestConfirm.IsAttending ? "Asistirá" : "No asistirá";
                    string guestNameLower = guest.Name.Trim().ToLowerInvariant();
                    string menu = "";
                    if (guestConfirm.IsAttending)
                    {
                        if (guestNameLower == "javi" || guestNameLower == "nil")
                        {
                            menu = " (Menú Celíaco)";
                        }
                        else
                        {
                            menu = guestConfirm.IsChildMenu ? " (Menú Infantil)" : " (Menú Adulto)";
                        }
                    }
                    detailsSb.Append($"<li>{guest.Name}: <strong>{status}</strong>{menu}</li>");
                    if (guestConfirm.IsAttending) attendingCount++;
                }
            }
            detailsSb.Append("</ul>");

            await _familyRepository.SaveChangesAsync();

            // Send confirmation email
            var targetEmail = !string.IsNullOrWhiteSpace(request.Email) ? request.Email : family.Email;
            if (!string.IsNullOrWhiteSpace(targetEmail))
            {
                var htmlBody = EmailTemplateEngine.GenerateConfirmationEmail(
                    family.Name, 
                    targetEmail, 
                    attendingCount, 
                    detailsSb.ToString());
                    
                await _emailService.SendEmailAsync(targetEmail, "¡Confirmación de Asistencia Recibida!", htmlBody);
            }

            return true;
        }

        public async Task<bool> UpdateGuestAsync(int guestId, GuestDto guestDto)
        {
            var families = await _familyRepository.GetAllAsync();
            foreach (var family in families)
            {
                var guest = family.Guests.FirstOrDefault(g => g.Id == guestId);
                if (guest != null)
                {
                    guest.UpdateConfirmation(
                        guest.IsAttending, // Keep current status
                        guest.IsChildMenu,
                        guest.IsHalfPortion,
                        guestDto.Intolerances,
                        guestDto.Observations,
                        guestDto.FunnyComment,
                        guestDto.SelectedIntolerances?.ToList()
                    );
                    await _familyRepository.SaveChangesAsync();
                    return true;
                }
            }
            return false;
        }
    }
}
