using Abp.Application.Services.Dto;
using NMS.Application.Shared.Dtos.EmployeeInfoDtos;
using NMS.Application.Shared.Dtos.RoleInfoDtos;
using NMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace NMS.Application.Shared.Interfaces
{
    public interface IRoleInfoRepository
    {
        Task<PagedResultDto<GetRoleForViewDto>> GetAllRoleInfos(GetAllInputFilter input);
        //Task<PagedResultDto<GetRoleForViewDto>> GetAll();
        Task<GetRoleForViewDto> GetRoleInfo(int id);
        Task<GetRoleForViewDto> EditRoleInfo(int id, GetRoleForEditOutput editOutput);
        Task<RoleInfo> CreateRoleInfo(CreateRoleDto createRoleDto);
        Task<RoleInfo> DeleteRoleInfo(int id);
        Task<bool> IsRoleExists(int id);
    }
}
