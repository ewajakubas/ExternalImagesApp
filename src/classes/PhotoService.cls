public with sharing class PhotoService {

    //  named credentials OR custom metadata type should be
    private static final String EXTERNAL_SERVICE_URL = 'https://picsum.photos/v2/list';

    @Future(Callout=true)
    public static void fetchAndStorePhotos() {
        try {
            HttpRequest request = new HttpRequest();
            request.setEndpoint(EXTERNAL_SERVICE_URL);
            request.setMethod('GET');

            Http http = new Http();
            HttpResponse response = http.send(request);
            System.debug('response body ' + response.getBody());

            List<Image__c> imagesListToInstert = New List<Image__c>();
            if (response != null && response.getStatusCode() == 200) {
                List<PhotoWrapper.Image> externalImagesRecords = (List<PhotoWrapper.Image>) JSON.deserialize(response.getBody(), List<PhotoWrapper.Image>.class);

                for (PhotoWrapper.Image externalImage : externalImagesRecords) {
                    if (!imageExistsInDatabase(externalImage.id)) {
                        Image__c newImage = new Image__c(
                                Id__c = externalImage.id,
                                Title__c = externalImage.author + '_' + externalImage.id,
                                Url__c = externalImage.url,
                                Author__c = externalImage.author,
                                Download_url__c = externalImage.download_url,
                                Width__c = externalImage.width,
                                Height__c = externalImage.height
                        );
                        imagesListToInstert.add(newImage);
                    }
                }
                if (!imagesListToInstert.isEmpty()) {
                    System.debug(Database.insert(imagesListToInstert, false));
                }
            } else {
                System.debug('External service request failed with status code: ' + response.getStatusCode());
                System.debug('Response body: ' + response.getBody());
            }
        } catch (Exception ex) {
            System.debug('Exception occurred: ' + ex.getMessage());
        }
    }

    private static Boolean imageExistsInDatabase(String externalImageId) {
        List<Image__c> existingImages = new List<Image__c>();
        try {
            existingImages = [SELECT Id FROM Image__c WHERE Id__c = :externalImageId LIMIT 1];
        } catch (Exception ex) {
            System.debug('Exception occurred: ' + ex.getMessage());
        }
        System.debug('existingImages ' + existingImages);
        return !existingImages.isEmpty();
    }

    @Future
    public static void deleteOldPhotos() {
        // Calculate the datetime 10 minutes ago
        Datetime tenMinutesAgo = Datetime.now().addMinutes(-10);
        Datetime sevenDaysAgo = Datetime.now().addDays(-7);
        Datetime oneDaysAgo = Datetime.now().addDays(-1);
        try {
            List<Image__c> recordsToDelete = [SELECT Id FROM Image__c WHERE CreatedDate < :tenMinutesAgo];
            Database.delete(recordsToDelete, false);
        } catch (Exception ex) {
            System.debug('Exception occurred: ' + ex.getMessage());
        }
    }
}