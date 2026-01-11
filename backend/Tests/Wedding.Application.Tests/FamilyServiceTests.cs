using AutoMapper;
using FluentAssertions;
using Moq;
using Wedding.Application.DTOs;
using Wedding.Application.Mappings;
using Wedding.Application.Services;
using Wedding.Domain.Entities;
using Wedding.Domain.Repositories;
using Xunit;

namespace Wedding.Application.Tests
{
    public class FamilyServiceTests
    {
        private readonly Mock<IFamilyRepository> _mockRepo;
        private readonly FamilyService _service;
        private readonly IMapper _mapper;

        public FamilyServiceTests()
        {
            _mockRepo = new Mock<IFamilyRepository>();
            
            var config = new MapperConfiguration(cfg => cfg.AddProfile<MappingProfile>());
            _mapper = config.CreateMapper();

            _service = new FamilyService(_mockRepo.Object, _mapper);
        }

        [Fact]
        public async Task CreateFamilyAsync_ShouldCreateFamily_AndReturnDto()
        {
            // Arrange
            string name = "Familia Test";
            var guests = new List<string> { "Guest 1", "Guest 2" };

            // Act
            var result = await _service.CreateFamilyAsync(name, guests);

            // Assert
            result.Should().NotBeNull();
            result.Name.Should().Be(name);
            result.Guests.Should().HaveCount(2);

            _mockRepo.Verify(r => r.AddAsync(It.Is<Family>(f => f.Name == name && f.Guests.Count == 2)), Times.Once);
            _mockRepo.Verify(r => r.SaveChangesAsync(), Times.Once);
        }

        [Fact]
        public async Task GetFamilyByTokenAsync_ShouldReturnFamily_WhenTokenExists()
        {
            // Arrange
            var family = new Family("Familia Test");
            _mockRepo.Setup(r => r.GetByTokenAsync(family.Token)).ReturnsAsync(family);

            // Act
            var result = await _service.GetFamilyByTokenAsync(family.Token);

            // Assert
            result.Should().NotBeNull();
            result!.Token.Should().Be(family.Token);
        }

        [Fact]
        public async Task ConfirmAttendanceAsync_ShouldVerifyAttendance_AndSave()
        {
            // Arrange
            var family = new Family("Familia Test");
            family.AddGuest("Guest 1");
            var guestId = family.Guests.First().Id;

            _mockRepo.Setup(r => r.GetByTokenAsync(family.Token)).ReturnsAsync(family);

            var request = new ConfirmationRequest
            {
                Guests = new List<GuestConfirmationDto>
                {
                    new GuestConfirmationDto
                    {
                        GuestId = guestId,
                        IsAttending = true,
                        FunnyComment = "Jaja"
                    }
                }
            };

            // Act
            var result = await _service.ConfirmAttendanceAsync(family.Token, request);

            // Assert
            result.Should().BeTrue();
            family.ConfirmationDate.Should().NotBeNull();
            family.Guests.First().IsAttending.Should().BeTrue();
            family.Guests.First().FunnyComment.Should().Be("Jaja");

            _mockRepo.Verify(r => r.SaveChangesAsync(), Times.Once);
        }
    }
}
