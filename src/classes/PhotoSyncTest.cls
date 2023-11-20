@IsTest
private class PhotoSyncTest {
    @IsTest static void dailyPhotoSyncSchedule() {

        String CRON_EXP = '0 0 0 * * *';
        DailyPhotoSync sync = new DailyPhotoSync();
        Test.startTest();
        Id jobId = System.schedule('Sync Images', CRON_EXP, sync);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime, State FROM CronTrigger WHERE Id = :jobId];
        Assert.areEqual(CRON_EXP, ct.CronExpression);
        Assert.areEqual(0, ct.TimesTriggered);
        Test.stopTest();
    }

    @IsTest static void dailyPhotoDeleteSchedule() {

        String CRON_EXP = '0 0 * * *';
        DeleteOldPhotoSync sync = new DeleteOldPhotoSync();
        Test.startTest();
        Id jobId = System.schedule('Delete Images', CRON_EXP, sync);
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime, State FROM CronTrigger WHERE Id = :jobId];
        Assert.areEqual(CRON_EXP, ct.CronExpression);
        Assert.areEqual(0, ct.TimesTriggered);
        Test.stopTest();
    }
}