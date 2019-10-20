using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using NMS.Application.Shared.Dtos.ImporterInfoDtos;
using NMS.Application.Shared.Dtos.ProformaDtos;
using NMS.Application.Shared.Interfaces;
using NMS.Core;

namespace NocManagementSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AnnualRequirementController : ControllerBase
    {
        private readonly IAnnualRequirementRepository _annualReqRepository;
        public AnnualRequirementController(IAnnualRequirementRepository annualReqRepository)
        {
            _annualReqRepository = annualReqRepository;
        }
        [HttpPost("SaveAnnualRequirementMst")]
        public async Task<ActionResult<AnnualRequirementMst>> SaveAnnualRequirementMst(AnnualRequirementMst annualRequirementMst)
        {
            try
            {
                var userId = User.FindFirst(ClaimTypes.NameIdentifier).Value;
                if (annualRequirementMst.ImporterId.ToString() != userId)
                    return BadRequest("Unauthorized access");
                var annualReqMst = await _annualReqRepository.SaveAnnualRequirementMst(annualRequirementMst);
                return annualReqMst;
            }
            catch(Exception ex)
            {
                throw ex;
            }
           
        }
        [HttpPost("SaveAnnualRequirementDtl")]
        public async Task<ActionResult<IEnumerable<AnnualRequirementDtl>>> 
            SaveAnnualRequirementDtl(IEnumerable<AnnualRequirementDtl> annualRequirementDtls)
        {
            var annReqDtls = await _annualReqRepository.SaveAnnualRequirementDtl(annualRequirementDtls);
            return annReqDtls.ToList();
        }
        [HttpPost("GetAnnualRequirementsByImporter")]
        public async Task<IEnumerable<AnnualRequirementMst>> GetAnnualRequirementsByImporter(ImporterForProformaDto importerForProformaDto)
        {
            var annualRequirements = await _annualReqRepository.GetAnnualRequirementsByImporter(importerForProformaDto.ImporterId);
            return annualRequirements;
        }
        [HttpPost("GetAnnReqProdDtlsByImp")]
        public async Task<IEnumerable<AnnReqProdDtlsForProforDto>> GetAnnReqProdDtlsByImp(ImporterForProformaDto importerForProformaDto)
        {
            var annProds = await _annualReqRepository.GetAnnReqProdDtlsByImp(importerForProformaDto.ImporterId);
            return annProds;
        }
    }
}