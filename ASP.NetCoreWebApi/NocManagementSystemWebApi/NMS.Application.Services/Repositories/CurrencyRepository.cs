using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using NMS.Application.Shared.Interfaces;
using NMS.Core;
using NMS.EntityFrameworkCore;

namespace NMS.Application.Services.Repositories
{
    public class CurrencyRepository:ICurrencyRepository
    {
        private readonly NmsDataContext _context;
        public CurrencyRepository(NmsDataContext context)
        {
            _context = context;
        }

        public async Task<IEnumerable<CurrencyRate>> Get()
        {
            var currencies = await _context.CurrencyRates.ToListAsync();
            return currencies;
        }
    }
}
