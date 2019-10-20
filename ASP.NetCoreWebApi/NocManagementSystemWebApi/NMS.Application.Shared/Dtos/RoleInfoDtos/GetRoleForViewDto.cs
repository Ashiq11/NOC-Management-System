using Abp.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace NMS.Application.Shared.Dtos.RoleInfoDtos
{
    public class GetRoleForViewDto : Entity<int>
    {
        public string Name { get; set; }
    }
}
