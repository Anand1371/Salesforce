public with sharing class B2B_PaymentMethodController {
    public B2B_PaymentMethodController() {

    }

    @AuraEnabled
    public static Map<String, Object> getBillingAddressId(String cartId){
        try {
            Map<String, Object> myMap = new Map<String, Object>();
            List<WebCart> cartData = [SELECT Id, AccountId, TotalProductAmount, TotalChargeAmount, GrandTotalAmount, 
            CreatedBy.Contact.Account.Approved_for_Credit__c, CreatedBy.Contact.Account.Credit_Limit__c  
            FROM WebCart WHERE Id=:cartId];

            String accountId = cartData[0].AccountId;

            List<ContactPointAddress> billingAddressId = [SELECT Id FROM ContactPointAddress WHERE ParentId =:accountId AND AddressType = 'Billing' AND IsDefault=true];
            
            myMap.put('billingAddressId', billingAddressId[0].Id);
            myMap.put('TotalProductAmount',cartData[0].TotalProductAmount);
            myMap.put('TotalChargeAmount',cartData[0].TotalChargeAmount);
            myMap.put('GrandTotalAmount',cartData[0].GrandTotalAmount);
            myMap.put('ApprovedForCredit',cartData[0].CreatedBy.Contact.Account.Approved_for_Credit__c);
            myMap.put('CreditLimit',cartData[0].CreatedBy.Contact.Account.Credit_Limit__c);

            return myMap;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Map<String, Object> getAccountDetails(String cartId){
        try {
            Map<String, Object> myMap = new Map<String, Object>();
            List<WebCart> cartData = [SELECT Id, AccountId, TotalProductAmount, TotalChargeAmount, GrandTotalAmount, 
            CreatedBy.Contact.Account.Approved_for_Credit__c, CreatedBy.Contact.Account.Credit_Limit__c  
            FROM WebCart WHERE Id=:cartId];

            myMap.put('ApprovedForCredit',cartData[0].CreatedBy.Contact.Account.Approved_for_Credit__c);
            myMap.put('CreditLimit',cartData[0].CreatedBy.Contact.Account.Credit_Limit__c);
            myMap.put('GrandTotalAmount',cartData[0].GrandTotalAmount);

            return myMap;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string updateCreditLimit(String cartId, Decimal grandTotal, Decimal creditLimit){
        try {
            List<WebCart> cartData = [SELECT Id, AccountId FROM WebCart WHERE Id=:cartId];
            String accountId = cartData[0].AccountId;
            Account a = [SELECT Credit_Limit__c FROM Account WHERE Id =:accountId];
            a.Credit_Limit__c = creditLimit - grandTotal;
            update a;
            return 'Credit Limit Updated';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}
