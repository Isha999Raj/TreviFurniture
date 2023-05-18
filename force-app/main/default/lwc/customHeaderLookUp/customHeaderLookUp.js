import { LightningElement, api, wire, track } from 'lwc';
import lookUp from '@salesforce/apex/MaterialSpecOnProdController.getSpecRecords';

export default class CustomHeaderLookUp extends LightningElement {
    @api label = 'label';
    @api placeholder = 'search...';
    @api iconName = 'standard:contact';
    @api recordId;
    lstResult = []; 
    searchKey='';   
    isSearchLoading = false; 
    delayTimeout;
    isValueSelected;
    selectedRecord = {}; 

    @wire(lookUp, { searchKey: '$searchKey'})
     searchResult(value) {
         debugger;
        console.log('recordId==',this.recordId);
        console.log('searchKey==',this.searchKey);
        const { data, error } = value; 
        this.isSearchLoading = false;
        if (data) {
             this.hasRecords = data.length == 0 ? false : true;
             this.lstResult = JSON.parse(JSON.stringify(data));
             console.log('lstResult--',this.lstResult);
         }
        else if (error) {
            console.log('(error---> ' + JSON.stringify(error));
         }
    };
       
    handleKeyChange(event) {
        this.isSearchLoading = true;
        window.clearTimeout(this.delayTimeout);
        const searchKey = event.target.value;
        this.delayTimeout = setTimeout(() => {
        this.searchKey = searchKey;
        }, 300);
    }

    toggleResult(event){
        const lookupInputContainer = this.template.querySelector('.lookupInputContainer');
        const clsList = lookupInputContainer.classList;
        const whichEvent = event.target.getAttribute('data-source');
        switch(whichEvent) {
            case 'searchInputField':
                clsList.add('slds-is-open');
               break;
            case 'lookupContainer':
                clsList.remove('slds-is-open');    
            break;                    
           }
    }

    handleRemove(){
        this.searchKey = '';    
        this.selectedRecord = {};
        this.lookupUpdateParenthandler(undefined); 
        this.isValueSelected = false;
    }

    handelSelectedRecord(event){  
        var objId = event.target.getAttribute('data-recid'); 
        this.selectedRecord = this.lstResult.find(data => data.Id === objId); 
        this.lookupUpdateParenthandler(this.selectedRecord); 
        this.handelSelectRecordHelper(); 
    }

    handelSelectRecordHelper(){
        this.template.querySelector('.lookupInputContainer').classList.remove('slds-is-open');
        this.isValueSelected = true;
    }

    lookupUpdateParenthandler(value){
        console.log(value);
        const oEvent = new CustomEvent('lookupupdate',
        { 'detail': {selectedRecord: value}});
        this.dispatchEvent(oEvent);
    }
}