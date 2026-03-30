public with sharing class ClaimProcessorTest {
 @isTest 
 static void testUSLifePolicyTax() {
    Claim__c claim = new Claim__c(
        Status__c = 'Pending',
        Country__c = 'US',
        Policy_Type__c = 'Life',
        Amount__c = 1000
    );

    Test.startTest();
    ClaimProcessor.processAll();
    Test.stopTest();

    System.assert(claim.Tax_Amount__c == 100, 'Expected tax amount to be 100 for US Life policy');
 }
}