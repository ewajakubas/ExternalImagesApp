global class DailyPhotoSync implements Schedulable {

    global void execute(SchedulableContext SC) {
        PhotoService.fetchAndStorePhotos();
    }
    public static String scheduleJob() {
        String cronExpression = '0 0 * * *'; // Run daily at midnight
        String jobName = 'DailyImageSyncJob';
        System.schedule(jobName, cronExpression, new DailyPhotoSync());
        return jobName;
    }
}