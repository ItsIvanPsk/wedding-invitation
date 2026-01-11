using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Threading.Tasks;
using Wedding.Domain.Entities;
using Wedding.Domain.Repositories;

namespace Wedding.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class IntolerancesController : ControllerBase
    {
        private readonly IIntoleranceRepository _repository;

        public IntolerancesController(IIntoleranceRepository repository)
        {
            _repository = repository;
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var intolerances = await _repository.GetAllAsync();
            return Ok(intolerances);
        }
    }
}
