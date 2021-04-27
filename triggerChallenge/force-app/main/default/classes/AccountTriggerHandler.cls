public with sharing class AccountTriggerHandler {
    List<Account> oldList {get; set;}
    List<Account> newList {get; set;}
    Map<Id, Account> newMap {get; set;}
    Map<Id, Account> oldMap {get; set;}

    public AccountTriggerHandler() {}

    public AccountTriggerHandler(List<Account> oldList, List<Account> newList, Map<Id, Account> oldMap, Map<Id, Account> newMap) {
        this.oldList = oldList;
        this.newList = newList;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }

    public void beforeDelete() {
        AccountHelper.verifyAndBlockClients(this.oldList);
    }

}
