public with sharing class PriceMarginTriggerHandler {
    List<PriceMargin__c> oldList {get; set;}
    List<PriceMargin__c> newList {get; set;}
    Map<Id, PriceMargin__c> oldMap {get; set;}
    Map<Id, PriceMargin__c> newMap {get; set;}

    public PriceMarginTriggerHandler() {}

    public PriceMarginTriggerHandler(List<OrderItem> oldList, List<OrderItem> newList, Map<Id, OrderItem> oldMap, Map<Id, OrderItem> newMap) {
        this.oldList = oldList;
        this.newList = newList;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }


    public void beforeInsert() {

    }
}
