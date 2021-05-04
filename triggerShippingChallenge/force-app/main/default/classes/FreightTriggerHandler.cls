public with sharing class FreightTriggerHandler {
    List<Freight__c> oldList {get; set;}
    List<Freight__c> newList {get; set;}
    Map<Id, Freight__c> oldMap {get; set;}
    Map<Id, Freight__c> newMap {get; set;}
    
    public static Boolean runTrigger;

    static {
        runTrigger = true;
    }

    public static Boolean isTriggerEnabled() {
        return runTrigger;
    }

    public static Boolean enableTrigger() {
        return runTrigger = true;
    }
    
    public static Boolean disableTrigger() {
        return runTrigger = false;
    }

    public FreightTriggerHandler() {}

    public FreightTriggerHandler(List<Freight__c> oldList, List<Freight__c> newList, Map<Id, Freight__c> oldMap, Map<Id, Freight__c> newMap) {
        this.oldList = oldList;
        this.newList = newList;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }

    public void beforeInsert() {
        FreightHelper.calculateScore(this.newList);
    }
}
