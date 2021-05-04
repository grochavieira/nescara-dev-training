public with sharing class FreightHelper {
    public FreightHelper() {}

    public static void calculateScore(List<Freight__c> freightList) {
        for (Freight__c freight : freightList) {
            Integer score = 0;
            Boolean hasDeliveryIdentification = false;

            if (!String.isEmpty(freight.CEP__C)) {
                score += 1000;
                hasDeliveryIdentification = true;
            }

            if (!String.isEmpty(freight.City__c)) {
                score += 100;
                hasDeliveryIdentification = true;
            }

            if (!String.isEmpty(freight.State__c)) {
                score += 10;
                hasDeliveryIdentification = true;
            }

            if (!hasDeliveryIdentification) {
                freight.addError('O Frete necessita de ao menos 1 campo para identificação de entrega!');
            }
            else {
                freight.Score__c = score;
            }         
        }
    }
}
