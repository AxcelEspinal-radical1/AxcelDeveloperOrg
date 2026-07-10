@isTest
public with sharing class TestDataFactory {
  public static Opportunity buildOpportunity(String name, String stage) {
    return new Opportunity(
      Name = name,
      StageName = stage,
      CloseDate = Date.today().addDays(30)
    );
  }

  public static List<Opportunity> createOpportunities(
    Integer count,
    String stage
  ) {
    List<Opportunity> opps = new List<Opportunity>();
    for (Integer i = 0; i < count; i++) {
      opps.add(buildOpportunity('Test Opp ' + i, stage));
    }
    insert opps;
    return opps;
  }
}
