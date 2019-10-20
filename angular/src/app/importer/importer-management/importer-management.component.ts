import { Component, OnInit, ViewChild, ɵConsole } from '@angular/core';
import { Table } from 'primeng/components/table/table';
import { Paginator } from 'primeng/components/paginator/paginator';
import { PrimengTableHelper } from 'src/app/helpers/PrimengTableHelper';
import { LazyLoadEvent } from 'primeng/components/common/lazyloadevent';
import { AlertifyService } from 'src/app/_services/alertify.service';
import { ViewImporterModalComponent } from './view-importer-modal.component';
import { ImporterInfoService } from 'src/app/_services/importer-info.service';
import { IGetAllInputFilterDto, IPagedResultDto } from 'src/app/common/app-pagedResult';
import { FileDownloadService } from 'src/app/helpers/file-download.service';
import { IFileDto } from 'src/app/common/FileDto';
import 'jspdf-autotable';
import * as jsPDF from 'jspdf';
import { environment } from 'src/environments/environment';
import { HttpClient } from '@angular/common/http';

@Component({
  selector: 'importer-management',
  templateUrl: './importer-management.component.html',
  styleUrls: ['./importer-management.component.css']
})
export class ImporterManagementComponent implements OnInit {

  @ViewChild('viewImporterModalComponent', { static: false }) viewImporterModal: ViewImporterModalComponent;
  @ViewChild('dataTable', { static: true }) dataTable: Table;
  @ViewChild('paginator', { static: true }) paginator: Paginator;
  filterText = '';
  primengTableHelper: PrimengTableHelper;
  fileName: any;
  fileType: any;
  fileToken: any;
  baseUrl = environment.apiUrl + 'ImporterInfo/';
  fileDownloadInitiated: boolean;
  constructor(private _importerInfoService: ImporterInfoService,
    private _alertifyService: AlertifyService,
    private _fileDownloadService: FileDownloadService,
              private http: HttpClient
  ) {
    this.primengTableHelper = new PrimengTableHelper();
  }

  ngOnInit() {
  }

  getImporters(event?: LazyLoadEvent) {
    if (this.primengTableHelper.shouldResetPaging(event)) {
      this.paginator.changePage(0);
      return;
    }

    this.primengTableHelper.showLoadingIndicator();

    const fltr: IGetAllInputFilterDto = {
      filter: this.filterText,
      sorting: this.primengTableHelper.getSorting(this.dataTable),
      skipCount: this.primengTableHelper.getSkipCount(this.paginator, event),
      maxResultCount: this.primengTableHelper.getMaxResultCount(this.paginator, event)
    };
    this._importerInfoService.getAllImporterInfos(fltr).subscribe(result => {
      const r = result as IPagedResultDto;
      this.primengTableHelper.totalRecordsCount = r.totalCount;
      this.primengTableHelper.records = r.items;
      this.primengTableHelper.hideLoadingIndicator();
    });
  }
  reloadPage(): void {
    this.paginator.changePage(this.paginator.getPage());
  }
  deleteImporter(importer: IGetImporterForViewDto): void {
    const result = confirm('are you sure want to remove?');
    // if (result) {
    //   this._importerInfoService.deleteImporter(importer.id)
    //     .subscribe(() => {
    //       this.reloadPage();
    //       this._alertifyService.error('Successfully Deleted');
    //     });
    // }
  }
  viewImporterReport(): void {
   // const doc = new jsPDF();
   // doc.text("Hello there", 15, 15);
   // doc.save('first.pdf');

    this._importerInfoService.getAllImporterInfosPdf().subscribe(result => {
      const r = result as IPagedResultDto;
      let row: any[] = []
      let rowD: any[] = []
      let col = ['Organization','Contact','Contact No.','Position','Email','Division','District','Upazila','Address','DlsLicense No.','Nid No.']; // initialization for headers
      let title = "Importer Report" // title of report
      for (let a = 0; a < r.totalCount; a++) {
        row.push(r.items[a].orgName)
        row.push(r.items[a].contactName)
        row.push(r.items[a].contactNo)
        row.push(r.items[a].position)
        row.push(r.items[a].email)
        row.push(r.items[a].division)
        row.push(r.items[a].district)
        row.push(r.items[a].upazila)
        row.push(r.items[a].address)
        row.push(r.items[a].dlsLicenseNo)
        row.push(r.items[a].nidNo)
        rowD.push(row);
        row = [];
      }
      // console.log(col);
      // console.log(rowD);
      // console.log(title);
      this.getReport(col, rowD, title);
    });
  }

  getReport(col: any[], rowD: any[], title: any) {
    const totalPagesExp = "{total_pages_count_string}";
    let pdf = new jsPDF('l', 'pt', 'legal');
    pdf.setTextColor(51, 156, 255);
    pdf.text("Department of Livestock Services Bangladesh", 350, 40);
    // pdf.text("Email:", 450, 60); // 450 here is x-axis and 80 is y-axis
    // pdf.text("Phone:", 450, 80); // 450 here is x-axis and 80 is y-axis
    // pdf.text("" + title, 435, 100);  //
    pdf.setLineWidth(1.5);
    pdf.line(5, 107, 995, 107)
    var pageContent = function (data) {
      // HEADER

      // FOOTER
      var str = "Page " + data.pageCount;
      // Total page number plugin only available in jspdf v1.0+
      if (typeof pdf.putTotalPages === 'function') {
        str = str + " of " + totalPagesExp;
      }
      pdf.setFontSize(11);
      var pageHeight = pdf.internal.pageSize.height || pdf.internal.pageSize.getHeight();
      pdf.text(str, data.settings.margin.left, pageHeight - 10); // showing current page number
    };
    pdf.autoTable(col, rowD,
      {
        theme: "grid",
        didDrawPage: pageContent,
        margin: { top: 110 },
      });

    //for adding total number of pages // i.e 10 etc
    if (typeof pdf.putTotalPages === 'function') {
      pdf.putTotalPages(totalPagesExp);
    }

    pdf.save(title + '.pdf');
  }

  exportToExcel(): void {
    const fileDto: IFileDto = {
      fileName: this.fileName,
      fileType: this.fileType,
      fileToken: this.fileToken

    }
    this._importerInfoService.getImportersToExcel(
    )
      .subscribe(result => {
        const r = result as IFileDto;
        this._fileDownloadService.downloadTempFile(r);
      });
  }
  DownloadDlsLicenseFile(fname: string) {
    this.fileDownloadInitiated = true;
    return this.http.get(this.baseUrl + 'DownloadFile/' + fname, { responseType: 'blob' })
      .subscribe((result: any) => {
        if (result.type !== 'text/plain') {
          const blob = new Blob([result]);
          const saveAs = require('file-saver');
          const file = 'dls_license_' + fname;
          saveAs(blob, file);
          this.fileDownloadInitiated = false;
        } else {
          this.fileDownloadInitiated = false;
          alert('File not found in Blob!');
        }
      }, error => {
        this._alertifyService.warning('No file found');
      });
  }
  DownloadIrcFile(fname: string) {
    this.fileDownloadInitiated = true;
    return this.http.get(this.baseUrl + 'DownloadFile/' + fname, { responseType: 'blob' })
      .subscribe((result: any) => {
        if (result.type !== 'text/plain') {
          const blob = new Blob([result]);
          const saveAs = require('file-saver');
          const file = 'nid_' + fname;
          saveAs(blob, file);
          this.fileDownloadInitiated = false;
        } else {
          this.fileDownloadInitiated = false;
          alert('File not found in Blob!');
        }
      }, err => {
        this._alertifyService.warning('No file found');
      });
  }
  DownloadNidFile(fname: string) {
    this.fileDownloadInitiated = true;
    return this.http.get(this.baseUrl + 'DownloadFile/' + fname, { responseType: 'blob' })
      .subscribe((result: any) => {
        if (result.type !== 'text/plain') {
          const blob = new Blob([result]);
          const saveAs = require('file-saver');
          const file = 'irc_' + fname;
          saveAs(blob, file);
          this.fileDownloadInitiated = false;
        } else {
          this.fileDownloadInitiated = false;
          alert('File not found in Blob!');
        }
      }, err => {
        this._alertifyService.warning('No file found');
      });
  }
}


export class GetImporterForViewDto implements IGetImporterForViewDto {
  id: number | undefined;
  userId: number | undefined;
  username: string | undefined;
  orgName: string | undefined;
  contactName: string | undefined;
  contactNo: string | undefined;
  position: string | undefined;
  email: string | undefined;
  division: string | undefined;
  district: string | undefined;
  upazila: string | undefined;
  address: string | undefined;
  dlsLicenseType: string | undefined;
  dlsLicenseNo: string | undefined;
  dlsLicenseScan: string | undefined;
  nidNo: string | undefined;
  nidScan: string | undefined;
  ircScan: string | undefined;
  impCode: string | undefined;

  constructor(data?: IGetImporterForViewDto) {
    if (data) {
      for (var property in data) {
        if (data.hasOwnProperty(property))
          (<any>this)[property] = (<any>data)[property];
      }
    }
  }
}


export interface IGetImporterForViewDto {
  id: number | undefined;
  userId: number | undefined;
  username: string | undefined;
  orgName: string | undefined;
  contactName: string | undefined;
  contactNo: string | undefined;
  position: string | undefined;
  email: string | undefined;
  division: string | undefined;
  district: string | undefined;
  upazila: string | undefined;
  address: string | undefined;
  dlsLicenseType: string | undefined;
  dlsLicenseNo: string | undefined;
  dlsLicenseScan: string | undefined;
  nidNo: string | undefined;
  nidScan: string | undefined;
  ircScan: string | undefined;
  impCode: string | undefined;
}
