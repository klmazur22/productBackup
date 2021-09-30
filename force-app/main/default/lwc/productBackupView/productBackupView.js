import { LightningElement, wire, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getProductBackupInfo from '@salesforce/apex/ProductBackupController.getProductBackupInfo';
import getRelatedProductInfo from '@salesforce/apex/ProductBackupController.getRelatedProductInfo';

export default class ProductBackupView extends LightningElement {
    @api recordId;

    @track backup;
    @track product;
    falseVariable = false;//SF bug: "hour12" attribute works properly only with variable

    @wire(getProductBackupInfo, { productBackupRecordId: '$recordId' })
    wiredBackup(result) {
        let { data, error } = result;
        if (data) {
            this.backup = data;
        } else if (error) {
            this.backup = undefined;
            const event = new ShowToastEvent({
                "title": "Error",
                "message": "Error ocurred: " + error.body.message,
                variant: 'error'
            });
            this.dispatchEvent(event);
        }
    }
    
    @wire(getRelatedProductInfo, { productBackupRecordId: '$recordId' })
    wiredProduct(result) {
        let { data, error } = result;
        if (data) {
            this.product = data;
        } else if (error) {
            this.product = undefined;
            const event = new ShowToastEvent({
                "title": "Error",
                "message": "Failed to find related product: " + error.body.message,
                variant: 'error'
            });
            this.dispatchEvent(event);
        }
    }
}