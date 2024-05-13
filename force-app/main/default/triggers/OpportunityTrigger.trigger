trigger OpportunityTrigger on Opportunity (before insert, after insert) {
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
    }
}