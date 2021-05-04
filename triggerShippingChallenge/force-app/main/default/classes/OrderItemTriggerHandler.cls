public with sharing class OrderItemTriggerHandler {
    List<OrderItem> oldList {get; set;}
    List<OrderItem> newList {get; set;}
    Map<Id, OrderItem> oldMap {get; set;}
    Map<Id, OrderItem> newMap {get; set;}

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

    public OrderItemTriggerHandler() {}

    public OrderItemTriggerHandler(List<OrderItem> oldList, List<OrderItem> newList, Map<Id, OrderItem> oldMap, Map<Id, OrderItem> newMap) {
        this.oldList = oldList;
        this.newList = newList;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }

    public void beforeInsert() {
        OrderItemHelper.checkOrderItem(this.newList);
    }

    public void afterInsert() {
        List<Order> orderList = OrderItemHelper.calculateFreight(this.newList);
        if(!orderList.isEmpty()) {
            update orderList;
        }
    }

    public void beforeUpdate() {
        OrderItemHelper.checkOrderItem(this.oldMap, this.newMap);
    }

    public void afterUpdate() {
        List<Order> orderList = OrderItemHelper.calculateFreight(this.oldMap, this.newMap);
        if(orderList != null && !orderList.isEmpty()) {
            update orderList;
        }
    }

    public void beforeDelete() {
        OrderItemHelper.checkOrderItem(this.oldList);
    }

    public void afterDelete() {
        List<Order> orderList = OrderItemHelper.calculateFreight(this.oldList);
        if(!orderList.isEmpty()) {
            update orderList;
        }
    }
}
