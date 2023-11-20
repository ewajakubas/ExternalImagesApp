global with sharing class DeleteOldPhotoSync implements Schedulable {

    global void execute(SchedulableContext SC) {
        PhotoService.deleteOldPhotos();
    }

    public static String scheduleJob() {
        String cronExpression = '0 0 * * *'; // Run daily at midnight
        String jobName = 'DeleteImagesJob';
        System.schedule(jobName, cronExpression, new DeleteOldPhotoSync());
        return jobName;
    }
}