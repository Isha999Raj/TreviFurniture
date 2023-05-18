trigger TriggerOnOpportunity on Opportunity (after update) {

    SObject_Trigger_Control__mdt triggerConfig = SObject_Trigger_Control__mdt.getInstance('Opportunity');
    system.debug('triggerConfig:: ' + triggerConfig);
    
    if(triggerConfig != null && triggerConfig.Trigger_Status__c) {
        OpportunityTriggerHelper handlerInstance = OpportunityTriggerHelper.getInstance();
        if(trigger.isAfter && trigger.isUpdate) {
            System.debug('On After Opportunity Trigger fired');
            handlerInstance.doDiscountApproval(trigger.new, trigger.oldMap);
        }
    }
    
}