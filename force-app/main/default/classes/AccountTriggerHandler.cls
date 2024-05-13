public class AccountTriggerHandler {
    
    //Upon Account Creation if Industry is not null and having value as ‘Media’ then populate Rating as Hot.
	public static void populateRating(List<Account> accts)
    {
        for(Account acc : accts)
        {
            if(acc.Industry != null && acc.Industry == 'Media')
            {
                acc.Rating = 'Hot';
            }
        }
    }
    
    //When an account inserts and CopyBillingToShipping (Custom Field) checkbox is checked then automatically copy account billing address into account shipping address.
    public static void populateShippingAddress(List<Account> accts){
        for(Account acc : accts)
        {
            if(acc.CopyBillingToShipping__c)
            {
                if(acc.BillingStreet != null)
                {
                    acc.ShippingStreet = acc.BillingStreet;
                }
                if(acc.BillingState != null)
                {
                    acc.ShippingState = acc.BillingState;
                }
                if(acc.BillingCity != null)
                {
                    acc.ShippingCity = acc.BillingCity;
                }
                if(acc.BillingCountry != null)
                {
                    acc.ShippingCountry = acc.BillingCountry;
                }
                if(acc.BillingPostalCode != null)
                {
                    acc.ShippingPostalCode = acc.BillingPostalCode;
                }
            }
        }
    }

    //Create a related Contact when an Account is created.
    public static void createContact(List<Account> accts)
    {
        List<Contact> conts = new List<Contact>();
        for(Account acc : accts){
            Contact con = new Contact();
            con.FirstName = acc.Name + 'FN';
            con.LastName = acc.Name + 'LN';
            con.AccountId = acc.Id;
            conts.add(con);
        }

        if(!conts.isEmpty())
        {
            insert conts;
        }
    }

    //Create a related Opportunity when an Account is created.
    public static void createOpportunity(List<Account> accts)
    {
        List<Opportunity> opps = new List<Opportunity>();
        for(Account acc : accts){
            Opportunity opp = new Opportunity();
            opp.Name = acc.Name + ' Opportunity';
            opp.AccountId = acc.Id;
            opp.StageName = 'Prospecting';
            opp.CloseDate = Date.today();
            opps.add(opp);
        }

        if(!opps.isEmpty())
        {
            insert opps;
        }
    }
}