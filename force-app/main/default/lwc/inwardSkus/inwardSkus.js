import { LightningElement, api, wire, track } from 'lwc';
import getTransferredSKUs from '@salesforce/apex/InwardSKUs_Controller.getTransferredSKUs'; //
import SaveTransferLogDetails from '@salesforce/apex/InwardSKUs_Controller.SaveTransferLogDetails';
import modal from "@salesforce/resourceUrl/modal";
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { loadStyle } from "lightning/platformResourceLoader";

export default class InwardSkus extends LightningElement {

connectedCallback() {
loadStyle(this, modal);
}
    @api recordId;

    @track transferredLogData = [];

    @track totalPagesize;
    @track disablePrev = false;
    @track disableNext = false;
    @track tempListFirstIndex;
    @track tempListLastIndex;
    @track pagenumberforPagination = 1;
    @track searchKey;

    @wire(getTransferredSKUs, { WarehousetansferedlogID: '$recordId' })
    wireResponse(data, error) {
        debugger;
        if (data) {

            if (data.data != undefined) {
                if (Array.isArray(data.data)) {
                    if (data.data.length > 0) {
                        this.transferredLogData = data.data;
                        this.OnloadListArrangement(this.transferredLogData);
                        //setTimeout(() => this.template.querySelector('c-custom-pagination').setPagination(10));

                        /*if (Number.isInteger(this.transferredLogData.length)) {
                            this.totalPagesize = this.transferredLogData.length;
                        }
                        else {
                            this.totalPagesize = Math.ceil(this.transferredLogData.length);
                        }
                        var tempList= [];
                        if (this.transferredLogData.length > 0 && this.transferredLogData.length < 10) {
                            for (var i = 0; i < this.transferredLogData.length; i++) {
                                tempList.push(this.transferredLogData[i]);
                            }
                        }
                        else if (this.transferredLogData.length > 10) {
                            for (var i = 0; i < 10; i++) {
                                tempList.push(this.transferredLogData[i]);
                            }
                        }

                        this.pageRecordsToDisplay = tempList;
                        this.tempListFirstIndex = tempList.length-10;
                        this.tempListLastIndex = tempList.length;
                        if(this.pagenumberforPagination == 1){
                            this.disablePrev = true;
                        }if(this.pagenumberforPagination == this.totalPagesize){
                            this.disableNext = true;
                        }*/
                    }
                }

            }

        }
        else if (error) {

        }
    }

    OnloadListArrangement(completeList){
        debugger;
        if (Number.isInteger(completeList.length)) {
            this.totalPagesize = completeList.length;
        }
        else {
            this.totalPagesize = Math.ceil(completeList.length);
        }
        var tempList= [];
        if (completeList.length > 0 && completeList.length < 10) {
            for (var i = 0; i < completeList.length; i++) {
                tempList.push(completeList[i]);
            }
        }
        else if (completeList.length > 10) {
            for (var i = 0; i < 10; i++) {
                tempList.push(completeList[i]);
            }
        }

        this.pageRecordsToDisplay = tempList;
        this.tempListFirstIndex = tempList.length-10;
        this.tempListLastIndex = tempList.length;
        if(this.pagenumberforPagination == 1){
            this.disablePrev = true;
        }if(this.pagenumberforPagination == this.totalPagesize){
            this.disableNext = true;
        }

    }

    handleNext(event){
        debugger;
        var tempListForPagination = [];
        if(this.tempListLastIndex < this.transferredLogData.length){
            if((this.transferredLogData.length - this.tempListLastIndex) > 10){
                for(var i = this.tempListLastIndex; i<this.tempListLastIndex+10; i++){
                    tempListForPagination.push(this.transferredLogData[i]);
                }
            }
            else if((this.transferredLogData.length - this.tempListLastIndex) < 10){
                for(var i = this.tempListLastIndex; i<this.tempListLastIndex+(this.transferredLogData.length - this.tempListLastIndex); i++){
                    tempListForPagination.push(this.transferredLogData[i]);
                }
            }
            this.tempListFirstIndex = this.tempListLastIndex;
            this.tempListLastIndex = this.tempListLastIndex +10;
            this.pageRecordsToDisplay = tempListForPagination;
            
            this.pagenumberforPagination = pagenumberforPagination++;
            if (this.pagenumberforPagination == 1) {
                this.disablePrev = true;
            } if (this.pagenumberforPagination == this.totalPagesize) {
                this.disableNext = true;
            }
        }


    }

    handlePrevious(event){
        debugger;
        var tempListForPagination = [];
        for(var i = this.tempListFirstIndex-10; i<this.tempListFirstIndex; i++){
            tempListForPagination.push(this.transferredLogData[i]);
        }
        this.tempListFirstIndex = this.tempListFirstIndex-10;
        this.tempListLastIndex = this.tempListFirstIndex;
        this.pageRecordsToDisplay = tempListForPagination;

        this.pagenumberforPagination = pagenumberforPagination--;
        if (this.pagenumberforPagination == 1) {
            this.disablePrev = true;
        } if (this.pagenumberforPagination == this.totalPagesize) {
            this.disableNext = true;
        }

    }

    handleSaveRecord(event){
        var transferSKUsForapex = [];
        for(var i=0; i<this.transferredLogData.length; i++){
            delete this.transferredLogData[i].product__r;
            delete this.transferredLogData[i].Warehouse_Transfer_Log__r;
            transferSKUsForapex.push(this.transferredLogData[i]);

        }
        debugger;
        SaveTransferLogDetails({ TransferredSKUs:transferSKUsForapex })
            .then(result => {
                if(result == 'SUCCESS'){
                    this.closeModal();
                    this.showToast('Updated', 'Transfer SKUs Have been updated Successfully', 'SUCCESS');
                }
            })
            .catch(error => {
                this.error = error;
            });

    }
    handleDismiss(){
        this.closeModal();
    }

    closeModal() {
        this.dispatchEvent(new CloseActionScreenEvent());
    }
    showToast(Toasttitle, Toastmessage, ToastOutput ) {
        debugger;
        const event = new ShowToastEvent({
            title: Toasttitle,
            message: Toastmessage,
            variant: ToastOutput,
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }


    pageRecordsToDisplay = [];
    paginationCallback(event) {
        this.pageRecordsToDisplay = event.detail.recordToDisplay;
    }

    handleRecQuanChange(event) {
        debugger;
        var name = event.target.name;
        var currenttypedvalue = event.detail.value;
        var currentRecId = event.target.dataset.id;

        /*var element = this.transferredLogData.find(ele  => ele.Id === event.target.dataset.id);
        element['Recieved_Quantity__c'] = event.target.value;
        this.transferredLogData = [...this.transferredLogData];
        console.log(JSON.stringify(this.transferredLogData));*/

        let tempFieldWrapperArray = this.transferredLogData.map(element => Object.assign({}, element));
        //console.log('onRecordEditFormLoad running: tempFieldWrapperArray',JSON.stringify(tempFieldWrapperArray));

        let tempInputFieldArray = [];
        this.template.querySelectorAll('lightning-input-field').forEach(inputField => {
            tempInputFieldArray.push({ "fieldName": inputField.fieldName, "value": inputField.value });
        });
        console.log('onRecordEditFormLoad running: tempInputFieldArray', JSON.stringify(tempInputFieldArray));

        tempFieldWrapperArray.forEach(fieldWrapper => {
            var element = this.transferredLogData.find(ele  => ele.Id === event.target.dataset.id);
            if (element) {
                if(name=='input1')
                {
                   fieldWrapper.Recieved_Quantity__c = event.detail.value;
                }
                else{ 
                fieldWrapper.Remarks__c = event.detail.value; //new changes
                }
                console.log('fieldWrapper====>',fieldWrapper);
            }
        });
        this.transferredLogData = tempFieldWrapperArray;
        console.log(JSON.stringify(this.transferredLogData));

    }

    handleKeyChange(event){
        debugger;
        var tempSearchList = [];
        var tempCompleteList = this.transferredLogData;
        this.searchKey = event.target.value;
        const searchKey = event.target.value.toLowerCase();  
        console.log( 'Search Key is ' + searchKey );
 
        if ( searchKey ) {  
            this.records = this.transferredLogData;
 
             if ( this.records ) {
                let recs = [];
                 for (let rec of this.records) {

                     if ((rec.Product__r.Name).toLowerCase().includes(searchKey)) {
                         recs.push(rec);
                         //break;
                     }

                     console.log('Rec is ' + JSON.stringify(rec));
                     /*let valuesArray = Object.values( rec );
                     console.log( 'valuesArray is ' + valuesArray );
                     for ( let val of valuesArray ) {
                         if ( val ) {
                             if ( val.toLowerCase().includes( searchKey ) ) {
                                 recs.push( rec );
                                 break;
                             }
                         }
                     }*/
                 }
                console.log( 'Recs are ' + JSON.stringify( recs ) );
                tempSearchList = recs;
                this.OnloadListArrangement(tempSearchList);
             }
        }  else {
            this.OnloadListArrangement(tempCompleteList);
           // this.pageRecordsToDisplay = tempCompleteList;
        }

    }

}