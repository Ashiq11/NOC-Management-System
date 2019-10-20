using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.HttpsPolicy;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using NMS.Application.Services.Repositories;
using NMS.Application.Shared.Interfaces;
using NMS.Application.Shared.Services.Exporting;
using NMS.EntityFrameworkCore;
using Swashbuckle.AspNetCore.Swagger;

namespace NocManagementSystem
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddDbContext<NmsDataContext>(x => x.UseSqlServer(Configuration.GetConnectionString("DefaultConnection")));
            services.AddMvc().SetCompatibilityVersion(CompatibilityVersion.Version_3_0)
                .AddControllersAsServices();
            //services.AddControllers();
            // custom addJson NamingStrategy using Newtonsoft.Json.Serialization;
            //.AddJsonOptions(options => {
            //    var resolver = options.SerializerSettings.ContractResolver;
            //    if (resolver != null)
            //        (resolver as DefaultContractResolver).NamingStrategy = null;
            //});
            services.AddCors();
            services.AddTransient<IAuthRepository, AuthRepository>();
            services.AddTransient<ICurrencyRepository, CurrencyRepository>();
            services.AddTransient<IAnnualRequirementRepository, AnnualRequirementRepository>();
            services.AddTransient<IEmployeeInfoRepository, EmployeeInfoRepository>();
            services.AddTransient<IProformaInvoiceRepository, ProformaInvoiceRepository>();
            services.AddTransient<IImporterInfoRepository, ImporterInfoRepository>();
            services.AddTransient<ITempFileCacheManager, TempFileCacheManager>();
            services.AddTransient<IRoleInfoRepository, RoleInfoRepository>();
            services.AddTransient<IUserRoleConfRepository, UserRoleConfRepository>();
            services.AddTransient<IImporterExcelExporter, ImporterExcelExporter>();
            services.AddAuthentication(JwtBearerDefaults.AuthenticationScheme)
              .AddJwtBearer(options => {
                  options.TokenValidationParameters = new TokenValidationParameters
                  {
                      ValidateIssuerSigningKey = true,
                      IssuerSigningKey = new SymmetricSecurityKey(Encoding.ASCII
                                          .GetBytes(Configuration.GetSection("AppSettings:Token").Value)),
                      ValidateIssuer = false,
                      ValidateAudience = false
                  };
              });
            // Register the Swagger generator, defining 1 or more Swagger documents
            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "NMS API", Version = "v1" });
                c.DocInclusionPredicate((docName, description) => true);
                   //Note: This is just for showing Authorize button on the UI. 
                  //Authorize button's behaviour is handled in wwwroot/swagger/ui/index.html
                   c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme());
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            app.UseCors(x => x.AllowAnyOrigin().AllowAnyHeader().AllowAnyMethod());

            app.UseHttpsRedirection();

            app.UseDefaultFiles();
            app.UseStaticFiles();
            //app.UseStaticFiles(new StaticFileOptions()
            //{
            //    FileProvider = new PhysicalFileProvider(Path.Combine(Directory.GetCurrentDirectory(), @"Resources")),
            //    RequestPath = new PathString("/Resources")
            //});

            app.UseRouting();

            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });

            // Enable middleware to serve generated Swagger as a JSON endpoint.
            app.UseSwagger();

            // Enable middleware to serve swagger-ui (HTML, JS, CSS, etc.),
            // specifying the Swagger JSON endpoint.
            app.UseSwaggerUI(c =>
            {
                c.SwaggerEndpoint("/swagger/v1/swagger.json", "NMS API V1");
                //c.RoutePrefix = string.Empty;
            });

        }
    }
}
