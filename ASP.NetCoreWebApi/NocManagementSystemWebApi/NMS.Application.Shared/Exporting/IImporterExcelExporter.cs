using NMS.Application.Shared.Dtos.ImporterInfoDtos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace NMS.Application.Shared.Services.Exporting
{
    public interface IImporterExcelExporter
    {
        FileDto ExportToFile(List<GetImporterForViewDto> impoters);
    }
}
