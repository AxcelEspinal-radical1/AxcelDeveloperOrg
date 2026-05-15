@isTest
public with sharing class OpportunityProcessTest {
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

    Map<String, String> mockMap = new Map<String, String>{
      String.valueOf(testOpportunity.Id) => 'Technology'
    };
    Test.setMock(
      HttpCalloutMock.class,
      new DynamicHttpCalloutMock(200, JSON.serialize(mockMap))
    );

    Test.startTest();
    OpportunityProcess.processOpportunities(testOpps);
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

    Map<String, String> mockMap = new Map<String, String>{
      String.valueOf(testOpportunity.Id) => 'Hardware'
    };
    Test.setMock(
      HttpCalloutMock.class,
      new DynamicHttpCalloutMock(200, JSON.serialize(mockMap))
    );

    Test.startTest();
    OpportunityProcess.processOpportunities(testOpps);
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
      OpportunityProcess.processOpportunities(testOpps);
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

  @isTest
  static void testOpportunityProcess_Bulk_200Records() {
    List<Opportunity> testOpps = TestDataFactory.createOpportunities(
      200,
      'Prospecting'
    );

    Map<String, String> mockMap = new Map<String, String>();
    for (Opportunity opp : testOpps) {
      mockMap.put(String.valueOf(opp.Id), 'Technology');
    }

    Test.setMock(
      HttpCalloutMock.class,
      new DynamicHttpCalloutMock(200, JSON.serialize(mockMap))
    );

    Test.startTest();
    OpportunityProcess.processOpportunities(testOpps);
    Test.stopTest();

    Integer qualificationCount = [
      SELECT COUNT()
      FROM Opportunity
      WHERE StageName = 'Qualification'
    ];
    System.assertEquals(200, qualificationCount, 'Count mismatch');
  }
}
