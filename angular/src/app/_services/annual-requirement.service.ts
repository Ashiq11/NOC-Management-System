import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { JwtHelperService } from '@auth0/angular-jwt';
import {map} from 'rxjs/operators';
// import { environment } from 'src/environments/environment.prod';
import { environment } from 'src/environments/environment';

@Injectable({
  providedIn: 'root'
})
export class AnnualRequirementService {
  baseUrl = environment.apiUrl + 'AnnualRequirement/';
  jwtHelper = new JwtHelperService();
  decodedToken: any;
  constructor(private http: HttpClient) { }
  saveAnnualRequirementMst(model: any) {
    return this.http.post(this.baseUrl + 'SaveAnnualRequirementMst', model);
  }
  saveAnnualRequirementDtl(model: any) {
      return this.http.post(this.baseUrl + 'SaveAnnualRequirementDtl', model);
  }
  searchAnnualRequirements(model: any) {
    return this.http.post(this.baseUrl + 'GetAnnualRequirementsByImporter', model);
  }
  }
