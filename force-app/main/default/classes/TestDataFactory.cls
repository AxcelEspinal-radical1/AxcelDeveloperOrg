@isTest
public with sharing class TestDataFactory {
  public static Opportunity createOpportunity() {
    Opportunity testOpportunity = new Opportunity(Name = 'Test Opportunity');
    insert testOpportunity;
    return testOpportunity;
  }
}
