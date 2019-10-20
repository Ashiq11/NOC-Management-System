using System.Threading.Tasks;
using Abp.Application.Services.Dto;
using Microsoft.AspNetCore.Mvc;
using NMS.Application.Shared.Dtos.EmployeeInfoDtos;
using NMS.Application.Shared.Dtos.RoleInfoDtos;
using NMS.Application.Shared.Interfaces;
using NMS.Core;

namespace NocManagementSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RoleInfoController : ControllerBase
    {
        private readonly IRoleInfoRepository _roleInfoRepository;

        public RoleInfoController(IRoleInfoRepository roleInfoRepository)
        {
            _roleInfoRepository = roleInfoRepository;
        }

        // GET: api/GetAllRoleInfos
        [HttpPost("GetAllRoleInfos")]
        public async Task<PagedResultDto<GetRoleForViewDto>> GetAllRoleInfos(GetAllInputFilter input)
        {
            var result = await _roleInfoRepository.GetAllRoleInfos(input);
            return result;
        }

        // GET: api/GetRoleInfo/5
        [HttpGet("GetRoleInfo/{id}")]
        public async Task<ActionResult<GetRoleForViewDto>> GetRoleInfo(int id)
        {
            var roleInfo = await _roleInfoRepository.GetRoleInfo(id);

            if (roleInfo == null)
            {
                return NotFound();
            }

            return roleInfo;
        }

        // POST: api/RoleInfo
        [HttpPost("CreateRoleInfo")]
        public async Task<ActionResult<RoleInfo>> CreateRoleInfo(CreateRoleDto createRoleDto)
        {
            var createrole = await _roleInfoRepository.CreateRoleInfo(createRoleDto);
            return createrole;
        }

        // PUT: api/EditRoleInfo/5
        [HttpPut("EditRoleInfo/{id}")]
        public async Task<ActionResult<GetRoleForViewDto>> EditRoleInfo(int id, GetRoleForEditOutput editOutput)
        {

            if (_roleInfoRepository.IsRoleExists(id) == null)
            {
                return BadRequest();
            }

            var roleInfo = await _roleInfoRepository.EditRoleInfo(id, editOutput);

            return roleInfo;
        }

        // DELETE: api/RoleInfo/5
        [HttpDelete("DeleteRoleInfo/{id}")]
        public async Task<ActionResult<RoleInfo>> DeleteRoleInfo(int id)
        {
            var roleInfo = await _roleInfoRepository.DeleteRoleInfo(id);
            return roleInfo;
        }
    }
}