﻿using Microsoft.AspNetCore.Mvc;

namespace NocManagementSystem.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmployeeController : ControllerBase
    {
        //private readonly IEmployeeInfoAppService _employeeInfoRepository;
        //public EmployeeController(IEmployeeInfoAppService employeeInfoRepository)
        //{
        //    _employeeInfoRepository = employeeInfoRepository;
        //}

        //// GET: api/Employees
        //[HttpGet]
        //public Task<PagedResultDto<GetEmployeeForViewDto>> GetAll(GetAllEmployeesInput input)
        //{
        //    var v = _employeeInfoRepository.GetAll(input);
        //    return v;
        //}

        ////// GET: api/Employees/5
        ////[HttpGet("{id}")]
        ////public async Task<GetEmployeeForViewDto> GetEmployeeForView(int id)
        ////{
        ////    var employee = await _employeeInfoAppService.GetEmployeeForView(id);

        ////    return employee;
        ////}

        ////public async Task CreateOrEdit(CreateOrEditEmployeeDto input)
        ////{

        ////}
        //[HttpGet("Hello")]
        //public ActionResult Hello()
        //{
        //    return Ok("hello");
        //}
    }
}