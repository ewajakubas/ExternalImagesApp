public with sharing class PhotoController {

    @AuraEnabled(Cacheable=true)
    public static List<Image__c> getImages() {
        List<Image__c> imagesRecords = new List<Image__c>();
        try {
            imagesRecords = [SELECT Id, Title__c, Author__c, Height__c, Width__c, Url__c, Download_url__c FROM Image__c];
        } catch (Exception ex) {
            System.debug('Exception occurred: ' + ex.getMessage());
        }
        return imagesRecords;
    }
}