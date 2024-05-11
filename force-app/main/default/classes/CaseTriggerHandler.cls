public class CaseTriggerHandler {
    public static void updateCaseNumberOnAccount(List<Case> cases) {
        List<Account> accts = new List<Account>();
        for(Case cas : cases)
        {
            if(cas.AccountId != null)
            {
                Account acc = new Account();
                acc.Id = cas.AccountId;
                acc.Latest_Case_Number__c = cas.CaseNumber;

                accts.add(acc);
            }
        }

        if(!accts.isEmpty())
        {
            update accts;
        }
    }
}