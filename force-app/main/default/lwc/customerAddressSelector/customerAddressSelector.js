import { LightningElement, api, track, wire } from 'lwc';
import getAllAddresses from "@salesforce/apex/AdresssLWCController.getAllCustomerAddress";
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getOppRecId from '@salesforce/apex/LWC_Handler.getOppoRecordTypeId';
import { encodeDefaultFieldValues } from 'lightning/pageReferenceUtils';
import { CloseActionScreenEvent } from 'lightning/actions';

export default class CustomerAddressSelector extends NavigationMixin(LightningElement) {

    @api recordId;
    selectedAddressIndex = -1;
    selectedBilAddressIndex = -1;
    @track ship_addresses = [];
    @track bill_addresses = [];
    error;
    @track accRecord;
    @track showRecordTypePage = true;
    @track showAddressPage = false;
    @track selectedValue = '';
    @track dis = true;
     options = [
        { label: 'B2B', value: 'B2B' },
        { label: 'B2C', value: 'B2C' },
    ];
     handleChange(event) {
        const selectedOption = event.detail.value;
        this.selectedValue = selectedOption;
        this.dis = false;
        console.log('Option selected with value: ' + selectedOption);
    }

    handleClick(event)
    {
       this.showRecordTypePage = false;
     // this.showAddressPage = true;
    }
    handleClose(event)
    {
        //this.showAddressPage = false;
        this.closeAction();
    }
    closeAction(){
  this.dispatchEvent(new CloseActionScreenEvent());
}
    
    
    connectedCallback(){
        setTimeout(() => {
            this.getRecordDetails();
        }, 300);
    }

    getRecordDetails(){
        getAllAddresses({custId : this.recordId}).then(data => {
            if(data){
                let clonedData = JSON.parse(JSON.stringify(data));
                this.accRecord = clonedData.account;
                this.ship_addresses = clonedData.customer_ship_addresses;
                this.bill_addresses = clonedData.customer_bill_addresses;
                this.selectedAddressIndex = clonedData.ship_selected_index != undefined ? clonedData.ship_selected_index : -1;
                this.selectedBilAddressIndex = clonedData.bill_selected_index != undefined ? clonedData.bill_selected_index : -1;
                console.log('RecordId', this.recordId);
                console.log('Data',clonedData);
            }
            if(error){
                this.error = error;
                console.log("Errorsss",error);
            }
       })
    }

    /*@wire(getAllAddresses,{ custId : '$recordId'})
    recordDetails({data,error}){
        debugger;
        if(data){
            let clonedData = JSON.parse(JSON.stringify(data));
            this.accRecord = clonedData.account;
            this.ship_addresses = clonedData.customer_ship_addresses;
            this.bill_addresses = clonedData.customer_bill_addresses;
            this.selectedAddressIndex = clonedData.ship_selected_index != undefined ? clonedData.ship_selected_index : -1;
            this.selectedBilAddressIndex = clonedData.bill_selected_index != undefined ? clonedData.bill_selected_index : -1;
            console.log('RecordId', this.recordId);
            console.log('Data',clonedData);
        }
        if(error){
            this.error = error;
            console.log("Errorsss",error);
        }
    }*/

    onAddressSelect(event) {
        debugger;
        let addressId = event.currentTarget.dataset.id;
        let selectedIndex = event.currentTarget.dataset.index;

        if(addressId && selectedIndex) {
            if(this.selectedAddressIndex !== -1)
                this.ship_addresses[this.selectedAddressIndex].checked = false;
            this.ship_addresses[selectedIndex].checked = true;
            this.selectedAddressIndex = selectedIndex;
        }
        
    }

    onBillAddressSelect(event) {
        debugger;
        let addressId = event.currentTarget.dataset.id;
        let selectedIndex = event.currentTarget.dataset.index;

        if(addressId && selectedIndex) {
            if(this.selectedBilAddressIndex !== -1)
                this.bill_addresses[this.selectedBilAddressIndex].checked = false;
            this.bill_addresses[selectedIndex].checked = true;
            this.selectedBilAddressIndex = selectedIndex;
        }
        
    }



    handleNavigate() {
        let index = this.ship_addresses.findIndex((item) => {
            return item.checked === true;
        });

        let billingIndex = this.bill_addresses.findIndex((item) => {
            return item.checked === true;
        });
        if(index === -1 || billingIndex === -1) {
            const evt = new ShowToastEvent({
                title: "No Selection",
                message: "Please select Shipping and Billing address in-order to proceed.",
                variant: "Warning",
            });
            this.dispatchEvent(evt);
            return;
        }

        let selectedAddress = this.ship_addresses[index];
        let addressId = selectedAddress.id;
        let accShipAddress = false;

        let selectedBillingAddress = this.bill_addresses[billingIndex];
        let billAddressId = selectedBillingAddress.id;
        let accountBillAddress = false;
        
        if(selectedAddress.id === 'Shipping') {
            addressId = undefined;
            accShipAddress = true;
        }
        
        if(selectedBillingAddress.id === 'Billing') {
            billAddressId = undefined;
            accountBillAddress = true;
        }
        
    
        this.openCreateRecordForm(addressId, accShipAddress, billAddressId, accountBillAddress);
    }    

    openCreateRecordForm(addressId, accShipAddress, billAddressId, accountBillAddress){
        debugger;
        
        let defaultValues = encodeDefaultFieldValues({
            AccountId : this.accRecord.Id,
            Name : `${this.accRecord.Name} - Opportunity`,
            StageName:'New',
            CurrencyIsoCode:this.accRecord.CurrencyIsoCode,
            Customer_Address__c: addressId,
            Account_Shipping_Address__c: accShipAddress,
            Customer_Billing_Address__c: billAddressId,
            Account_Billing_Address__c: accountBillAddress,
            LeadSource : this.accRecord.AccountSource
        });

        getOppRecId({recordTypeName:this.selectedValue}).then(result=>{
            let recordTypeId = result;

            this[NavigationMixin.Navigate]({
                type: 'standard__objectPage',
                attributes: {
                    objectApiName: 'Opportunity',
                    actionName: 'new'
                },state: {
                    defaultFieldValues: defaultValues,
                    recordTypeId: recordTypeId
                }
            });
        }).catch(error=>{
            console.log('Error----',error);
            this.showNotification('error',error,'error');
        })
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