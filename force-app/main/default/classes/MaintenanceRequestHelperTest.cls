@isTest
private class MaintenanceRequestHelperTest {
    // public MaintenanceRequestHelperTest() {
    // }
    
    @isTest static void TestCreateRelatedMaintenanceRequest() {
        // Test data setup
        // Create one account with one opportunity by calling a utility method
        Case maintenanceRequest = TestDataFactory.createMaintenanceRequest();
        
        // Perform test
        Test.startTest();
        
        List<Case> cases = [SELECT Id, Origin, Vehicle__c, Status, Type,
            (SELECT Equipment__c, Name, Quantity__c, Equipment__r.Maintenance_Cycle__c FROM Work_Parts__r)
            FROM Case WHERE Type =  'Repair'];
        System.assertEquals(1, cases.size(), 'The test case doesn\'t exist');
        Case existingCase = cases.get(0);

        // check that the maintenance cycle is 150
        AggregateResult[] groupedResults = [SELECT MIN(Equipment__r.Maintenance_Cycle__c) FROM Work_Part__c];
        Decimal days = (Decimal)groupedResults[0].get('expr0');
        System.assertEquals(150, days.intValue(), 'The maintenance cycle is incorrect');
        
        MaintenanceRequestHelper.createRelatedMaintenanceRequests(cases);

        Test.stopTest();

        List<Case> newCases = [SELECT Id, Origin, Vehicle__c, Status, Type, Date_Due__c, ParentId,
            (SELECT Equipment__c, Name, Quantity__c, Equipment__r.Maintenance_Cycle__c FROM Work_Parts__r)
            FROM Case WHERE Type =  'Routine Maintenance'];
        
        System.assertEquals(1, newCases.size(), 'The new test case has not been created');
        Case newCase = newCases.get(0);
        System.assertEquals('New', newCase.Status, 'The new case status is incorrect.');
        Date dueDate = System.today().addDays(150);
        System.assertEquals(dueDate, newCase.Date_Due__c, 'The new case due date is incorrect.');
        System.assertEquals(existingCase.Id, newCase.ParentId, 'The parent ID has not been set properly.');
        System.assertEquals(2, newCase.Work_Parts__r.size(), 'The number of related Work Parts records is incorrect.');
        
    }        
}