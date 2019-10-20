using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace NMS.Application.Shared.Dtos.ProformaDtos
{
    public class ProformaInvoiceMstUpdateDto
    {
        public int Id { get; set; }
        public string Currency { get; set; }
        public string CountryOfOrigin { get; set; }
        public string PortOfLoading { get; set; }
        public string PortOfEntry { get; set; }
    }
}