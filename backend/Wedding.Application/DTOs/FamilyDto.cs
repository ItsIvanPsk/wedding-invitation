using System;
using System.Collections.Generic;

namespace Wedding.Application.DTOs
{
    public class GuestDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public bool IsAttending { get; set; }
        public bool IsChildMenu { get; set; }
        public bool IsHalfPortion { get; set; }
        public bool IsAdultMenu { get; set; } // Derived from !IsChildMenu
        public string? Intolerances { get; set; }
        public List<int> SelectedIntolerances { get; set; } = new(); // IDs
        public string? Observations { get; set; }
        public string? FunnyComment { get; set; }
    }

    public class FamilyDto
    {
        public int Id { get; set; }
        public string Name { get; set; } = string.Empty;
        public string Token { get; set; } = string.Empty;
        public DateTime? ConfirmationDate { get; set; }
        public List<GuestDto> Guests { get; set; } = new();
    }

    public class ConfirmationRequest
    {
        public List<GuestConfirmationDto> Guests { get; set; } = new();
    }

    public class GuestConfirmationDto
    {
        public int GuestId { get; set; }
        public bool IsAttending { get; set; }
        public bool IsChildMenu { get; set; }
        public bool IsHalfPortion { get; set; }
        // IsAdultMenu can be used by frontend to send intention, but backend will map to IsChildMenu
        public bool IsAdultMenu { get; set; }
        public string? Intolerances { get; set; }
        public List<int> SelectedIntolerances { get; set; } = new();
        public string? Observations { get; set; }
        public string? FunnyComment { get; set; }
    }
}
