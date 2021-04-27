public with sharing class ContactHelper {
    public ContactHelper() {}

    public static List<Account> updateRelatedAccount(List<Contact> contactList) {
        Set<Id> accountIds = new Set<Id>();

        for (Contact contact : contactList) {
            accountIds.add(contact.AccountId);
        }

        List<Account> relatedAccounts = [
            SELECT Id, Name
            FROM Account
            WHERE Id IN: accountIds
        ];

        for (Account account : relatedAccounts) {
            account.NecessitaAtualizarContato__c = true;
        }

        return relatedAccounts;
    }
}
