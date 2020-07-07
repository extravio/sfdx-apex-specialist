@isTest
private class TestDataFactoryBulk {
    
    @isTest static void TestBulk() {

        // create vehicle
        Vehicle__c vehicle = new Vehicle__c(Name='1984 AMC Spirit Coupe');
        insert vehicle;
        
        // create a new product2/equipment
        Product2 equipment = new Product2();
        equipment.Name='Astro Cup Holder';
        equipment.Cost__c = 100;
        equipment.Current_Inventory__c = 1;
        equipment.Lifespan_Months__c = 1;
        equipment.Maintenance_Cycle__c = 30;        
        equipment.Warehouse_SKU__c = '#holdthis';
        equipment.IsActive = true;
        insert equipment;   


        // insert 201 work orders as open with routine maintenance
        List<Case> cases = new List<Case>();
        for (Integer i=0;i<201;i++) {
            Case c = new Case();
            c.Subject = vehicle.Name;
            c.Vehicle__c = vehicle.Id;
            c.Status = 'New';
            c.Type = 'Routine Maintenance';
            c.Equipment__c = equipment.Id;
            c.Date_Reported__c = System.today();
            cases.add(c);
        }
        insert cases;

        // update all of the work orders as closed -- should create 200 more
        for (Case c : cases) {
            c.Status = 'Closed';
        }
        update cases;

        System.assertEquals(402, [select count() from Case where Equipment__c = :equipment.Id]);
    }
}
