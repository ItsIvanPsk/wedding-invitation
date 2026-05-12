using Microsoft.AspNetCore.Mvc;
using Wedding.Application.DTOs;
using Wedding.Application.Services;

namespace Wedding.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class FamiliesController : ControllerBase
    {
        private readonly IFamilyService _service;

        public FamiliesController(IFamilyService service)
        {
            _service = service;
        }

        [HttpGet("{token}")]
        public async Task<IActionResult> GetByToken(string token)
        {
            var family = await _service.GetFamilyByTokenAsync(token);
            if (family == null) return NotFound("Family not found or invalid token.");
            return Ok(family);
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var families = await _service.GetAllFamiliesAsync();
            return Ok(families);
        }

        [HttpPost("{token}/confirm")]
        public async Task<IActionResult> Confirm(string token, [FromBody] ConfirmationRequest request)
        {
            var result = await _service.ConfirmAttendanceAsync(token, request);
            if (!result) return BadRequest("Could not confirm attendance.");
            return Ok("Attendance confirmed.");
        }

        [HttpPatch("guests/{guestId}")]
        public async Task<IActionResult> UpdateGuest(int guestId, [FromBody] GuestDto guestDto)
        {
            var result = await _service.UpdateGuestAsync(guestId, guestDto);
            if (!result) return NotFound("Guest not found.");
            return Ok("Guest updated.");
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] CreateFamilyRequest request)
        {
            var family = await _service.CreateFamilyAsync(request.Name, request.GuestNames);
            return CreatedAtAction(nameof(GetByToken), new { token = family.Token }, family);
        }
    }

    public class CreateFamilyRequest
    {
        public string Name { get; set; } = string.Empty;
        public List<string> GuestNames { get; set; } = new();
    }
}
