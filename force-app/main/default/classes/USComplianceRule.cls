public with sharing class USComplianceRule implements IComplianceRule {
  public boolean isCompliant(Claim__c claim) {
    if (claim.Requirements__r == null || claim.Requirements__r.isEmpty()) {
      return false;
    }

    for (Requirement__c req : claim.Requirements__r) {
      if (req.Status__c != 'Completed') {
        return false;
      }
    }
    return true;
  }
}
