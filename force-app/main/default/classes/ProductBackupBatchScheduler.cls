/**
* @author Kyrylo Mazur
* @date 9/2021
* @description schedulable class to run ProductBackupBatch
*
*/
global class ProductBackupBatchScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        ProductBackupBatch productBackupBatch = new ProductBackupBatch();
        database.executebatch(productBackupBatch);
    }
}