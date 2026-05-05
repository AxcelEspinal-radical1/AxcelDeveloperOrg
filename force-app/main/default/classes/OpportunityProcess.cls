public with sharing class OpportunityProcess {
  public static void processOpportunity(Opportunity opportunity) {
    HttpRequest req = new HttpRequest();
    req.setEndpoint(
      'https://jsonplaceholder.typicode.com/posts/' + opportunity.Id
    );
    req.setMethod('GET');
    Http http = new Http();
    HttpResponse res = http.send(req);
    String body = res.getBody();
    Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(
      body
    );
    String category = (String) jsonResponse.get('category');

    if (opportunity.StageName == 'Prospecting' && category == 'Technology') {
      opportunity.StageName = 'Qualification';
      update opportunity;
    }
  }
}
