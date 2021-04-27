public with sharing class ContactTriggerHandler {
    List<Contact> oldList {get; set;}
    List<Contact> newList {get; set;}
    Map<Id, Contact> newMap {get; set;}
    Map<Id, Contact> oldMap {get; set;}

    public ContactTriggerHandler() {}

    public ContactTriggerHandler(List<Contact> oldList, List<Contact> newList, Map<Id, Contact> oldMap, Map<Id, Contact> newMap) {
        this.oldList = oldList;
        this.newList = newList;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }

    public void afterDelete() {
        List<Account> relatedAccounts = ContactHelper.updateRelatedAccount(this.oldList);
        update relatedAccounts;
    }
}
