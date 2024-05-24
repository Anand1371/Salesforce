trigger OpportunityTrigger on Opportunity (before insert, after insert, after update) {
	if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            //Upon Opportunity Creation if Amount is not null and is greater than 100000 then populate ‘Hot Opportunity’ in description field.
            OpportunityTriggerHandler.populateDescription(Trigger.new);
        }
    }

    if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
            //Account records should have a field named ‘Recent Opportunity Amount’. It should contain the opportunity amount of the latest created opportunity on account.
            OpportunityTriggerHandler.updateAmountOnAccount(Trigger.new);
        }

        if(Trigger.isUpdate)
        {
            //When a Opportunity Stage (field) is changed, create a Task record on Opportunity and assign it to Logged In User/Opportunity Owner / Any User
            OpportunityTriggerHandler.createTask(Trigger.new, Trigger.oldMap);
        }
    }
}