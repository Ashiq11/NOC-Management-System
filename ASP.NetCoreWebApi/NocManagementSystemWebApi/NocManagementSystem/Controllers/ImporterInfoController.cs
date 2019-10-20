using System.IO;
using System.Threading.Tasks;
using Abp.Application.Services.Dto;
using Microsoft.AspNetCore.Mvc;
using NMS.Application.Shared.Dtos.EmployeeInfoDtos;
using NMS.Application.Shared.Dtos.ImporterInfoDtos;
using NMS.Application.Shared.Interfaces;
using NMS.Application.Shared.Services.Exporting;

namespace NocManagementSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ImporterInfoController : ControllerBase
    {
        private readonly IImporterInfoRepository _importerInfoRepository;

        public ImporterInfoController(IImporterInfoRepository importerInfoRepository)
        {
            _importerInfoRepository = importerInfoRepository;
        }

        // GET: api/GetAllImporterInfos
        [HttpPost("GetAllImporterInfos")]
        public async Task<PagedResultDto<GetImporterForViewDto>> GetAllImporterInfos(GetAllInputFilter input)
        {

            var result = await _importerInfoRepository.GetAllImporterInfos(input);
            return result;

        }
        [HttpGet("GetAllImporterInfosPdf")]
        public async Task<PagedResultDto<GetImporterForViewDto>> GetAllImporterInfosPdf()
        {

            var result = await _importerInfoRepository.GetAllImporterInfosPdf();
            return result;

        }

        [HttpGet("GetImportersToExcel")]
        public async Task<FileDto> GetImportersToExcel()
        {
            var result = await _importerInfoRepository.GetImportersToExcel();
            return result;
        }
        [HttpGet("DownloadFile/{fileName}")]
        //async Task<FileStream>
        public FileStream DownloadPiFile(string fileName)
        {
            var currentDirectory = Directory.GetCurrentDirectory();
            currentDirectory = currentDirectory + "\\Resources\\ImporterInfoDoc";
            var file = Path.Combine(Path.Combine(currentDirectory), fileName);
            return new FileStream(file, FileMode.Open, FileAccess.Read);
        }
    }
}