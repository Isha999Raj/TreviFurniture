public without sharing class Utility {
    
    public static void doApproval(Id objId, Id approverId, String approvalName, String comments){
        try{
            system.debug('objId -- ' + objId);
            system.debug('approverId -- ' + approverId);
            system.debug('approvalName -- ' + approvalName);
            system.debug('comments -- ' + comments);
            Map<Id, Approval.ProcessSubmitRequest> caseToapprovalRequestMap = new Map<Id, Approval.ProcessSubmitRequest>();
            Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
            approvalRequest.setComments(comments);
            approvalRequest.setObjectId(objId);
            approvalRequest.setProcessDefinitionNameOrId(approvalName);
            approvalRequest.setNextApproverIds(new List<Id> {approverId});
            caseToapprovalRequestMap.put(objId, approvalRequest);
            
            if(!caseToapprovalRequestMap.isEmpty())
                List<Approval.ProcessResult> result = Approval.process(caseToapprovalRequestMap.values());
        }
        catch(Exception e){
            system.debug('ERROR :: ' + e.getMessage() + 'AT LINE NUMBER :: ' + e.getLineNumber());
            HandleBusinessException.captureError('Utility', 'doApproval', e);
        }           
    }
    
    public static void sendEmailToOwner(String reqId, String templateName){
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        List<String> recipients = new List<String>();
        try{
            EmailTemplate emailTempRec = [SELECT Id, Subject, Description FROM EmailTemplate WHERE Name =: templateName];
            system.debug('emailTempRec::'+emailTempRec);           
            
            New_Product_Price_request__c priceReq = [SELECT Id, Opportunity__r.OwnerId, Opportunity__r.Owner.Email FROM New_Product_Price_request__c WHERE Id =: reqId];
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            mail.setSaveAsActivity(false);
            mail.setTargetObjectId(priceReq.Opportunity__r.OwnerId);
            mail.setSenderDisplayName('Trevi Furniture');
            mail.setTemplateId(emailTempRec.Id);
            mails.add(mail);
            System.debug('Mails----'+mails);
            if(!mails.isEmpty()){
                system.debug('Sending Email');
                Messaging.sendEmail(mails);
            }
        }
        catch(Exception e){
            HandleBusinessException.captureError('Utility', 'sendEmailToOwner', e);
        }
    }
    
}