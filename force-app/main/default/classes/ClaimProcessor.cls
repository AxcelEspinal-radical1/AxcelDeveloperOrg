public with sharing class ClaimProcessor {
  private ITaxStrategy taxStrategy;
  private IComplianceRule complianceRule;

  public ClaimProcessor(ITaxStrategy strategy, IComplianceRule rule) {
    this.taxStrategy = strategy;
    this.complianceRule = rule;
  }

  public void processAll(List<Claim__c> claims) {
    for (Claim__c claim : claims) {
      claim.Tax_Amount__c = taxStrategy.calculateTax(claim);

      if (complianceRule.isCompliant(claim)) {
        claim.Status__c = 'Approved';
      }
    }
  }
}
