using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using NMS.Core;
using NMS.Application.Shared.Dtos.ProformaDtos;

namespace NMS.Application.Shared.Interfaces
{
    public interface IAnnualRequirementRepository
    {
        Task<AnnualRequirementMst> SaveAnnualRequirementMst(AnnualRequirementMst requirementMst);
        Task<IEnumerable<AnnualRequirementDtl>> SaveAnnualRequirementDtl(IEnumerable<AnnualRequirementDtl> requirementDtls);
        Task<IEnumerable<AnnualRequirementMst>> GetAnnualRequirementsByImporter(int importerId);
        Task<IEnumerable<AnnReqProdDtlsForProforDto>> GetAnnReqProdDtlsByImp(int importerId);
    }
}
