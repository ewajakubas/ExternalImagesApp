global class DailyPhotoSync implements Schedulable {

    global void execute(SchedulableContext SC) {
        PhotoService.fetchAndStorePhotos();
    }
    public static String scheduleJob() {
        //String cronExpression = '0 0 0 * * ?'; // Run daily at midnight
        String CRON_EXP = '0 0 1 * * ?'; // Every 1 hours
        String CRON_EXP_1 = '0 10 * * * ?';

        String cronExpression = '0 10 * * * ?';
        String jobName = 'MyScheduledJob';
        System.schedule(jobName, CRON_EXP_1, new DailyPhotoSync());
        return jobName;
    }
}