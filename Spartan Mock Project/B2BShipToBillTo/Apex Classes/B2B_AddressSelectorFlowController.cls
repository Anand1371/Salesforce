public with sharing class B2B_AddressSelectorFlowController {
    public B2B_AddressSelectorFlowController() {

    }

    @AuraEnabled
    public static List<User> userData(String userId){
        try {
            List<User> u = [SELECT Id, Email, Phone, Contact.Name, Contact.Account.Name FROM User WHERE Id=:userId];
            return u;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<ContactPointAddress> getBillingAddressByContactId(String cartId){
        try {
            List<WebCart> cartData = [SELECT Id, AccountId from WebCart WHERE Id=:cartId];
            Id accountId = cartData[0].AccountId;
            List<ContactPointAddress> billingAddresses = [
                SELECT Name, Street, City, State,  Country, PostalCode, AddressType, IsDefault FROM ContactPointAddress 
                WHERE ParentId =:accountId AND AddressType = 'Billing'];
            return billingAddresses;  
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<ContactPointAddress> getShippingAddressByContactId(String cartId){
        try {
            List<WebCart> cartData = [SELECT Id, AccountId from WebCart WHERE Id=:cartId];
            Id accountId = cartData[0].AccountId;
            List<ContactPointAddress> shippingAddresses = [
                SELECT Name, Street, City, State,  Country, PostalCode, AddressType, IsDefault FROM ContactPointAddress 
                WHERE ParentId =:accountId AND AddressType = 'Shipping'];
            return shippingAddresses;  
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled
    public static string createNewContactPointShippingAddress(Map<String, String> newAddress, Boolean isDefault, Boolean isAddressForFutureUse, String cartId){
        try {

            if(isAddressForFutureUse == true)
            {
                List<WebCart> cart = [SELECT AccountId FROM WebCart WHERE Id =:cartID];
                ContactPointAddress add = new ContactPointAddress();
                add.Name = newAddress.get('name');
                add.Street = newAddress.get('street');
                add.City = newAddress.get('city');
                add.State = newAddress.get('state');
                add.Country = newAddress.get('country');
                add.PostalCode = newAddress.get('postalCode');
                add.IsDefault = isDefault;
                add.AddressType = 'Shipping';
                add.ParentId = cart[0].AccountId;

                insert add;
            
                return 'saved to Object';
            }
            else {
                return 'not saved to contact point address';
            }
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    

    @AuraEnabled
    public static List<CartItem> getProductsData(String cartId){
        try {
            List<CartItem> cartItems = [SELECT  Name, Sku, Quantity ,ListPrice, TotalPrice FROM CartItem WHERE CartId=:cartId AND Sku!=null];
            return cartItems;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled
    public static List<OrderItemSummary> getProductsDataByOrderSummaryId(String orderSummaryId){
        try {
            List<OrderItemSummary> OSItems = [SELECT  Name, StockKeepingUnit, Quantity ,ListPrice, TotalPrice FROM OrderItemSummary WHERE OrderSummaryId=:orderSummaryId AND StockKeepingUnit!=null];
            return OSItems;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String getOrderIdByOrderSummaryId(String orderSummaryId){
        try {
            return [SELECT OriginalOrder.OrderNumber FROM OrderSummary WHERE Id=:orderSummaryId].OriginalOrder.OrderNumber;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static string updateBillingDefault(String addId){
        try {
            List<ContactPointAddress> cpd = [SELECT Id, IsDefault FROM ContactPointAddress WHERE Id=:addId];
            cpd[0].IsDefault = true;
            update cpd;
            return 'updated';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }


    @AuraEnabled
    public static List<OrderSummary> getBillingAddressByOrderSummary(String orderSummaryId){
        try {
            List<OrderSummary> addr = [SELECT BillingStreet, BillingCity, BillingState, 
            BillingCountry, BillingPostalCode FROM OrderSummary WHERE Id=:orderSummaryId];
            return addr;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<OrderDeliveryGroupSummary> getShippingAddressByOrderSummary(String orderSummaryId){
        try {
            List<OrderDeliveryGroupSummary> addr = [SELECT DeliverToStreet, DeliverToCity, DeliverToState, 
            DeliverToCountry, DeliverToPostalCode FROM OrderDeliveryGroupSummary WHERE OrderSummaryId=:orderSummaryId];
            return addr;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static String saveToCart(String addressId, String cartId){
        try {
            List<ContactPointAddress> billingAddress = [
                SELECT Id, Name, Street, City, State,  Country, PostalCode FROM ContactPointAddress 
                WHERE Id=:addressId];
            WebCart cart = [SELECT Id FROM WebCart WHERE Id=:cartId];
            cart.BillingStreet = billingAddress[0].Street;
            cart.BillingState = billingAddress[0].State;
            cart.BillingCity = billingAddress[0].City;
            cart.BillingCountry = billingAddress[0].Country;
            cart.BillingPostalCode = billingAddress[0].PostalCode;
            //cart.PoNumber = '0001';
            update cart;
            return 'cart Updated with billing address';
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

}
