public with sharing class MaintenanceRequestHelper {
    public MaintenanceRequestHelper() {
    }

    public static Case createRelatedMaintenanceRequest(Case closedCase) {

        System.debug('MaintenanceRequestHelper.createRelatedMaintenanceRequest called with ID: ' + closedCase.Id);

        // get shortest Maintenance_Cycle__c of all the Equip
        // ideally, this should be in a separate helper class.
        AggregateResult[] groupedResults = [SELECT MIN(Equipment__r.Maintenance_Cycle__c) 
            FROM Work_Part__c 
            WHERE Maintenance_Request__r.Id = :closedCase.Id];
        Decimal days = 0.0;
        If (groupedResults[0].get('expr0') != null) 
          days = (Decimal)groupedResults[0].get('expr0');
        Integer idays = (Integer)days.intValue();

        Case newCase = new Case(

            Status = 'New',
            Type = 'Routine Maintenance',
            Subject = 'Routine Maintenance',
            Origin = closedCase.Origin,
            Vehicle__c = closedCase.Vehicle__c,
            Equipment__c = closedCase.Equipment__c,
            Date_Reported__c = System.today(),
            Date_Due__c = System.today().addDays(idays)
            
        //     ParentId
        );

        // SELECT Id , (SELECT Id FROM Cases__r) FROM Vehicle__c
        // SELECT Id FROM Product2
        // SELECT Id, (SELECT Id FROM Work_Parts__r) FROM Product2
        // SELECT Id, (SELECT Id FROM Work_Parts__r) FROM Case
        // SELECT Id, (SELECT Id FROM Work_Parts__r) FROM Case
        // SELECT Id, Name FROM Work_Part__c WHERE Maintenance_Request__r.Id = '5002w000005A8wIAAS'


        // SELECT Id, Maintenance_Request__r.Id, Maintenance_Request__r.CaseNumber, 
        // Equipment__r.Id, Equipment__r.Maintenance_Cycle__c 
        // FROM Work_Part__c

        // SELECT Maintenance_Request__r.Id, MIN(Equipment__r.Maintenance_Cycle__c)  FROM Work_Part__c GROUP BY Maintenance_Request__r.Id

        // System.debug(newCase.Date_Due__c);

        return newCase;
    }
}
