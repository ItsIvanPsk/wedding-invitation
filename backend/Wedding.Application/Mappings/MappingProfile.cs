using AutoMapper;
using Wedding.Application.DTOs;
using Wedding.Domain.Entities;

namespace Wedding.Application.Mappings
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {
            CreateMap<Family, FamilyDto>();
            CreateMap<Guest, GuestDto>()
                .ForMember(dest => dest.SelectedIntolerances, opt => opt.MapFrom(src => src.GuestIntolerances.Select(gi => gi.IntoleranceId).ToList()))
                .ForMember(dest => dest.IsAdultMenu, opt => opt.MapFrom(src => !src.IsChildMenu));
        }
    }
}
