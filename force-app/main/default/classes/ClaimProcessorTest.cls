 @isTest 
public with sharing class ClaimProcessorTest {
  @isTest static void testUSLifePolicyTax() {
    Claim__c mockClaim = new Claim__c(
        Status__c = 'Pending',
        Country__c = 'US',
        Policy_Type__c = 'Life',
        Amount__c = 1000
    );

    Test.startTest();
    ClaimProcessor.processAll();
    Test.stopTest();

    System.assertEquals(100, mockClaim.Tax_Amount__c, 'Tax amount should be 10% of the claim amount for US Life policies');
 }
}