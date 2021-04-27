public with sharing class OpportunityLineItemTriggerHandler {
    List<OpportunityLineItem> newList {get; set;}
    List<OpportunityLineItem> oldList {get; set;}
    Map<Id, OpportunityLineItem> newMap {get; set;}
    Map<Id, OpportunityLineItem> oldMap {get; set;}

    public OpportunityLineItemTriggerHandler() {}

    public OpportunityLineItemTriggerHandler(List<OpportunityLineItem> oldList, List<OpportunityLineItem> newList, Map<Id, OpportunityLineItem> oldMap, Map<Id, OpportunityLineItem> newMap) {
        this.oldList = oldList;
        this.newList = newList;
        this.oldMap = oldMap;
        this.newMap = newMap;
    }

    public void beforeUpdate() {
        OpportunityLineItemHelper.checkItemQuantityChange(this.oldMap, this.newMap);
    }

    public void afterUpdate() {
        List<Opportunity> relatedOpportunities = OpportunityLineItemHelper.checkItemChange(this.oldMap, this.newMap);
        update relatedOpportunities;
    }
}
