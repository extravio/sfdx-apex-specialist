# Code samples

## Create a map of Case Id => Maintenance_Cycle__c

```
    Map<Id,AggregateResult> maintenanceCycles = new Map<id,AggregateResult>([SELECT Maintenance_Request__r.Id, 
            MIN(Equipment__r.Maintenance_Cycle__c) 
            FROM Work_Part__c 
            GROUP BY Maintenance_Request__r.Id]
    );
```

## Query to test the MaintenanceRequestHelper

```
Case c = [SELECT Id, Origin, Vehicle__c, Status, Type, (SELECT Equipment__c, Name, Quantity__c, Equipment__r.Maintenance_Cycle__c FROM Work_Parts__r) FROM Case WHERE Id = '5002w000005A8wIAAS'][0];
// System.debug(results.get('5002w000005A8wIAAS').get('expr0'));
System.debug(c);

for (Work_Part__c wp : c.Work_Parts__r) {
	System.debug(wp.Name);
    System.debug(wp.Equipment__r.Maintenance_Cycle__c);
}
```

## Various queries

```
SELECT Id , (SELECT Id FROM Cases__r) FROM Vehicle__c

SELECT Id, (SELECT Id FROM Work_Parts__r) FROM Product2

SELECT Id, (SELECT Id FROM Work_Parts__r) FROM Case

SELECT Id, Name FROM Work_Part__c WHERE Maintenance_Request__r.Id = '5002w000005A8wIAAS'

SELECT Id, Maintenance_Request__r.Id, Maintenance_Request__r.CaseNumber, Equipment__r.Id, Equipment__r.Maintenance_Cycle__c FROM Work_Part__c

SELECT Maintenance_Request__r.Id, MIN(Equipment__r.Maintenance_Cycle__c)  FROM Work_Part__c GROUP BY Maintenance_Request__r.Id
```