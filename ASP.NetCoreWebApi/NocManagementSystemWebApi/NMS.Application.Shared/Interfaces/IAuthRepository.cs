using NMS.Application.Shared.Dtos;
using NMS.Application.Shared.Dtos.ImporterInfoDtos;
using NMS.Application.Shared.Dtos.UserLoginDtos;
using NMS.Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace NMS.Application.Shared.Interfaces
{
    public interface IAuthRepository
    {
        Task<ImporterInfo> Register(ImporterInfoDto importerInfoDto,int id);
        Task<bool> UserExist(string username);
        Task<UserLogin> CreateUserLogin(UserLogin userLogin, string password);
        Task<ImporterInfo> UpdateImporterFilePath(int id, string[] Arr);
        Task<UserLogin> Login(string username, string password);
        Task<UserCredential> GetUserCredential(int id, string userType);
    }
}
