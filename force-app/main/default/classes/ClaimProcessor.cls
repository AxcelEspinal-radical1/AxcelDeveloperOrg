public with sharing class ClaimProcessor {
    public static void processAll(List<Claim__c> claims) {
        for (Claim__c claim:claims) {
            if (claim.Country__c == 'US') {
                if (claim.Policy_Type__c == 'Life') {
                    claim.Tax_Amount__c = claim.Amount__c * 0.1;
                }
            }
        }
    }
}