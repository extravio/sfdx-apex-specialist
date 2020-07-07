@isTest
private class WarehouseSyncScheduleTest {
    // Dummy CRON expression: midnight on March 15.
    // Because this is a test, job executes
    // immediately after Test.stopTest().
    public static String CRON_EXP = '0 0 0 15 3 ? 2022';

    static testmethod void testScheduledJob() {
        
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock());

        Test.startTest();

        
        // Schedule the test job
        String jobId = System.schedule('ScheduledApexTest', CRON_EXP, new WarehouseSyncSchedule());         
        // Verify the scheduled job has not run yet.
        List<Product2> eqts = [SELECT Id, Name FROM Product2];

        System.assertEquals(0, eqts.size(), 'Products exist before job has run');

        // List<Product2>eqts2 = [SELECT Id, Name FROM Product2];
        // System.assertEquals(3, eqts2.size(), 'The number of inserted records is incorrect');


       
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE Id = :jobId];
        
        System.assertEquals(CRON_EXP, ct.CronExpression);

        // Stopping the test will run the job synchronously
        Test.stopTest();
        
    }
}
