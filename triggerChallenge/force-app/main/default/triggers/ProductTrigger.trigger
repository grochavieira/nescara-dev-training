trigger ProductTrigger on Product2 (before insert, after insert) {
    ProductTriggerHandler handler = new ProductTriggerHandler(
        Trigger.old,
        Trigger.new,
        Trigger.oldMap,
        Trigger.newMap
    );
    
    switch on Trigger.operationType {
        when BEFORE_INSERT {
            handler.beforeInsert();
        }

        when AFTER_INSERT {
            handler.afterInsert();
        }
    }
}