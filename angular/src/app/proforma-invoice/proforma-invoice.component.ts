import { Component, OnInit, ViewChild, TemplateRef } from '@angular/core';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { CurrencyService } from '../_services/currency.service';
import { BsModalRef, BsModalService } from 'ngx-bootstrap';
import { AlertifyService } from '../_services/alertify.service';
import { ProformaInvoiceService } from '../_services/proforma-invoice.service';
import { LoginService } from '../_services/login.service';
import { saveAs } from 'file-saver';
import { read } from 'fs';
import { HttpClient } from '@angular/common/http';
import { environment } from 'src/environments/environment';

@Component({
  selector: 'app-proforma-invoice',
  templateUrl: './proforma-invoice.component.html',
  styleUrls: ['./proforma-invoice.component.css']
})
export class ProformaInvoiceComponent implements OnInit {
  @ViewChild('proformaInvDtlModal', { static: false }) proformaInvDtlModal: TemplateRef<any>;
  @ViewChild('proformaInvMstSearchModal', { static: false }) proformaInvMstSearchModal: TemplateRef<any>;
  modalRef: BsModalRef;
  proformaInvoiceForm: FormGroup;
  proformaInvoiceDtlForm: FormGroup;
  saveButtonTitle = 'Save';
  proformaUpdateMode = false;
  public loading = false;
  currencies: ICurrency[] = [];
  proformaInvoiceDtls: IProformaInvoiceDtl[] = [];
  proformaInvDtlModalTitle = '';
  addMode = false;
  editMode = false;
  updateProd: IProformaInvoiceDtl;
  annualReqMsts: IAnnualRequirementMst[];
  annProds: IAnnReqProdDtlsForProforDto[] = [];
  exchngDisabled = true;
  proformaInvProdTotalAmtDto: ProfInvTotalAmtDtoByProdDto;
  piScanFile: any;
  litScanFile: any;
  testReportFile: any;
  otherDocFile: any;
  piMstId: number;
  proformaInvoiceMsts: IProformaInvoiceMst[] = [];
  fileDownloadInitiated: boolean;
  totalAmountValidationErrorMsg = false;
  totalAmountValidation: IPiTotalAmountValidationDto;
  updateBtnDisable = false;
  submitButtonDisable = true;
  isSubmitted = false;
  baseUrl = environment.apiUrl + 'ProformaInvoice/';
  p: any = 1;
  currentDateString = new Date();
  todayDate = this.currentDateString.getDate() + '/' + (this.currentDateString.getMonth() + 1) + '/' + this.currentDateString.getFullYear();
  constructor(
    private currencyService: CurrencyService,
    private modalService: BsModalService,
    private alertify: AlertifyService,
    private proformaService: ProformaInvoiceService,
    private loginService: LoginService,
    private http: HttpClient
  ) {}

  ngOnInit() {
    this.createProformaInvoiceForm();
    this.createProformaInvoiceDtlForm();
    this.getCurrencies();
    this.getProductListFromAnnualReq();
  }
  createProformaInvoiceForm() {

    this.proformaInvoiceForm = new FormGroup({
      applicationNo: new FormControl(''),
      proformaInvoiceNo: new FormControl(''),
      proformaDate: new FormControl(this.todayDate),
      submissionDate: new FormControl(''),
      countryOfOrigin: new FormControl('', [Validators.required]),
      currency: new FormControl('', [Validators.required]),
      portOfLoading: new FormControl('', [Validators.required]),
      portOfEntry: new FormControl('', [Validators.required]),
      piScan: new FormControl('', [Validators.required]),
      litScan: new FormControl('', [Validators.required]),
      testReport: new FormControl('', [Validators.required]),
      otherDoc: new FormControl('')
    });
  }
  createProformaInvoiceDtlForm() {
    this.proformaInvoiceDtlForm = new FormGroup({
      prodName: new FormControl('', [
        Validators.required
      ]),
      prodType: new FormControl('', [
        Validators.required,
        Validators.maxLength(500)
      ]),
      hsCode: new FormControl('', [
        Validators.required,
        Validators.maxLength(20)
      ]),
      manufacturer: new FormControl('', [
        Validators.required,
        Validators.maxLength(100)
      ]),
      packSize: new FormControl('', [
        Validators.required,
        Validators.maxLength(100)
      ]),
      noOfUnits: new FormControl('', [
        Validators.required,
        Validators.maxLength(8),
        Validators.pattern(/^[0-9]+(.[0-9]{1,2})?$/)
      ]),
      totalAmount: new FormControl('', [
        Validators.required,
        Validators.maxLength(6),
        Validators.pattern(/^[0-9]+(.[0-9]{1,2})?$/)
      ]),
      unitPrice: new FormControl('', [
        Validators.required,
        Validators.maxLength(8),
        Validators.pattern(/^[0-9]+(.[0-9]{1,2})?$/)
      ]),
      exchangeRate: new FormControl('', [Validators.required]),
      totalPrice: new FormControl('', Validators.required),
      totalPriceInBdt: new FormControl('', Validators.required)
    });
  }
  openModal(template: TemplateRef<any>) {
    this.modalRef = this.modalService.show(template, { class: 'modal-lg' });
  }
  getCurrencyRate() {
      const currenc = this.proformaInvoiceForm.value.currency;
      let excngRate: number;
      // tslint:disable-next-line: only-arrow-functions
      this.currencies.forEach( function(item, index) {
        if (item.currency === currenc) {
          excngRate = item.exchangeRate;
        }
      });
      return excngRate;
  }
  validateProformaInvFileUpload(file: File) {
    if (file) {
      const fileName = file.name;
      const fileSize = file.size;
      const allowedFile = '.pdf';
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
  onSelectedPiFile(event) {
    const f = event.target.files[0];
    const result = this.validateProformaInvFileUpload(f);
    if (result === 'invalidFileFormat') {
      this.proformaInvoiceForm.controls.piScan.reset();
      this.alertify.error('Invalid File Format');
      return;
    }
    if (result === 'invalidFileSize') {
      this.proformaInvoiceForm.controls.piScan.reset();
      this.alertify.error('Invalid File Size');
      return;
    }
    if (this.isSubmitted === true) {
        this.alertify.warning('Proforma Invoice already submitted. can not update file.');
        return;
    }
    if (this.proformaUpdateMode === true) {
      const piFormData = new FormData();
      piFormData.append('piFile', f);
      this.proformaService.updatePiFile(piFormData, this.piMstId).subscribe(resp => {
        this.alertify.success('Proforma Invoice updated successfullt.');
        const piMst = resp as IProformaInvoiceMst;
      }, error => {
        console.log(console.error);
      });
      return;
    }
    if (result === 'fileOk') {
      this.piScanFile = f;
    }
  }
  onSelectedLitFile(event) {
    const f = event.target.files[0];
    const result = this.validateProformaInvFileUpload(f);
    if (result === 'invalidFileFormat') {
      this.proformaInvoiceForm.controls.litScan.reset();
      this.alertify.error('Invalid File Format');
      return;
    }
    if (result === 'invalidFileSize') {
      this.proformaInvoiceForm.controls.litScan.reset();
      this.alertify.error('Invalid File Size');
      return;
    }
    if (this.isSubmitted === true) {
      this.alertify.warning('Proforma Invoice already submitted. can not update file.');
      return;
    }
    if (this.proformaUpdateMode === true) {
      const litFormData = new FormData();
      litFormData.append('litFile', f);
      this.proformaService.updateLitFile(litFormData, this.piMstId).subscribe(resp => {
        const piMst = resp as IProformaInvoiceMst;
        this.alertify.success('Literature review updated successfullt.');
      }, error => {
        console.log(console.error);
      });
      return;
    }
    if (result === 'fileOk') {
      this.litScanFile = f;
    }
  }
  onSelectedTestFile(event) {
    const f = event.target.files[0];
    const result = this.validateProformaInvFileUpload(f);
    if (result === 'invalidFileFormat') {
      this.proformaInvoiceForm.controls.testReport.reset();
      this.alertify.error('Invalid File Format');
      return;
    }
    if (result === 'invalidFileSize') {
      this.proformaInvoiceForm.controls.testReport.reset();
      this.alertify.error('Invalid File Size');
      return;
    }
    if (this.isSubmitted === true) {
      this.alertify.warning('Proforma Invoice already submitted. can not update file.');
      return;
    }
    if (this.proformaUpdateMode === true) {
      const testFormData = new FormData();
      testFormData.append('testFile', f);
      this.proformaService.updateTestFile(testFormData, this.piMstId).subscribe(resp => {
        const piMst = resp as IProformaInvoiceMst;
        this.alertify.success('Tset Report updated successfullt');
      }, error => {
        console.log(console.error);
      });
      return;
    }
    if (result === 'fileOk') {
      this.testReportFile = f;
    }
  }
  onSelectedOtherDocFile(event) {
    const f = event.target.files[0];
    const result = this.validateProformaInvFileUpload(f);
    if (result === 'invalidFileFormat') {
      this.proformaInvoiceForm.controls.otherDoc.reset();
      this.alertify.error('Invalid File Format');
      return;
    }
    if (result === 'invalidFileSize') {
      this.proformaInvoiceForm.controls.otherDoc.reset();
      this.alertify.error('Invalid File Size');
      return;
    }
    if (this.isSubmitted === true) {
      this.alertify.warning('Proforma Invoice already submitted. can not update file.');
      return;
   }
    if (this.proformaUpdateMode === true) {
      const otherFormData = new FormData();
      otherFormData.append('otherFile', f);
      this.proformaService.updateOtherFile(otherFormData, this.piMstId).subscribe(resp => {
        this.alertify.success('Other Document updated successfullt');
        const piMst = resp as IProformaInvoiceMst;
      }, error => {
        console.log(console.error);
      });
      return;
    }
    if (result === 'fileOk') {
      this.otherDocFile = f;
    }
  }
  openProformaDtlModal(mode: string) {
    if (mode === 'add') {
      this.proformaInvDtlModalTitle = 'Add Product';
      this.proformaInvoiceDtlForm.reset();
      this.proformaInvoiceDtlForm.get('prodName').setValue('');
      const exRate = this.getCurrencyRate();
      this.proformaInvoiceDtlForm.get('exchangeRate').setValue(exRate);
    }
    if (mode === 'update') {
      this.proformaInvDtlModalTitle = 'Update Product';
      const exRate =  this.getCurrencyRate();
      this.proformaInvoiceDtlForm.get('exchangeRate').setValue(exRate);

    }
    this.openModal(this.proformaInvDtlModal);
    this.editMode = false;
    this.addMode = true;
  }
  openProforMstodal() {
  }
  getCurrencies() {
    this.currencyService.getCurrency().subscribe(
      resp => {
        this.currencies = resp as ICurrency[];
      },
      error => {
        console.log(error);
      }
    );
  }
  addUpdateProduct() {
    if (this.addMode === true) {
      const a: IProformaInvoiceDtl = {
        id: 0,
        mstId: 0,
        prodName: this.proformaInvoiceDtlForm.value.prodName,
        prodType: this.proformaInvoiceDtlForm.value.prodType,
        hsCode: this.proformaInvoiceDtlForm.value.hsCode,
        packSize: this.proformaInvoiceDtlForm.value.packSize,
        manufacturer: this.proformaInvoiceDtlForm.value.manufacturer,
        noOfUnits: this.proformaInvoiceDtlForm.value.noOfUnits,
        unitPrice: this.proformaInvoiceDtlForm.value.unitPrice,
        totalPrice: this.proformaInvoiceDtlForm.value.totalPrice,
        totalPriceInBdt: this.proformaInvoiceDtlForm.value.totalPriceInBdt,
        exchangeRate: this.proformaInvoiceDtlForm.value.exchangeRate,
        totalAmount: this.proformaInvoiceDtlForm.value.totalAmount,
        approvalStatus: null,
        approvedBy: 0,
        remarks: null
      };
      for (const i of this.proformaInvoiceDtls) {
        if (i.prodName === a.prodName) {
          this.alertify.warning('duplicate product');
          return false;
        }
      }
      this.proformaInvoiceDtls.push(a);
      this.modalRef.hide();
      this.proformaInvoiceDtlForm.reset();
    }
    if (this.editMode === true) {
      const a: IProformaInvoiceDtl = {
        id: 0,
        mstId: 0,
        prodName: this.proformaInvoiceDtlForm.value.prodName,
        prodType: this.proformaInvoiceDtlForm.value.prodType,
        hsCode: this.proformaInvoiceDtlForm.value.hsCode,
        packSize: this.proformaInvoiceDtlForm.value.packSize,
        manufacturer: this.proformaInvoiceDtlForm.value.manufacturer,
        noOfUnits: this.proformaInvoiceDtlForm.value.noOfUnits,
        unitPrice: this.proformaInvoiceDtlForm.value.unitPrice,
        totalPrice: this.proformaInvoiceDtlForm.value.totalPrice,
        totalPriceInBdt: this.proformaInvoiceDtlForm.value.totalPriceInBdt,
        exchangeRate: this.proformaInvoiceDtlForm.value.exchangeRate,
        totalAmount: this.proformaInvoiceDtlForm.value.totalAmount,
        approvalStatus: null,
        approvedBy: 0,
        remarks: null
      };
      this.proformaInvoiceDtls.find(
        item => item.prodName === this.updateProd.prodName
      ).prodType = a.prodType;
      this.proformaInvoiceDtls.find(
        item => item.prodName === this.updateProd.prodName
      ).hsCode = a.hsCode;
      this.proformaInvoiceDtls.find(
        item => item.prodName === this.updateProd.prodName
      ).packSize = a.packSize;
      this.proformaInvoiceDtls.find(
        item => item.prodName === this.updateProd.prodName
      ).manufacturer = a.manufacturer;
      this.proformaInvoiceDtls.find(
        item => item.prodName === this.updateProd.prodName
      ).unitPrice = a.unitPrice;
      this.proformaInvoiceDtls.find(
        item => item.prodName === this.updateProd.prodName
      ).noOfUnits = a.noOfUnits;
      this.proformaInvoiceDtls.find(
        item => item.prodName === this.updateProd.prodName
      ).totalPrice = a.totalPrice;
      this.proformaInvoiceDtls.find(
        item => item.prodName === this.updateProd.prodName
      ).totalPriceInBdt = a.totalPriceInBdt;
      this.proformaInvoiceDtls.find(
        item => item.prodName === this.updateProd.prodName
      ).exchangeRate = a.exchangeRate;
      this.proformaInvoiceDtls.find(
        item => item.prodName === this.updateProd.prodName
      ).totalAmount = a.totalAmount;
      this.proformaInvoiceDtls.find(
        item => item.prodName === this.updateProd.prodName
      ).prodName = a.prodName;
      this.modalRef.hide();
      this.proformaInvoiceDtlForm.reset();
    }
  }
  removeProduct(p: IProformaInvoiceDtl) {
    const result = confirm('are you sure want to remove?');
    if (result === true) {
      for (let i = 0; i < this.proformaInvoiceDtls.length; i++) {
        if (this.proformaInvoiceDtls[i].prodName === p.prodName) {
          this.proformaInvoiceDtls.splice(i, 1);
        }
      }
    } else {
      return;
    }
  }
  editProduct(p: IProformaInvoiceDtl) {
    this.updateProd = p;
    this.proformaInvoiceDtlForm.setValue({
      prodName: p.prodName,
      prodType: p.prodType,
      hsCode: p.hsCode,
      packSize: p.packSize,
      manufacturer: p.manufacturer,
      noOfUnits: p.noOfUnits,
      unitPrice: p.unitPrice,
      totalPrice: p.totalPrice,
      totalPriceInBdt: p.totalPriceInBdt,
      exchangeRate: p.exchangeRate,
      totalAmount: p.totalAmount
    });
    this.openProformaDtlModal('update');
    this.editMode = true;
    this.addMode = false;
  }
  getProductListFromAnnualReq() {
    const importerDto: IAnnualReqByImporterDto = {
      importerId: this.loginService.getUserId()
    };
    this.proformaService.getProductListFromAnnualReq(importerDto).subscribe( resp => {
      console.log(resp);
      this.annProds = resp as IAnnReqProdDtlsForProforDto[];
      console.log(this.annProds);
    }, error => {
      console.log(error);
    });
  }

  prodNameSelectChng() {
    const p = this.proformaInvoiceDtlForm.value.prodName;
    let r = '';
    // tslint:disable-next-line: only-arrow-functions
    this.proformaInvoiceDtls.forEach(function(item, index) {
      if ( item.prodName === p) {
        r = 'duplicate';
      }
    });
    if (r === 'duplicate') {
      this.alertify.warning('duplicate product');
      return false;
    }
    let prod: IAnnReqProdDtlsForProforDto;
    // tslint:disable-next-line: only-arrow-functions
    this.annProds.forEach(function(item, index) {
      if (item.prodName === p) {
        prod = item;
      }
    });
    this.proformaInvoiceDtlForm.get('packSize').setValue(prod.packSize);
    this.proformaInvoiceDtlForm.get('hsCode').setValue(prod.hsCode);
    this.proformaInvoiceDtlForm.get('manufacturer').setValue(prod.manufacturer);
    this.proformaInvoiceDtlForm.get('prodType').setValue(prod.prodType);
  }
  NoOfUnitKeydown() {
    this.proformaInvoiceDtlForm.get('unitPrice').enable();
  }
  calculateTotalPrice() {
    const noOfUn = this.proformaInvoiceDtlForm.value.noOfUnits;
    const unitPri = this.proformaInvoiceDtlForm.value.unitPrice;
    if ((noOfUn === undefined || noOfUn === '') || (unitPri === undefined || unitPri === '')) {
      this.proformaInvoiceDtlForm.get('totalPrice').setValue('');
      this.proformaInvoiceDtlForm.get('totalPriceInBdt').setValue('');
    } else {
      const exRate = this.proformaInvoiceDtlForm.value.exchangeRate;
      const totalPri = noOfUn * unitPri;
      const totalPrInBdt = totalPri * exRate;
      this.proformaInvoiceDtlForm.get('totalPrice').setValue(totalPri);
      this.proformaInvoiceDtlForm.get('totalPriceInBdt').setValue(totalPrInBdt);
    }
  }
  currencySelectChange() {
    const cRate = this.getCurrencyRate();
    if (this.proformaInvoiceDtls.length > 0) {
      // tslint:disable-next-line: only-arrow-functions
      this.proformaInvoiceDtls.forEach(function(item, index) {
        item.exchangeRate = cRate;
        item.totalPriceInBdt = item.totalPrice * item.exchangeRate;
      });
    }
  }
  validateTotalAmtount() {
    const totalAmt = this.proformaInvoiceDtlForm.value.totalAmount;
    const impterId = this.loginService.getUserId();
    const prdName = this.proformaInvoiceDtlForm.value.prodName;
    this.proformaInvProdTotalAmtDto = {
      prodName: prdName,
      totalAmount: totalAmt,
      importerId: impterId
    };
    this.proformaService.getCrntYearTotlProformaInvAmtByProd(this.proformaInvProdTotalAmtDto).subscribe(resp => {
      this.totalAmountValidation = resp as IPiTotalAmountValidationDto;
      if (this.totalAmountValidation.validationStatus === false) {
        this.totalAmountValidationErrorMsg = true;
        this.proformaInvoiceDtlForm.get('totalAmount').setValue('');
        this.alertify.warning('Invalid Proforma amount');
      } else {
        this.totalAmountValidationErrorMsg = false;
      }
    });
  }
  saveUpdatePormaInvoice() {
    this.loading = true;
    const formData = new FormData();
    const impId = this.loginService.getUserId();
    if (this.proformaInvoiceDtls.length < 1) {
      this.loading = false;
      this.alertify.warning('No Product to save');
      return false;
    }
    if (this.proformaUpdateMode === false) {
      formData.append('piScan', this.piScanFile);
      formData.append('litScan', this.litScanFile);
      formData.append('testScan', this.testReportFile);
      formData.append('otherScan', this.otherDocFile);
      const proMst: IProformaInvoiceMst  = {
        id: 0,
        applicationNo: 0,
        proformaInvoiceNo: null,
        proformaDate: new Date(),
        submissionDate: new Date(),
        currency: this.proformaInvoiceForm.value.currency,
        countryOfOrigin: this.proformaInvoiceForm.value.countryOfOrigin,
        portOfLoading: this.proformaInvoiceForm.value.portOfLoading,
        portOfEntry: this.proformaInvoiceForm.value.portOfEntry,
        piScan: null,
        litScan: null,
        testReport: null,
        otherDoc: null,
        confirmation: false,
        importerId: impId
      };
      this.proformaService.saveProformaInvoiceMst(proMst).subscribe(resp => {
        const proInveMst = resp as IProformaInvoiceMst;
        const proforInDtl: IProformaInvoiceDtl[] = [];
        console.log(proInveMst);
        for (const d of this.proformaInvoiceDtls) {
          const obj: IProformaInvoiceDtl = {
            id: 0,
            mstId: proInveMst.id,
            prodName: d.prodName,
            prodType: d.prodType,
            hsCode: d.hsCode,
            manufacturer: d.manufacturer,
            exchangeRate: d.exchangeRate,
            noOfUnits: d.noOfUnits,
            unitPrice: d.unitPrice,
            packSize: d.packSize,
            totalAmount: d.totalAmount,
            totalPrice: d.totalPrice,
            totalPriceInBdt: d.totalPriceInBdt,
            approvalStatus: null,
            approvedBy: 0,
            remarks: null
          };
          proforInDtl.push(obj);
        }
        this.proformaService.saveProformaInvoiceDtl(proforInDtl).subscribe(response => {
          const proformaDtl = response as IProformaInvoiceDtl[];
          console.log(proformaDtl);
          if (proInveMst.id !== undefined && proInveMst.id > 0) {
            this.proformaService.UploadProformaFiles(formData, proInveMst.id).subscribe(r => {
              this.alertify.success('Proforma Invoice saved successfully');
              this.resetPage();
              this.loading = false;
            }, e => {
              this.alertify.success('Proforma Invoice save failed');
              console.log(e);
            });
          }
        }, err => {
          this.alertify.success('Proforma Invoice save failed');
          console.log(err);
        });
      }, error => {
        this.alertify.success('Proforma Invoice saved failed');
        console.log(error);
      });
    }
    if ( this.proformaUpdateMode === true) {
      const proMstUpdtDto: IProformaInvoiceMstUpdateDto  = {
        id: this.piMstId,
        currency: this.proformaInvoiceForm.value.currency,
        countryOfOrigin: this.proformaInvoiceForm.value.countryOfOrigin,
        portOfLoading: this.proformaInvoiceForm.value.portOfLoading,
        portOfEntry: this.proformaInvoiceForm.value.portOfEntry
      };
      this.proformaService.updateProformaInvoiceMst(proMstUpdtDto).subscribe(response => {
        const proInveMst = response as IProformaInvoiceMst;
        const proforInDtlUpdtDto: IProformaInvoiceDtl[] = [];
        for (const d of this.proformaInvoiceDtls) {
          const obj: IProformaInvoiceDtl = {
            id: 0,
            mstId: proInveMst.id,
            prodName: d.prodName,
            prodType: d.prodType,
            hsCode: d.hsCode,
            manufacturer: d.manufacturer,
            exchangeRate: d.exchangeRate,
            noOfUnits: d.noOfUnits,
            unitPrice: d.unitPrice,
            packSize: d.packSize,
            totalAmount: d.totalAmount,
            totalPrice: d.totalPrice,
            totalPriceInBdt: d.totalPriceInBdt,
            approvalStatus: null,
            approvedBy: 0,
            remarks: null
          };
          proforInDtlUpdtDto.push(obj);
        }
        this.proformaService.updateProformaInvoiceDtl(proforInDtlUpdtDto, this.piMstId).subscribe(resp => {
          const ProMstDtl = resp as IProformaInvoiceDtl[];
          this.loading = false;
          this.resetPage();
          this.alertify.success('Proforma Invoice updated successfully');
        }, err => {
          console.log(err);
          this.alertify.error('Proforma Invoice update failed');
        });
      }, error => {
        console.log(error);
        this.alertify.error('Proforma Invoice updated successfully');
      });
    }
  }
  getAllProformaInvoiceMstByUser() {
    const importer: IAnnualReqByImporterDto = {
      importerId: 0
    };
    importer.importerId = this.loginService.getUserId();
    this.proformaService.getAllProformaInvoiceMstByUser(importer).subscribe(resp => {
      this.proformaInvoiceMsts = resp as IProformaInvoiceMst[];
      this.openModal(this.proformaInvMstSearchModal);
      if (this.proformaInvoiceMsts.length === 0) {
        this.alertify.warning('No Data Found');
      }
    }, error => {
      console.log(error);
    });
  }
  selectProforma(p: IProformaInvoiceMst) {
    const pDate = new Date(p.proformaDate);
    const sDate = new Date(p.proformaDate);
    let formattedSubmissionDate: any;
    const formattedProformaDate = pDate.getDate() + '/' + (pDate.getMonth() + 1) + '/' + pDate.getFullYear();
    if (p.submissionDate === undefined || p.submissionDate === null) {
      formattedSubmissionDate = p.submissionDate;
    } else {
      formattedSubmissionDate = sDate.getDate() + '/' + (sDate.getMonth() + 1) + '/' + sDate.getFullYear();
    }
    if (p.confirmation === false) {
      this.isSubmitted = false;
      this.updateBtnDisable = false;
      this.submitButtonDisable = false;
    } else if (p.confirmation === true) {
      this.isSubmitted = true;
      this.submitButtonDisable = true;
      this.updateBtnDisable = true;
    }
    this.saveButtonTitle = 'Update';
    this.proformaUpdateMode = true;
    this.piMstId = p.id;
    this.proformaInvoiceForm.get('applicationNo').setValue(p.applicationNo);
    this.proformaInvoiceForm.get('proformaInvoiceNo').setValue(p.proformaInvoiceNo);
    this.proformaInvoiceForm.get('proformaDate').setValue(formattedProformaDate);
    this.proformaInvoiceForm.get('submissionDate').setValue(formattedSubmissionDate);
    this.proformaInvoiceForm.get('countryOfOrigin').setValue(p.countryOfOrigin);
    this.proformaInvoiceForm.get('currency').setValue(p.currency);
    this.proformaInvoiceForm.get('portOfLoading').setValue(p.portOfLoading);
    this.proformaInvoiceForm.get('portOfEntry').setValue(p.portOfEntry);
    this.proformaInvoiceForm.get('piScan').clearValidators();
    this.proformaInvoiceForm.get('piScan').updateValueAndValidity();
    this.proformaInvoiceForm.get('litScan').clearValidators();
    this.proformaInvoiceForm.get('litScan').updateValueAndValidity();
    this.proformaInvoiceForm.get('testReport').clearValidators();
    this.proformaInvoiceForm.get('testReport').updateValueAndValidity();
    this.proformaInvoiceForm.get('otherDoc').clearValidators();
    this.proformaInvoiceForm.get('otherDoc').updateValueAndValidity();
    this.getProformaDtlsByProformaMst(p.id);
    this.modalRef.hide();
  }
  getProformaDtlsByProformaMst(poMstId: number) {
    const proforma: IProformaMstIdDto = {
      proformaMstId: 0
    };
    proforma.proformaMstId = poMstId;
    this.proformaService.getProformaDtlsByProformaMst(proforma).subscribe(resp => {
      this.proformaInvoiceDtls = resp as IProformaInvoiceDtl[];
      if (this.proformaInvoiceDtls.length === 0) {
        this.alertify.warning('No Data Found');
      }
    });
  }
  DownloadPiFile(fname: string) {
    this.fileDownloadInitiated = true;
    return this.http.get(this.baseUrl + 'DownloadPiFile/' + fname, { responseType: 'blob' })
      .subscribe((result: any) => {
        if (result.type !== 'text/plain') {
          const blob = new Blob([result]);
          const saveAs = require('file-saver');
          const file = 'proforma_invoice_' + fname;
          saveAs(blob, file);
          this.fileDownloadInitiated = false;
        } else {
          this.fileDownloadInitiated = false;
          alert('File not found in Blob!');
        }
      }
      );
  }
  DownloadLitFile(fname: string) {
    this.fileDownloadInitiated = true;
    return this.http.get(this.baseUrl + 'DownloadPiFile/' + fname, { responseType: 'blob' })
      .subscribe((result: any) => {
        if (result.type !== 'text/plain') {
          const blob = new Blob([result]);
          const saveAs = require('file-saver');
          const file = 'literature_review_' + fname;
          saveAs(blob, file);
          this.fileDownloadInitiated = false;
        } else {
          this.fileDownloadInitiated = false;
          alert('File not found in Blob!');
        }
      }
      );
  }
  DownloadTestFile(fname: string) {
    this.fileDownloadInitiated = true;
    return this.http.get(this.baseUrl + 'DownloadPiFile/' + fname, { responseType: 'blob' })
      .subscribe((result: any) => {
        if (result.type !== 'text/plain') {
          const blob = new Blob([result]);
          const saveAs = require('file-saver');
          const file = 'test_report_' + fname;
          saveAs(blob, file);
          this.fileDownloadInitiated = false;
        } else {
          this.fileDownloadInitiated = false;
          alert('File not found in!');
        }
      }
      );
  }
  DownloadOtherFile(fname: string) {
    if (fname === '' || fname === undefined || fname === null) {
      this.alertify.warning('No File Found');
    }
    this.fileDownloadInitiated = true;
    return this.http.get(this.baseUrl + 'DownloadPiFile/' + fname, { responseType: 'blob' })
      .subscribe((result: any) => {
        if (result.type !== 'text/plain') {
          const blob = new Blob([result]);
          const saveAs = require('file-saver');
          const file = 'other_doc_' + fname;
          saveAs(blob, file);
          this.fileDownloadInitiated = false;
        } else {
          this.fileDownloadInitiated = false;
          this.alertify.warning('File not found in Blob!');
        }
      }
      );
  }
  submitProformaInvoice() {
    const proMstId: IProformaMstIdDto = {
      proformaMstId: this.piMstId
    };
    this.proformaService.submitProformaInvoice(proMstId).subscribe( resp => {
      const proM = resp as IProformaInvoiceMst[];
      this.resetPage();
      this.alertify.success('Proforma Invoice submitted successfully');
    }, err => {
      this.alertify.success('Proforma Invoice submission failed');
    });
  }
  IsProformaSubmitted(mId: number) {
    let res: ISubmissionResult = {
      IsSubmitted: false
    };
    const proMst: IProformaMstIdDto = {
      proformaMstId: this.piMstId
    };
    this.proformaService.IsProformaSubmitted(proMst).subscribe(resp => {
      res = resp as ISubmissionResult;
    });
    if (res.IsSubmitted === false) {
      return false;
    } else {
      return false;
    }
  }
  resetPage() {
    // this.proformaInvoiceForm.reset();
    this.createProformaInvoiceForm();
    this.proformaInvoiceForm.get('currency').setValue('');
    this.proformaInvoiceForm.get('proformaDate').setValue(this.todayDate);
    // this.proformaInvoiceDtlForm.reset();
    this.createProformaInvoiceDtlForm();
    this.proformaInvoiceDtls = [];
    this.proformaInvoiceMsts = [];
    this.piMstId = null;
    this.totalAmountValidationErrorMsg = false;
    this.totalAmountValidation = {
      annualTotalAmount: 0,
      remainingAmount: 0,
      validationStatus: false,
      proformaTotalAmount: 0
    };
    this.saveButtonTitle = 'Save';
    this.proformaUpdateMode = false;
    this.addMode = false;
    this.editMode = false;
    this.loading = false;
    this.exchngDisabled = true;
    this.updateBtnDisable = false;
    this.submitButtonDisable = true;
    this.isSubmitted = false;
  }
}
interface IProformaInvoiceMst {
  id: number;
  applicationNo: number;
  proformaInvoiceNo: string;
  proformaDate: Date;
  submissionDate: Date;
  currency: string;
  countryOfOrigin: number;
  portOfLoading: string;
  portOfEntry: string;
  piScan: string;
  litScan: string;
  testReport: string;
  otherDoc: string;
  confirmation: boolean;
  importerId: number;
}
interface IProformaInvoiceDtl {
  id: number;
  mstId: number;
  prodName: string;
  prodType: string;
  hsCode: string;
  manufacturer: string;
  packSize: string;
  noOfUnits: number;
  unitPrice: number;
  totalPrice: number;
  totalPriceInBdt: number;
  exchangeRate: number;
  totalAmount: number;
  approvalStatus: boolean;
  approvedBy: number;
  remarks: string;
}
interface ICurrency {
  id: number;
  currency: string;
  exchangeRate: number;
}
interface IAnnualReqByImporterDto {
  importerId: number;
}
interface IProformaMstIdDto {
  proformaMstId: number;
}
interface IAnnualRequirementDtl {
  id: number;
  annReqMstId: number;
  prodName: string;
  prodType: string;
  hsCode: string;
  manufacturer: string;
  countryOfOrigin: string;
  packSize: string;
  tentativeUnits: number;
  unitPrice: number;
  totalPrice: number;
  totalPriceInBdt: number;
  currency: string;
  exchangeRate: number;
  totalAmount: number;
}
interface IAnnualRequirementMst {
  id: number;
  importerId: number;
  submissionDate: string;
  AnnualRequirementDtls: IAnnualRequirementDtl;
}
interface IAnnReqProdDtlsForProforDto {
  productId: number;
  prodName: string;
  prodType: string;
  hsCode: string;
  manufacturer: string;
  packSize: string;
}
interface ProfInvTotalAmtDtoByProdDto {
  importerId: number;
  prodName: string;
  totalAmount: number;
}
interface IProformaInvoiceMstUpdateDto {
  id: number;
  currency: string;
  countryOfOrigin: number;
  portOfLoading: string;
  portOfEntry: string;
}
interface IProfInvDtlUpdtDto {
  mstId: number;
  prodName: string;
  prodType: string;
  hsCode: string;
  manufacturer: string;
  packSize: string;
  noOfUnits: number;
  unitPrice: number;
  totalPrice: number;
  totalPriceInBdt: number;
  exchangeRate: number;
  totalAmount: number;
}
interface IPiTotalAmountValidationDto {
    annualTotalAmount: number;
    proformaTotalAmount: number;
    remainingAmount: number;
    validationStatus: boolean;
}
interface ISubmissionResult{
  IsSubmitted: boolean;
}

