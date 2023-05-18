import { LightningElement, track, wire, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAllSpecs from '@salesforce/apex/MaterialSpecOnProdController.getAllSpecs';
import { CloseActionScreenEvent } from 'lightning/actions';
import { NavigationMixin } from 'lightning/navigation';

export default class CreateMaterialSpecOnProduct extends LightningElement {

    @api recordId;
    @api recId ;

    handleLookupSelection(event){
        debugger;
        if(event.detail.selectedRecord != undefined){
            console.log('Selected Record Value on Parent Component is ' +  
            JSON.stringify(event.detail.selectedRecord));
            alert(event.detail.selectedRecord.Id + ' '+ event.detail.selectedRecord.Header__c);
            console.log('NAME--->',event.detail.selectedRecord.Header__c)
            this.recId =  event.detail.selectedRecord.Id;
            console.log(' this.recId---->', this.recId);
        }
    }

    /*@api recordId;
    @track specList = [{
        Quantity : '',
        UnitPrice : '',
        Product2Id : '',
        ProductCode : ''

    }];
    @track keyIndex = 0;
    value = '';

    connectedCallback(){
        setTimeout(() => {
            debugger;
            this.getRecordDetails();
        }, 300);
    }

    getRecordDetails(){
        getAllSpecs({}).then(data => {
            debugger;
            if(data){
                console.log('RecordId', this.recordId);
                console.log('Data',data);
            }
            if(error){
                console.log("Errorsss",error);
            }
       })
    }

    addRow() {
        this.keyIndex+1;
        this.oppProdList.push({
            Quantity : '',
            Plant__c : '',
            UnitPrice : '',
            Product2Id : '',
            ProductCode : ''
        });
    }

    removeRow(event) {

        if (this.oppProdList.length > 1) {
            this.oppProdList.splice(event.target.accessKey,1);
            this.keyIndex-1;
        }
    }

    handleChange(event) {
        debugger;
        if (event.target.name === 'Qty') {
            this.oppProdList[event.target.accessKey].Quantity = event.target.value;
        }
        else if (event.target.name === 'plant') {
            this.oppProdList[event.target.accessKey].Plant__c = event.target.value;
        }
        else if (event.target.name === 'unitPrice') {
            this.oppProdList[event.target.accessKey].UnitPrice = event.target.value;
        }
    }

    doSubmit() {
        debugger;
        var oppProdListss = this.oppProdList;
        var oppProductList= [];
        for(var i in oppProdListss){
            oppProductList.push({
            OpportunityId: this.oppId,
            Product2Id: oppProdListss[i].Product2Id,
            Quantity : oppProdListss[i].Quantity,
            UnitPrice : oppProdListss[i].UnitPrice,
            Plant__c : oppProdListss[i].Plant__c
            });
            if(this.prvsPrice != 'undefined' && this.prvsPrice != ''){
                if(this.prvsPrice > oppProdListss[i].UnitPrice){
                    this.doApproval = true;
                }
                else if(this.prvsPrice < oppProdListss[i].UnitPrice){
                    this.sendEmail = true;
                }

            }

        }

    saveOppLineItem({oppProductList : JSON.stringify(oppProductList), currencyCode : this.curr, soId : this.soId, doApproval : this.doApproval, sendEmail : this.sendEmail}).then(result => {
            if(result){
                console.log('Result -->',result);
                this.showNotification('Success','Opportunity Line Items are created successfully!!','success');
                this.closeAction();
            }
       }).catch(error=>{
            console.log("Error",error);
            this.showNotification('Error',error.body.message,'error');
        });
    }
    
    handleProdSelection(event){
        debugger;
        console.log("the selected record id is -- " + event.detail.index);
        this.oppProdList[event.detail.index].Product2Id = event.detail.selectedId;
        this.oppProdList[event.detail.index].ProductCode = event.detail.code;        
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
    }*/
}