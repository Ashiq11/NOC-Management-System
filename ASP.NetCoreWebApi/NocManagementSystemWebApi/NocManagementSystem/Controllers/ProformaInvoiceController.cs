﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using NMS.Application.Shared.Dtos.ProformaDtos;
using NMS.Application.Shared.Interfaces;
using NMS.Core;

namespace NocManagementSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ProformaInvoiceController : ControllerBase
    {
        private readonly IProformaInvoiceRepository _proformaInvoiceRepository;
        public ProformaInvoiceController(IProformaInvoiceRepository proformaInvoiceRepository)
        {
            _proformaInvoiceRepository = proformaInvoiceRepository;
        }
        [HttpPost("GetCrntYearTotlProformaInvAmtByProd")]
        public async Task<PiTotalAmountValidationDto> GetCrntYearTotlProformaInvAmtByProd(ProfInvTotalAmtDtoByProdDto profInvTotalAmtDtoByProdDto)
        {
            var totalAmtValidityDto = await _proformaInvoiceRepository.GetCrntYearTotlProformaInvAmtByProd(profInvTotalAmtDtoByProdDto);
            return totalAmtValidityDto;
        }
        [HttpPost("SaveProformaInvoiceMst")]
        public async Task<ActionResult<ProformaInvoiceMst>> SaveProformaInvoiceMst(ProformaInvoiceMst proformaInvoiceMst)
        {
            ProformaInvoiceMst proformaMst = null;
            if (proformaInvoiceMst != null)
            {
                proformaMst = await _proformaInvoiceRepository.SaveProformaInvoiceMst(proformaInvoiceMst);
            }
            return proformaMst;
        }
        [HttpPost("UpdateProformaInvoiceMst")]
        public async Task<ActionResult<ProformaInvoiceMst>> UpdateProformaInvoiceMst(ProformaInvoiceMstUpdateDto proformaInvoiceMstUpdateDto)
        {
            if (proformaInvoiceMstUpdateDto.Id < 1)
                return BadRequest();
            var userId = Convert.ToInt32(User.FindFirst(ClaimTypes.NameIdentifier).Value);
            var res = await _proformaInvoiceRepository.ValidateUpdateProMstClaim(proformaInvoiceMstUpdateDto.Id, userId);
            if (res == false)
                return BadRequest();
            var result = await _proformaInvoiceRepository.IsProformaSubmitted(proformaInvoiceMstUpdateDto.Id);
            if (result.IsSubmitted == true)
                return BadRequest();
            var proMst = await _proformaInvoiceRepository.UpdateProformaInvoiceMst(proformaInvoiceMstUpdateDto);
            return proMst;
        }

        [HttpPost("SaveProformaInvoiceDtl")]
        public async Task<ActionResult<IEnumerable<ProformaInvoiceDtl>>> SaveProformaInvoiceDtl(IEnumerable<ProformaInvoiceDtl> proformaInvoiceDtl)
        {
            IEnumerable<ProformaInvoiceDtl> proformaDtl = null;
            if (proformaInvoiceDtl != null)
            {
                proformaDtl = await _proformaInvoiceRepository.SaveProformaInvoiceDtl(proformaInvoiceDtl);
            }
            return proformaDtl.ToList();
        }
        [HttpPost]
        [Route("UpdateProformaInvoiceDtl/{mstId}")]
        public async Task<ActionResult<IEnumerable<ProformaInvoiceDtl>>> UpdateProformaInvoiceDtl([FromBody] IEnumerable<ProformaInvoiceDtl> proformaInvoiceDtls, int mstId)
        {
            if (proformaInvoiceDtls == null)
                return BadRequest();
            var userId = Convert.ToInt32(User.FindFirst(ClaimTypes.NameIdentifier).Value);
            var res = await _proformaInvoiceRepository.ValidateUpdateProMstClaim(mstId, userId);
            if (res == false)
                return BadRequest();
            var proDtls = await _proformaInvoiceRepository.UpdateProformaInvoiceDtl(proformaInvoiceDtls, mstId);
            return proDtls.ToList();
        }
        [HttpPost]
        [Route("UploadProformaFiles/{id}")]
        public async Task<ActionResult<ProformaInvoiceMst>> UploadProformaFiles(int id)
        {
            try
            {
                var userId = User.FindFirst(ClaimTypes.NameIdentifier).Value;
                string[] proformaFilePathArr = new string[4];
                for (int i = 0; i < Request.Form.Files.Count; i++)
                {
                    var v = Request.Form;
                    var file = Request.Form.Files[i];
                    var folderName = Path.Combine("Resources", "ProformaDoc");
                    var pathToSave = Path.Combine(Directory.GetCurrentDirectory(), folderName);
                    if (file.Length > 0)
                    {
                        var guid = Guid.NewGuid();
                        var fileName = guid + ".pdf";
                        var fullPath = Path.Combine(folderName, fileName);
                        var dbPath = fileName;
                        proformaFilePathArr[i] = dbPath;
                        using (var stream = new FileStream(fullPath, FileMode.Create))
                        {
                            file.CopyTo(stream);
                        }
                    }
                }
                ProformaInvoiceMst updatedProforma = await _proformaInvoiceRepository.UpdateProformaFilePath(id, proformaFilePathArr);
                return updatedProforma;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        [HttpPost]
        [Route("UpdatePiFile/{mstId}")]
        public async Task<ActionResult<ProformaInvoiceMst>> UpdatePiFile(int mstId)
        {
            try
            {
                string[] piFilePathArr = new string[1];
                if (Request.Form.Files.Count > 0)
                {
                    var v = Request.Form;
                    var file = Request.Form.Files[0];
                    var folderName = Path.Combine("Resources", "ProformaDoc");
                    var pathToSave = Path.Combine(Directory.GetCurrentDirectory(), folderName);
                    if (file.Length > 0)
                    {
                        var gid = Guid.NewGuid();
                        var fileName = gid + ".pdf";
                        var fullPath = Path.Combine(folderName, fileName);
                        var dbPath =  fileName;
                        piFilePathArr[0] = dbPath;
                        using (var stream = new FileStream(fullPath, FileMode.Create))
                        {
                            file.CopyTo(stream);
                        }
                    }
                }
                ProformaInvoiceMst updatedProforma = await _proformaInvoiceRepository.UpdatePiFilePath(mstId, piFilePathArr);
                return updatedProforma;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        [HttpPost]
        [Route("UpdateLitFile/{mstId}")]
        public async Task<ActionResult<ProformaInvoiceMst>> UpdateLitFile(int mstId)
        {
            try
            {
                string[] litFilePathArr = new string[1];
                if (Request.Form.Files.Count > 0)
                {
                    var v = Request.Form;
                    var file = Request.Form.Files[0];
                    var folderName = Path.Combine("Resources", "ProformaDoc");
                    var pathToSave = Path.Combine(Directory.GetCurrentDirectory(), folderName);
                    if (file.Length > 0)
                    {
                        var gid = Guid.NewGuid();
                        var fileName = gid + ".pdf";
                        var fullPath = Path.Combine(folderName, fileName);
                        var dbPath = fileName;
                        litFilePathArr[0] = dbPath;
                        using (var stream = new FileStream(fullPath, FileMode.Create))
                        {
                            file.CopyTo(stream);
                        }
                    }
                }
                ProformaInvoiceMst updatedProforma = await _proformaInvoiceRepository.UpdateLitFilePath(mstId, litFilePathArr);
                return updatedProforma;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        [HttpPost]
        [Route("UpdateTestFile/{mstId}")]
        public async Task<ActionResult<ProformaInvoiceMst>> UpdateTestFile(int mstId)
        {
            try
            {
                string[] testFilePathArr = new string[1];
                if (Request.Form.Files.Count > 0)
                {
                    var v = Request.Form;
                    var file = Request.Form.Files[0];
                    var folderName = Path.Combine("Resources", "ProformaDoc");
                    var pathToSave = Path.Combine(Directory.GetCurrentDirectory(), folderName);
                    if (file.Length > 0)
                    {
                        var gid = Guid.NewGuid();
                        var fileName = gid + ".pdf";
                        var fullPath = Path.Combine(folderName, fileName);
                        var dbPath = fileName;
                        testFilePathArr[0] = dbPath;
                        using (var stream = new FileStream(fullPath, FileMode.Create))
                        {
                            file.CopyTo(stream);
                        }
                    }
                }
                ProformaInvoiceMst updatedProforma = await _proformaInvoiceRepository.UpdateTestFilePath(mstId, testFilePathArr);
                return updatedProforma;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        [HttpPost]
        [Route("UpdateOtherFile/{mstId}")]
        public async Task<ActionResult<ProformaInvoiceMst>> UpdateOtherFile(int mstId)
        {
            try
            {
                string[] otherFilePathArr = new string[1];
                if (Request.Form.Files.Count > 0)
                {
                    var v = Request.Form;
                    var file = Request.Form.Files[0];
                    var folderName = Path.Combine("Resources", "ProformaDoc");
                    var pathToSave = Path.Combine(Directory.GetCurrentDirectory(), folderName);
                    if (file.Length > 0)
                    {
                        var gid = Guid.NewGuid();
                        var fileName = gid + ".pdf";
                        var fullPath = Path.Combine(folderName, fileName);
                       // var dbPath = Path.Combine(folderName, fileName);
                        var dbPath = fileName;
                        otherFilePathArr[0] = dbPath;
                        using (var stream = new FileStream(fullPath, FileMode.Create))
                        {
                            file.CopyTo(stream);
                        }
                    }
                }
                ProformaInvoiceMst updatedProforma = await _proformaInvoiceRepository.UpdateOtherFilePath(mstId, otherFilePathArr);
                return updatedProforma;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        [HttpPost("GetAllProformaInvoiceMstByUser")]
        public async Task<IEnumerable<ProformaInvoiceMst>> GetAllProformaInvoiceMstByUser(ImporterIdDto importerIdDto)
        {
            var proformaInvoiceMsts = await _proformaInvoiceRepository.GetAllProformaInvoiceMstByUser(importerIdDto);
            return proformaInvoiceMsts;
        }
        [HttpPost("GetProformaDtlsByProformaMst")]
        public async Task<IEnumerable<ProformaInvoiceDtl>> GetProformaDtlsByProformaMst(ProformaIdDto poMstId)
        {
            var proformaInvoiceDtls = await _proformaInvoiceRepository.GetProformaDtlsByProformaMst(poMstId.ProformaMstId);
            return proformaInvoiceDtls;
        }
        [HttpGet("DownloadPiFile/{fileName}")]
        //async Task<FileStream>
        public FileStream DownloadPiFile(string fileName)
        {
            var currentDirectory = Directory.GetCurrentDirectory();
            currentDirectory = currentDirectory + "\\Resources\\ProformaDoc";
            var file = Path.Combine(Path.Combine(currentDirectory), fileName);
            return  new FileStream(file, FileMode.Open, FileAccess.Read);
        }
        [HttpPost("IsProformaSubmitted")]
        public async Task<SubmissionResult> IsProformaSubmitted(ProformaIdDto proformaIdDto)
        {
            var res = await _proformaInvoiceRepository.IsProformaSubmitted(proformaIdDto.ProformaMstId);
            return res;
        }
        [HttpPost("SubmitProformaInvoice")]
        public async Task<ProformaInvoiceMst> SubmitProformaInvoice(ProformaIdDto proformaIdDto)
        {
            var userId = Convert.ToInt32(User.FindFirst(ClaimTypes.NameIdentifier).Value);
            var proMst = await _proformaInvoiceRepository.SubmitProformaInvoice(userId, proformaIdDto.ProformaMstId);
            return proMst;
        }
    }
}