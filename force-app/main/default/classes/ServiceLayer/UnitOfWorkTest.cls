@isTest
private class UnitOfWorkTest {
    
    @isTest static void challengeComplete() {

        // Create a Unit Of Work
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[] {
                Product2.SObjectType,
                PricebookEntry.SObjectType,
                Opportunity.SObjectType,
                OpportunityLineItem.SObjectType
            }
        );

        Test.startTest();

        AccountContactSetup.AccountContactSetupUoW(uow);

        // Commit the work to the database!
        uow.commitWork();
        
        System.assertEquals(100, [Select Id from Account].size());
        System.assertEquals(500, [Select Id from Contact].size());
        System.assertEquals(500, [Select Id from Note].size());
        
        Test.stopTest();

    }
    
    
    @isTest static void testCreation() {
        OpportunitiesSetup.OpportunitiesRecordsCreate();

        Test.startTest();
        
        System.assertEquals(10, [Select Id from Opportunity].size());
        System.assertEquals(55, [Select Id from Product2].size());
        System.assertEquals(55, [Select Id from OpportunityLineItem].size());
        
        Test.stopTest();

    }

    @isTest static void testCreationUoW() {
        OpportunitiesSetup.OpportunitiesRecordsCreateUoW();

        Test.startTest();
        
        System.assertEquals(10, [Select Id from Opportunity].size());
        System.assertEquals(55, [Select Id from Product2].size());
        System.assertEquals(55, [Select Id from OpportunityLineItem].size());
        
        Test.stopTest();

    }
}