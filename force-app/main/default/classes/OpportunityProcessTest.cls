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
  public class DynamicHttpCalloutMock implements HttpCalloutMock {
    private Integer statusCode;
    private String responseBody;

    public DynamicHttpCalloutMock(Integer statusCode, String responseBody) {
      this.statusCode = statusCode;
      this.responseBody = responseBody;
    }

    public HttpResponse respond(HttpRequest req) {
      HttpResponse res = new HttpResponse();
      res.setHeader('Content-Type', 'application/json');
      res.setBody(this.responseBody);
      res.setStatusCode(this.statusCode);
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
