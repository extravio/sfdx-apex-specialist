public with sharing class MaintenanceRequestHelper {

    public static void createRelatedMaintenanceRequests(Case[] closedCases) {
    
        List<Case> newCases = new List<Case>();
        List<Work_Part__c> newWorkParts = new List<Work_Part__c>();

        for(Case c : closedCases) {
            newCases.add(MaintenanceRequestHelper.createRelatedMaintenanceRequest(c));
        }
        // System.debug('MaintenanceRequest Trigger - new requests: ' + newCases.size());
        insert newCases;

        // Create related Work Parts
        // Create a Map of the Closed case so that the ycan be retrieved by their Id
        Map<Id, Case> closedCasesMap = new Map<Id, Case>(closedCases);
        System.debug('Closed cases map: ' + closedCasesMap);
        // Iterate through the new Cases
        Case closedCase;
        for(Case newC : newCases) {
            closedCase = closedCasesMap.get(newC.parentId);
            System.debug('Get Work parts from closed case: ' + closedCase);
            for (Work_Part__c wp_closed : closedCase.Work_Parts__r) {
                newWorkParts.add(MaintenanceRequestHelper.createRelatedWorkPart(newC.Id, wp_closed));
            }
        }
        insert newWorkParts;
    }

    
    public static Case createRelatedMaintenanceRequest(Case closedCase) {

        System.debug('MaintenanceRequestHelper.createRelatedMaintenanceRequest called with ID: ' + closedCase.Id);

        // Get lowest maintenance cycle. Maintenance_Cycle__c is Decimal
        // Default to 3 years
        Decimal days = 1095.0;
        for (Work_Part__c wp : closedCase.Work_Parts__r) {
            if (wp.Equipment__r.Maintenance_Cycle__c != null && wp.Equipment__r.Maintenance_Cycle__c < days)
                days = wp.Equipment__r.Maintenance_Cycle__c;
        }
        Integer intDays = days.intValue();
        System.debug('Maintenance Cycle: ' + intDays);

        Case newCase = new Case(
            Status = 'New',
            Type = 'Routine Maintenance',
            Subject = 'Routine Maintenance',
            Origin = closedCase.Origin,
            Vehicle__c = closedCase.Vehicle__c,
            Date_Reported__c = System.today(),
            Date_Due__c = System.today().addDays(intDays),
            ParentId = closedCase.Id
        );

        return newCase;
    }

    public static Work_Part__c createRelatedWorkPart(Id CaseId, Work_Part__c closedWorkPart) {
        Work_Part__c workPart = new Work_Part__c(
            Equipment__c = closedWorkPart.Equipment__c,
            Maintenance_Request__c = CaseId,
            Quantity__c = closedWorkPart.Quantity__c
        );

        System.debug('Create new work part: ' + workPart);
        return workPart;
    }

}
