public with sharing class DynamicRecordEditFormController {

    @AuraEnabled(cacheable = true)
    public static List<String> getApiName() {
        List<String> getAllFields = new List<String>();
        List<Schema.SObjectType> objects = new List<Schema.SObjectType>{ Product2.SObjectType};
        for(Schema.SObjectType objType: objects){
        for(Schema.SObjectField fld: objType.getDescribe().fields.getMap().values()){
            System.debug('API Field Name =  '+fld.getDescribe().getName());
            if(fld.getDescribe().getName() != 'id' && fld.getDescribe().getName() !='createdbyid' && fld.getDescribe().getName() !='lastmodifieddate' && fld.getDescribe().getName() !='lastmodifiedbyid' && fld.getDescribe().getName() !='systemmodstamp' && fld.getDescribe().getName() !='externaldatasourceid' && fld.getDescribe().getName()  != 'externalid' && fld.getDescribe().getName()  != 'isdeleted' && fld.getDescribe().getName()  != 'isarchived' && fld.getDescribe().getName()  != 'lastvieweddate' && fld.getDescribe().getName()  != 'lastreferenceddate' && fld.getDescribe().getName()  != 'createddate'){
               getAllFields.add(fld.getDescribe().getName());
            }
        }
        }
        return getAllFields;
    } 

    public static Map<string,string> getApiNameXlabel() {
        string opbjectAPIName = 'Product2';
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType leadSchema = schemaMap.get(opbjectAPIName);
        Map<String, Schema.SObjectField> fieldMap = leadSchema.getDescribe().fields.getMap();
        Map<string,string> fieldLabelXAPIName = New Map<string,string>();
        for (String fieldName: fieldMap.keySet()) {
            System.debug('fieldName ====> ' + fieldName);
            if(fieldname != 'id' && fieldname !='createdbyid' && fieldname !='lastmodifieddate' && fieldname !='lastmodifiedbyid' && fieldname !='systemmodstamp' && fieldname !='externaldatasourceid' && fieldname  != 'externalid' && fieldname  != 'isdeleted' && fieldname  != 'isarchived' && fieldname  != 'lastvieweddate' && fieldname  != 'lastreferenceddate' && fieldname  != 'createddate' && fieldname  != 'isdeleted'){
                fieldLabelXAPIName.put(fieldName,fieldMap.get(fieldName).getDescribe().getLabel());
            }
        
        }
        System.debug('fieldLabelXAPIName: ' +fieldLabelXAPIName);
        return fieldLabelXAPIName;
    }

    @AuraEnabled
    public static string insertPBE(Id prodId, Id reqId) {
        Product2 prod = [SELECT Id, List_Price__c FROM Product2 WHERE Id =: prodId];
        PricebookEntry pbe = new PricebookEntry();
        pbe.Product2Id = prodId;
        pbe.Pricebook2Id = [SELECT Id FROM Pricebook2 WHERE Name = 'Standard Price Book' LIMIT 1].Id;
        pbe.UnitPrice = prod.List_Price__c;
        pbe.IsActive = true;
        insert pbe;
        
        Utility.sendEmailToOwner(reqId,'Pricing Email');

        return 'success';
    }
}