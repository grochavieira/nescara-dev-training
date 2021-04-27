public static void postponeEvents(Set<Id> accountsId){
    List<Evento__c> postponedEvents = [
        SELECT Id, Name, Descricao__c, Ativo__c, Status__c, Localidade__c, Tipo__c, Data__c, Conta__c
        FROM Evento__c
        WHERE Ativo__c = true 
        AND Status__c = 'Adiado'
        AND Conta__c In: accountsId
    ];
    
    List<Evento__c> newUpdatedEvents = new List<Evento__c>();
    
    for (Evento__c postponedEvent : postponedEvents){
        if(postponedEvent.Tipo__c == 'Comercial'){
            Date todaysDate = Date.newInstance(
                system.today().year(), 
                system.today().month(), 
                system.today().day()
            );
            
            postponedEvent.Ativo__c = false;
            newUpdatedEvents.add(postponedEvent);
            
            newUpdatedEvents.add(
                new Evento__c(
                    Name = postponedEvent.Name,
                    Descricao__c = postponedEvent.Descricao__c,
                    Ativo__c = true,
                    Localidade__c = postponedEvent.Localidade__c,
                    Tipo__c = postponedEvent.Tipo__c,
                    Status__c = 'Pendente',
                    Data__c = todaysDate,
                    Conta__c = postponedEvent.Conta__c
                )
            );
        } else {
            Date todaysDate = Date.newInstance(
                system.today().year(), 
                system.today().month(), 
                system.today().day()
            );
 
            postponedEvent.Data__c = todaysDate;
            newUpdatedEvents.add(postponedEvent);
        }
    }
    
    upsert newUpdatedEvents;
}
 
List<Account> accounts = [
    Select Id, Name
    FROM Account
    WHERE Name = 'Cliente Teste'
];
 
Set<Id> accountId = new Set<Id>{accounts.get(0).Id};
    
postponeEvents(accountId);

