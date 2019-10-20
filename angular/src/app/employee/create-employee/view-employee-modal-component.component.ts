import { Component, ViewChild, EventEmitter, Output } from '@angular/core';
import { CreateOrEditEmployeeDto } from './create-edit-employee-modal.component';
import { ModalDirective } from 'ngx-bootstrap';

@Component({
  selector: 'viewEmployeeModal',
  templateUrl: './view-employee-modal-component.component.html',
  styleUrls: ['./view-employee-modal-component.component.css']
})
export class ViewEmployeeModalComponent {

  @ViewChild('createOrEditModal', { static: true }) modal: ModalDirective;
  @Output() modalSave: EventEmitter<any> = new EventEmitter<any>();

  active = false;
    saving = false;

    item: CreateOrEditEmployeeDto;

    constructor(
        
    ) {
        this.item = new CreateOrEditEmployeeDto();
    }

    show(item: CreateOrEditEmployeeDto): void {
        this.item = item;
        this.active = true;
        this.modal.show();
    }

    close(): void {
        this.active = false;
        this.modal.hide();
    }
}

