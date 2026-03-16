public with sharing class ExternalService {
    @AuraEnabled(cacheable=true)
    public static void notifyStatus(Id claimId, String requirementStatus) {
        system.debug('ExternalService.notifyStatus called with claimId: ' + claimId + ' and requirementStatus: ' + requirementStatus);
    }
}