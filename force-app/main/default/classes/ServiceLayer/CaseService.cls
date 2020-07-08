global class CaseService {
    global static void closeCases(Set<Id> caseIds, String reason) {
        // Validate parameters
        if(caseIds == null || caseIds.size() == 0)
            throw new CaseServiceException('Cases not specified.');
        if(reason == null ||reason.length() == 0)
            throw new CaseServiceException('Invalid reason.');
        // Query Cases
        List<Case> cases = [select Id, Status, Reason from Case where Id in :caseIds];
        // Update Cases
        List<Case> casesToUpdate = new List<Case>();
        for(Case c : cases) {
            c.Status = 'Closed';
            c.Reason = reason;
            casesToUpdate.add(c);
        }
        try {
            update casesToUpdate;
            System.debug('Cases updates: ' + casesToUpdate.size());
        } catch (DmlException e) {
            System.debug('A DML exception has occurred: ' + e.getMessage());
            throw e;
        }       
    }
    public class CaseServiceException extends Exception {} 
}
