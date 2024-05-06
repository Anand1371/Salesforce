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
}