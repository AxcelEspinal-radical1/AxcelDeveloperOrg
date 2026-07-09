public class ServiceRequestProcessor {
  public static void recalculatePriorities() {
    List<Service_Request__c> requests = [
      SELECT Id, Status__c, Priority__c, Region__c, CreatedDate, Score__c
      FROM Service_Request__c
      WHERE Status__c IN ('New', 'In Progress')
    ];

    List<Service_Request__c> requestsToUpdate = new List<Service_Request__c>();

    for (Service_Request__c req : requests) {
      String newPriority = 'Low';
      if (req.Region__c == 'North' && req.Score__c > 80) {
        newPriority = 'High';
      } else if (req.Score__c > 50) {
        newPriority = 'Medium';
      }

      if (req.Priority__c != newPriority) {
        req.Priority__c = newPriority;
        requestsToUpdate.add(req);
      }
    }

    if (!requestsToUpdate.isEmpty()) {
      update requestsToUpdate;
    }
  }
}
