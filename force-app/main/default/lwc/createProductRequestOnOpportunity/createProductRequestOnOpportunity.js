import { LightningElement,api,wire,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import getRecordDetails from '@salesforce/apex/LWC_Handler.getAccRecord';
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class CreateProductRequestOnOpportunity extends NavigationMixin(LightningElement) {

    @api recordId;
    @track accRecord;

    connectedCallback(){
        setTimeout(() => {
            this.getRecordDetails();
        }, 300);
    }

    getRecordDetails(){
        getRecordDetails({accId : this.recordId}).then(data => {
            if(data){
                this.accRecord = data;
                console.log('RecordId', this.recordId);
                console.log('Data',data);
                this.openCreateRecordForm();
            }
            if(error){
                console.log("Errorsss",error);
            }
       })
    }

    openCreateRecordForm(){
        debugger;
        
        let defaultValues = encodeDefaultFieldValues({
            Account__c : this.accRecord.AccountId,
            Opportunity__c :this.accRecord.Id
        });

        this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'New_Product_Price_request__c',
                actionName: 'new'
            },state: {
                defaultFieldValues: defaultValues
            }
        });
    }

    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

}