@isTest
public with sharing class OpportunityProcessTest {
  @isTest
  static void testOpportunityProcess__TechnologyEndpoint() {
    Opportunity testOpportunity = TestDataFactory.createOpportunity(
      'Test Opportunity'
    );

    Test.startTest();
    OpportunityProcess.processOpportunity(testOpportunity);
    Test.stopTest();

    System.assert(
      testOpportunity.StageName == 'Qualification',
      'The opportunity stage should be updated to Qualification adding the category Technology'
    );
  }
}
