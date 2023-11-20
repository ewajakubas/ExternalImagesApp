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

            List<Image__c> imagesListToInsert = New List<Image__c>();
            if (response != null && response.getStatusCode() == 200) {
                List<PhotoWrapper.Image> externalImagesRecords = (List<PhotoWrapper.Image>) JSON.deserialize(response.getBody(), List<PhotoWrapper.Image>.class);

                for (PhotoWrapper.Image externalImage : externalImagesRecords) {
                    if (!checkPhotoInDatabase(externalImage.id)) {
                        Image__c newImage = new Image__c(
                                Id__c = externalImage.id,
                                Title__c = externalImage.author + '_' + externalImage.id,
                                Url__c = externalImage.url,
                                Author__c = externalImage.author,
                                Download_url__c = externalImage.download_url,
                                Width__c = externalImage.width,
                                Height__c = externalImage.height
                        );
                        imagesListToInsert.add(newImage);
                    }
                }
                if (!imagesListToInsert.isEmpty()) {
                    Database.insert(imagesListToInsert, false);
                }
            } else {
                System.debug('External service request failed with status code: ' + response.getStatusCode());
            }
        } catch (Exception ex) {
            System.debug('Exception occurred: ' + ex.getMessage());
        }
    }

    private static Boolean checkPhotoInDatabase(String externalImageId) {
        List<Image__c> existingImages = new List<Image__c>();
        try {
            existingImages = [SELECT Id FROM Image__c WHERE Id__c = :externalImageId LIMIT 1];
        } catch (Exception ex) {
            System.debug('Exception occurred: ' + ex.getMessage());
        }
        return !existingImages.isEmpty();
    }

    @Future
    public static void deleteOldPhotos() {
        // Calculate the datetime 7 days ago
        Datetime sevenDaysAgo = Datetime.now().addDays(-7);
        try {
            List<Image__c> recordsToDelete = [SELECT Id FROM Image__c WHERE CreatedDate < :sevenDaysAgo];
            Database.delete(recordsToDelete, false);
        } catch (Exception ex) {
            System.debug('Exception occurred: ' + ex.getMessage());
        }
    }
}

