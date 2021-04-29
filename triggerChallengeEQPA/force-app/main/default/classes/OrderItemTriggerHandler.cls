public with sharing class OrderItemTriggerHandler {
    List<OrderItem> oldList {get; set;}
    List<OrderItem> newList {get; set;}
    Map<Id, OrderItem> oldMap {get; set;}
    Map<Id, OrderItem> newMap {get; set;}

    public OrderItemTriggerHandler() {}

    public OrderItemTriggerHandler(List<OrderItem> oldList, List<OrderItem> newList, Map<Id, OrderItem> oldMap, Map<Id, OrderItem> newMap) {
        this.oldList = oldList;
        this.newList = newList;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }

    public void afterInsert() {
        List<Account> accountList = OrderItemHelper.getClientOrdersTotalAmountByStatus(this.newList);
        if(!accountList.isEmpty()) {
            update accountList;
        }
    }

    public void afterUpdate() {
        List<Account> accountList = OrderItemHelper.getClientOrdersTotalAmountByStatus(this.oldMap, this.newMap);
        if(accountList != null && !accountList.isEmpty()) {
            update accountList;
        }
    }

    public void afterDelete() {
        List<Account> accountList = OrderItemHelper.getClientOrdersTotalAmountByStatus(this.oldList);
        if(!accountList.isEmpty()) {
            update accountList;
        }
    }
}
