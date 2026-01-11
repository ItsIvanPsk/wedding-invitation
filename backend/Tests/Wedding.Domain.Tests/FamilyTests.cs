using FluentAssertions;
using Wedding.Domain.Entities;
using Xunit;

namespace Wedding.Domain.Tests
{
    public class FamilyTests
    {
        [Fact]
        public void Family_ShouldBeCreated_WithValidNameAndToken()
        {
            // Arrange & Act
            var family = new Family("Familia Test");

            // Assert
            family.Id.Should().Be(0); // Default int value
            family.Name.Should().Be("Familia Test");
            family.Token.Should().NotBeNullOrEmpty();
            family.Token.Length.Should().Be(8);
            family.Guests.Should().BeEmpty();
            family.ConfirmationDate.Should().BeNull();
        }

        [Fact]
        public void AddGuest_ShouldAddGuestToFamily()
        {
            // Arrange
            var family = new Family("Familia Test");

            // Act
            family.AddGuest("Ivan");

            // Assert
            family.Guests.Should().HaveCount(1);
            family.Guests.First().Name.Should().Be("Ivan");
            // family.Guests.First().FamilyId.Should().Be(family.Id); // FamilyId is set by EF or after save
        }

        [Fact]
        public void ConfirmAttendance_ShouldSetConfirmationDate()
        {
            // Arrange
            var family = new Family("Familia Test");

            // Act
            family.ConfirmAttendance();

            // Assert
            family.ConfirmationDate.Should().NotBeNull();
            family.ConfirmationDate.Should().BeCloseTo(DateTime.UtcNow, TimeSpan.FromSeconds(1));
        }

        [Fact]
        public void Guest_UpdateConfirmation_ShouldUpdateFields()
        {
            // Arrange
            var guest = new Guest("Nerea");

            // Act
            guest.UpdateConfirmation(true, "Gluten", "No observations", "Muy majos");

            // Assert
            guest.IsAttending.Should().BeTrue();
            guest.Intolerances.Should().Be("Gluten");
            guest.Observations.Should().Be("No observations");
            guest.FunnyComment.Should().Be("Muy majos");
        }
    }
}
