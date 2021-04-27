public with sharing class ProductTriggerHandler {
    List<Product2> oldList {get; set;}
    List<Product2> newList {get; set;}
    Map<Id, Product2> newMap {get; set;}
    Map<Id, Product2> oldMap {get; set;}

    public ProductTriggerHandler(List<Product2> oldList, List<Product2> newList, Map<Id, Product2> oldMap, Map<Id, Product2> newMap) {
        this.oldList = oldList;
        this.newList = newList;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }

    public void beforeInsert() {
        ProductHelper.createProductDisplayURL(this.newList);
    }

    public void afterInsert() {
       List<PricebookEntry> entryList = ProductHelper.standardPriceCatalogProductRegistration(this.newList);
       insert entryList;
    }
}
