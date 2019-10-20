using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.EntityFrameworkCore;
using NMS.Core;

namespace NMS.EntityFrameworkCore
{
    public class NmsDataContext : DbContext
    {
        public NmsDataContext(DbContextOptions<NmsDataContext> options) : base(options) { }
        public DbSet<ImporterInfo> ImporterInfos { get; set; }
        public DbSet<UserLogin> UserLogins { get; set; }
        public DbSet<RoleInfo> RoleInfos { get; set; }
        public DbSet<UserRoleConf> UserRoleConfs { get; set; }
        public DbSet<EmployeeInfo> EmployeeInfos { get; set; }
        public DbSet<CurrencyRate> CurrencyRates { get; set; }
        public DbSet<AnnualRequirementMst> AnnualRequirementMsts { get; set; }
        public DbSet<AnnualRequirementDtl> AnnualRequirementDtls { get; set; }
        public DbSet<ProformaInvoiceMst> ProformaInvoiceMsts { get; set; }
        public DbSet<ProformaInvoiceDtl> ProformaInvoiceDtls { get; set; }

    }
}
