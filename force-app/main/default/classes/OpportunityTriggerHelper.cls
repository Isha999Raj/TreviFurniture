/*
 * Author : Anjali Singh
 */

public without sharing class OpportunityTriggerHelper {

    static OpportunityTriggerHelper handlerInstance;
    public static OpportunityTriggerHelper getInstance() {
        if(handlerInstance == null) 
            handlerInstance = new OpportunityTriggerHelper();
        return handlerInstance;
    }
    
    public void doDiscountApproval(List<Opportunity> newOppList, Map<Id, Opportunity> oldOppMap){
        try{
            Map<Id,Opportunity> freshOppMap = new Map<Id,Opportunity>([SELECT Id, Owner.ManagerId, Owner.UserRoleId, Owner.UserRole.Name, RecordType.DeveloperName FROM Opportunity WHERE Id IN:oldOppMap.keySet()]);
            Map<Id, Approval.ProcessSubmitRequest> oppToapprovalRequestMap = new Map<Id, Approval.ProcessSubmitRequest>();
            List<ProcessInstance> recordUnderApprovalList = [Select ID, Status,TargetObjectID, TargetObject.Name From ProcessInstance Where Status = 'Pending' AND TargetObjectID IN :oldOppMap.keySet()];
            Set<Id> underApprovalOppSet = new Set<Id>();
            for(ProcessInstance approvalOpp : recordUnderApprovalList) {
                underApprovalOppSet.add(approvalOpp.TargetObjectID);
            }
            List<User> uList = [SELECT Id FROM User WHERE UserRole.Name = 'MD'];
            
            if(!newOppList.isEmpty()) {
                for(opportunity opp : newOppList) {
                    
                    if(underApprovalOppSet.contains(opp.Id)) {
                        opp.addError(Constants.UNDER_APPROVAL_PROCESS_ERR_MSG);
                        continue;
                    }
                    Id managerId = freshOppMap.get(opp.Id).Owner.ManagerId;
                    
                    if(managerId != uList[0].Id){
                        if( opp.Total_Discount__c >0 && opp.Total_Discount__c != oldOppMap.get(opp.Id).Total_Discount__c && opp.Approved_by_Manager__c == false) {
                            if(managerId != null) {
                                system.debug('MNGR Approval:: ');
                                Utility.doApproval(opp.Id, managerId, Constants.OPP_Mngr_APPROVAL_PROCESS, Constants.Mngr_APPROVAL_PROCESS_MSG);
                            }
                        }
                        else if(uList[0].Id != null && opp.Total_Discount__c >2 && opp.Approved_by_Manager__c == true && opp.Approved_by_Manager__c != oldOppMap.get(opp.Id).Approved_by_Manager__c){
                            system.debug('MD Approval:: ');
                            Utility.doApproval(opp.Id, uList[0].Id, Constants.OPP_Mngr_APPROVAL_PROCESS, Constants.Mngr_APPROVAL_PROCESS_MSG);
                        }
                    }
                    else{
                        if(uList[0].Id != null && opp.Total_Discount__c > 0 && opp.Total_Discount__c != oldOppMap.get(opp.Id).Total_Discount__c && opp.Approved_by_Manager__c == true ){
                            system.debug('MD Approval:: ');
                            Utility.doApproval(opp.Id, uList[0].Id, Constants.OPP_Mngr_APPROVAL_PROCESS, Constants.Mngr_APPROVAL_PROCESS_MSG);
                        }
                    }
                }
            }            
        }
        catch(exception ex){
            system.debug('Error==> ' + ex.getMessage() + ' at line number==> ' + ex.getLineNumber() );
            HandleBusinessException.captureError('OpportunityTriggerHelper', 'doDiscountApproval', ex);
        }
    }
}