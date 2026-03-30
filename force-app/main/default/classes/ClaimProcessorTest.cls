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

    ITaxStrategy usTaxStrategy = new USTaxStrategy();
    ClaimProcessor processor = new ClaimProcessor(usTaxStrategy);

    Test.startTest();
    processor.processAll(claims);
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

    ITaxStrategy usTaxStrategy = new USTaxStrategy();
    ClaimProcessor processor = new ClaimProcessor(usTaxStrategy);

    Test.startTest();
    processor.processAll(claims);
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

    ITaxStrategy frTaxStrategy = new FRTaxStrategy();
    ClaimProcessor processor = new ClaimProcessor(frTaxStrategy);

    Test.startTest();
    processor.processAll(claims);
    Test.stopTest();

    System.assertEquals(
      200,
      mockClaim.Tax_Amount__c,
      'Tax amount should be 20% for FR claims'
    );
  }

  @isTest
  static void testComplianceMetPositive() {
    List<Claim__c> claims = new List<Claim__c>();
    Claim__c mockClaim = new Claim__c(
      Status__c = 'Pending',
      Country__c = 'US',
      Amount__c = 1000
    );
    claims.add(mockClaim);

    List<Requirement__c> requirements = new List<Requirement__c>();
    Requirement__c mockRequirement = new Requirement__c(
      Claim__c = mockClaim.Id,
      Status__c = 'Completed'
    );
    requirements.add(mockRequirement);

    ITaxStrategy usTaxStrategy = new USTaxStrategy();
    ClaimProcessor processor = new ClaimProcessor(usTaxStrategy);

    Test.startTest();
    processor.processAll(claims);
    Test.stopTest();

    System.assertEquals(
      'Approved',
      mockClaim.Status__c,
      'Claim should be approved when all requirements are completed'
    );
  }
}
