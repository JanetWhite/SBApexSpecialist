@isTest
public class MaintenanceRequestTest {

    static testmethod void testPositive() {
        
        //create cases which should result in new cases
        List<Case> casesList = new List<Case>();
        List<Product2> prodList = new List<Product2>();
        List<Work_Part__c> workList = new List<Work_Part__c>();
        
        for(integer i=0;i<1;i++){
        	Product2 theProduct = new Product2(name='Test'+i,
                                               Maintenance_Cycle__c=10,
                                               Replacement_Part__c=true);
            prodList.add(theProduct);
        }
        insert prodList;
        system.debug('prodList = ' + prodList);
        
        for(integer i=0;i<1;i++){
            Case theCase = new Case(Type='Routine Maintenance', 
                                    Status='New', 
                                    Subject='Test',
                                   	Equipment__c=prodList[i].id);
                casesList.add(theCase);
        }
        insert casesList;
        system.debug('casesList = ' + casesList);
        
        for(integer i=0;i<1;i++){
            Work_Part__c wp = new Work_Part__c(Maintenance_Request__c=casesList[i].id,
                                                 Equipment__c=prodList[i].id,
                                                 Quantity__c=1);
                workList.add(wp);
        }
        system.debug('workList = ' + workList);
        insert workList;
        
        for(case c : casesList){
            c.Status='Closed';
        }
    	
        integer beforeTest = [select count() from Case where Type='Routine Maintenance'];
        Test.startTest();
        	update casesList;
    	Test.stopTest();
        integer afterTest = [select count() from Case where Type='Routine Maintenance'];
        system.assertEquals(beforeTest*2,afterTest);
    
    
    }
    
    
}