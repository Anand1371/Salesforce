trigger PositionTrigger on Position__c (before insert) {
	if(Trigger.isBefore && Trigger.isInsert)
    {
        //Upon Creation of Position (Custom Object) if it is a New Position and Open Date, Min Pay & Max Pay are not populated then populated them with below values:
        //a. Open Date = Today’s Date
        //b. Min Pay = 10000
        //c. Max Pay = 15000
        PositionTriggerHandler.populatePay(Trigger.New);
    }
}