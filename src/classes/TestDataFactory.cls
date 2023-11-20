public with sharing class TestDataFactory {
    public static List<Image__c> createTestImage(Integer numberImages) {
        List<Image__c> newImageList = new List<Image__c>();
        for (Integer i = 0; i < numberImages; i++) {
            Image__c testImage = new Image__c(
                    Id__c = 'Id' + i,
                    Title__c = 'TestAuthor' + '_' + i
            );
            newImageList.add(testImage);
        }
        insert newImageList;
        return newImageList;
    }
}