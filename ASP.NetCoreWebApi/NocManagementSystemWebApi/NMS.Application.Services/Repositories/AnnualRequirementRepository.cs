using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using NMS.Application.Shared.Dtos.ProformaDtos;
using NMS.Application.Shared.Interfaces;
using NMS.Core;
using NMS.EntityFrameworkCore;

namespace NMS.Application.Services.Repositories
{
    public class AnnualRequirementRepository : IAnnualRequirementRepository
    {
        private readonly NmsDataContext _nmsDataContext;
        public AnnualRequirementRepository(NmsDataContext nmsDataContext)
        {
            _nmsDataContext = nmsDataContext;
        }

        public async Task<IEnumerable<AnnReqProdDtlsForProforDto>> GetAnnReqProdDtlsByImp(int importerId)
        {
            var prodDtls = await (from d in _nmsDataContext.AnnualRequirementDtls
                                  join m in _nmsDataContext.AnnualRequirementMsts on d.AnnReqMstId equals m.Id
                                  where (m.ImporterId == importerId)
                                  select new AnnReqProdDtlsForProforDto {
                                      ProductId = d.Id,
                                      ProdName = d.ProdName,
                                      ProdType = d.ProdType,
                                      HsCode = d.HsCode,
                                      Manufacturer = d.Manufacturer,
                                      PackSize = d.PackSize
                                  }).ToListAsync();
            return prodDtls;
        }

        public async Task<IEnumerable<AnnualRequirementMst>> GetAnnualRequirementsByImporter(int importerId)
        {
            var annualRequirements = await _nmsDataContext.AnnualRequirementMsts
                .Include(x => x.AnnualRequirementDtls)
                .Where(i => i.ImporterId == importerId).ToListAsync();
            return annualRequirements;
        }

        public async Task<IEnumerable<AnnualRequirementDtl>> SaveAnnualRequirementDtl(IEnumerable<AnnualRequirementDtl> requirementDtls)
        {
            try
            {
                if (requirementDtls.Count() > 0)
                {
                    foreach (var d in requirementDtls)
                    {
                        await _nmsDataContext.AnnualRequirementDtls.AddAsync(d);
                        await _nmsDataContext.SaveChangesAsync();
                    }
                }
                return requirementDtls;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public async Task<AnnualRequirementMst> SaveAnnualRequirementMst(AnnualRequirementMst requirementMst)
        {
            try
            {
                requirementMst.SubmissionDate = DateTime.Now;
                await _nmsDataContext.AnnualRequirementMsts.AddAsync(requirementMst);
                await _nmsDataContext.SaveChangesAsync();
                return requirementMst;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
    }
}
