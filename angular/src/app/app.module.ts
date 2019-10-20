import { BrowserModule } from '@angular/platform-browser';
import {BrowserAnimationsModule} from '@angular/platform-browser/animations';
import { NgModule } from '@angular/core';
import { NgxLoadingModule } from 'ngx-loading';
import { LoginModule } from './login/login.module';
import { RouterModule } from '@angular/router';
import { AppRoutingModule } from './app-routing.module';
import { AppComponent } from './app.component';
import { HttpClientModule } from '@angular/common/http';
import { RegisterService } from './_services/register.service';
import { JwtModule } from '@auth0/angular-jwt';
import { PortalModule } from './portal/portal.module';
import { ImporterRoleGuard } from './_guard/importerRole.guard';
import { PortalRoutingModule } from './portal/portal-routing.module';
import { LoginService } from './_services/login.service';
import { LoginRoutingModule } from './login/login-routing.module';
import { ModalModule, TabsModule, TooltipModule, BsDropdownModule } from 'ngx-bootstrap';
import { FormsModule } from '@angular/forms';
import {  PaginatorModule} from 'primeng/primeng';
import { TableModule } from 'primeng/table';
import { CurrencyService } from './_services/currency.service';
import { AnnualRequirementService } from './_services/annual-requirement.service';
import { AutoCompleteModule } from 'primeng/autocomplete';
import { ServiceProxyModule } from './shared/service-proxies/service-proxy.module';

export function tokenGetter() {
   return localStorage.getItem('token');
}
@NgModule({
   declarations: [
      AppComponent
   ],
   imports: [
      BrowserModule,
      BrowserAnimationsModule,
      NgxLoadingModule.forRoot({}),
      RouterModule,
      HttpClientModule,
      AppRoutingModule,
      //Ashiq -added
      FormsModule,
      ModalModule.forRoot(),
      TabsModule.forRoot(),
		TooltipModule,
      BsDropdownModule.forRoot(),
      TableModule,
     PaginatorModule,
     AutoCompleteModule,
     ServiceProxyModule,
      //
      PortalRoutingModule,
      LoginModule,
      PortalModule,
      LoginRoutingModule,
      PortalRoutingModule,
      ModalModule.forRoot(),
      JwtModule.forRoot({
         config: {
            tokenGetter: tokenGetter,
            whitelistedDomains: ['localhost:5000', 'localhost:41682', 'localhost:2930'],
            blacklistedRoutes: ['localhost:5000/api/auth', 'localhost:41682/api/auth']
         }
      })
   ],
   providers: [RegisterService, ImporterRoleGuard, LoginService, CurrencyService, AnnualRequirementService],
   bootstrap: [
      AppComponent
   ]
})
export class AppModule { }
