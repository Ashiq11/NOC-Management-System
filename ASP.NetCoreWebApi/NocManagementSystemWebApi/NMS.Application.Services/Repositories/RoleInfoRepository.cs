using Abp.Application.Services.Dto;
using Microsoft.EntityFrameworkCore;
using System.Linq;
using System.Threading.Tasks;
using System.Linq.Dynamic.Core;
using Abp.Linq.Extensions;
using NMS.Application.Shared.Interfaces;
using NMS.EntityFrameworkCore;
using NMS.Application.Shared.Dtos.RoleInfoDtos;
using NMS.Core;
using NMS.Application.Shared.Dtos.EmployeeInfoDtos;

namespace NMS.Application.Services.Repositories
{
    public class RoleInfoRepository : IRoleInfoRepository
    {
        private readonly NmsDataContext _context;

        public RoleInfoRepository(NmsDataContext context)
        {
            _context = context;
        }

        public async Task<RoleInfo> CreateRoleInfo(CreateRoleDto createRoleDto)
        {
            RoleInfo roleInfo = new RoleInfo
            {
                Name = createRoleDto.Name,
            };
            await _context.RoleInfos.AddAsync(roleInfo);
            await _context.SaveChangesAsync();
            return roleInfo;
        }

        public async Task<RoleInfo> DeleteRoleInfo(int id)
        {
            var roleInfo = await _context.RoleInfos.FirstOrDefaultAsync(e => e.Id == id);
            _context.RoleInfos.Remove(roleInfo);
            await _context.SaveChangesAsync();
            return roleInfo;
        }

        public async Task<GetRoleForViewDto> EditRoleInfo(int id, GetRoleForEditOutput editOutput)
        {
            RoleInfo roleInfo = await _context.RoleInfos.FirstOrDefaultAsync(i => i.Id == id);
            if (roleInfo != null)
            {
                roleInfo.Name = editOutput.Name;

            }
            _context.RoleInfos.Update(roleInfo);
            await _context.SaveChangesAsync();
            var updatedRoleInfo = await GetRoleInfo(roleInfo.Id);
            return updatedRoleInfo;
        }

        public async Task<PagedResultDto<GetRoleForViewDto>> GetAllRoleInfos(GetAllInputFilter input)
        {
            var roleInfo = (from r in _context.RoleInfos
                                where r.Name.Contains(input.Filter)

                                select new GetRoleForViewDto
                                {
                                    Id=r.Id,
                                    Name=r.Name
                                });
            var totalCount = await roleInfo.CountAsync();

            var results = await roleInfo
                .OrderBy(input.Sorting ?? "e => e.Id asc")
                .PageBy(input)
                .ToListAsync();

            return new PagedResultDto<GetRoleForViewDto>(
                totalCount,
                results
                );
        }

        //public async Task<PagedResultDto<GetRoleForViewDto>> GetAll()
        //{
        //    var roleInfo = (from r in _context.RoleInfos
        //                    select new GetRoleForViewDto
        //                    {
        //                        Id = r.Id,
        //                        Name = r.Name
        //                    });
        //    var totalCount = await roleInfo.CountAsync();
        //    var results = await roleInfo.ToListAsync();

        //    return new PagedResultDto<GetRoleForViewDto>(
        //         totalCount,
        //         results
        //         );
        //}

        public async Task<GetRoleForViewDto> GetRoleInfo(int id)
        {
            var roleInfo =await (from r in _context.RoleInfos
                            where (r.Id==id)

                            select new GetRoleForViewDto
                            {
                                Id = r.Id,
                                Name = r.Name
                            }).FirstOrDefaultAsync();

            return roleInfo;
        }
        public async Task<bool> IsRoleExists(int id)
        {
            if (await _context.RoleInfos.AnyAsync(x => x.Id == id))
                return false;
            return true;
        }
        
    }
}
