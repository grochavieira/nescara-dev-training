public with sharing class OrderItemHelper {
    public OrderItemHelper() {}

    public static List<Account> getClientOrdersTotalAmountByStatus(Map<Id, Order> oldMap, Map<Id, Order> newMap) {
        Set<Id> accountIdSet = new Set<Id>();

        for (Order newItem : newMap.values()) {
            Order oldItem = oldMap.get(newItem.Id);

            if ((newItem.Status != oldItem.Status)) {
                accountIdSet.add(newItem.AccountId);
            }
        }

        if (accountIdSet.isEmpty()) return null;

        List<Account> accountList = addClientOrderTotalAmount(accountIdSet);
        return accountList;
    }

    public static List<Account> getClientOrdersTotalAmountByStatus(Map<Id, OrderItem> oldMap, Map<Id, OrderItem> newMap) {
        Set<Id> orderIdSet = new Set<Id>();
        Set<Id> orderItemIdSet = new Set<Id>();

        for (OrderItem newItem : newMap.values()) {
            OrderItem oldItem = oldMap.get(newItem.Id);

            if ((newItem.Quantity != oldItem.Quantity) || (newItem.UnitPrice != oldItem.UnitPrice)) {
                orderIdSet.add(newItem.OrderId);
                orderItemIdSet.add(newItem.Id);
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
        List<Account> newAccountList = addClientAverageProductPrice(accountList, accountIdSet);
        return newAccountList;
    }

    public static List<Account> getClientOrdersTotalAmountByStatus(List<OrderItem> orderItemList) {
        Set<Id> orderIdSet = new Set<Id>();
        Set<Id> orderItemIdSet = new Set<Id>();

        for (OrderItem orderItem : orderItemList) {
            orderIdSet.add(orderItem.OrderId);
            orderItemIdSet.add(orderItem.Id);
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
        List<Account> newAccountList = addClientAverageProductPrice(accountList, accountIdSet);
        return newAccountList;
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
            Account account = new Account(
                Id = key,
                OpenOrdersTotalValue__c = 0,
                ClosedOrdersTotalValue__c = 0,
                CanceledOrdersTotalValue__c = 0,
                AverageProductPrice__c = 0
            );

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

    public static List<Account> addClientAverageProductPrice(List<Account> accountList, Set<Id> accountIdSet) {
        List<AggregateResult> resultList = [
            SELECT Order.AccountId AccountId, AVG(UnitPrice) AverageUnitPrice 
            FROM OrderItem 
            WHERE Order.AccountId IN: accountIdSet
            GROUP BY Order.AccountId
        ];

        Map<Id, Decimal> clientAverageProductPriceMap = new Map<Id, Decimal>();

        for (AggregateResult result : resultList) {
            Id accountId = (Id)result.get('AccountId');
            Decimal averageUnitPrice = (Decimal)result.get('AverageUnitPrice');
            clientAverageProductPriceMap.put(accountId, averageUnitPrice);
        }

        for (Account account : accountList) {
            if (clientAverageProductPriceMap.containsKey(account.Id)) {
                account.AverageProductPrice__c = clientAverageProductPriceMap.get(account.Id);
            }
        }

        return accountList;
    }
}
