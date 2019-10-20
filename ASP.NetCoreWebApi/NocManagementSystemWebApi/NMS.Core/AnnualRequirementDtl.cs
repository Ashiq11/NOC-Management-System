using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace NMS.Core
{
    public class AnnualRequirementDtl
    {
        public int Id { get; set; }
        public int AnnReqMstId { get; set; }
        public string ProdName { get; set; }
        public string ProdType { get; set; }
        public string HsCode { get; set; }
        public string Manufacturer { get; set; }
        public string CountryOfOrigin { get; set; }
        public string PackSize { get; set; }
        public string Currency { get; set; }
        public double TotalAmount { get; set; }
        public int TentativeUnits { get; set; }
        public double Unitprice { get; set; }
        public double TotalPrice { get; set; }
        public double TotalPriceInBdt { get; set; }
    }
}
