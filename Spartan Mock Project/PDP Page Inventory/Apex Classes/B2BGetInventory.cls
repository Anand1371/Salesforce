public with sharing class B2BGetInventory {
    public B2BGetInventory() {

    }
    // Method to check whether Produts are in Stock or Not
  @AuraEnabled(cacheable=true)
  public static String updateStatus(String productId)
  {
    Map<String, Object> resultData = getInventory(productId);
    Decimal availQuantity = (Decimal)resultData.get('Available_for_Purchase__c');
    if(availQuantity<=0)
    {
      List<Product2> product = [SELECT Id, StockKeepingUnit from Product2 WHERE Id=:productId];
      String sku = product[0].StockKeepingUnit;
      Http http = new Http();
      HttpRequest request = new HttpRequest();
      request.setEndpoint(Url.getOrgDomainUrl().toExternalForm() + '/services/apexrest/Inventory__c/'+sku);
      request.setBody('{"Status__c":"Out of Stock"}');
      request.setMethod('PATCH');
		  request.setHeader('Authorization','Bearer '+UserInfo.getSessionId());
      request.setHeader('Content-Type', 'application/json');
      HttpResponse response = http.send(request);
      System.debug('response--'+response);
      if (response.getStatusCode() == 200 || response.getStatusCode() == 201) {
        return 'Stock Field Updated';
      }
      return 'Stock Field Not Updated';
    }
    return 'In Stock - No need to update Stock Status';
  }


  // Method to call getInventory from API Class
  @AuraEnabled(cacheable=true)
  public static Map<String, Object> getInventory(String productId) {
    List<Product2> product = [SELECT Id, StockKeepingUnit from Product2 WHERE Id=:productId];
    String sku = product[0].StockKeepingUnit;
    Http http = new Http();
    Map<String,Object> responseData  = new Map<String,Object>();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(Url.getOrgDomainUrl().toExternalForm() + '/services/apexrest/Inventory__c/'+sku);
    request.setMethod('GET');
		request.setHeader('Authorization','Bearer '+UserInfo.getSessionId());
    request.setHeader('Content-Type', 'application/json');
    HttpResponse response = http.send(request);
    // If the request is successful, parse the JSON response.
    System.debug('response--'+response);
    if (response.getStatusCode() == 200 || response.getStatusCode() == 201) {
      responseData = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
    }
    return responseData;
  }


  //Method to update Inventory for reserve and Commit
  @AuraEnabled(cacheable=true)
  public static String updateInventory(String productId, String sku, Decimal reservedQuantity) {
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    request.setEndpoint(Url.getOrgDomainUrl().toExternalForm() + '/services/apexrest/Inventory__c/'+sku);
    request.setBody('{"Reserved__c":'+reservedQuantity+'}');
    request.setMethod('PATCH');
		request.setHeader('Authorization','Bearer '+UserInfo.getSessionId());
    request.setHeader('Content-Type', 'application/json');
    HttpResponse response = http.send(request);
    //System.debug('Anand'+ reservedQuantity);
    // If the request is successful, parse the JSON response.
    System.debug('response--'+response);
    if (response.getStatusCode() == 200 || response.getStatusCode() == 201) {
      return 'Field Updated';
    }
    return 'Field Not Updated';
  }


  //Method to create case when product is Out of Stock
  @AuraEnabled
  public static string createCase(String productId,String userId){
    try {
      List<User> userlist = [SELECT u.Id, u.ContactId FROM User u WHERE u.Id =:userId];
      Case ca = new Case();
      //ca.Origin = 'Web';
      ca.ContactId = userlist[0].ContactId;
      //ca.AccountId = effectiveAccountId;
      ca.Comments = 'Notify Me When Prodct Available';
      insert ca;
      return 'Successfully created Case';
    } catch (Exception e) {
      throw new AuraHandledException(e.getMessage());
    }
  }


}
