@isTest
public with sharing class OpportunityProcessTest {
  @isTest
  global class MockResponseGenerator implements HttpCalloutMock {
    HttpResponse res = new HttpResponse();

    global HttpResponse respond(HttpRequest req) {
      res.setHeader('Content-Type', 'application/json');
      res.setBody('{"example": "test"}');
      res.setStatusCode(200);
      return res;
    }
  }

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
