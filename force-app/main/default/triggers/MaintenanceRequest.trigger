trigger MaintenanceRequest on Case (after update) {
  
  // https://developer.salesforce.com/forums/?id=906F0000000Qtw4IAC

  System.debug('Trigger called: ' + Trigger.operationType);
  System.debug('RecursiveTriggerHandler.FirstRun: ' + RecursiveTriggerHandler.FirstRun);
  // if (RecursiveTriggerHandler.FirstRun) {

  //   RecursiveTriggerHandler.FirstRun = false;

    // Get maintenance requests of type Repair or Routine Maintenance with Closed status
    List<Case> cases = [SELECT Id, Origin, Vehicle__c, Subject, Status, Type, Equipment__c,
      (SELECT Equipment__c, Name, Quantity__c, Equipment__r.Maintenance_Cycle__c FROM Work_Parts__r)
      FROM Case WHERE Id IN :Trigger.New
        AND (Type = 'Repair' OR Type = 'Routine Maintenance')
        AND Status = 'Closed'
    ];

    System.debug('MaintenanceRequest Trigger executing - number of records: ' + cases.size());
    MaintenanceRequestHelper.createRelatedMaintenanceRequests(cases);
  // }
}