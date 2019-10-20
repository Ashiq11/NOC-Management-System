import {Injectable} from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
// import { environment } from 'src/environments/environment.prod';
import { environment } from 'src/environments/environment';

@Injectable({
    providedIn: 'root'
})
export class RegisterService {
    baseUrl = environment.apiUrl + 'Auth/';
    constructor( private http: HttpClient) {}
    register(model) {
        return this.http.post(this.baseUrl + 'RegisterImporter', model, {
            headers: new HttpHeaders({
                Accept : '*/*'
              })
        });
    }
    UploadImporterFile(formData: FormData, id: number) {
        console.log(formData);
        return this.http.post(this.baseUrl + 'UploadImporterFile/' + id, formData);
    }
}
