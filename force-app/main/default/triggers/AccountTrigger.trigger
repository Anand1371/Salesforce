trigger AccountTrigger on Account (before insert, after insert) {
	if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            //Upon Account Creation if Industry is not null and having value as ‘Media’ then populate Rating as Hot.
            AccountTriggerHandler.populateRating(Trigger.new);
            
            //When an account inserts and CopyBillingToShipping (Custom Field) checkbox is checked then automatically copy account billing address into account shipping address.
            AccountTriggerHandler.populateShippingAddress(Trigger.new);
        }
    }

    if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        {
            //Create a related Contact when an Account is created.
            AccountTriggerHandler.createContact(Trigger.New);

            //Create a related Opportunity when an Account is created.
            AccountTriggerHandler.createOpportunity(Trigger.New);

            //On Account create two checkbox fields labeled as Contact and Opportunity.
            //Now when a new Account record is created and if a particular Contact or Opportunity checkbox is checked then create that related record. 
            //Also Opportunity record should be created only if the Account record Active picklist is populated with a Yes.
            AccountTriggerHandler.createContactOpportunity(Trigger.New);
        }
    }
}