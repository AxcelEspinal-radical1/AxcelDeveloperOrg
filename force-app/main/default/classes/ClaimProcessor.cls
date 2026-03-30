public with sharing class ClaimProcessor {
  private ITaxStrategy taxStrategy;

  public ClaimProcessor(ITaxStrategy strategy) {
    this.taxStrategy = strategy;
  }

  public void processAll(List<Claim__c> claims) {
    for (Claim__c claim : claims) {
      claim.Tax_Amount__c = taxStrategy.calculateTax(claim);

      Boolean allmet = true;

      if (claim.Requirements__r != null) {
        for (Requirement__c req : claim.Requirements__r) {
          if (req.Status__c != 'Completed') {
            allmet = false;
            break;
          }
        }
      } else {
        allmet = false;
      }
      if (allMet) {
        claim.Status__c = 'Approved';
      }
    }
  }
}
