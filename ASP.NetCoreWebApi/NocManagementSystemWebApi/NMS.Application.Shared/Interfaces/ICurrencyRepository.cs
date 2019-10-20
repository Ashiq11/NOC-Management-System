using NMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace NMS.Application.Shared.Interfaces
{
    public interface ICurrencyRepository
    {
        Task<IEnumerable<CurrencyRate>> Get();
    }
}
