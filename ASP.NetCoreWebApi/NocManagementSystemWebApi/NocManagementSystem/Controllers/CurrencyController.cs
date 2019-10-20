using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using NMS.Application.Shared.Interfaces;
using NMS.Core;

namespace NocManagementSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CurrencyController : ControllerBase
    {
        private readonly ICurrencyRepository _currencyRepository;
        public CurrencyController(ICurrencyRepository currencyRepository)
        {
            _currencyRepository = currencyRepository;
        }
        [HttpGet("GetCurrency")]
        public async Task<IEnumerable<CurrencyRate>> GetCurrency()
        {
            var currencies = await _currencyRepository.Get();
            return currencies;
        }
    }
}