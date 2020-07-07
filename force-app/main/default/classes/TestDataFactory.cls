@isTest
public with sharing class TestDataFactory {

    //public static List<Case> createMaintenanceRequests(Integer numMaintenanceRequests) {
    public static Case createMaintenanceRequest(String Status, String Type) {
        // List<Case> cases = new List<Case>();
        
        // Create one Vehicle
        Vehicle__c vehicle = new Vehicle__c(Name='Vehicle1');
        insert vehicle;
        ID vehicleID = vehicle.Id;

        // Create 2 Equipements
        Product2 part1 = new Product2(Name = 'Part1', IsActive = true, Maintenance_Cycle__c = 150, Current_Inventory__c = 10, ProductCode = 'Part1', Replacement_Part__c = true);
        insert part1;
        ID part1ID = part1.Id;
        Product2 part2 = new Product2(Name = 'Part2', IsActive = true, Maintenance_Cycle__c = 200, Current_Inventory__c = 10, ProductCode = 'Part2', Replacement_Part__c = true);
        insert part2;
        ID part2ID = part2.Id;

        // Create 1 Maintenance request
        Case maintenanceRequest = new Case(Type = Type, Subject = 'Maintenance', Status = Status, Origin = 'Email', Vehicle__c = vehicleID, Equipment__c = part1ID);
        insert maintenanceRequest;
        ID maintenanceRequestID = maintenanceRequest.Id;

        // Create 2 Work Parts
        Work_Part__c workpart1 = new Work_Part__c(Quantity__c = 1, Maintenance_Request__c = maintenanceRequestID, Equipment__c = part1ID);
        insert workpart1;
        ID workpart1ID = workpart1.Id;
        Work_Part__c workpart2 = new Work_Part__c(Quantity__c = 1, Maintenance_Request__c = maintenanceRequestID, Equipment__c = part2ID);
        insert workpart2;
        ID workpart2ID = workpart2.Id;

        return maintenanceRequest;
    }

    public static void createMaintenanceRequests(Integer numCases, String Status, String Type) {
        
        List<Case> cases = new List<Case>();
        
        // Create one Vehicle
        Vehicle__c vehicle = new Vehicle__c(Name='Vehicle2');
        insert vehicle;
        ID vehicleID = vehicle.Id;

        // Create 1 Piece of Equipement
        Product2 part1 = new Product2(Name = 'Part2', IsActive = true, Maintenance_Cycle__c = 150, Current_Inventory__c = 10, ProductCode = 'Part1', Replacement_Part__c = true);
        insert part1;
        ID part1ID = part1.Id;

        // Create numCases Maintenance request
        for (Integer i = 0; i < numCases; i++) {
            cases.add(new Case (
                    Type = Type,
                    Subject = 'Maintenance',
                    Status = Status,
                    Origin = 'Email',
                    Vehicle__c = vehicleID, 
                    Equipment__c = part1ID
                )
            );
        }

        System.debug('Test Data Factory - number of records : ' + cases.size());
        
        insert cases;
    }
}