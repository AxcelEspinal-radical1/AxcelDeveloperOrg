public with sharing class OpportunityProcess {
  public static void processOpportunity(Id opportunityId) {
    Opportunity opp = [
      SELECT Id, StageName
      FROM Opportunity
      WHERE Id = :opportunityId
      LIMIT 1
    ];
    if (opp.StageName == 'Prospecting') {
      opp.StageName = 'Qualification';
      update opp;
    }
  }
}
