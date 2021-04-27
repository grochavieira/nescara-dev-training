public with sharing class ProductHelper {
    public ProductHelper() {}

    public static void createProductDisplayURL(List<Product2> productList) {
        for (Product2 product : productList) {
            product.DisplayUrl = System.Label.BaseURL + product.Name.replace(' ', '-');
        }
    }

    public static List<PricebookEntry> standardPriceCatalogProductRegistration(List<Product2> productList) {
        List<Pricebook2> pricebookList = [
            SELECT Id, Name
            FROM Pricebook2
            WHERE isStandard = true
        ];

        Pricebook2 standardPricebook = pricebookList.get(0); 

        List<PricebookEntry> entryList = new List<PricebookEntry>();

        Map<String, BasePrice__c> basePriceMap = BasePrice__c.getAll();

        for (Product2 product: productList) {
            Decimal unitPrice = 0;

            if (basePriceMap.containsKey(product.Family)) {
                unitPrice = basePriceMap.get(product.Family).Value__c;
            } else {
              unitPrice = 5;  
            }

            PricebookEntry entry = new PricebookEntry(
                Pricebook2Id = standardPricebook.Id,
                Product2Id = product.Id,
                UnitPrice = unitPrice
            );

            entryList.add(entry);
        }

        return entryList;
    }
}

