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
    IComplianceRule usComplianceRule = new USComplianceRule();
    ClaimProcessor processor = new ClaimProcessor(
      usTaxStrategy,
      usComplianceRule
    );

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
    IComplianceRule usComplianceRule = new USComplianceRule();
    ClaimProcessor processor = new ClaimProcessor(
      usTaxStrategy,
      usComplianceRule
    );

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
    IComplianceRule frComplianceRule = new USComplianceRule();
    ClaimProcessor processor = new ClaimProcessor(
      frTaxStrategy,
      frComplianceRule
    );

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
    String claimJson =
      '{' +
      '"attributes": {"type": "Claim__c"},' +
      '"Status__c": "Pending",' +
      '"Country__c": "US",' +
      '"Amount__c": 1000,' +
      '"Requirements__r": {' +
      '"totalSize": 1,' +
      '"done": true,' +
      '"records": [' +
      '{' +
      '"attributes": {"type": "Requirement__c"},' +
      '"Status__c": "Completed"' +
      '}' +
      ']' +
      '}' +
      '}';

    Claim__c mockClaim = (Claim__c) JSON.deserialize(claimJson, Claim__c.class);
    List<Claim__c> claims = new List<Claim__c>{ mockClaim };

    ITaxStrategy usTaxStrategy = new USTaxStrategy();
    IComplianceRule usComplianceRule = new USComplianceRule();
    ClaimProcessor processor = new ClaimProcessor(
      usTaxStrategy,
      usComplianceRule
    );

    Test.startTest();
    processor.processAll(claims);
    Test.stopTest();

    System.assertEquals(
      'Approved',
      mockClaim.Status__c,
      'Claim should be approved when all requirements are completed'
    );
  }

  @isTest
  static void testComplianceMetNegative() {
    String claimJson =
      '{' +
      '"attributes": {"type": "Claim__c"},' +
      '"Status__c": "Pending",' +
      '"Country__c": "US",' +
      '"Amount__c": 1000,' +
      '"Requirements__r": {' +
      '"totalSize": 1,' +
      '"done": true,' +
      '"records": [' +
      '{' +
      '"attributes": {"type": "Requirement__c"},' +
      '"Status__c": "In Progress"' +
      '}' +
      ']' +
      '}' +
      '}';

    Claim__c mockClaim = (Claim__c) JSON.deserialize(claimJson, Claim__c.class);
    List<Claim__c> claims = new List<Claim__c>{ mockClaim };

    ITaxStrategy usTaxStrategy = new USTaxStrategy();
    IComplianceRule usComplianceRule = new USComplianceRule();
    ClaimProcessor processor = new ClaimProcessor(
      usTaxStrategy,
      usComplianceRule
    );

    Test.startTest();
    processor.processAll(claims);
    Test.stopTest();

    System.assertEquals(
      'Pending',
      mockClaim.Status__c,
      'Claim should remain pending when not all requirements are completed'
    );
  }

  @isTest
  public class MockNotification implements INotificationService {
    public Boolean wasCalled = false;

    public void sendNotification(String message) {
      wasCalled = true;
    }
  }

  @isTest
  static void testNotificationSending() {
    String claimJson =
      '{' +
      '"attributes": {"type": "Claim__c"},' +
      '"Status__c": "Pending",' +
      '"Country__c": "US",' +
      '"Amount__c": 1000,' +
      '"Requirements__r": {' +
      '"totalSize": 1,' +
      '"done": true,' +
      '"records": [' +
      '{' +
      '"attributes": {"type": "Requirement__c"},' +
      '"Status__c": "Completed"' +
      '}' +
      ']' +
      '}' +
      '}';

    Claim__c mockClaim = (Claim__c) JSON.deserialize(claimJson, Claim__c.class);
    List<Claim__c> claims = new List<Claim__c>{ mockClaim };

    MockNotification mock = new MockNotification();
    ITaxStrategy usTaxStrategy = new USTaxStrategy();
    IComplianceRule usComplianceRule = new USComplianceRule();
    ClaimProcessor processor = new ClaimProcessor(
      usTaxStrategy,
      usComplianceRule,
      mock
    );

    Test.startTest();
    processor.processAll(claims);
    Test.stopTest();

    System.assertEquals(
      true,
      mock.wasCalled,
      'Notification should be sent when claim is approved'
    );
  }
}
