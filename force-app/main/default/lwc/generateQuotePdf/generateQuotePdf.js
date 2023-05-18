import { LightningElement,api,wire,track } from 'lwc';
import savePDF from '@salesforce/apex/ProductController.savePDF'
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import QuotePdfLink from '@salesforce/label/c.QuotePdfLink'; 
export default class GenerateQuotePdf extends LightningElement {
 
 @api recId;
    @track urlUsed;
       
    connectedCallback(){
        debugger;
       this.urlUsed = QuotePdfLink + this.recId;
    }

    savePDF(){
        savePDF({url:this.urlUsed,id:this.recId,fileName:"FILE"}).then(result => {
            console.log("JADSJKHKDHSD",result);
            this.showNotification('Success','Your Quote generated successfully','success');
            this.closeAction();
        }).catch(error=>{
            console.log("Error",error);
        });
    }

    closeAction(){
        this.dispatchEvent(new CloseActionScreenEvent());
    }

    showNotification(title,message,variant){
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant
        });
        this.dispatchEvent(evt);
    }



}