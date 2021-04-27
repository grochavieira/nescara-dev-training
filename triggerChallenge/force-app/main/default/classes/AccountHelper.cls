public with sharing class AccountHelper {
    public AccountHelper() {}

    public static void verifyAndBlockClients(List<Account> accountList) {
        Map<String, AccountDeleteBlockTypes__c> accountTypesMap = AccountDeleteBlockTypes__c.getAll();

        Set<String> accountTypes = accountTypesMap.keySet();

        for (Account account : accountList) {
            if (accountTypes.contains(account.Type)) {
                account.addError(System.Label.AccountBlockError);
            }
        }
    }
}
