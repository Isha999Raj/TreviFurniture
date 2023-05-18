/*
 Author : GC
*/
public without sharing class LWC_Handler {
    
     @AuraEnabled
    public static string getOppoRecordTypeId(string recordTypeName){
        try {
            return Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

     @AuraEnabled
    public static Opportunity getAccRecord(String accId){
        try {
            if(String.isBlank(accId))
                return null;
            return [Select Id, Name, AccountId, Approval_Status__c, Approved_By_Manager__c,CloseDate,ContractId,Description ,
                    Design_Visit_Required__c, Discovery_Completed__c,ForecastCategoryName, LeadSource, Opportunity__c FROM Opportunity where Id =:accId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}