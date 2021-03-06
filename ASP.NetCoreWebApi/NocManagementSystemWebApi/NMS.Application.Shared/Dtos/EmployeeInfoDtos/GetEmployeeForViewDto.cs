﻿using Abp.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace NMS.Application.Shared.Dtos.EmployeeInfoDtos
{
    public class GetEmployeeForViewDto : Entity<int>
    {
      //  public EmployeeInfoDto Employee { get; set; }
        public string EmpCode { get; set; }
        public string EmpName { get; set; }
        public string Designation { get; set; }
        public string Email { get; set; }
        public string ContactNo { get; set; }
        public int UserId { get; set; }
        public string  Username { get; set; }
        public string Password { get; set; }

    }
}
