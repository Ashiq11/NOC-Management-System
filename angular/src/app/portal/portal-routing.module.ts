import {NgModule} from '@angular/core';
import {Routes, RouterModule} from '@angular/router';
import { PortalComponent } from './portal.component';
import { ImporterDashboardComponent } from '../importer-dashboard/importer-dashboard.component';
import { ImporterRoleGuard } from '../_guard/importerRole.guard';
import { AdminDashboardComponent } from '../admin-dashboard/admin-dashboard.component';
import { PageNotFoundComponent } from '../page-not-found/page-not-found.component';
import { AnnualRequirementComponent } from '../annual-requirement/annual-requirement.component';
import { ProformaInvoiceComponent } from '../proforma-invoice/proforma-invoice.component';
import { EmployeesComponent } from '../employee/create-employee/employees.component';
import { CreateEditEmployeeModalComponent } from '../employee/create-employee/create-edit-employee-modal.component';
import { ImporterManagementComponent } from '../importer/importer-management/importer-management.component';
import { RoleManagementComponent } from '../role-management/role-management.component';


const potalRoutes: Routes = [
    {
        path: 'portal',
        component: PortalComponent,
        children: [
            {path: '', redirectTo: 'importer', pathMatch: 'full'},
            {path: 'importer', component: ImporterDashboardComponent, canActivate: [ImporterRoleGuard]},
            {path: 'admin', component: AdminDashboardComponent},
            { path: 'pagenotfound', component: PageNotFoundComponent },
            {path: 'annualrequirement', component: AnnualRequirementComponent, canActivate: [ImporterRoleGuard]},
            {path: 'proformainvoice', component: ProformaInvoiceComponent, canActivate: [ImporterRoleGuard]},
            {path: 'createemployee', component: CreateEditEmployeeModalComponent},
            {path: 'employee', component: EmployeesComponent},
            {path: 'importermanagement', component: ImporterManagementComponent},
            {path: 'rolemanagement', component: RoleManagementComponent}
        ]
    }
];
@NgModule({
    imports: [RouterModule.forChild(potalRoutes)],
    exports: [RouterModule]
})
export class PortalRoutingModule {}
