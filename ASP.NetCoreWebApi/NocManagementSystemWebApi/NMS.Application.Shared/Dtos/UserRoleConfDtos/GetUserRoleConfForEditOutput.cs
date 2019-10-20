using Abp.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace NMS.Application.Shared.Dtos.UserRoleConfDtos
{
    public class GetUserRoleConfForEditOutput : Entity<int>
    {
        public string UserName { get; set; }
        public string RoleName { get; set; }
        public int UserId { get; set; }
        public int RoleId { get; set; }

    }
}
