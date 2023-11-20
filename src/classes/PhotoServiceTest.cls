@IsTest
private class PhotoServiceTest {
    private class MockHttpResponseGenerator implements HttpCalloutMock {
        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setStatusCode(200);
            response.setBody('[{"id": "1", "author": "Author1", "url": "https://example.com/image1.jpg",' +
                    ' "download_url": "https://example.com/image1.jpg", "width": 100, "height": 100},' +
                    ' {"id": "2", "author": "Author2", "url": "https://example.com/image2.jpg", ' +
                    '"download_url": "https://example.com/image2.jpg", "width": 100, "height": 100}]');
            return response;
        }
    }

    @IsTest
    static void testFetchAndStorePhotos() {
        List<Image__c> testImages = TestDataFactory.createTestImage(3);
        testImages.get(0).Id__c = '1';
        update testImages;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        PhotoService.fetchAndStorePhotos();
        Test.stopTest();
        List<Image__c> insertedImages = [SELECT Id FROM Image__c];
        Assert.areEqual(4, insertedImages.size());
        Assert.areEqual(3, testImages.size());
    }

    @IsTest
    static void testDeleteOldPhotos() {
        List<Image__c> testImages = TestDataFactory.createTestImage(3);
        Datetime tenMinutesAgo = Datetime.now().addMinutes(-20);
        Datetime twoHoursAgo = Datetime.now().addHours(-2);
        // Set CreatedDate > 7 days
        Datetime tenDaysAgo = Datetime.now().addDays(-10);
        Test.setCreatedDate(testImages.get(0).Id, tenMinutesAgo);
        Test.setCreatedDate(testImages.get(1).Id, twoHoursAgo);
        Test.setCreatedDate(testImages.get(2).Id, tenDaysAgo);
        update testImages;

        Test.startTest();
        PhotoService.deleteOldPhotos();
        Test.stopTest();

        List<Image__c> images = [SELECT Id FROM Image__c];
        Assert.areEqual(images.size(), 2);
    }
}