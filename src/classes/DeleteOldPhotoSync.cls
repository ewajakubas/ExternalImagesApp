global with sharing class DeleteOldPhotoSync implements Schedulable {

    global void execute(SchedulableContext SC) {
        PhotoService.deleteOldPhotos();
    }

    public static String scheduleJob() {
        //String cronExpression = '0 0 0 * * ?'; // Run daily at midnight
        // Cron expression for every 5 minutes: 0 */5 * * * ?
        String cronExpression = '0 10 * * * ?';
        String CRON_EXP = '0 0 2 * * ?'; // Every 2 hours

        String jobName = 'DeleteImagesJob';
        System.schedule(jobName, cronExpression, new DeleteOldPhotoSync());
        return jobName;
    }
}