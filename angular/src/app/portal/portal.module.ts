import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { HttpClientModule } from '@angular/common/http';
import { NgxLoadingModule } from 'ngx-loading';
import {NgxPaginationModule} from 'ngx-pagination';
import { PortalComponent } from './portal.component';
import { PortalRoutingModule } from './portal-routing.module';
import { AdminDashboardComponent } from '../admin-dashboard/admin-dashboard.component';
import { ImporterDashboardComponent } from '../importer-dashboard/importer-dashboard.component';
import { PageNotFoundComponent } from '../page-not-found/page-not-found.component';
import { AnnualRequirementComponent } from '../annual-requirement/annual-requirement.component';
import { ModalModule, TabsModule, TooltipModule, BsDropdownModule } from 'ngx-bootstrap';
import { FormsModule, ReactiveFormsModule } from '@angular/forms';
import { EmployeesComponent } from '../employee/create-employee/employees.component';
import { CreateEditEmployeeModalComponent } from '../employee/create-employee/create-edit-employee-modal.component';
import { PaginatorModule } from 'primeng/primeng';
import { TableModule } from 'primeng/table';
import { ProformaInvoiceComponent } from '../proforma-invoice/proforma-invoice.component';
import { ViewEmployeeModalComponent } from '../employee/create-employee/view-employee-modal-component.component';
import { ImporterManagementComponent } from '../importer/importer-management/importer-management.component';
import { ViewImporterModalComponent } from '../importer/importer-management/view-importer-modal.component';
import { RoleManagementComponent } from '../role-management/role-management.component';
import { RoleComponent } from '../role-management/role/role.component';
import { UserRoleAssignComponent } from '../role-management/user-role-assign/user-role-assign.component';
import { CreateEditRoleModalComponent } from '../role-management/role/create-edit-role-modal.component';
import { CreateEditUserRoleAssignModalComponent } from '../role-management/user-role-assign/create-edit-user-role-assign-modal.component';
import { UserLookupTableModalComponent } from '../lookUpTabelModals/user-lookup-table-modal.component';
import { RoleLookupTableModalComponent } from '../lookUpTabelModals/role-lookup-table-modal.component';

@NgModule({
  imports: [
    CommonModule,
    //Ashiq added
    FormsModule,
    ReactiveFormsModule,
    ModalModule,
		TabsModule,
		TooltipModule,
    BsDropdownModule.forRoot(),
    TableModule,
    PaginatorModule,

    //
    HttpClientModule,
    PortalRoutingModule,
    ReactiveFormsModule,
    NgxLoadingModule,
    NgxPaginationModule
  ],
  declarations: [
    PortalComponent,
    AdminDashboardComponent,
    ImporterDashboardComponent,
    PageNotFoundComponent,
    AnnualRequirementComponent,
    CreateEditEmployeeModalComponent,
    EmployeesComponent,
    ViewEmployeeModalComponent,
    ProformaInvoiceComponent,
    ImporterManagementComponent,
    ViewImporterModalComponent,
    RoleManagementComponent,
    RoleComponent,
    UserRoleAssignComponent,
    CreateEditRoleModalComponent,
    CreateEditUserRoleAssignModalComponent,
    UserLookupTableModalComponent,
    RoleLookupTableModalComponent
  ],
  providers: []
})
export class PortalModule { }
