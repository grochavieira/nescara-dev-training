trigger OrderTrigger on Order (before insert) {

    if (OrderTriggerHandler.isTriggerEnabled()) {
        OrderTriggerHandler handler = new OrderTriggerHandler(
            Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap
        );

        switch on Trigger.operationType {
            when BEFORE_INSERT {
                handler.beforeInsert();
            }
        }
    }   
}