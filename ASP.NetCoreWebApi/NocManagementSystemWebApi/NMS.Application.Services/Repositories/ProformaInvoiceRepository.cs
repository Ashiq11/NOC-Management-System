using Microsoft.EntityFrameworkCore;
using NMS.Application.Shared.Dtos.ProformaDtos;
using NMS.Application.Shared.Interfaces;
using NMS.Core;
using NMS.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace NMS.Application.Services.Repositories
{
    public class ProformaInvoiceRepository : IProformaInvoiceRepository
    {
        private readonly NmsDataContext _nmsDataContext;
        public ProformaInvoiceRepository(NmsDataContext nmsDataContext)
        {
            _nmsDataContext = nmsDataContext;
        }
        public async Task<IEnumerable<ProformaInvoiceMst>> GetAllProformaInvoiceMstByUser(ImporterIdDto importerIdDto)
        {
            var proformaInvoicemsts = await _nmsDataContext.ProformaInvoiceMsts.Where(y => y.ImporterId == importerIdDto.ImporterId).OrderByDescending(x => x.ProformaDate).ToListAsync();
            return proformaInvoicemsts;
        }
        public async Task<PiTotalAmountValidationDto> GetCrntYearTotlProformaInvAmtByProd(ProfInvTotalAmtDtoByProdDto profInvTotalAmtDtoByProdDto)
        {
            int year = DateTime.Now.Year;
            DateTime firstDay = new DateTime(year, 1, 1);
            DateTime lastDay = new DateTime(year, 12, 31);
            var lastDate = lastDay.AddHours(23).AddMinutes(59).AddSeconds(59);
            var annReqsCrntYear = await (from mst in _nmsDataContext.ProformaInvoiceMsts
                                         join dtl in _nmsDataContext.ProformaInvoiceDtls on mst.Id equals dtl.MstId
                                         where (mst.ImporterId == profInvTotalAmtDtoByProdDto.ImporterId && dtl.ProdName == profInvTotalAmtDtoByProdDto.ProdName 
                                         && mst.SubmissionDate > firstDay && mst.SubmissionDate <= lastDate && dtl.ApprovalStatus != false)
                                         select new{
                                            dtl.Id,
                                            dtl.ProdName,
                                            dtl.TotalAmount
                                         }).ToListAsync();
            var totalProformaAmount = 0.0;
            foreach(var v in annReqsCrntYear)
            {
                totalProformaAmount += v.TotalAmount;
            }
            var annualreq = await (from mst in _nmsDataContext.AnnualRequirementMsts
                                    join dtl in _nmsDataContext.AnnualRequirementDtls on mst.Id equals dtl.AnnReqMstId
                                    where (mst.ImporterId == profInvTotalAmtDtoByProdDto.ImporterId && dtl.ProdName == profInvTotalAmtDtoByProdDto.ProdName
                                    && mst.SubmissionDate > firstDay && mst.SubmissionDate <= lastDate)
                                    select new
                                    {
                                        dtl.Id,
                                        dtl.ProdName,
                                        dtl.TotalAmount
                                    }).FirstOrDefaultAsync();
            var totalAnnualAmount = annualreq.TotalAmount;
            var remainingAmount = totalAnnualAmount - totalProformaAmount;
            var totalAmtValidityDto = new PiTotalAmountValidationDto
            {
                AnnualTotalAmount = totalAnnualAmount,
                ProformaTotalAmount = totalProformaAmount,
                RemainingAmount = remainingAmount,
                ValidationStatus = profInvTotalAmtDtoByProdDto.TotalAmount > remainingAmount ? false : true
            };
            return totalAmtValidityDto;
        }
        public async Task<IEnumerable<ProformaInvoiceDtl>> GetProformaDtlsByProformaMst(int poMstId)
        {
            try
            {
                var proformaInvoiceDtls = await _nmsDataContext.ProformaInvoiceDtls.Where(x => x.MstId == poMstId).OrderByDescending(a => a.ProdName).ToListAsync();
                return proformaInvoiceDtls;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
        public async Task<IEnumerable<ProformaInvoiceDtl>> SaveProformaInvoiceDtl(IEnumerable<ProformaInvoiceDtl> proformaInvoiceDtl)
        {
            if (proformaInvoiceDtl.Count() > 0)
            {
                foreach (var d in proformaInvoiceDtl)
                {
                    await _nmsDataContext.ProformaInvoiceDtls.AddAsync(d);
                    await _nmsDataContext.SaveChangesAsync();
                }
            }
            return proformaInvoiceDtl;
        }
        public async Task<ProformaInvoiceMst> SaveProformaInvoiceMst(ProformaInvoiceMst proformaInvoiceMst)
        {
            var today = DateTime.Now;
            var formattedDate = today.ToString("ddMMyyyy"); //+ today.Month.ToString() + today.Year.ToString();
            if (formattedDate.Length < 6)
            {
                formattedDate = "0" + formattedDate;
            }
            var totalProforma = await _nmsDataContext.ProformaInvoiceMsts.ToListAsync();
            proformaInvoiceMst.ApplicationNo = formattedDate + (totalProforma.Count() + 1).ToString();
            proformaInvoiceMst.ProformaInvoiceNo = (totalProforma.Count() + 1).ToString();
            proformaInvoiceMst.ProformaDate = DateTime.Now;
            proformaInvoiceMst.SubmissionDate = null;
            await _nmsDataContext.ProformaInvoiceMsts.AddAsync(proformaInvoiceMst);
            await _nmsDataContext.SaveChangesAsync();
            return proformaInvoiceMst;
        }
        public async Task<ProformaInvoiceMst> UpdatePiFilePath(int mstId, string[] Arr)
        {
            ProformaInvoiceMst targetedProforma = await _nmsDataContext.ProformaInvoiceMsts.FirstOrDefaultAsync(x => x.Id == mstId);
            targetedProforma.PiScan = Arr[0] == null ? null : Arr[0].Replace("\\", "/");
            if (mstId > 0 && targetedProforma != null)
            {
                _nmsDataContext.ProformaInvoiceMsts.Attach(targetedProforma);
                await _nmsDataContext.SaveChangesAsync();
            }
            return targetedProforma;
        }
        public async Task<ProformaInvoiceMst> UpdateLitFilePath(int mstId, string[] Arr)
        {
            ProformaInvoiceMst targetedProforma = await _nmsDataContext.ProformaInvoiceMsts.FirstOrDefaultAsync(x => x.Id == mstId);
            targetedProforma.LitScan = Arr[0] == null ? null : Arr[0].Replace("\\", "/");
            if (mstId > 0 && targetedProforma != null)
            {
                _nmsDataContext.ProformaInvoiceMsts.Attach(targetedProforma);
                await _nmsDataContext.SaveChangesAsync();
            }
            return targetedProforma;
        }
        public async Task<ProformaInvoiceMst> UpdateTestFilePath(int mstId, string[] Arr)
        {
            ProformaInvoiceMst targetedProforma = await _nmsDataContext.ProformaInvoiceMsts.FirstOrDefaultAsync(x => x.Id == mstId);
            targetedProforma.TestReport = Arr[0] == null ? null : Arr[0].Replace("\\", "/");
            if (mstId > 0 && targetedProforma != null)
            {
                _nmsDataContext.ProformaInvoiceMsts.Attach(targetedProforma);
                await _nmsDataContext.SaveChangesAsync();
            }
            return targetedProforma;
        }
        public async Task<ProformaInvoiceMst> UpdateOtherFilePath(int mstId, string[] Arr)
        {
            ProformaInvoiceMst targetedProforma = await _nmsDataContext.ProformaInvoiceMsts.FirstOrDefaultAsync(x => x.Id == mstId);
            targetedProforma.OtherDoc = Arr[0] == null ? null : Arr[0].Replace("\\", "/");
            if (mstId > 0 && targetedProforma != null)
            {
                _nmsDataContext.ProformaInvoiceMsts.Attach(targetedProforma);
                await _nmsDataContext.SaveChangesAsync();
            }
            return targetedProforma;
        }
        public async Task<ProformaInvoiceMst> UpdateProformaFilePath(int id, string[] Arr)
        {
            ProformaInvoiceMst targetedProforma = await _nmsDataContext.ProformaInvoiceMsts.FirstOrDefaultAsync(i => i.Id == id);

            targetedProforma.PiScan = Arr[0] == null ? null : Arr[0].Replace("\\", "/");
            targetedProforma.LitScan = Arr[1] == null ? null : Arr[1].Replace("\\", "/");
            targetedProforma.TestReport = Arr[2] == null ? null : Arr[2].Replace("\\", "/");
            targetedProforma.OtherDoc = Arr[3] == null ? null : Arr[3].Replace("\\", "/");
            if (id > 0 && targetedProforma != null)
            {
                _nmsDataContext.ProformaInvoiceMsts.Attach(targetedProforma);
                await _nmsDataContext.SaveChangesAsync();
            }
            return targetedProforma;
        }
        public async Task<ProformaInvoiceMst> UpdateProformaInvoiceMst(ProformaInvoiceMstUpdateDto proformaInvoiceMstUpdateDto)
        {
            var proMst = await _nmsDataContext.ProformaInvoiceMsts.FirstOrDefaultAsync(x => x.Id == proformaInvoiceMstUpdateDto.Id);
            proMst.Currency = proformaInvoiceMstUpdateDto.Currency;
            proMst.CountryOfOrigin = proformaInvoiceMstUpdateDto.CountryOfOrigin;
            proMst.PortOfLoading = proformaInvoiceMstUpdateDto.PortOfLoading;
            proMst.PortOfEntry = proformaInvoiceMstUpdateDto.PortOfEntry;
            _nmsDataContext.ProformaInvoiceMsts.Attach(proMst);
            await _nmsDataContext.SaveChangesAsync();
            return proMst;
        }
        public async Task<bool> ValidateUpdateProMstClaim(int proMstId, int userId)
        {
            var proInvMst = await _nmsDataContext.ProformaInvoiceMsts.FirstOrDefaultAsync(x => x.Id == proMstId);
            if (proInvMst.ImporterId == userId)
                return true;
            return false;
        }
        public async Task<IEnumerable<ProformaInvoiceDtl>> UpdateProformaInvoiceDtl(IEnumerable<ProformaInvoiceDtl> proformaInvoiceDtls, int mstId)
        {
            var targetedProMstDtls = await _nmsDataContext.ProformaInvoiceDtls.Where(x => x.MstId == mstId).ToListAsync();
            foreach(var v in targetedProMstDtls)
            {
                 _nmsDataContext.Remove(v);
                await _nmsDataContext.SaveChangesAsync();
            }

            if(proformaInvoiceDtls.Count() > 0)
            {
                foreach(var v in proformaInvoiceDtls)
                {
                    await _nmsDataContext.ProformaInvoiceDtls.AddAsync(v);
                    await _nmsDataContext.SaveChangesAsync();
                }
            }
            var proDtls = await GetProformaDtlsByProformaMst(mstId);
            return proDtls;
        }
        public async Task<SubmissionResult> IsProformaSubmitted(int mstId)
        {
            SubmissionResult submissionResult = new SubmissionResult();
            var proMst = await _nmsDataContext.ProformaInvoiceMsts.FirstOrDefaultAsync(x => x.Id == mstId);
            if (proMst.Confirmation == true && proMst.SubmissionDate != null)
            {
                submissionResult.IsSubmitted = true;
            }
            else
            {
                submissionResult.IsSubmitted = false;
            }
            return submissionResult;
        }

        public async Task<ProformaInvoiceMst> SubmitProformaInvoice(int userId, int proMstId)
        {
            var proMst = await _nmsDataContext.ProformaInvoiceMsts.FirstOrDefaultAsync(x => x.Id == proMstId && x.ImporterId == userId);
            proMst.Confirmation = true;
            proMst.SubmissionDate = DateTime.Now;
            _nmsDataContext.Attach(proMst);
            await _nmsDataContext.SaveChangesAsync();
            return proMst;
        }
    }
}
