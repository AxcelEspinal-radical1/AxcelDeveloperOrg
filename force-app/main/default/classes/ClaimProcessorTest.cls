@isTest
public with sharing class ClaimProcessorTest {
  @isTest
  static void testUSLifePolicyTax() {
    List<Claim__c> claims = new List<Claim__c>();
    Claim__c mockClaim = new Claim__c(
      Status__c = 'Pending',
      Country__c = 'US',
      Policy_Type__c = 'Life',
      Amount__c = 1000
    );
    claims.add(mockClaim);

    Test.startTest();
    ClaimProcessor.processAll(claims);
    Test.stopTest();

    System.assertEquals(
      100,
      mockClaim.Tax_Amount__c,
      'Tax amount should be 10% of the claim amount for US Life policies'
    );
  }

  @isTest
  static void testUSOtherPolicyTax() {
    List<Claim__c> claims = new List<Claim__c>();
    Claim__c mockClaim = new Claim__c(
      Status__c = 'Pending',
      Country__c = 'US',
      Policy_Type__c = 'Other',
      Amount__c = 1000
    );
    claims.add(mockClaim);

    Test.startTest();
    ClaimProcessor.processAll(claims);
    Test.stopTest();

    System.assertEquals(
      50,
      mockClaim.Tax_Amount__c,
      'Tax amount should be 5% of the claim amount for US Other policies'
    );
  }

  @isTest
  static void testFRTax() {
    List<Claim__c> claims = new List<Claim__c>();
    Claim__c mockClaim = new Claim__c(
      Status__c = 'Pending',
      Country__c = 'FR',
      Amount__c = 1000
    );
    claims.add(mockClaim);
    Test.startTest();
    ClaimProcessor.processAll(claims);
    Test.stopTest();

    System.assertEquals(
      200,
      mockClaim.Tax_Amount__c,
      'Tax amount should be 20% for FR claims'
    );
  }
}
