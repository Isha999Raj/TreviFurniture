import { LightningElement,wire,api,track} from 'lwc';
import savePDF from '@salesforce/apex/DeliveryChallanVFController.savePDF'
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import challanLink from '@salesforce/label/c.Opp_International_Link'; 

export default class GenerateProformaInvoicePDF extends LightningElement {

    @api recordId;
    @track urlUsed;
       
    connectedCallback(){
       this.urlUsed = challanLink + this.recordId;
    }

    savePDF(){
        savePDF({url:this.urlUsed,id:this.recordId,fileName:"FILE"}).then(result => {
            console.log("JADSJKHKDHSD",result);
            this.showNotification('Success','Your performa invoice generated successfully','success');
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