trigger AccountTrigger on Account (before insert) {
	if(Trigger.isBefore && Trigger.isInsert)
    {
        //Upon Account Creation if Industry is not null and having value as ‘Media’ then populate Rating as Hot.
        AccountTriggerHandler.populateRating(Trigger.new);
    }
}