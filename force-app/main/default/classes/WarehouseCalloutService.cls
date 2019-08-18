public with sharing class WarehouseCalloutService {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    // complete this method to make the callout (using @future) to the
    // REST endpoint and update equipment on hand.
    @future(callout=true)
    public static void runWarehouseEquipmentSync(){
        
        List<Product2> invToUpsert = new List<Product2>();
        Http http = new Http();
		HttpRequest request = new HttpRequest();
        request.setEndpoint('https://th-superbadge-apex.herokuapp.com/equipment');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        // If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            // Deserialize the JSON string into collections of primitive data types.
            List<Object> results = (List<Object>) JSON.deserializeUntyped(response.getBody());
            // Loop through and map to upsert equipment
            for(Object r: results){
                Map<String, Object> mapProduct = (Map<String, Object>)r;
                Product2 product = new Product2();
                product.Name = (String)mapProduct.get('name');
                product.Warehouse_SKU__c = (String)mapProduct.get('sku');
                product.Replacement_Part__c = true;
                product.Current_Inventory__c = (Decimal)mapProduct.get('quantity');
                product.Maintenance_Cycle__c = (Decimal)mapProduct.get('maintenanceperiod');
                product.Lifespan_Months__c = (Decimal)mapProduct.get('lifespan');
                product.Cost__c = (Decimal)mapProduct.get('cost');
                     invToUpsert.add(product); 
                system.debug('invToUpsert = ' + invToUpsert);
                    }
                
                    upsert invToUpsert Warehouse_SKU__c;
                
      	}
	}
}