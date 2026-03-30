public with sharing class ClaimProcessor {
    public static void processAll() {
        List<Claim__c> claims = [SELECT Id, Status__c, Country__c, Policy_Type__c, Amount__c FROM Claim__c WHERE Status__c = 'Pending'];
        for (Claim__c claim:claims) {
            if (claim.Country__c == 'US') {
                if (claim.Policy_Type__c == 'Life') {
                    claim.Tax_Amount__c = claim.Amount__c * 0.1;
                }
            }
        }
    }
}