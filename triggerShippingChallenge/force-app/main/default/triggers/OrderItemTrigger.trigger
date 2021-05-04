trigger OrderItemTrigger on OrderItem (before insert, after insert, before update, after update, before delete, after delete) {
    if (OrderItemTriggerHandler.isTriggerEnabled()) {
        OrderItemTriggerHandler handler = new OrderItemTriggerHandler(
            Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap
        );

        switch on Trigger.operationType {
            when BEFORE_INSERT {
                handler.beforeInsert();
            }
            
            when AFTER_INSERT {
                handler.afterInsert();
            }

            when BEFORE_UPDATE {
                handler.beforeUpdate();
            }

            when AFTER_UPDATE {
                handler.afterUpdate();
            }

            when BEFORE_DELETE {
                handler.beforeDelete();
            }

            when AFTER_DELETE {
                handler.afterDelete();
            }
        }
    }
}