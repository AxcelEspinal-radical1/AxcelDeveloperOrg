public class ServiceRequestProcessor implements Database.Batchable<sObject> {
  public static void recalculatePriorities() {
    Database.executeBatch(new ServiceRequestProcessor(), 200);
  }

  public Database.QueryLocator start(Database.BatchableContext bc) {
    return Database.getQueryLocator(
      [
        SELECT Id, Status__c, Priority__c, Region__c, Score__c
        FROM Service_Request__c
        WHERE Status__c IN ('New', 'In Progress')
      ]
    );
  }

  public void execute(
    Database.BatchableContext bc,
    List<Service_Request__c> scope
  ) {
    List<Service_Request__c> requestsToUpdate = new List<Service_Request__c>();

    for (Service_Request__c req : scope) {
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
      Database.SaveResult[] results = Database.update(requestsToUpdate, false);
      for (Database.SaveResult sr : results) {
        if (!sr.isSuccess()) {
          for (Database.Error err : sr.getErrors()) {
            System.debug(
              'Error updating Service Request ID ' +
                sr.getId() +
                ': ' +
                err.getMessage()
            );
          }
        }
      }
    }
  }

  public void finish(Database.BatchableContext bc) {
    System.debug('ServiceRequestProcessor batch job finished.');
  }
}
