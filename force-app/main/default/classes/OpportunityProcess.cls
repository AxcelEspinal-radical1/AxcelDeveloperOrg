public with sharing class OpportunityProcess {
  public static void processOpportunity(Opportunity opportunity) {
    if (opportunity.StageName == 'Prospecting') {
      opportunity.StageName = 'Qualification';
      update opportunity;
    }
  }
}
