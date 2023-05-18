trigger LeadTrigger on Lead (after insert,after update) {
    if(trigger.isAfter && (trigger.isInsert || trigger.isUpdate)){
        System.debug('Trigger Fired');
        for(Lead led : trigger.new){
            if(led.Total_Product_Interest_Price__c == null){
                LeadProductAmountSumHelper.UpdateProductAmountOnLead(trigger.new);
            }
        }
        
    }
}