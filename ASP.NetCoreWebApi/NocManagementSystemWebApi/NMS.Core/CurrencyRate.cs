using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace NMS.Core
{
    public class CurrencyRate
    {
        public int Id { get; set; }
        public string Currency { get; set; }
        public double ExchangeRate { get; set; }
    }
}
