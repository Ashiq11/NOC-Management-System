﻿using Abp.Domain.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Threading.Tasks;

namespace NMS.Core
{
    public class RoleInfo : Entity<int>
    {
        [Required]
        public string Name { get; set; }
    }
}
