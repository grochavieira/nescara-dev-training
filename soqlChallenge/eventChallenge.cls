public static Map<String, List<Evento__c>> getNextEvents(Date maxDate, Set<String> eventTypes){
    Date todaysDate = Date.newInstance(
        system.today().year(), 
        system.today().month(), 
        system.today().day()
    );
    
    List<Evento__c> eventList = [
        SELECT Id, Name, Data__c, Tipo__c
        FROM Evento__c
        WHERE Ativo__c = true
        AND Tipo__c In: eventTypes
        AND (Data__c >=: todaysDate AND Data__c <=: maxDate)
    ];
    
    Map<String, List<Evento__c>> mapTypeToEvent = new Map<String,List<Evento__c>>();
 
    for (Evento__c event : eventList) {
        if (mapTypeToEvent.containsKey(event.Tipo__c)) {
            mapTypeToEvent.get(event.Tipo__c).add(event);
        }
        else {
            mapTypeToEvent.put(event.Tipo__c, new List<Evento__c> {
                event
            });
        }
    }
        
    return mapTypeToEvent;
}
 
Date maxDate = Date.newInstance(2021, 06, 20);
Set<String> eventTypes = new Set<String>{'Comercial', 'Festa'};
 
System.debug(getNextEvents(maxDate, eventTypes));