using Abp.Domain.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace NMS.Core
{
    public class UserRoleConf : Entity<int>
    {
        public int UserId { get; set; }
        public int RoleId { get; set; }
    }
}
