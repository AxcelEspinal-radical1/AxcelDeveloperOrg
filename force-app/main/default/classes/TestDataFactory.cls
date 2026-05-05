@isTest
public with sharing class TestDataFactory {
  public static Opportunity createOpportunity(String name) {
    Opportunity testOpportunity = new Opportunity(
      Name = name,
      StageName = 'Prospecting',
      CloseDate = Date.today().addDays(30)
    );
    insert testOpportunity;
    return testOpportunity;
  }
}
