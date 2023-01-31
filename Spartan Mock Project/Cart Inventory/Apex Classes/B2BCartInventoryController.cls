public with sharing class B2BCartInventoryController {
    public B2BCartInventoryController() {

    }

    @AuraEnabled
    public static void removeCartItem(String cartItemId){
        try {
            List<CartItem> cartItemData = [SELECT Id, Product2Id, Quantity, Sku FROM CartItem WHERE Id=:cartItemId];
            Map<String, Decimal> cartItemsData = new Map<String, Decimal>();
            List<String> productIds = new List<String>();
            cartItemsData.put(cartItemData[0].Product2Id,cartItemData[0].Quantity);
            productIds.add(cartItemData[0].Product2Id);
            Map<String, Object> removeCartData = new Map<String, Object>{'check' => 'removeCart', 'productId' => productIds, 'reqBody' => cartItemsData};
            System.debug(removeCartData);
            updateInventory(removeCartData);
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void clearCartItems(String cartId){
        try {
            Map<String, Decimal> cartItemsData = new Map<String, Decimal>();
            List<String> productIds = new List<String>();
            for(CartItem items : [SELECT Id, CartId, Product2Id, Quantity, Sku FROM CartItem WHERE CartId=:cartId])
            {
                productIds.add(items.Product2Id);
                cartItemsData.put(items.Product2Id, items.Quantity);  
            }
            Map<String, Object> clearCartData = new Map<String, Object>{'check' => 'clearCart', 'productId' => productIds, 'reqBody' => cartItemsData};
            System.debug(clearCartData);
            updateInventory(clearCartData);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void quantityChange(Decimal newQua, String cartItemId){
        try {
            Decimal finalQua;
            List<CartItem> cartItemData = [SELECT Id, Product2Id, Quantity, Sku FROM CartItem WHERE Id=:cartItemId];
            Map<String, Decimal> cartItemsData = new Map<String, Decimal>();
            List<String> productIds = new List<String>();
            productIds.add(cartItemData[0].Product2Id);
            Decimal oldQua = cartItemData[0].Quantity;
            if(newQua > oldQua)
            {
                finalQua = newQua - oldQua;
                cartItemsData.put(cartItemData[0].Product2Id,finalQua);
                Map<String, Object> removeCartData = new Map<String, Object>{'check' => 'increasedQuantity', 'productId' => productIds, 'reqBody' => cartItemsData};
                System.debug(removeCartData);
                updateInventory(removeCartData);
            }
            else if(oldQua > newQua)
            {
                finalQua = oldQua - newQua;
                cartItemsData.put(cartItemData[0].Product2Id,finalQua);
                Map<String, Object> removeCartData = new Map<String, Object>{'check' => 'decreasedQuantity', 'productId' => productIds, 'reqBody' => cartItemsData};
                System.debug(removeCartData);
                updateInventory(removeCartData);
            }
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static Decimal inventory(String cartItemId){
        try {
            List<CartItem> cartItemData = [SELECT Id, Product2Id, Quantity, Sku FROM CartItem WHERE Id=:cartItemId];
            String productId = cartItemData[0].Product2Id;
            Map<String, Object> resultData = B2BGetInventory.getInventory(productId);
            Decimal available_stock = (Decimal)resultData.get('Available_for_Purchase__c') + cartItemData[0].Quantity;
            System.debug(available_stock);
            return available_stock;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void updateInventory(Map<String, Object> reqBody)
    {
        String data = JSON.Serialize(reqBody);
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(Url.getOrgDomainUrl().toExternalForm() + '/services/apexrest/Inventory__c');
        request.setBody(data);
        request.setMethod('PATCH');
		request.setHeader('Authorization','Bearer '+UserInfo.getSessionId());
        request.setHeader('Content-Type', 'application/json');
        HttpResponse response = http.send(request);
        System.debug('response--'+response);
    }
}
