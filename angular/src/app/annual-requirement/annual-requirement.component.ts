import { Component, OnInit, ViewChild, TemplateRef } from '@angular/core';
import { BsModalService, BsModalRef } from 'ngx-bootstrap';
import { FormGroup, FormControl, Validators } from '@angular/forms';
import { CurrencyService } from '../_services/currency.service';
import { AlertifyService } from '../_services/alertify.service';
import { LoginService } from '../_services/login.service';
import { AnnualRequirementService } from '../_services/annual-requirement.service';

@Component({
  selector: 'app-annual-requirement',
  templateUrl: './annual-requirement.component.html',
  styleUrls: ['./annual-requirement.component.css']
})
export class AnnualRequirementComponent implements OnInit {
  @ViewChild('annualReqsModal', { static: false }) annualReqsModal: TemplateRef<any>;
  @ViewChild('taskmodal', { static: false }) requirementmodal: TemplateRef<any>;
  modalRef: BsModalRef;
  annualRequirementsForm: FormGroup;
  currencies: ICurrency[];
  annualRequirements: IAnnualRequirementDtl[] = [];
  modalTitle = '';
  addMode = false;
  editMode = false;
  updateProd: IAnnualRequirementDtl;
  annReqs: IAllAnnualRequirements[] = [];
  updateProdType = '';
  public loading = false;
  p: any = 1;
  constructor(
    private modalService: BsModalService,
    private currencyService: CurrencyService,
    private alertify: AlertifyService,
    private loginService: LoginService,
    private annualRequirementService: AnnualRequirementService
  ) {}

  ngOnInit() {
    this.createAnnualRequirementForm();
    this.getCurrencies();
  }
  createAnnualRequirementForm() {
    this.annualRequirementsForm = new FormGroup({
      prodName: new FormControl('', [
        Validators.required,
        Validators.maxLength(50)
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
      countryOfOrigin: new FormControl('', [
        Validators.required,
        Validators.maxLength(20)
      ]),
      packSize: new FormControl('', [
        Validators.required,
        Validators.maxLength(100)
      ]),
      tentativeUnits: new FormControl('', [
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
      currency: new FormControl('', [Validators.required]),
      exchangeRate: new FormControl('', [Validators.required]),
      totalPrice: new FormControl('', Validators.required),
      totalPriceInBdt: new FormControl('', Validators.required)
    });
  }
  openModal(template: TemplateRef<any>) {
    this.modalRef = this.modalService.show(template, { class: 'modal-lg' });
  }
  openRequireModal(mode: string) {
    if (mode === 'add') {
      this.modalTitle = 'Add Product';
      this.annualRequirementsForm.reset();
    }
    if (mode === 'update') {
      this.modalTitle = 'Update Product';
    }
    this.editMode = false;
    this.addMode = true;
    this.openModal(this.requirementmodal);
  }
  getCurrencies() {
    this.currencyService.getCurrency().subscribe(
      resp => {
        this.currencies = resp as ICurrency[];
        console.log(this.currencies);
      },
      error => {
        console.log(error);
      }
    );
  }
  onCUrrencyChange() {
    const curren = this.annualRequirementsForm.value.currency;
    let exchRate = 0;
    // tslint:disable-next-line: only-arrow-functions
    this.currencies.forEach(function(item, index) {
      if (item.currency === curren) {
        exchRate = item.exchangeRate;
      }
    });
    const unitPrice = this.annualRequirementsForm.value.unitPrice;
    const tentaUnit = this.annualRequirementsForm.value.tentativeUnits;
    const totalPriceInForeignCurrency = unitPrice * tentaUnit;
    const totPriceInBdt = totalPriceInForeignCurrency * exchRate;
    this.annualRequirementsForm.get('exchangeRate').setValue(exchRate);
    this.annualRequirementsForm.get('totalPrice').setValue(totalPriceInForeignCurrency);
    this.annualRequirementsForm.get('totalPriceInBdt').setValue(totPriceInBdt);
  }
  resetCurrency() {
    this.annualRequirementsForm.get('currency').setValue('');
  }
  addUpdateProduct() {
    if (this.addMode === true) {
      const a: IAnnualRequirementDtl = {
        id: 0,
        annReqMstId: 0,
        prodName: this.annualRequirementsForm.value.prodName,
        prodType: this.annualRequirementsForm.value.prodType,
        hsCode: this.annualRequirementsForm.value.hsCode,
        packSize: this.annualRequirementsForm.value.packSize,
        manufacturer: this.annualRequirementsForm.value.manufacturer,
        countryOfOrigin: this.annualRequirementsForm.value.countryOfOrigin,
        tentativeUnits: this.annualRequirementsForm.value.tentativeUnits,
        unitPrice: this.annualRequirementsForm.value.unitPrice,
        totalPrice: this.annualRequirementsForm.value.totalPrice,
        totalPriceInBdt: this.annualRequirementsForm.value.totalPriceInBdt,
        currency: this.annualRequirementsForm.value.currency,
        exchangeRate: this.annualRequirementsForm.value.exchangeRate,
        totalAmount: this.annualRequirementsForm.value.totalAmount
      };
      for (const i of this.annualRequirements) {
        if (i.prodName === a.prodName) {
          this.alertify.warning('duplicate product');
          return false;
        }
      }
      this.annualRequirements.push(a);
      this.modalRef.hide();
      this.annualRequirementsForm.reset();
    }
    if (this.editMode === true) {
      const a: IAnnualRequirementDtl = {
        id: 0,
        annReqMstId: 0,
        prodName: this.annualRequirementsForm.value.prodName,
        prodType: this.annualRequirementsForm.value.prodType,
        hsCode: this.annualRequirementsForm.value.hsCode,
        packSize: this.annualRequirementsForm.value.packSize,
        manufacturer: this.annualRequirementsForm.value.manufacturer,
        countryOfOrigin: this.annualRequirementsForm.value.countryOfOrigin,
        tentativeUnits: this.annualRequirementsForm.value.tentativeUnits,
        unitPrice: this.annualRequirementsForm.value.unitPrice,
        totalPrice: this.annualRequirementsForm.value.totalPrice,
        totalPriceInBdt: this.annualRequirementsForm.value.totalPriceInBdt,
        currency: this.annualRequirementsForm.value.currency,
        exchangeRate: this.annualRequirementsForm.value.exchangeRate,
        totalAmount: this.annualRequirementsForm.value.totalAmount
      };
      this.annualRequirements.find(
        item => item.prodName === this.updateProd.prodName
      ).prodType = a.prodType;
      this.annualRequirements.find(
        item => item.prodName === this.updateProd.prodName
      ).hsCode = a.hsCode;
      this.annualRequirements.find(
        item => item.prodName === this.updateProd.prodName
      ).packSize = a.packSize;
      this.annualRequirements.find(
        item => item.prodName === this.updateProd.prodName
      ).manufacturer = a.manufacturer;
      this.annualRequirements.find(
        item => item.prodName === this.updateProd.prodName
      ).countryOfOrigin = a.countryOfOrigin;
      this.annualRequirements.find(
        item => item.prodName === this.updateProd.prodName
      ).tentativeUnits = a.tentativeUnits;
      this.annualRequirements.find(
        item => item.prodName === this.updateProd.prodName
      ).unitPrice = a.unitPrice;
      this.annualRequirements.find(
        item => item.prodName === this.updateProd.prodName
      ).totalPrice = a.totalPrice;
      this.annualRequirements.find(
        item => item.prodName === this.updateProd.prodName
      ).totalPriceInBdt = a.totalPriceInBdt;
      this.annualRequirements.find(
        item => item.prodName === this.updateProd.prodName
      ).currency = a.currency;
      this.annualRequirements.find(
        item => item.prodName === this.updateProd.prodName
      ).exchangeRate = a.exchangeRate;
      this.annualRequirements.find(
        item => item.prodName === this.updateProd.prodName
      ).totalAmount = a.totalAmount;
      this.annualRequirements.find(
        item => item.prodName === this.updateProd.prodName
      ).prodName = a.prodName;
      this.modalRef.hide();
      this.annualRequirementsForm.reset();
    }
  }
  removeProduct(p: IAnnualRequirementDtl) {
    const result = confirm('are you sure want to remove?');
    if (result === true) {
      for (let i = 0; i < this.annualRequirements.length; i++) {
        if (this.annualRequirements[i].prodName === p.prodName) {
          this.annualRequirements.splice(i, 1);
        }
      }
    } else {
      return;
    }
  }
  editProduct(p: IAnnualRequirementDtl) {
    this.updateProd = p;
    this.annualRequirementsForm.setValue({
      prodName: p.prodName,
      prodType: p.prodType,
      hsCode: p.hsCode,
      packSize: p.packSize,
      manufacturer: p.manufacturer,
      countryOfOrigin: p.countryOfOrigin,
      tentativeUnits: p.tentativeUnits,
      unitPrice: p.unitPrice,
      totalPrice: p.totalPrice,
      totalPriceInBdt: p.totalPriceInBdt,
      currency: p.currency,
      exchangeRate: p.exchangeRate,
      totalAmount: p.totalAmount
    });
    this.openRequireModal('update');
    this.editMode = true;
    this.addMode = false;
  }
  saveAnnualRequirement() {
    this.loading = true;
    if (this.annualRequirements.length < 1) {
      this.loading = false;
      this.alertify.warning('No Product to save');
      return false;
    }
    const impId = this.loginService.getUserId();
    const today = new Date();
    const dd = String(today.getDate()).padStart(2, '0');
    const mm = String(today.getMonth() + 1).padStart(2, '0');
    const yyyy = today.getFullYear();

    const currentDate = mm + '-' + dd + '-' + yyyy;
    const annReqMst: IAnnualRequirementMst = {
      id: 0,
      importerId: impId,
      submissionDate: currentDate
    };
    this.annualRequirementService.saveAnnualRequirementMst(annReqMst).subscribe(
      resp => {
        const annualReqMst = resp as IAnnualRequirementMst;
        let annReqDtls: IAnnualRequirementDtl[] = [];
        // tslint:disable-next-line: prefer-for-of
        for (let i = 0; i < this.annualRequirements.length; i++) {
          const obj: IAnnualRequirementDtl = {
            id: 0,
            annReqMstId: annualReqMst.id,
            prodName: this.annualRequirements[i].prodName,
            prodType: this.annualRequirements[i].prodType,
            hsCode: this.annualRequirements[i].hsCode,
            manufacturer: this.annualRequirements[i].manufacturer,
            countryOfOrigin: this.annualRequirements[i].countryOfOrigin,
            packSize: this.annualRequirements[i].packSize,
            tentativeUnits: this.annualRequirements[i].tentativeUnits,
            unitPrice: this.annualRequirements[i].unitPrice,
            totalPrice: this.annualRequirements[i].totalPrice,
            totalPriceInBdt: this.annualRequirements[i].totalPriceInBdt,
            currency: this.annualRequirements[i].currency,
            exchangeRate: this.annualRequirements[i].exchangeRate,
            totalAmount: this.annualRequirements[i].totalAmount
          };
          annReqDtls.push(obj);
        }
        this.annualRequirementService
          .saveAnnualRequirementDtl(annReqDtls)
          .subscribe(
            response => {
              const annualReqDtl = response as IAnnualRequirementDtl[];
              this.loading = false;
              this.alertify.success('Annual Requirement Submission successful');
              this.annualRequirements = [];
              annReqDtls = [];
            },
            err => {
              this.alertify.error('Annual Requirement Submission Failed');
              console.log(err);
            }
          );
      },
      error => {
        this.alertify.error('Annual Requirement Submission Failed');
        console.log(error);
      }
    );
  }
  searchAnnualRequirements() {
    this.loading = true;
    const imp = this.loginService.getUserId();
    const importer: IImporterForAnnReqDto = {
      importerId: imp
    };
    this.annualRequirementService.searchAnnualRequirements(importer).subscribe(resp => {
      this.annReqs = resp as IAllAnnualRequirements[];
      this.openModal(this.annualReqsModal);
      this.loading = false;
      console.log(this.annReqs);
    }, err => {
      this.loading = false;
      this.alertify.warning('No data found');
      console.log(err);
    });
  }
}

interface ICurrency {
  id: number;
  currency: string;
  exchangeRate: number;
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
}
interface IAllAnnualRequirements {
  id: number;
  importerId: number;
  submissionDate: Date;
  annualRequirementDtls: IAnnualRequirementDtl[];
}
interface IImporterForAnnReqDto {
  importerId: number;
}