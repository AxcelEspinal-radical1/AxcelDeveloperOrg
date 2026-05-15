public with sharing class OpportunityProcess {
  public static void processOpportunities(List<Opportunity> opportunities) {
    List<Opportunity> oppsToUpdate = new List<Opportunity>();
    List<String> oppIds = new List<String>();

    for (Opportunity opp : opportunities) {
      if (opp.StageName == 'Prospecting') {
        oppIds.add(String.valueOf(opp.Id));
      }
    }

    if (oppIds.isEmpty()) {
      return;
    }

    try {
      HttpRequest req = new HttpRequest();
      req.setEndpoint(
        'https://jsonplaceholder.typicode.com/posts/bulk?ids=' +
        String.join(oppIds, ',')
      );
      req.setMethod('GET');

      Http http = new Http();
      HttpResponse res = http.send(req);

      if (res.getStatusCode() == 200) {
        Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(
          res.getBody()
        );

        for (Opportunity opp : opportunities) {
          String category = (String) jsonResponse.get(String.valueOf(opp.Id));
          if (opp.StageName == 'Prospecting' && category == 'Technology') {
            opp.StageName = 'Qualification';
            oppsToUpdate.add(opp);
          }
        }

        if (!oppsToUpdate.isEmpty()) {
          update oppsToUpdate;
        }
      }
    } catch (Exception ex) {
      System.debug(LoggingLevel.ERROR, ex.getMessage());
    }
  }
}
