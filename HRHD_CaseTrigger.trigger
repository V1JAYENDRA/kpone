/*
*  @Name : HRHD_CaseTrigger
*  @Author : Arwa Chitalwala
*  @Created Date : 06-19-2017
*  @Description : TRIGGER FOR CASE OBJECT
**/
Trigger HRHD_CaseTrigger on Case(before insert, after insert, before update, after update, before delete) {

    if (Trigger.isBefore) {
        if (Trigger.isUpdate) {
            // Logic to complete milestone when case is closed.
            //  HRHD_CaseTriggerHandler.UpdateMilestoneCheck(trigger.new);z
            // Logic to populate category,subcategories based on quick codes.
            HRHD_CaseTriggerHandler.assignCategoryValues(trigger.new, trigger.oldMap);
            // HRHD_CaseTriggerHandler.populateSLAeffectiveDate(trigger.new);
            //Commented as it is pending for final undersatanding and approval on the same
            //HRHD_CaseTriggerHandler.autopopulateEmployeeInformationOnCase(trigger.new);
            HRHD_CaseTriggerHandler.updateCaseCurrentEmployeeFields(trigger.oldMap, trigger.new);
            HRHD_CaseTriggerHandler.restrictQueueMemberApproval(trigger.new, trigger.old);
            HRHD_CaseTriggerHandler.updateAssignmentQueue(trigger.new); // commented on 4th December
            //HRHD_CaseAssignmentHandler.isFromTrigger=true;
            //HRHD_CaseAssignmentHandler.caseAssignedTo(trigger.new);
            HRHD_SLAHandler.calculateSLA(Trigger.New);
        }
        if (Trigger.isInsert) {
            // Logic to populate category,subcategories based on quick codes.
            HRHD_CaseTriggerHandler.assignCategoryValues(trigger.new, null);
            //HRHD_CaseTriggerHandler.checkCaseUpdatedFlag(trigger.new);
            // HRHD_CaseTriggerHandler.populateSLAeffectiveDate(trigger.new);
            HRHD_CaseTriggerHandler.updateCaseCurrentEmployeeFields(null, trigger.new);
            HRHD_CaseTriggerHandler.updateCaseInitiatorFormType(trigger.new);

            HRHD_CaseTriggerHandler.updateCaseWebInquiryFormType(trigger.new);
                        HRHD_CaseTriggerHandler.updateAssignmentQueue(trigger.new);
            HRHD_CaseAssignmentHandler.isFromTrigger = true;
            HRHD_CaseAssignmentHandler.caseAssignedTo(trigger.new);
            HRHD_SLAHandler.calculateSLA(Trigger.New);
        }
    }
    
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            // Logic to call assignment rules
            HRHD_CaseTriggerHandler.invokeCaseAssignmentRules(trigger.new, null);
            if (HRHD_CaseTriggerHandler.bCheckRecursiveCall != true)
                HRHD_CaseTriggerHandler.InvokeCallOut(trigger.newMap, trigger.oldMap);
                //Venkat: SUBMIT Error              HRHD_SLAHandler.calculateSLA(trigger.new, new Map<Id , Case>());
        }
        if (Trigger.isUpdate) {
            // Logic to call assignment rules
            HRHD_CaseTriggerHandler.invokeCaseAssignmentRules(trigger.new, trigger.oldMap);
            if (HRHD_CaseTriggerHandler.bCheckRecursiveCall != true)
                HRHD_CaseTriggerHandler.InvokeCallOut(trigger.newMap, trigger.oldMap);
            //Venkat:Submit ERROR              HRHD_SLAHandler.calculateSLA(trigger.new, new Map<Id , Case>());
            //Sumeet : Commenting this code as it is causing continuous error and could not test any scenarios
            //HRHD_CaseTriggerHandler.checkEmailTocase(trigger.new);
        }
    }

}