public without sharing class TransferWarehouseProducts{
    
    Public static string CurrentPageRecordId;
    
    @AuraEnabled
    Public static void getCurrentRecordId(String CurrentrecordId){
        CurrentPageRecordId='a021e000003VrOdAAK';
        System.debug('RecordId--'+CurrentPageRecordId);
    }
    
    @AuraEnabled(cacheable=true)
    public static List<sObject> getWarehouseMasterRecords(string searchKey,string recordId){
        List <sObject> returnList = new List <sObject> ();
        List<Warehouse_Master__c> WareHouseRecodrd=new List<Warehouse_Master__c>();
        string sQuery;
        system.Debug('searchKey--'+searchKey);
        try{
            string sWildCardText = '%'+searchKey+'%'  ;
            system.Debug('sWildCardText--'+sWildCardText);
            if(searchKey==null){
                system.debug('First Query');
                WareHouseRecodrd=[Select Id,Name,Active__c From Warehouse_Master__c Where Id!=:recordId];
            }else{
                system.debug(' Second Query');
                WareHouseRecodrd=[Select Id,Name,Active__c From Warehouse_Master__c Where Name LIKE:sWildCardText AND Id!=:recordId];  
            }
            System.debug('returnList---->'+returnList);
            System.debug('WareHouseRecodrd---->'+WareHouseRecodrd);
            return WareHouseRecodrd;
        }
        catch(Exception e){
            System.debug('Exception--->'+e.getMessage());
            System.debug('Exception--->'+e.getLineNumber());
            return WareHouseRecodrd;
        }
    } 
}