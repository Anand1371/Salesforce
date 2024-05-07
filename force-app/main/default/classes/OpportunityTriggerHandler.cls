public class OpportunityTriggerHandler {
    //Upon Opportunity Creation if Amount is not null and is greater than 100000 then populate ‘Hot Opportunity’ in description field.
	public static void populateDescription(List<Opportunity> opps)
    {
        for(Opportunity opp : opps)
        {
            if(opp.Amount != null && opp.Amount > 100000)
            {
                opp.Description = '‘Hot Opportunity';
            }
        }
    }
}