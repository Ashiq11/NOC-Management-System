using Microsoft.EntityFrameworkCore;
using NMS.Application.Shared.Dtos.ImporterInfoDtos;
using NMS.Application.Shared.Dtos.UserLoginDtos;
using NMS.Application.Shared.Interfaces;
using NMS.Core;
using NMS.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace NMS.Application.Services.Repositories
{
    public class AuthRepository : IAuthRepository
    {
        private readonly NmsDataContext _nmsDataContext;
        public AuthRepository(NmsDataContext nmsDataContext)
        {
            _nmsDataContext = nmsDataContext;
        }

        public async Task<UserLogin> CreateUserLogin(UserLogin userLogin, string password)
        {
            byte[] passwordHash, passwordSalt;
            CreatePasswordHash(password, out passwordHash, out passwordSalt);
            userLogin.PasswordHash = passwordHash;
            userLogin.PasswordSalt = passwordSalt;
            await _nmsDataContext.UserLogins.AddAsync(userLogin);
            await _nmsDataContext.SaveChangesAsync();
            return userLogin;
        }
        public void CreatePasswordHash(string password, out byte[] passwordHash, out byte[] passwordSalt)
        {
            using (var hmac = new System.Security.Cryptography.HMACSHA512())
            {
                passwordSalt = hmac.Key;
                passwordHash = hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
            }
        }

        public async Task<ImporterInfo> Register(ImporterInfoDto importerInfoDto, int id)
        {
            ImporterInfo importerInfo = new ImporterInfo
            {
                OrgName = importerInfoDto.OrgName,
                ContactName = importerInfoDto.ContactName,
                Position = importerInfoDto.Position,
                ContactNo = importerInfoDto.ContactNo,
                Email = importerInfoDto.Email.ToLower(),
                Division = importerInfoDto.Division,
                District = importerInfoDto.District,
                Upazila = importerInfoDto.Upazila,
                Address = importerInfoDto.Address,
                DlsLicenseType = importerInfoDto.DlsLicenseType,
                DlsLicenseNo = importerInfoDto.DlsLicenseNo,
                //DlsLicenseScan = importerInfoDto.DlsLicenseScan,
                NidNo = importerInfoDto.NidNo,
                //NidScan = importerInfoDto.NidScan,
                //IrcScan = importerInfoDto.IrcScan,
                UserId = id
            };
            await _nmsDataContext.ImporterInfos.AddAsync(importerInfo);
            bool result = await _nmsDataContext.SaveChangesAsync() > 0;
            UserRoleConf userRoleConf = null;
            if (result)
            {
                userRoleConf = await AssignImporterToRole(importerInfo.UserId);
            }
            // ********need to be delete the user for Assign ImporterTRole failed ****************** ///
            return importerInfo;
        }
        private async Task<UserRoleConf> AssignImporterToRole(int userId)
        {
            UserRoleConf userRoleConf = null;
            if (userId > 0)
            {
                userRoleConf = new UserRoleConf
                {

                    UserId = userId,
                    RoleId = 2
                };
                await _nmsDataContext.UserRoleConfs.AddAsync(userRoleConf);
                _nmsDataContext.SaveChanges();
            }
            return userRoleConf;
        }

        public async Task<bool> UserExist(string username)
        {
            if (await _nmsDataContext.UserLogins.AnyAsync(x => x.Username == username))
                return false;
            return true;
        }

        public async Task<ImporterInfo> UpdateImporterFilePath(int id, string[] Arr)
        {
            ImporterInfo targetedImporter = await _nmsDataContext.ImporterInfos.FirstOrDefaultAsync(i => i.Id == id);

            targetedImporter.DlsLicenseScan = Arr[0] == null ? null : Arr[0].Replace("\\", "/");
            targetedImporter.NidScan = Arr[1] == null ? null : Arr[1].Replace("\\", "/");
            targetedImporter.IrcScan = Arr[2] == null ? null : Arr[2].Replace("\\", "/");

            if (id > 0 && targetedImporter != null)
            {
                _nmsDataContext.ImporterInfos.Attach(targetedImporter);
                await _nmsDataContext.SaveChangesAsync();
            }
            return targetedImporter;
        }

        public async Task<UserLogin> Login(string username, string password)
        {
            var user = await _nmsDataContext.UserLogins.FirstOrDefaultAsync(x => x.Username == username);
            if (user == null)
                return null;
            if (!VerifyPasswordHash(password, user.PasswordHash, user.PasswordSalt))
                return null;
            return user;
        }
        private bool VerifyPasswordHash(string password, byte[] passwordHash, byte[] passwordSalt)
        {
            using (var hmac = new System.Security.Cryptography.HMACSHA512(passwordSalt))
            {
                var computedHash = hmac.ComputeHash(System.Text.Encoding.UTF8.GetBytes(password));
                for (int i = 0; i < computedHash.Length; i++)
                {
                    if (computedHash[i] != passwordHash[i])
                        return false;
                }
            }
            return true;
        }

        public async Task<UserCredential> GetUserCredential(int id, string userType)
        {
            UserCredential userCred = null;
            if (userType == "I")
            {
                userCred = await (from ul in _nmsDataContext.UserLogins
                                  join im in _nmsDataContext.ImporterInfos on ul.Id equals im.UserId
                                  join urc in _nmsDataContext.UserRoleConfs on ul.Id equals urc.UserId
                                  join ri in _nmsDataContext.RoleInfos on urc.RoleId equals ri.Id
                                  where (ul.Id == id)
                                  select new UserCredential
                                  {
                                      UserLoginId = ul.Id,
                                      Username = ul.Username,
                                      ContactName = im.ContactName,
                                      Email = im.Email,
                                      Position = im.Position,
                                      Role = ri.Name,
                                      OrgName = im.OrgName
                                  }).FirstOrDefaultAsync();
            }
            else if (userType == "E")
            {
                userCred = await (from ul in _nmsDataContext.UserLogins
                                  join emp in _nmsDataContext.EmployeeInfos on ul.Id equals emp.UserId
                                  join urc in _nmsDataContext.UserRoleConfs on ul.Id equals urc.UserId
                                  join ri in _nmsDataContext.RoleInfos on urc.RoleId equals ri.Id
                                  where (ul.Id == id)
                                  select new UserCredential
                                  {
                                      UserLoginId = ul.Id,
                                      Username = ul.Username,
                                      Email = emp.Email,
                                      ContactName = emp.EmpName,
                                      Role = ri.Name,
                                      OrgName = "Department of Livestock Services(DLS)",
                                      Position = emp.Designation
                                  }).FirstOrDefaultAsync();
            }
            return userCred;
        }
    }
}
