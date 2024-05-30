trigger AccountTrigger on Account (before insert, after insert, before update, after update) {
	if(Trigger.isBefore)
    {
        if(Trigger.isInsert)
        {
            //Upon Account Creation if Industry is not null and having value as ‘Media’ then populate Rating as Hot.
            AccountTriggerHandler.populateRating(Trigger.new);
            
            //When an account inserts and CopyBillingToShipping (Custom Field) checkbox is checked then automatically copy account billing address into account shipping address.
            AccountTriggerHandler.populateShippingAddress(Trigger.new);
        }

        if(Trigger.isUpdate)
        {
            //If the Account phone is updated then populate below message in description.
            //Description = Phone is Updated! Old Value : XXX & New Value : XXX
            AccountTriggerHandler.updateDescription(Trigger.new, Trigger.oldMap);
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

        if(Trigger.isUpdate)
        {
            //If the Account phone is updated then populate the phone number on all related Contacts (Home Phone field). [Using Map]
            AccountTriggerHandler.updatePhoneOnRelatedontacts(Trigger.new, Trigger.oldMap);

            //Write a trigger on Account when Account Active field is updated from ‘Yes’ to ‘No’ then check all opportunities associated with the account. 
            //Update all Opportunities Stage to close lost if stage not equal to close won.
            AccountTriggerHandler.updateOppStage(Trigger.new, Trigger.oldMap);
        }
    }
}