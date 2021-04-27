public with sharing class OpportunityLineItemHelper {
    public OpportunityLineItemHelper() {}

    public static void checkItemQuantityChange(Map<Id, OpportunityLineItem> oldMap, Map<Id, OpportunityLineItem> newMap) {
        for (OpportunityLineItem newItem : newMap.values()) {
            OpportunityLineItem oldItem = oldMap.get(newItem.Id);

            if (newItem.Quantity > oldItem.Quantity) {
                newItem.addError(System.Label.OpportunityLineItemChangeError);  
            }
            else if (newItem.Quantity < oldItem.Quantity) {
                newItem.ServiceDate = Datetime.now().date();
            }
        }
    }

    public static List<Opportunity> checkItemChange(Map<Id, OpportunityLineItem> oldMap, Map<Id, OpportunityLineItem> newMap) {
        Set<Id> opportunityIdSet = new Set<Id>();

        for (OpportunityLineItem newItem : newMap.values()) {
            OpportunityLineItem oldItem = oldMap.get(newItem.id);

            if ((newItem.Quantity != oldItem.Quantity) || (newItem.UnitPrice != oldItem.UnitPrice)) {
                opportunityIdSet.add(newItem.OpportunityId);
            }
        }

        List<Opportunity> relatedOpportunities = [
            SELECT Id, StageName
            FROM Opportunity
            WHERE Id IN: opportunityIdSet
            AND StageName != 'Prospect'
        ];

        for (Opportunity opportunity : relatedOpportunities) {
            opportunity.StageName = 'Prospect';
        }

        return relatedOpportunities;
    }
}
