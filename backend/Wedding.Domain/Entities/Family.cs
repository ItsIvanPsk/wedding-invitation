using System;
using System.Collections.Generic;

namespace Wedding.Domain.Entities
{
    public class Family
    {
        public int Id { get; private set; }
        public string Token { get; private set; }
        public string Name { get; private set; }
        public DateTime? ConfirmationDate { get; private set; } // Represents the confirmation timestamp

        private readonly List<Guest> _guests = new();
        public IReadOnlyCollection<Guest> Guests => _guests.AsReadOnly();

        private Family() { } // EF Core

        public Family(string name)
        {
            // Id is database generated or manually assigned in SQL

            Name = name;
            Token = GenerateToken();
            _guests = new List<Guest>();
        }

        public void AddGuest(string name)
        {
            _guests.Add(new Guest(name));
        }

        public void ConfirmAttendance()
        {
            ConfirmationDate = DateTime.UtcNow;
        }

        private string GenerateToken()
        {
            // Simple random string for token if needed in code
            var chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
            var stringChars = new char[8];
            var random = new Random();

            for (int i = 0; i < stringChars.Length; i++)
            {
                stringChars[i] = chars[random.Next(chars.Length)];
            }

            return new String(stringChars);
        }
    }
}
