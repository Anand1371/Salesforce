public class PositionTriggerHandler {
    //Upon Creation of Position (Custom Object) if it is a New Position and Open Date, Min Pay & Max Pay are not populated then populated them with below values:
    //a. Open Date = Today’s Date
    //b. Min Pay = 10000
    //c. Max Pay = 15000
	public static void populatePay(List<Position__c> pts)
    {
        for(Position__c pos : pts)
        {
            if(pos.Open_Date__c == null){
                pos.Open_Date__c = Date.today();
            }
            if(pos.Min_Pay__c == null){
                pos.Min_Pay__c = 10000;
            }
            if(pos.Max_Pay__c == null){
                pos.Max_Pay__c = 15000;
            }
        }
    }
}