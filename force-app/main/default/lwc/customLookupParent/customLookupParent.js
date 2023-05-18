import { LightningElement,api,wire,track } from 'lwc';
import getCurrentRecordId from '@salesforce/apex/TransferWarehouseProducts.getCurrentRecordId';
export default class CustomLookupParent extends LightningElement { 
    @api recordId;
    @api recId ; 
    @api showProductWareHouse ;
    handleLookupSelection(event){
        debugger;
        if(event.detail.selectedRecord != undefined){
            console.log('Selected Record Value on Parent Component is ' +  
            JSON.stringify(event.detail.selectedRecord));
            alert(event.detail.selectedRecord.Id + ' '+ event.detail.selectedRecord.Name);
            console.log('NAME--->',event.detail.selectedRecord.Name)
           this.recId =  event.detail.selectedRecord.Id;
           console.log(' this.recId---->', this.recId);
        }
    }
    handleClick(event)
        {
            debugger;
            console.log('recId--',this.recId);
            this.showProductWareHouse = true;
        }
}