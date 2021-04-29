public with sharing class OrderItemHelper {
    public OrderItemHelper() {}

    public static List<Account> getClientOrdersTotalAmountByStatus(Map<id, OrderItem> oldMap, Map<id, OrderItem> newMap) {
        Set<Id> orderIdSet = new Set<Id>();

        for (OrderItem newItem : newMap.values()) {
            OrderItem oldItem = oldMap.get(newItem.Id);

            if ((newItem.Quantity != oldItem.Quantity) || (newItem.UnitPrice != oldItem.UnitPrice)) {
                orderIdSet.add(newItem.OrderId);
            }
        }

        if (orderIdSet.isEmpty()) return null;

        List<Order> orderList = [
            SELECT AccountId
            FROM Order
            WHERE Id IN: orderIdSet
        ];

        Set<Id> accountIdSet = new Set<Id>();

        for (Order order : orderList) {
            accountIdSet.add(order.AccountId);
        }

        List<Account> accountList = addClientOrderTotalAmount(accountIdSet);
        return accountList;
    }

    public static List<Account> getClientOrdersTotalAmountByStatus(List<OrderItem> orderItemList) {
        Set<Id> orderIdSet = new Set<Id>();

        for (OrderItem orderItem : orderItemList) {
            orderIdSet.add(orderItem.OrderId);
        }

        List<Order> orderList = [
            SELECT AccountId
            FROM Order
            WHERE Id IN: orderIdSet
        ];

        Set<Id> accountIdSet = new Set<Id>();

        for (Order order : orderList) {
            accountIdSet.add(order.AccountId);
        }

        List<Account> accountList = addClientOrderTotalAmount(accountIdSet);
        return accountList;
    }

    public static List<Account> addClientOrderTotalAmount(Set<Id> accountIdSet) {
        List<AggregateResult> resultList = getOrdersTotalAmount(accountIdSet);
        Map<Id, Map<String, Decimal>> aggregateAccountMap = new Map<Id, Map<String, Decimal>>();

        for (AggregateResult aggregateResult: resultList) {
            Id accountId = (Id)aggregateResult.get('AccountId');
            String status = (String)aggregateResult.get('Status');
            Decimal totalAmount = (Decimal)aggregateResult.get('TotalAmount');

            if (aggregateAccountMap.containsKey(accountId)) {
                aggregateAccountMap.get(accountId).put(
                    status, 
                    totalAmount
                );
            }
            else {
                aggregateAccountMap.put(
                    accountId, 
                    new Map<String, Decimal> {
                    status => totalAmount
                });
            }
        }

        List<Account> accountList = new List<Account>();

        for (Id key: aggregateAccountMap.keySet()) {
            Map<String, Decimal> statusToTotalAmountMap = aggregateAccountMap.get(key);
            Account account = new Account(Id = key);

            if (statusToTotalAmountMap.containsKey('Open')) {
                account.OpenOrdersTotalValue__c = statusToTotalAmountMap.get('Open');
            }
            if (statusToTotalAmountMap.containsKey('Closed')) {
                account.ClosedOrdersTotalValue__c = statusToTotalAmountMap.get('Closed');
            }
            if (statusToTotalAmountMap.containsKey('Canceled')) {
                account.CanceledOrdersTotalValue__c = statusToTotalAmountMap.get('Canceled');
            }

            accountList.add(account);
        }

        return accountList;
    }

    public static List<AggregateResult> getOrdersTotalAmount(Set<Id> accountIdSet) {
        List<AggregateResult> resultList = [
            SELECT AccountId, Status, SUM(TotalAmount) TotalAmount
            FROM Order
            WHERE AccountId IN: accountIdSet
            GROUP BY AccountId, Status
        ];

        return resultList;
    } 
}
