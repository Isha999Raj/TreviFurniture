public with sharing class InwardSKUs_Controller {
    
    @AuraEnabled(cacheable=true)
    public static List<Transfered_SKU__c> getTransferredSKUs(String WarehousetansferedlogID){
        List<Transfered_SKU__c> TransferredSKUs = [SELECT CreatedById,CreatedDate,Id,Name,OwnerId,Product__c,product__r.Name, Quantity__c,UOM__c,Warehouse_Transfer_Log__c, Warehouse_Transfer_Log__r.Name ,
                                                     Warehouse_Transfer_Log__r.Destination_Source__c, Warehouse_Transfer_Log__r.Destination_Source__r.Name, Warehouse_Transfer_Log__r.Source_Warehouse__c,Warehouse_Transfer_Log__r.Source_Warehouse__r.Name,Recieved_Quantity__c ,Remarks__c
                                                    FROM Transfered_SKU__c 
                                                    where Warehouse_Transfer_Log__c =:WarehousetansferedlogID ];
                                                    System.debug('TransferredSKUs ===> ' + TransferredSKUs);
        return TransferredSKUs;
    }

    @AuraEnabled
    public static string SaveTransferLogDetails(List<Transfered_SKU__c> TransferredSKUs){
        string message = '';
        try{
            System.debug('TransferredSKUs ====> ' + TransferredSKUs);
            update TransferredSKUs;
            message = 'SUCCESS';
        }
        catch(exception e){
            System.debug('the error has occured due to ===> ' );
            System.debug('the error has occured at ===> ' );
            message = 'FAIL';
        }
        return message;
        
    }


}