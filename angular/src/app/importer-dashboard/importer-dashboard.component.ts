import { Component, OnInit } from '@angular/core';
import { LoginService } from '../_services/login.service';
import { AlertifyService } from '../_services/alertify.service';
import { Router } from '@angular/router';
import { $ } from 'protractor';

@Component({
  selector: 'app-importer-dashboard',
  templateUrl: './importer-dashboard.component.html',
  styleUrls: ['./importer-dashboard.component.css']
})
export class ImporterDashboardComponent implements OnInit {
  constructor(private alertify: AlertifyService, private router: Router) { }

  ngOnInit() {
  }
  logout() {
    localStorage.removeItem('token');
    this.alertify.message('logged out');
    this.router.navigate(['/login']);
  }
}

