@isTest
public with sharing class OpportunityProcessTest {
  @isTest
  static void testOpportunityProcess() {
    Opportunity testOpportunity = new Opportunity(
      Name = 'Test Opportunity',
      StageName = 'Prospecting'
    );
    insert testOpportunity;

    Test.startTest();
    OpportunityProcess.processOpportunity(testOpportunity.Id);
    Test.stopTest();

    System.assert(
      testOpportunity.StageName == 'Qualification',
      'The opportunity stage should be updated to Qualification'
    );
  }
}
