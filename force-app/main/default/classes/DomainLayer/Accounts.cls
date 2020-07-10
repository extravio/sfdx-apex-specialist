// https://trailhead.salesforce.com/content/learn/modules/apex_patterns_dsl/apex_patterns_dsl_apply_dl_principles
public class Accounts extends fflib_SObjectDomain {
    public Accounts(List<Account> sObjectList) {
        super(sObjectList);
    }
    
    // Note: The Constructor inner class allows the base class method SObjectDomain.triggerHandler 
    // used in the Apex trigger sample shown in the previous unit to create a new instance of the 
    // domain class passing in the sObject list (for example, Trigger.new). 
    // This is a workaround to the present lack of full reflection in Apex. 
    public class Constructor implements fflib_SObjectDomain.IConstructable {
        public fflib_SObjectDomain construct(List<SObject> sObjectList) {
            return new Accounts(sObjectList);
        }
    }

    public override void onApplyDefaults() {
        // Apply defaults to Opportunities
        for(Account acc : (List<Account>) Records) {
            // Set the Description field to the value 'Domain classes rock!'
            acc.Description = 'Domain classes rock!';
        }
    }
    
    // public override void onBeforeInsert() {
    //     for(Account acc : (List<Account>) Records) {
    //         acc.Description = 'Domain classes rock!';
    //      }  
    // }

    public override void onBeforeUpdate(Map<Id, SObject> existingRecords) {
        for(Account acc : (List<Account>) Records) {
            acc.AnnualRevenue = acc.Description.getLevenshteinDistance('Domain classes rock!');
         }  
    }

}