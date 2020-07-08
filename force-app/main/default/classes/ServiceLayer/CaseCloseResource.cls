@RestResource(urlMapping='/case/*/close')
global with sharing class CaseCloseResource {
    @HttpPost
    global static void closeCase(String reason) {
        // Parse context
        try {
            RestRequest req = RestContext.request;
            String[] uriParts = req.requestURI.split('/');
            Id caseId = uriParts[2];
            // Call the service
            CaseService.closeCases(new Set<ID> { caseId }, reason);
        } catch (DmlException e) {
            System.debug('An exception has occurred: ' + e.getMessage());
        }
    }
}

// To test, open WorkBench: https://workbench.developerforce.com/login.php
// and create a POST request to /services/apexrest/case/5002w000005uOmdAAE/close
// { "reason": "My Reason" }
