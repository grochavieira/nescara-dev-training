public with sharing class OrderTriggerHandler {
    List<Order> oldList {get; set;}
    List<Order> newList {get; set;}
    Map<Id, Order> oldMap {get; set;}
    Map<Id, Order> newMap {get; set;}

    public OrderTriggerHandler() {}

    public OrderTriggerHandler(List<Order> oldList, List<Order> newList, Map<Id, Order> oldMap, Map<Id, Order> newMap) {
        this.oldList = oldList;
        this.newList = newList;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }

    public void afterUpdate() {
        List<Account> accountList = OrderItemHelper.getClientOrdersTotalAmountByStatus(this.oldMap, this.newMap);
        if(accountList != null && !accountList.isEmpty()) {
            update accountList;
        }
    }
}
