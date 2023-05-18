import { LightningElement,api,wire,track } from 'lwc';
import getAllFields from '@salesforce/apex/DynamicRecordEditFormController.getApiName';
import insertPBE from '@salesforce/apex/DynamicRecordEditFormController.insertPBE';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { CloseActionScreenEvent } from 'lightning/actions';
export default class CreateProductOnProductRequest extends NavigationMixin(LightningElement) {
    @api recordId; 
    @api prodId;
    @track fieldList = [];

    @wire(getAllFields)
    wireMapData({error, data}) {
        if (data) {
            console.log(data);
            this.fieldList = data;
            console.log('fieldList -- ', this.fieldList);
        } else if (error) {
            this.error = error;
        }
    }

    handleSuccess(event) {
        debugger;
        console.log(this.fieldList);
        this.prodId = event.detail.id;
        insertPBE({prodId : event.detail.id, reqId : this.recordId}).then(result => {
            if(result){
                console.log('Result -->',result);
                console.log('event.detail.id -- ', event.detail.id);
                this.showNotification('Success!', 'The record has been successfully saved.', 'success');   
                this.navigateToViewProductPage();
            }
        }).catch(error=>{
            console.log("Error",error);
            this.showNotification('Error',error.body.message,'error');
        });               
        //this.closeAction();
    }

    handleError() {
        debugger;
        this.showNotification('Error!', 'An error occurred while attempting to save the record.', 'error');
        this.closeAction();
    }

    showNotification(title,message,variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }

    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    navigateToViewProductPage() {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: this.prodId,
                objectApiName: 'Product2',
                actionName: 'view'
            },
        });
    }

}