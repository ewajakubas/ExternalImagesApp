@IsTest
private class PhotoControllerTest {
    @IsTest
    static void testGetImages() {
        List<Image__c> testImages = TestDataFactory.createTestImage(10);
        Test.startTest();
        List<Image__c> resultImages = PhotoController.getImages();
        Test.stopTest();
        Assert.areEqual(testImages.size(), resultImages.size());
    }
}