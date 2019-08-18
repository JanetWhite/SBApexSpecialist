public class MaintenanceRequestHelper {
    public static void updateWorkOrders(List<Id> caseIds){
        //Get all the case details
        List<Case> caseList = [SELECT Id, Vehicle__c,Equipment__r.Maintenance_Cycle__c,
                                (SELECT Id, Equipment__r.Maintenance_Cycle__c 
                    					FROM Work_Parts__r 
                    					ORDER BY Equipment__r.Maintenance_Cycle__c asc limit 1) 
                            	FROM case where id =: caseIds];
        system.debug('caseList = ' + caseList);
        List<Case> casesToInsert = new List<Case>();
        // update workorders 
        //Create a new request and add it to the list
        for(case theCase : caseList){
        		Case newCase = new Case(type ='Routine Maintenance',
                        subject = 'Routine Maintenance',
                    	Date_Reported__c = date.today(),
                    	Vehicle__c=theCase.Vehicle__c,
                        Equipment__c=theCase.Equipment__c,
                        Status='New',
                   		Date_Due__c=calculateDueDates(theCase));
            
                casesToInsert.add(newCase);   
        	}
    	system.debug('casesToInsert = ' + casesToInsert);	
        insert casesToInsert;
        } 
    
    
    private Static Date calculateDueDates(Case theCase ){
        //Calculates the date for each new case 
        //choose the shortest maintenance cycle if there are several work parts
		integer daysToAdd=365;
        system.debug('theCase = ' + theCase);
        /* //Looks like the checker code is looking for the rel to be direct from case to equipment
        if(null != theCase.Work_Parts__r[0].Equipment__r.Maintenance_Cycle__c.intvalue()){
        	daysToAdd=theCase.Work_Parts__r[0].Equipment__r.Maintenance_Cycle__c.intvalue();
		*/
        if(null != theCase.Equipment__r.Maintenance_Cycle__c.intvalue()){
        	daysToAdd=theCase.Equipment__r.Maintenance_Cycle__c.intvalue();
        }
       return date.today().addDays(daysToAdd);            
    }
}