using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace NMS.Application.Shared.Dtos.ProformaDtos
{
    public class ProfInvTotalAmtDtoByProdDto
    {
        public int ImporterId { get; set; }
        public string ProdName { get; set; }
        public float TotalAmount { get; set; }
    }
}