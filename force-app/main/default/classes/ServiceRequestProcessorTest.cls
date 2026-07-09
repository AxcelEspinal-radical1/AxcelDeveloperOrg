@isTest
private class ServiceRequestProcessorTest {
  @testSetup
  static void setupData() {
    List<Service_Request__c> requests = new List<Service_Request__c>();

    // We generate 200 test records to verify that the batch operates correctly.
    // To comply with Salesforce's unit test limits (exactly one batch execution chunk),
    // we query 150 active records and keep 50 closed records.
    for (Integer i = 0; i < 200; i++) {
      String status = (i < 150) ? 'New' : 'Closed';
      String region = (i < 50) ? 'North' : 'South';
      Decimal score = (i < 100) ? 85 : 45; // Some High priority, some Low, some Medium

      requests.add(
        new Service_Request__c(
          Status__c = status,
          Region__c = region,
          Score__c = score,
          Priority__c = 'Medium' // Initial value to check if it changes
        )
      );
    }
    insert requests;
  }

  @isTest
  static void testRecalculatePriorities() {
    Test.startTest();
    ServiceRequestProcessor.recalculatePriorities();
    Test.stopTest();

    // Verify the results
    // Open requests: 150 records. Closed requests: 50 records.
    // Out of open requests:
    // i < 50: Region = North, Score = 85 (i < 100) -> should be High
    // 50 <= i < 100: Region = South, Score = 85 -> should be Medium (score > 50)
    // 100 <= i < 150: Region = South, Score = 45 -> should be Low (score <= 50)
    // Closed requests: 150 <= i < 200 -> should remain unchanged (Medium)

    List<Service_Request__c> highPriorityRequests = [
      SELECT Id
      FROM Service_Request__c
      WHERE Priority__c = 'High'
    ];
    List<Service_Request__c> mediumPriorityRequests = [
      SELECT Id
      FROM Service_Request__c
      WHERE Priority__c = 'Medium'
    ];
    List<Service_Request__c> lowPriorityRequests = [
      SELECT Id
      FROM Service_Request__c
      WHERE Priority__c = 'Low'
    ];

    System.assertEquals(50, highPriorityRequests.size(), 'There should be 50 High priority requests (Region North, Score > 80)');
    // Medium requests include:
    // - 50 active South requests with Score = 85
    // - 50 closed requests which were not modified by the batch
    System.assertEquals(100, mediumPriorityRequests.size(), 'There should be 100 Medium priority requests (50 active South, 50 closed)');
    System.assertEquals(50, lowPriorityRequests.size(), 'There should be 50 Low priority requests (Score <= 50)');
  }
}

