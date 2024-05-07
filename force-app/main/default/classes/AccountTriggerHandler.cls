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
}