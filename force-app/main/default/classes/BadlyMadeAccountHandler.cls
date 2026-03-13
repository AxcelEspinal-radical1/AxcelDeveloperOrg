public with sharing class BadlyMadeAccountHandler {
    public static void handleAccounts() {
        List<Account> accounts = [SELECT Id, Name FROM Account];
        for (Account acc : accounts) {
            Contact con = [SELECT Id, Name FROM Contact WHERE AccountId = :acc.Id LIMIT 1];
            if (con != null) {
                acc.Name = con.Name + ' - ' + acc.Name;
                update acc;
            }
        }
    }
}