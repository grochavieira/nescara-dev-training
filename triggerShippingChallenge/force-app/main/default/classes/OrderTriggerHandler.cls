public with sharing class OrderTriggerHandler {
    List<Order> oldList {get; set;}
    List<Order> newList {get; set;}
    Map<Id, Order> oldMap {get; set;}
    Map<Id, Order> newMap {get; set;}

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

    public OrderTriggerHandler() {}

    public OrderTriggerHandler(List<Order> oldList, List<Order> newList, Map<Id, Order> oldMap, Map<Id, Order> newMap) {
        this.oldList = oldList;
        this.newList = newList;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }

    public beforeInsert() {

    }
}
