public with sharing class ClaimProcessor {
    private USTaxStrategy strategy;

    public ClaimProcessor() {
        this.strategy = new USTaxStrategy();
    }

    public static void processAll(List<Claim__c> claims) {
        ClaimProcessor processor = new ClaimProcessor();
        for (Claim__c claim : claims) {
            claim.Tax_Amount__c = processor.strategy.calculateTax(claim.Amount__c);
        }
    }
}