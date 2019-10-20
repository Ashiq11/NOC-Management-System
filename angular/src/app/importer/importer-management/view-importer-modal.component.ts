import { Component, OnInit, ViewChild, Output, EventEmitter } from '@angular/core';
import { ModalDirective } from 'ngx-bootstrap';
import { GetImporterForViewDto } from './importer-management.component';

@Component({
  selector: 'viewImporterModal',
  templateUrl: './view-importer-modal.component.html',
  styleUrls: ['./view-importer-modal.component.css']
})
export class ViewImporterModalComponent {

  @ViewChild('createOrEditModal', { static: false }) modal: ModalDirective;
  @Output() modalSave: EventEmitter<any> = new EventEmitter<any>();

  active = false;
    saving = false;

    item: GetImporterForViewDto;

    constructor(
        
    ) {
        this.item = new GetImporterForViewDto();
    }

    show(item: GetImporterForViewDto): void {
        this.item = item;
        this.active = true;
        this.modal.show();
    }

    close(): void {
        this.active = false;
        this.modal.hide();
    }
}
