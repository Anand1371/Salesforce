trigger CaseTrigger on Case (after insert) {
    if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
            //When a Case is created on any Account, put the latest case number on the Account in the ‘Latest Case Number’ field.
            CaseTriggerHandler.updateCaseNumberOnAccount(Trigger.new);
        }
    }
}