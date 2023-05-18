/**
 * Author: DeaGle
 */
global without sharing class EmailToLeadEmailServiceHandler implements Messaging.InboundEmailHandler {
    
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        System.debug('--- email'+email);
        System.debug('--- envelope'+envelope);

        String myPlainText= '';
        // Add the email plain text into the local variable 
        myPlainText = email.plainTextBody;

        try {
            List<Lead> vLeadList = [SELECT Id, Name, Email FROM Lead WHERE Email = :email.fromAddress LIMIT 1];
            
            if(!vLeadList.isEmpty()) {
                for(Lead lead: vLeadList) {
                    lead.Status = 'Customer Responded';
                }
                update vLeadList;
                return result;
            }
            //Otherwise
            Lead newLead = new Lead(FirstName =email.fromName != null ? email.fromName : 'NO_NAME', LastName = email.fromName != null ? email.fromName : 'NO_NAME', Email = email.fromAddress, LeadSource = 'Email', Company = '-');
            insert newLead;
        }catch(Exception e) {
            HandleBusinessException.captureError('EmailToLeadEmailServiceHandler', 'handleInboundEmail', e);
        }
        return result;
    }
}