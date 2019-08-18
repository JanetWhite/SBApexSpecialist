@isTest
private class WarehouseCalloutServiceTest {
  // implement your mock callout test here
     @isTest static void testCalloutSuccess() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());
        
        // Call method to test.
        test.startTest();
        WarehouseCalloutService.runWarehouseEquipmentSync();
        test.stopTest();
         
        // Verify products created
        Product2 prod = [select name, Warehouse_SKU__c from product2];
        System.assertEquals(prod.name, 'Test Product');
        System.assertEquals(prod.Warehouse_SKU__c, '100010');
    } 
    
    @isTest static void testSchedule() {
        // This test runs a scheduled job at midnight Sept. 3rd. 2022
        String CRON_EXP = '0 0 0 3 9 ? 2022';
     	// Schedule the test job
       	String jobId = System.schedule('WarehouseSyncSchedule', CRON_EXP, new WarehouseSyncSchedule());
      	// Get the information from the CronTrigger API object 
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId]; 
       	// Verify the expressions are the same System.assertEquals(CRON_EXP, ct.CronExpression); 
      	// Verify the job has not run 
      	System.assertEquals(0, ct.TimesTriggered); 
      	// Verify the next time the job will run 
      	System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));   
      	        
    }
    
}