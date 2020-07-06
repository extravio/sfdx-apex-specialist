@isTest
private class MaintenanceRequestTriggerTest {

    @isTest static void MaintenanceRequestTriggerTest() {
        // Test data setup
        Case maintenanceRequest = TestDataFactory.createMaintenanceRequest();
        
        // Perform test
        Test.startTest();

        // update status to 'Closed' to trigger the Maintenance Request Creation
        maintenanceRequest.Status = 'Closed';
        update maintenanceRequest;

        System.debug('Maintenance request updated: Status: ' + maintenanceRequest.Status + ' - Type: ' + maintenanceRequest.Type);
         

        Test.stopTest();
        
        List<Case> oldCases = [SELECT Id, Origin, Vehicle__c FROM Case WHERE Type =  'Repair' AND Status = 'Closed'];
        System.assertEquals(1, oldCases.size(), 'The closed test case doesn\'t exist');
        List<Case> newCases = [SELECT Id, Origin, Vehicle__c FROM Case WHERE Type =  'Routine Maintenance' AND Status = 'New'];
        System.assertEquals(1, newCases.size(), 'The new test case doesn\'t exist');

    }

    @isTest static void MaintenanceRequestTriggerNegativeTest() {
        
        Case maintenanceRequest = TestDataFactory.createMaintenanceRequest();
        
        // Perform test
        Test.startTest();

        // update type to 'Other' and status to 'Closed'. The trigger should not create a new request
        maintenanceRequest.Type = 'Other';
        maintenanceRequest.Status = 'Closed';
        update maintenanceRequest;

        System.debug('Maintenance request updated: Status: ' + maintenanceRequest.Status + ' - Type: ' + maintenanceRequest.Type);
         

        Test.stopTest();
        
        List<Case> oldCases = [SELECT Id, Origin, Vehicle__c FROM Case WHERE Type =  'Other' AND Status = 'Closed'];
        System.assertEquals(1, oldCases.size(), 'The closed test case doesn\'t exist');
        List<Case> newCases = [SELECT Id, Origin, Vehicle__c FROM Case WHERE Type =  'Routine Maintenance' AND Status = 'New'];
        System.assertEquals(0, newCases.size(), 'A new test case has been created');

    }
}
