using Abp.Application.Services.Dto;
using NMS.Application.Shared.Dtos.EmployeeInfoDtos;
using NMS.Application.Shared.Dtos.ImporterInfoDtos;
using NMS.Application.Shared.Services.Exporting;
using System.Threading.Tasks;

namespace NMS.Application.Shared.Interfaces
{
    public interface IImporterInfoRepository
    {
        Task<PagedResultDto<GetImporterForViewDto>> GetAllImporterInfos(GetAllInputFilter input);
        Task<FileDto> GetImportersToExcel();
        Task<PagedResultDto<GetImporterForViewDto>>GetAllImporterInfosPdf();
    }
}
