using System;

namespace Wedding.Domain.Entities
{
    public class Guest
    {
        public int Id { get; private set; }
        public int FamilyId { get; private set; }
        public string Name { get; private set; }
        public bool IsAttending { get; private set; }
        public bool IsChildMenu { get; private set; }
        public bool IsHalfPortion { get; private set; }
        public string? Intolerances { get; private set; } // Comma separated or JSON
        public string? Observations { get; private set; }
        public string? FunnyComment { get; private set; }
        
        public ICollection<GuestIntolerance> GuestIntolerances { get; private set; } = new List<GuestIntolerance>();


        public Guest(string name)
        {
            Name = name;
            IsAttending = false; // Default
            IsChildMenu = false;
            IsHalfPortion = false;
            Intolerances = string.Empty;
            Observations = string.Empty;
            FunnyComment = string.Empty;
        }

        public void UpdateConfirmation(bool isAttending, bool isChildMenu, bool isHalfPortion, string? intolerances, string? observations, string? funnyComment, List<int> selectedIntoleranceIds)
        {
            IsAttending = isAttending;
            IsChildMenu = isChildMenu;
            IsHalfPortion = isHalfPortion;
            Intolerances = intolerances;
            Observations = observations;
            FunnyComment = funnyComment;

            // Update Many-to-Many
            GuestIntolerances.Clear();
            foreach (var id in selectedIntoleranceIds)
            {
                GuestIntolerances.Add(new GuestIntolerance { GuestId = this.Id, IntoleranceId = id });
            }
        }
    }
}
