public without sharing class DeliveryChallanVFController {
    
    public String recordId =  System.currentPageReference().getParameters().get('id');
    Public List<OpportunityLineItem> getOppLineItemList {get;set;}
    public List<Product2> getProductListItem {get;set;}
    Public List<String> oppLineItemIdSet {get;set;}
    public DeliveryChallanDetails__mdt getCompanyDetails {get;set;}
    public List<Transfered_SKU__c> ListTSKUData {get;set;}
    Public String totalValueAmount {get;set;}
    public Integer totalQuantity {get;set;}
    public Integer Totalvalue {get;set;}
    public Warehouse_Transfer_Log__c getWareTraLogData {get;set;}
    public Warehouse_Master__c getWareHouseDestinationAddress {get;set;}
    
    public DeliveryChallanVFController() {
        try{
            if(!String.isBlank(recordId)){
                System.debug('recordId === >'+recordId);
                getWareTraLogData = [SELECT Id,Name,Destination_Source__c FROM Warehouse_Transfer_Log__c WHERE Id =: recordId LIMIT 1];
                if(!String.isBlank(getWareTraLogData.Destination_Source__c)){
                    getWareHouseDestinationAddress = [SELECT Id, Name, Address__Street__s, Address__City__s, Address__PostalCode__s, Address__StateCode__s, Address__CountryCode__s, Address__c FROM Warehouse_Master__c WHERE Id=:getWareTraLogData.Destination_Source__c]; 
                    System.debug('getWareHouseDestinationAddress == >'+getWareHouseDestinationAddress);
                }
                
                Set<Id> ProductIdSet = new Set<Id>();
                ListTSKUData = [SELECT Id,Name,Warehouse_Transfer_Log__c,Product__c FROM Transfered_SKU__c WHERE Warehouse_Transfer_Log__c =:recordId];
                if(ListTSKUData.size() > 0){
                    for(Transfered_SKU__c sku : ListTSKUData){
                        ProductIdSet.add(sku.Product__c);
                    }
                }
                getCompanyDetails = [SELECT Id,MasterLabel,CIN_No__c,GSTIN__c,PAN_No__c,StateAddress__c,StreetAddress__c,StreetAddress1__c,DC_No__c	 FROM DeliveryChallanDetails__mdt LIMIT 1];
                if( ProductIdSet.size() > 0){
                    totalQuantity = 0;
                    Totalvalue = 0;
                    getProductListItem = [SELECT Id,Name,ProductCode,Quantity__c,Hsn_Code__c,GST__c,Uom__c,(SELECT Id,UnitPrice FROM PricebookEntries) FROM Product2 WHERE ID IN:ProductIdSet];
                    for(Product2 pro : getProductListItem){
                        totalQuantity += Integer.valueOf(pro.Quantity__c);
                        for(PricebookEntry pri : pro.PricebookEntries){
                            Totalvalue += Integer.valueOf(pri.UnitPrice * pro.Quantity__c);
                        }
                    }
                    System.debug('Total Value INteger == >'+Totalvalue);
                    totalValueAmount = String.valueOf(NumberToTextConverter.convert(Totalvalue));
                }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }
        
    @AuraEnabled
    Public Static String checkData(String recordId){
        if(!String.isBlank(recordId)){
            Transfered_SKU__c TSKU =  [SELECT Id,Name,Warehouse_Transfer_Log__c,Product__c FROM Transfered_SKU__c WHERE Warehouse_Transfer_Log__c =:recordId LIMIT 1];
            return 'SUCCESS';
        }
        return null;
    }
    @AuraEnabled
    public static string savePDF(String url,String id,String fileName){
        try {
            
            PageReference ref = new PageReference(url);
            ContentVersion cont = new ContentVersion();
            
            cont.Title = fileName;
            cont.PathOnClient = fileName+'.pdf';
            cont.VersionData = ref.getContentAsPdf();
            cont.Origin = 'H';
            
            insert cont;    
            ContentDocumentLink cdl = createContentLink(cont.Id, id);
            return 'Success';
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if (contentVersionId == null || recordId == null) { return null; }
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [ SELECT ContentDocumentId FROM ContentVersion WHERE Id =: contentVersionId ].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        cdl.ShareType = 'V';
        try {
            insert cdl;
            return cdl;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
    }
}