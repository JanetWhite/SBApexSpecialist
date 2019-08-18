trigger MaintenanceRequest on Case (after update) {
    
    List<Id> CaseIds = new List<Id>();
    for (case c : trigger.new){
        if((c.Type=='Repair ' || c.Type=='Routine Maintenance')
           && (trigger.oldMap.get(c.Id).Status != c.Status) && c.Status=='Closed'){
              caseIds.add(c.Id); 
           }
        
    }    
    MaintenanceRequestHelper.updateWorkOrders(caseIds);
}