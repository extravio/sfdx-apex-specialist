@isTest
private class MaintenanceRequestHelperTest {
    // public MaintenanceRequestHelperTest() {
    // }
    
    @isTest static void TestCreateRelatedMaintenanceRequest() {
        // Test data setup
        // Create one account with one opportunity by calling a utility method
        // Status = Working - no trigger
        Case maintenanceRequest = TestDataFactory.createMaintenanceRequest('Working', 'Repair');
        
        // update status to 'Closed' and Type to 'Repair' to trigger the Maintenance Request Creation
        // RecursiveTriggerHandler.FirstRun = true;
        maintenanceRequest.Status = 'Closed';
        update maintenanceRequest;

        // Perform test
        Test.startTest();
        
        List<Case> cases = [SELECT Id, Origin, Vehicle__c, Status, Type, Subject, Equipment__c,
            (SELECT Equipment__c, Name, Quantity__c, Equipment__r.Maintenance_Cycle__c FROM Work_Parts__r)
            FROM Case WHERE Type =  'Repair'];
        System.assertEquals(1, cases.size(), 'The test case doesn\'t exist');
        Case existingCase = cases.get(0);

        // check that the maintenance cycle is 150
        AggregateResult[] groupedResults = [SELECT MIN(Equipment__r.Maintenance_Cycle__c) FROM Work_Part__c];
        Decimal days = (Decimal)groupedResults[0].get('expr0');
        System.assertEquals(150, days.intValue(), 'The maintenance cycle is incorrect');
        
        Test.stopTest();

        List<Case> newCases = [SELECT Id, Origin, Vehicle__c, Status, Type, Date_Due__c, ParentId, Equipment__c,
            (SELECT Equipment__c, Name, Quantity__c, Equipment__r.Maintenance_Cycle__c FROM Work_Parts__r)
            FROM Case WHERE Type =  'Routine Maintenance' AND Status = 'New'];
        
        System.assertEquals(1, newCases.size(), 'The number of new test cases is incorrect');
        Case newCase = newCases.get(0);
        System.assertEquals('New', newCase.Status, 'The new case status is incorrect.');
        Date dueDate = System.today().addDays(150);
        System.assertEquals(dueDate, newCase.Date_Due__c, 'The new case due date is incorrect.');
        System.assertEquals(existingCase.Id, newCase.ParentId, 'The parent ID has not been set properly.');
        System.assertEquals(existingCase.Equipment__c, newCase.Equipment__c, 'The Equipment__c has not been set properly.');
        System.assertEquals(2, newCase.Work_Parts__r.size(), 'The number of related Work Parts records is incorrect.');
        
    }

    @isTest static void MaintenanceRequestTriggerNegativeTest() {
        
        Case maintenanceRequest = TestDataFactory.createMaintenanceRequest('Working', 'Other');
        
        // Perform test
        Test.startTest();

        // update type to 'Other' and status to 'Closed'. The trigger should not create a new request
        // RecursiveTriggerHandler.FirstRun = true;
        maintenanceRequest.Status = 'Closed';
        update maintenanceRequest;

        System.debug('Maintenance request updated: Status: ' + maintenanceRequest.Status + ' - Type: ' + maintenanceRequest.Type);
         

        Test.stopTest();
        
        List<Case> oldCases = [SELECT Id, Origin, Vehicle__c FROM Case WHERE Type =  'Other' AND Status = 'Closed'];
        System.assertEquals(1, oldCases.size(), 'The closed test case doesn\'t exist');
        List<Case> newCases = [SELECT Id, Origin, Vehicle__c FROM Case WHERE Type =  'Routine Maintenance' AND Status = 'New'];
        System.assertEquals(0, newCases.size(), 'A new test case has been created');

    }

    // @isTest static void MaintenanceRequestTriggerBulk() {
        
    //     Test.startTest();
    //     TestDataFactory.createMaintenanceRequests(200, 'Closed', 'Repair');
    //     Test.stopTest();
        
    //     List<Case> oldCases = [SELECT Id, Origin, Vehicle__c FROM Case WHERE Type =  'Repair' AND Status = 'Closed'];
    //     System.assertEquals(200, oldCases.size(), 'The number of closed test cases is incorrect');
    //     List<Case> newCases = [SELECT Id, Origin, Vehicle__c FROM Case WHERE Type =  'Routine Maintenance' AND Status = 'New'];
    //     System.assertEquals(200, newCases.size(), 'The number of new test cases is incorrect');

    // }
}