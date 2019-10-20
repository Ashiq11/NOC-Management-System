using System;
using System.IdentityModel.Tokens.Jwt;
using System.IO;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using NMS.Application.Shared.Dtos.ImporterInfoDtos;
using NMS.Application.Shared.Dtos.UserLoginDtos;
using NMS.Application.Shared.Interfaces;
using NMS.Core;

namespace NocManagementSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private IConfiguration _configuration;
        private readonly IWebHostEnvironment _hostingEnvironment;
        private readonly IAuthRepository _authRepository;
        public AuthController(IAuthRepository importerRegRepository,
            IWebHostEnvironment hostingEnvironment,
            IConfiguration configuration)
        {
            _configuration = configuration;
            _hostingEnvironment = hostingEnvironment;
            _authRepository = importerRegRepository;
        }
        [HttpPost("RegisterImporter")]
        public async Task<ActionResult<ImporterInfo>> RegisterImporter(ImporterInfoDto importerInfoDto)
        {
            importerInfoDto.Username = importerInfoDto.Username.ToLower();
            if (!await _authRepository.UserExist(importerInfoDto.Username))
                return BadRequest("Username is Already Exist");

            var userLoginToCreate = new UserLogin
            {
                Username = importerInfoDto.Username,
                UserType = "I",
                CreatedDate = DateTime.Now,
                UpdatedDate = DateTime.Now
            };
            var createdUserLogin = await _authRepository.CreateUserLogin(userLoginToCreate, importerInfoDto.Password);
            ImporterInfo importer = null;
            if (createdUserLogin.Id > 0)
            {
                importer = await _authRepository.Register(importerInfoDto, createdUserLogin.Id);
            }
            return importer;
        }
        [HttpPost]
        [Route("UploadImporterFile/{id}")]
        public async Task<ActionResult<ImporterInfo>> UploadImporterFile(int id)
        {
            try
            {
                string[] importerFilePathArr = new string[3];
                for(int i = 0; i < Request.Form.Files.Count; i++)
                {
                    var v = Request.Form;
                    var file = Request.Form.Files[i];
                    var folderName = Path.Combine("Resources", "ImporterInfoDoc");
                    var pathToSave = Path.Combine(Directory.GetCurrentDirectory(), folderName);
                    if (file.Length > 0)
                    {
                        // var fileName = ContentDispositionHeaderValue.Parse(file.ContentDisposition).FileName.Trim('"');
                        var gid = Guid.NewGuid();
                        var fileName = gid+".pdf";
                        var fullPath = Path.Combine(folderName, fileName);
                        var dbPath = Path.Combine(fileName);
                        importerFilePathArr[i] = dbPath;
                        using (var stream = new FileStream(fullPath, FileMode.Create))
                        {
                            file.CopyTo(stream);
                        }
                    }
                }
                ImporterInfo updatedImporter = await _authRepository.UpdateImporterFilePath(id, importerFilePathArr);
                return updatedImporter;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        [HttpPost("login")]
        public async Task<IActionResult> Login(UserForLoginDto userForLoginDto)
        {
            var user = await _authRepository.Login(userForLoginDto.Username, userForLoginDto.Password);
            if (user == null)
                return Unauthorized();
            UserCredential userCredentials = await _authRepository.GetUserCredential(user.Id, user.UserType);
            var claims = new[]
            {
                new Claim(ClaimTypes.NameIdentifier,userCredentials.UserLoginId.ToString()),
                new Claim(ClaimTypes.Name, userCredentials.ContactName),
                new Claim(ClaimTypes.Email, userCredentials.Position),
                new Claim(ClaimTypes.Role, userCredentials.Role),
                new Claim(ClaimTypes.Surname, userCredentials.OrgName)
            };
            var key = new SymmetricSecurityKey(Encoding.UTF8
                            .GetBytes(_configuration.GetSection("AppSettings:Token").Value));
            var creds = new SigningCredentials(key, SecurityAlgorithms.HmacSha512Signature);
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = new ClaimsIdentity(claims),
                Expires = DateTime.Now.AddDays(1),
                SigningCredentials = creds
            };
            var tokenHandler = new JwtSecurityTokenHandler();
            var token = tokenHandler.CreateToken(tokenDescriptor);
            return Ok(new
            {
                token = tokenHandler.WriteToken(token)
            });
        }

    }
}