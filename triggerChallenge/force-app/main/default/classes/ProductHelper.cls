public with sharing class ProductHelper {
    public ProductHelper() {}

    public static void createProductDisplayURL(List<Product2> productList) {
        for (Product2 product : productList) {
            String productName = product.Name;
            product.DisplayUrl = 'www.empresa.com.br/produtos/' + productName.replace(' ', '-');
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

        Map<String, Integer> basePrice = new Map<String, Integer>();

        basePrice.put('Higiene', 40);
        basePrice.put('Eletrodomestico', 700);
        basePrice.put('Alimenticio', 10);
        basePrice.put('Ferramenta', 150);
        basePrice.put('MaterialConstrucao', 400);
        basePrice.put('QualquerOutraFamilia', 5);

        for (Product2 product: productList) {
            Integer unitPrice = 0;

            if (basePrice.containsKey(product.Family)) {
                unitPrice = basePrice.get(product.Family);
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

