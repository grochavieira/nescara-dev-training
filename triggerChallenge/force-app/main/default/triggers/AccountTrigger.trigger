trigger AccountTrigger on Account (before delete) {
    AccountTriggerHandler handler = new AccountTriggerHandler(
        Trigger.old,
        Trigger.new,
        Trigger.oldMap,
        Trigger.newMap
    );

    switch on Trigger.operationType {
        when BEFORE_DELETE {
            handler.beforeDelete();
        }
    }
}