@isTest
global with sharing class OpportunityProcessTest {
  global class MockResponseGenerator implements HttpCalloutMock {
    HttpResponse res = new HttpResponse();

    global HttpResponse respond(HttpRequest req) {
      res.setHeader('Content-Type', 'application/json');
      res.setBody('{"example": "test"}');
      res.setStatusCode(200);
      return res;
    }
  }

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
  static void testOpportunityProcess_HappyPath_TechnologyCategory() {
    List<Opportunity> testOpps = TestDataFactory.createOpportunities(
      1,
      'Prospecting'
    );
    Opportunity testOpportunity = testOpps[0];

    String jsonResponse = '{"category": "Technology"}';
    Test.setMock(
      HttpCalloutMock.class,
      new DynamicHttpCalloutMock(200, jsonResponse)
    );

    Test.startTest();
    OpportunityProcess.processOpportunity(testOpportunity);
    Test.stopTest();

    Opportunity updatedOpp = [
      SELECT StageName
      FROM Opportunity
      WHERE Id = :testOpportunity.Id
    ];
    System.assertEquals(
      'Qualification',
      updatedOpp.StageName,
      'Stage should have changed since the mock returns Technology.'
    );
  }

  @isTest
  static void testOpportunityProcess_BusinessMistake_OtherCategory() {
    List<Opportunity> testOpps = TestDataFactory.createOpportunities(
      1,
      'Prospecting'
    );
    Opportunity testOpportunity = testOpps[0];

    String jsonResponse = '{"category": "Hardware"}';
    Test.setMock(
      HttpCalloutMock.class,
      new DynamicHttpCalloutMock(200, jsonResponse)
    );

    Test.startTest();
    OpportunityProcess.processOpportunity(testOpportunity);
    Test.stopTest();

    Opportunity updatedOpp = [
      SELECT StageName
      FROM Opportunity
      WHERE Id = :testOpportunity.Id
    ];
    System.assertEquals(
      'Prospecting',
      updatedOpp.StageName,
      'The stage should remain Prospecting when the category is not Technology'
    );
  }

  @isTest
  static void testOpportunityProcess_Exception_HttpError() {
    List<Opportunity> testOpps = TestDataFactory.createOpportunities(
      1,
      'Prospecting'
    );
    Opportunity testOpportunity = testOpps[0];

    Test.setMock(
      HttpCalloutMock.class,
      new DynamicHttpCalloutMock(500, 'Internal Server Error')
    );

    Test.startTest();
    try {
      OpportunityProcess.processOpportunity(testOpportunity);
    } catch (Exception e) {
      System.assert(
        false,
        'The process should handle exceptions gracefully and not throw them to the user. Error: ' +
        e.getMessage()
      );
    }
    Test.stopTest();

    Opportunity updatedOpp = [
      SELECT StageName
      FROM Opportunity
      WHERE Id = :testOpportunity.Id
    ];
    System.assertEquals(
      'Prospecting',
      updatedOpp.StageName,
      'The stage should remain Prospecting if the callout fails'
    );
  }
}
