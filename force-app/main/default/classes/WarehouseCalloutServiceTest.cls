@isTest
private class WarehouseCalloutServiceTest {
    @isTest static  void testRunWarehouseEquipmentSync() {
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

        // Perform test
        Test.startTest();

        WarehouseCalloutService.runWarehouseEquipmentSync();

        Test.stopTest();

        List<Product2> eqts = [SELECT Id, Name FROM Product2];

        System.assertEquals(3, eqts.size(), 'The number of inserted records is incorrect');


    }
}