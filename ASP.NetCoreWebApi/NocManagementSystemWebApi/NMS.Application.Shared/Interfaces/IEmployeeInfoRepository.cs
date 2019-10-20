using Abp.Application.Services.Dto;
using NMS.Application.Shared.Dtos.EmployeeInfoDtos;
using NMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace NMS.Application.Shared.Interfaces
{
    public interface IEmployeeInfoRepository
    {
        Task<PagedResultDto<GetEmployeeForViewDto>> GetEmployeeInfos(GetAllInputFilter input);
        Task<GetEmployeeForViewDto> GetEmployeeInfo(int id);
        Task<GetEmployeeForViewDto> PutEmployeeInfo(int id, GetEmployeeForEditOutput editOutput);

        Task<EmployeeInfo> PostEmployeeInfo(GetEmployeeForEditOutput getEmployeeForEditOutput, int id);

        Task<EmployeeInfo> DeleteEmployeeInfo(int id);

        Task<bool> IsEmployeeEmailExists(string email);
        Task<bool> IsEmployeeUserNameExists(string username);
        Task<UserLogin> CreateUserLogin(UserLogin userLogin, string password);
        Task<bool> IsEmployeeExists(int id);
    }
}
