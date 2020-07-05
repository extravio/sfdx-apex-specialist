trigger MaintenanceRequest on Case (after update) {
  
  // https://developer.salesforce.com/forums/?id=906F0000000Qtw4IAC
  // if(checkRecursive.runOnce()) {

    // Get maintenance requests of type Repair or Routine Maintenance with Closed status
    List<Case> cases = [SELECT Id, Origin, Vehicle__c, Equipment__c, Status, Type
    FROM Case WHERE Id IN :Trigger.New
      AND (Type = 'Repair' OR Type = 'Routine Maintenance')
      AND Status = 'Closed'
    ];

    System.debug('MaintenanceRequest Trigger executing - number of records: ' + cases.size());

    List<Case> newCases = new List<Case>();

    for(Case c : cases) {
      newCases.add(MaintenanceRequestHelper.createRelatedMaintenanceRequest(c));
    }

    System.debug('MaintenanceRequest Trigger - new requests: ' + newCases.size());
    insert newCases;
  // }

}