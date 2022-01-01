/**
* @author Kyrylo Mazur
* @date 9/2021
* @description test class for ProductBackupBatch
*
*/
@isTest
private class ProductBackupBatchSchedulerTest {
    
    static final Id pricebookId = Test.getStandardPricebookId();
    
    @TestSetup private static void setup(){
        List<Product2> productsList = new List<Product2>();
        for (Integer i = 0; i < 3; i++){
        	productsList.add(new Product2(Name = 'Product' + i, ExternalId = '012345678901' + i, ProductCode = String.valueOf(i), IsActive = true));
        }
        insert productsList;
        
        List<PricebookEntry> pricebookEntriesList = new List<PricebookEntry>();
        for (Integer i = 0; i < 3; i++)
        	pricebookEntriesList.add(new PricebookEntry(Pricebook2Id = pricebookId, 
                                                        Product2Id = productsList[i].Id,
                                                        UnitPrice = 10*i+1,
                                                        IsActive = true));
        insert pricebookEntriesList;
        
        Product_Backup__c preCreatedBackupRecord = new Product_Backup__c(Name = productsList[0].Name,
                                                                         Product_External_ID__c = productsList[0].ExternalId,
                                                                         Selling_Price__c = 100);
        insert preCreatedBackupRecord;
    }
    
    @isTest
    static void testProductBackupBatch() {
        Test.startTest();
            ProductBackupBatchScheduler productBackupBatchScheduler = new ProductBackupBatchScheduler();   
            String cronExp = '0 0 12 * * ?';
            String jobId = System.schedule('ProductBackupBatchScheduler', cronExp, productBackupBatchScheduler);
        Test.stopTest();
        CronTrigger ct = [SELECT Id , CronExpression FROM CronTrigger WHERE Id = :jobId LIMIT 1];
        System.assertEquals(cronExp, ct.CronExpression);
    }
}