trigger OpportunityTrigger on Opportunity (before insert) {
	if(Trigger.isBefore && Trigger.isInsert)
    {
        //Upon Opportunity Creation if Amount is not null and is greater than 100000 then populate ‘Hot Opportunity’ in description field.
        OpportunityTriggerHandler.populateDescription(Trigger.new);
    }
}