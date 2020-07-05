@isTest
public with sharing class MaintenanceRequestHelperTest {
    // public MaintenanceRequestHelperTest() {
    // }
    
    @isTest static void TestCreateRelatedMaintenanceRequest() {
        // Test data setup
        // Create one account with one opportunity by calling a utility method
        Case maintenanceRequest = TestDataFactory.createMaintenanceRequest();
        
        // Perform test
        Test.startTest();
        
        List<Case> cases = [SELECT Id, Origin, Vehicle__c, Equipment__c, Status, Type FROM Case WHERE Type =  'Repair'];
        System.assertEquals(1, cases.size(), 'The test case doesn\'t exist');
        Case existingCase = cases.get(0);
        Case newCase = MaintenanceRequestHelper.createRelatedMaintenanceRequest(existingCase);
        
        AggregateResult[] groupedResults = [SELECT MIN(Equipment__r.Maintenance_Cycle__c) FROM Work_Part__c];
        Decimal days = (Decimal)groupedResults[0].get('expr0');
        System.assertEquals(150, days.intValue(), 'The maintenance cycle is incorrect');

        Test.stopTest();

        System.assertEquals('New', newCase.Status, 'The new case status is incorrect.');
        Date dueDate = System.today().addDays(150);
        System.assertEquals(dueDate, newCase.Date_Due__c, 'The new case due date is incorrect.');
        
    }        
}