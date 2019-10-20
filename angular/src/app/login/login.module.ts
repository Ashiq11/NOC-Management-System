import { NgModule } from '@angular/core';
import { NgxLoadingModule } from 'ngx-loading';
import { CommonModule } from '@angular/common';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { BsDropdownModule } from 'ngx-bootstrap/dropdown';
import { LoginComponent } from './login.component';
import { LoginRoutingModule } from './login-routing.module';
import { RegisterComponent } from '../register/register.component';
import { HttpClientModule } from '@angular/common/http';

@NgModule({
  imports: [
    CommonModule,
    NgxLoadingModule.forRoot({}),
    FormsModule,
    ReactiveFormsModule,
    HttpClientModule,
    LoginRoutingModule,
    BsDropdownModule.forRoot(),
  ],
  declarations: [
    LoginComponent,
    RegisterComponent
  ]
})
export class LoginModule { }
