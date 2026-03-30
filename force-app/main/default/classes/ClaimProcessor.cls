public with sharing class ClaimProcessor {
  private ITaxStrategy taxStrategy;

  public ClaimProcessor(ITaxStrategy strategy) {
    this.taxStrategy = strategy;
  }

  public void processAll(List<Claim__c> claims) {
    for (Claim__c claim : claims) {
      claim.Tax_Amount__c = taxStrategy.calculateTax(claim);
    }
  }
}
