/**
 * @description       : Register Controller
 * @author            : Anand Kumar Reddy
 * @group             : 
 * @last modified on  : 07-12-2022
 * @last modified by  : Anand Kumar Reddy
 * Modifications Log 
 * Ver   Date         Author              Modification
 * 1.0   07-12-2022   Anand Kumar Reddy   Initial Version
**/

global without sharing class B2B_SelfRegisterCustomController {
    
    public B2B_SelfRegisterCustomController() 
    {

    }

    //Static Variables
    static String B2BCOMMUNITYPLUSPROFILEID = '00e5h00000138wVAAQ';
    static String B2BREGISTEREDBUYERGROUPID = '0ZI5h000000XnhTGAS';

    // Check if email exist or not if Email Exist then Do Not Create another user account
    @AuraEnabled
    public static boolean isEmailExist(String Email){
        try 
        {
            List <Contact> emailCon = [Select id,Email FROM Contact Where Email =:Email];
            
            
            if(emailCon.isEmpty())
            {
                return false;
            }
            else
            {
                return true;
            } 
        } 
        catch (Exception e) 
        {
            throw new AuraHandledException('User Already Exist Exception' + e.getMessage());
        }
    }


    // Check if Phone Number exist or not if Phone Number Exist then Do Not Create another user account
    @AuraEnabled
    public static boolean isPhoneExist(String Phone){
        try 
        {
            
            List <Contact> phoneCon = [Select id,Phone FROM Contact Where Phone =:Phone];
            
            if(phoneCon.isEmpty())
            {
                return false;
            }
            else
            {
                return true;
            } 
        } 
        catch (Exception e) 
        {
            throw new AuraHandledException('User Already Exist Exception' + e.getMessage());
        }
    }


    // registration of new user

    @AuraEnabled
    public static Map<String, String> registerUser(string firstName, String lastName, string email, string phone, string accountName,string pass,boolean orgUser)
    {
        Map<String, String> returnMap = new Map<String, String>();
        List<String>accVal = new List<String>();
        String companyAccountId ='NA';
    
        accVal =  accountHandling(accountName, firstName, lastName, phone, orgUser);
        String acctID = accVal.get(0);
        String acctName = accVal.get(1);

        Contact con = new Contact();
        con.Lastname = firstName +' '+ lastName;
        con.Email = email;
        con.Phone = phone;
        con.AccountId = acctID;
        insert con;
        // generating a random number:
        String temp = String.valueOf(DateTime.now().getTime());

            

        String uAlias = firstName.SubString(0,1) + lastName.SubString(0,2)+temp.SubString(0,4); 
        // User u = new User(Username = email+'.SPARTAN',Email = email,FirstName = firstName, LastName=lastName,CommunityNickName = con.Id +'-'+DateTime.now().getTime());
        User u = new User(TimeZoneSidKey='America/Los_Angeles',
        LocaleSidKey='en_US',LanguageLocaleKey='en_US',
        ProfileId = B2BCOMMUNITYPLUSPROFILEID,
                
        EmailEncodingKey='ISO-8859-1',
        Alias =uAlias,
        Username = email,
        Email = email,FirstName = firstName, LastName=lastName,
        ContactId = con.Id ,
        CommunityNickName = firstName +' '+ lastName + temp.SubString(0,3) );

        System.debug('User Created Successfully');
        returnMap.put('message','User Created Successfully');

        try
        {
            String userId = Site.createExternalUser(u, acctId, pass);
            if(userId != null)
            {
                returnMap.put('userId',userId);
                String emailResult = sendWelcomeMail(u, userId);

                ApexPages.PageReference pageRef = Site.login(u.Username,pass,'https://anandexplorer-dev-ed.develop.my.site.com/spartan/s/');
                returnMap.put('pageRef',pageRef.getURL());
                                  
            }
        }
        catch(Site.ExternalUserCreateException e)
        {
            List <String> errors = e.getDisplayMessages();
            for(String error:errors)
            {
                System.debug('error:' +error);
            }
            System.debug(e.getMessage());
            returnMap.put('error',e.getMessage());
        }

        return returnMap;
        // end of function    
    }


    /// SEND A WELCOME EMAIL
    @AuraEnabled
    public static String sendWelcomeMail(User usr, String userId){
        try {

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            List<EmailTemplate> welcomeTemplate = new List<EmailTemplate>([Select Id from EmailTemplate where name = 'B2B_Welcome_Notification']);
                     
            mail.setSenderDisplayName('SPARTAN');
            mail.setTargetObjectId(userId);
            mail.setTemplateId(welcomeTemplate[0].Id);
            mail.setSaveAsActivity(false);

            Messaging.sendEmail( new List<Messaging.SingleEmailMessage>{mail} );

            return 'success';

        } catch (Exception e) {            
            throw new AuraHandledException('Email Error:'+ e.getMessage());
        }
    }





    //Permission Set Assignment Method
    @AuraEnabled
    public static String pset(String permissionsetGroupsID, Id userId)
    {
        ID psetGroupId = permissionsetGroupsID;
        List<PermissionSetAssignment> psAssignments= new List<PermissionSetAssignment>();
        PermissionSetAssignment assignment = new PermissionSetAssignment(
            PermissionSetGroupId = psetGroupId, AssigneeId = userId
        );

        System.debug(assignment);

        psAssignments.add(assignment);
        upsert psAssignments;
        

        return 'SuccessAssignment' ;
    }



// Method to Create Individual Account

    @AuraEnabled
    public static List<String> accountHandling(String accountName,String firstName, String lastName, String phone, boolean orgUser)
    {
        List<String>accVal = new List<String>();
        try 
        {
            Account userAc = new Account();
            userAc.Name = firstName + lastName;
            userAc.Phone = phone;
            //userAc.CurrencyIsoCode = 'USD';
            insert userAc;
            userAc.IsPartner = true;
            upsert userAc;
            BuyerAccount buyerAccount = new BuyerAccount();
            buyerAccount.BuyerId = userAc.Id;
            buyerAccount.Name = userAc.Name;
            buyerAccount.IsActive = true;
            upsert buyerAccount;
            BuyerGroupMember bm = new BuyerGroupMember();
            bm.buyerId = userAc.Id;
            bm.BuyerGroupId = B2BREGISTEREDBUYERGROUPID; 
            upsert bm;

            accVal.add(userAc.Id);
            accVal.add(userAc.Name);
            return accVal;

        } 
        catch (Exception e) 
        {
            System.debug('Account Error'  + e.getMessage());
            throw new AuraHandledException('User Account or company Account Already exist: '  + e.getMessage());
                
        }
    }
}