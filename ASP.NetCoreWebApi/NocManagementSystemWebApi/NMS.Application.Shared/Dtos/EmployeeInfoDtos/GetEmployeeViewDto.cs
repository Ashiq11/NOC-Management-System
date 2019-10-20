using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace NMS.Application.Shared.Dtos.EmployeeInfoDtos
{
    public class GetEmployeeViewDto
    {
        public EmployeeInfoDto Employee { get; set; }
        public string Username { get; set; }
        public string Password { get; set; }
    }
}
