import { Component, OnInit } from '@angular/core';
import { FormGroup, Validators, FormControl } from '@angular/forms';
import { from } from 'rxjs';
import { HttpClient, HttpErrorResponse } from '@angular/common/http';
import { RegisterService } from '../_services/register.service';
import { AlertifyService } from '../_services/alertify.service';
import { Router } from '@angular/router';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  styleUrls: ['./register.component.css']
})
export class RegisterComponent implements OnInit {
  registrationForm: FormGroup;
  public divisions = [];
  public ds: IDistrict[];
  public districts = [];
  upazilas = [];
  public up: IUpazila[];
  dlsFile: any;
  nidFile: any;
  ircFile: any;
  progress: number;
  importerInfo: IImporterInfo;
  public loading = false;
  constructor(
    private http: HttpClient,
    private registerService: RegisterService,
    private alertify: AlertifyService,
    private router: Router) { }

  ngOnInit() {
    this.http.get('../../assets/area_data/division.json').subscribe(
      data => {
        this.divisions = data as IDivsion[];
      }, (err: HttpErrorResponse) => {
        console.log (err.message);
      }
    );
    this.http.get('../../assets/area_data/district.json').subscribe(
      data => {
        this.districts = data as IDistrict[];
      }, (err: HttpErrorResponse) => {
        console.log (err.message);
      }
    );
    this.http.get('../../assets/area_data/upazila.json').subscribe(
      data => {
        this.upazilas = data as IUpazila[];
      }, (err: HttpErrorResponse) => {
        console.log (err.message);
      }
    );
    this.createRegistrationForm();
  }
  createRegistrationForm() {
    this.registrationForm = new FormGroup({
      orgName: new FormControl('' , [Validators.required, Validators.maxLength(200)]),
      contactName: new FormControl('', [Validators.required, Validators.maxLength(50)]),
      position: new FormControl('', [Validators.required, Validators.maxLength(20)]),
      contactNo : new FormControl('', [Validators.required, Validators.maxLength(20)]),
      email : new FormControl('', [Validators.required, Validators.maxLength(50), Validators.email]),
      division: new FormControl('', Validators.required),
      district: new FormControl('', Validators.required),
      upazila: new FormControl('', Validators.required),
      address: new FormControl('', [Validators.required, Validators.maxLength(500)]),
      dlsLicenseType: new FormControl('', Validators.required),
      dlsLicenseNo: new FormControl('', [Validators.required, Validators.maxLength(20)]),
      dlsLicenseScan: new FormControl('', Validators.required),
      nidNo: new FormControl('', [Validators.required, Validators.maxLength(20)]),
      nidScan: new FormControl('', Validators.required),
      ircScan: new FormControl('', Validators.required),
      username: new FormControl('', [Validators.required, Validators.maxLength(20)]),
      password: new FormControl('', [Validators.required, Validators.minLength(5), Validators.maxLength(10)]),
      confirmPassword: new FormControl('', Validators.required),
    }, this.passwordMatchValidator);
  }
  passwordMatchValidator(g: FormGroup) {
    return g.get('password').value === g.get('confirmPassword').value ? null : {'mismatch': true };
  }
  onDivisionChange() {
    const dists = [];
    const divName = this.registrationForm.value.division;
    this.districts.forEach(function(item, index) {
      if (item.division ===  divName) {
         const obj = {
            district: item.district,
            division: item.division
          };
         dists.push(obj);
      }
    });
    this.ds = dists as IDistrict[];
  }
  onDistrictChange() {
    const upazs = [];
    const upazName = this.registrationForm.value.district;
    // tslint:disable-next-line: only-arrow-functions
    this.upazilas.forEach(function(item, index) {
        if ( item.district === upazName ) {
          const obj = {
            upazila: item.upazila,
            district: item.district
          };
          upazs.push(obj);
        }
    });
    this.up = upazs as IUpazila[];
  }
  validateImporterInfoFileUpload(file: File) {
    if (file) {
      const fileName = file.name;
      const fileSize = file.size;
      const allowedFile = '.pdf';
      console.log(fileName);
      if (fileName.substr(fileName.length - allowedFile.length,
        allowedFile.length).toLowerCase() !== allowedFile.toLowerCase()) {
        return 'invalidFileFormat';
      }
      if (fileSize > 1024000) {
        return 'invalidFileSize';
      }
    }
    return 'fileOk';
  }
  onSelectedDlsFile(event) {
    const f = event.target.files[0];
    const result = this.validateImporterInfoFileUpload(f);
    if (result === 'invalidFileFormat') {
      this.registrationForm.controls.dlsLicenseScan.reset();
      this.alertify.error('Invalid File Format');
      return;
    }
    if (result === 'invalidFileSize') {
      this.registrationForm.controls.dlsLicenseScan.reset();
      this.alertify.error('Invalid File Size');
      return;
    }
    if (result === 'fileOk') {
      this.dlsFile = f;
    }
  }
  onSelectedNidFile(event) {
    const f = event.target.files[0];
    const result = this.validateImporterInfoFileUpload(f);
    console.log(result);
    if (result === 'invalidFileFormat') {
      this.registrationForm.controls.nidScan.reset();
      this.alertify.error('Invalid File Format');
      return;
    }
    if (result === 'invalidFileSize') {
      this.registrationForm.controls.nidScan.reset();
      this.alertify.error('Invalid File Size');
      return;
    }
    if (result === 'fileOk') {
      this.nidFile = f;
    }
  }
  onSelectedIrcFile(event) {
    const f = event.target.files[0];
    const result = this.validateImporterInfoFileUpload(f);
    console.log(result);
    if (result === 'invalidFileFormat') {
      this.registrationForm.controls.ircScan.reset();
      this.alertify.error('Invalid File Format');
      return;
    }
    if (result === 'invalidFileSize') {
      this.registrationForm.controls.ircScan.reset();
      this.alertify.error('Invalid File Size');
      return;
    }
    if (result === 'fileOk') {
      this.ircFile = f;
    }
  }
  register() {
    this.loading = true;
    const formData = new FormData();
    formData.append('dlsLicenseScan', this.dlsFile);
    formData.append('nidScan', this.nidFile);
    formData.append('ircScan', this.ircFile);
    console.log(formData);
    this.registerService.register(this.registrationForm.value).subscribe(resp => {
    this.importerInfo = resp as IImporterInfo;
    console.log(this.importerInfo.id);
    if (this.importerInfo.id !== undefined && this.importerInfo.id > 0 ) {
      this.registerService.UploadImporterFile(formData, this.importerInfo.id)
      .subscribe(response => {
        console.log(response);
        this.loading = false;
        this.alertify.success('Registration Successfull. Login with your credentials.');
        this.router.navigate(['/login']);
      }, error => {
        this.alertify.error('Registration failed');
      });
    }
     }, error => {
      this.alertify.error('Registration failed');
     });
  }
}
interface IDivsion {
  division: string;
}
interface IDistrict {
      district: string;
      division: string;
}
interface IUpazila {
  upazila: string;
  district: string;
}

interface IImporterInfo {
  id: number;
  orgName: string;
  contactName: string;
  position: string;
  contactNo: string;
  email: string;
  division: string;
  district: string;
  upazila: string;
  address: string;
  dlsLicenseType: string;
  dlsLicenseNo: string;
  dlsLicenseScan: string;
  nidNo: string;
  nidScan: string;
  ircScan: string;
  username: string;
  password: string;
}
