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

    //Account records should have a field named ‘Recent Opportunity Amount’. It should contain the opportunity amount of the latest created opportunity on account.
    public static void updateAmountOnAccount(List<Opportunity> opps)
    {
        List<Account> accts = new List<Account>();
        for(Opportunity opp : opps)
        {
            if(opp.Amount != null)
            {
                Account acc = new Account();
                acc.Id = opp.AccountId;
                acc.Recent_Opportunity_Amount__c = opp.Amount;

                accts.add(acc);
            }

            if(!accts.isEmpty())
            {
                update accts;
            }
        }
    }

    //When a Opportunity Stage (field) is changed, create a Task record on Opportunity and assign it to Logged In User/Opportunity Owner / Any User
    public static void createTask(List<Opportunity> opps, Map<Id, Opportunity> oldOppsMap)
    {
        List<Task> taskList = new List<Task>();
        for(Opportunity opp : opps)
        {
            if(opp.StageName != oldOppsMap.get(opp.Id).StageName)
            {
                Task task = new Task();
                task.WhatId = opp.Id;
                task.Subject = 'Email';
                task.Priority = 'Normal';
                task.status = 'Not Started';
                task.OwnerId = UserInfo.getUserId();

                taskList.add(task);
            }
        }

        if(!taskList.isEmpty())
        {
            insert taskList;
        }
    }
}