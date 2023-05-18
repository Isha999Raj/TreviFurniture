/**
 * Author: DeaGle
 */
public without sharing class AdresssLWCController {
    
    @AuraEnabled
    public static Map<String, Object> getAllCustomerAddress(String custId){
        try {
            Map<String, Object> returnWrapperMap = new Map<String, Object>();
            List<CustomerAddressWrapper> customerShippingAddressWrapper = new List<CustomerAddressWrapper>();
            List<CustomerAddressWrapper> customerBillingAddressWrapper = new List<CustomerAddressWrapper>();
            System.debug('--- custId'+custId);
            if(!String.isBlank(custId)) {
                Account customerAcc = [SELECT Id, Name, BillingState, BillingStreet, BillingCountry, BillingPostalCode, BillingCity, ShippingState, ShippingStreet, ShippingCountry, ShippingCity, ShippingPostalCode, AccountSource FROM Account WHERE Id = :custId];
                
                if(customerAcc != null && !String.isBlank(customerAcc.BillingCountry)) {
                    customerBillingAddressWrapper.add(new CustomerAddressWrapper('Billing', customerAcc.BillingStreet, customerAcc.BillingState, customerAcc.BillingCountry, customerAcc.BillingCity, customerAcc.BillingPostalCode, 'Billing', true));
                    returnWrapperMap.put('ship_selected_index', 0);
                    
                }
                
                if(customerAcc != null && !String.isBlank(customerAcc.ShippingCountry)) {
                    customerShippingAddressWrapper.add(new CustomerAddressWrapper('Shipping', customerAcc.ShippingStreet, customerAcc.ShippingState, customerAcc.ShippingCountry, customerAcc.ShippingCity, customerAcc.ShippingPostalCode, 'Shipping', true));
                    returnWrapperMap.put('bill_selected_index', 0);
                }

                for(Address__c custAddress :[SELECT Id, Address__Street__s, ToLabel(Address__StateCode__s), Address__PostalCode__s, ToLabel(Address__CountryCode__s), Address__City__s,Type__c FROM Address__c WHERE Account__c =:custId]) {

                    if(custAddress.Type__c == 'Billing') {
                        customerBillingAddressWrapper.add(new customerAddressWrapper(custAddress.Id, custAddress.Address__Street__s, custAddress.Address__StateCode__s, custAddress.Address__CountryCode__s, custAddress.Address__City__s, custAddress.Address__PostalCode__s, custAddress.Type__c, false));
                    }else {
                        customerShippingAddressWrapper.add(new customerAddressWrapper(custAddress.Id, custAddress.Address__Street__s, custAddress.Address__StateCode__s, custAddress.Address__CountryCode__s, custAddress.Address__City__s, custAddress.Address__PostalCode__s,custAddress.Type__c, false));
                    }
                }

                //System.debug('--- customerAddressWrapper'+customerAddressWrapper);
                returnWrapperMap.put('account', customerAcc);
                returnWrapperMap.put('customer_ship_addresses', customerShippingAddressWrapper);
                returnWrapperMap.put('customer_bill_addresses', customerBillingAddressWrapper);
                System.debug('--- response Wrapper '+returnWrapperMap);
            }
            return returnWrapperMap;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    public class CustomerAddressWrapper {
        @auraEnabled
        public String id;
        @auraEnabled
        public String street;
        @auraEnabled
        public String state;
        @auraEnabled
        public String country;
        @auraEnabled
        public String city;
        @auraEnabled
        public String gstNumber;
        @auraEnabled
        public String type;
        @AuraEnabled
        public String postalCode;
        @AuraEnabled
        public Boolean checked;

        public CustomerAddressWrapper(String id, String street, String state, String country, String city,String type, String postalCode, Boolean checked) {
            this.id = id;
            this.street = street;
            this.state = state;
            this.country = country;
            this.city = city;
          //  this.gstNumber = gstNumber;
            this.postalCode = postalCode;
            this.type = type;
            this.checked = checked;
        }
    }
}