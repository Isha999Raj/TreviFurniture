public without sharing class MaterialSpecOnProdController {
    
    @AuraEnabled
    public static specWrapper getAllSpecs(){
        List<Specification_Header__c> specHeaderList = [SELECT Id, Header__c FROM Specification_Header__c WHERE Active__c = TRUE];
        Set<Id> specHeadIdSet = new Set<Id>();
        for(Specification_Header__c header : specHeaderList){
            specHeadIdSet.add(header.Id);
        }
        List<Specification_Value__c> valueList = [SELECT Id, Value__c, Specification_Header__c FROM Specification_Value__c 
                                                  WHERE Active__c = TRUE AND Id IN: specHeadIdSet];
        specWrapper sWrap = new specWrapper();
        sWrap.headerList = specHeaderList;
        sWrap.valueList = valueList;
        return sWrap;
    }
    
    public class specWrapper{
        @AuraEnabled
        public List<Specification_Header__c> headerList;
        @AuraEnabled
        public List<Specification_Value__c> valueList;
    }
    
    @AuraEnabled(Cacheable=true)
    public static List<sObject> getSpecRecords(string searchKey){
        List <sObject> returnList = new List <sObject> ();
        List<Specification_Header__c> specHeaderList = new List<Specification_Header__c>();
        string sQuery;
        system.Debug('searchKey--'+searchKey);
        try{
            string sWildCardText = '%'+searchKey+'%'  ;
            system.Debug('sWildCardText--'+sWildCardText);
            
            if(searchKey==null){
                system.debug('First Query');
                specHeaderList=[SELECT Id, Header__c FROM Specification_Header__c WHERE Active__c = TRUE];
                
            }else{
                system.debug(' Second Query');
                specHeaderList=[SELECT Id, Header__c FROM Specification_Header__c WHERE Active__c = TRUE AND Name LIKE:sWildCardText];  
            }
            System.debug('returnList---->'+returnList);
            System.debug('specHeaderList---->'+specHeaderList);
            return specHeaderList;
        }
        catch(Exception e){
            System.debug('Exception--->'+e.getMessage());
            System.debug('Exception--->'+e.getLineNumber());
            return specHeaderList;
        }
    } 
    
}