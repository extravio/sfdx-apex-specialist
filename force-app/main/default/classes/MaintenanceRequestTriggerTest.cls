@isTest
public with sharing class MaintenanceRequestTriggerTest {

    @isTest static void MaintenanceRequestTriggerTest() {
        // Test data setup
        // Create one account with one opportunity by calling a utility method
        Case maintenanceRequest = TestDataFactory.createMaintenanceRequest();
        
        // Perform test
        Test.startTest();

        // update status to close to trigger the Maintenance Request Creation
        maintenanceRequest.Status = 'Closed';
        update maintenanceRequest;

        System.debug('Maintenance request updated: Status: ' + maintenanceRequest.Status + ' - Type: ' + maintenanceRequest.Type);
         

        Test.stopTest();
        
        List<Case> oldCases = [SELECT Id, Origin, Vehicle__c, Equipment__c FROM Case WHERE Type =  'Repair' AND Status = 'Closed'];
        System.assertEquals(1, oldCases.size(), 'The closed test case doesn\'t exist');
        List<Case> newCases = [SELECT Id, Origin, Vehicle__c, Equipment__c FROM Case WHERE Type =  'Routine Maintenance' AND Status = 'New'];
        System.assertEquals(1, newCases.size(), 'The new test case doesn\'t exist');

    }
}
