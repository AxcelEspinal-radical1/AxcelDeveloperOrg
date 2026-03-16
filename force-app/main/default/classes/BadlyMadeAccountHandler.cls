public with sharing class BadlyMadeAccountHandler {
    public static void handleAccounts() {
        List<Account> accounts = [SELECT Id, Name FROM Account];
        for (Account acc : accounts) {
            List<Contact> con = [SELECT Id, Name FROM Contact WHERE AccountId = :acc.Id];
            if (con != null && !con.isEmpty()) {
                acc.Name = con[0].Name + ' - ' + acc.Name;
                update acc;
            }
            for (Contact c : con) {
                c.LastName = acc.Name + ' Contact';
                update c;
            }
        }
    }
}