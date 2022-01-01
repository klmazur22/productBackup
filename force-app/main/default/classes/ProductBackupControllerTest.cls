/**
* @author Kyrylo Mazur
* @date 9/2021
* @description test class for ProductBackupController
*
*/
@isTest
private class ProductBackupControllerTest {
    
	static final Id pricebookId = Test.getStandardPricebookId();
    
    @TestSetup private static void setup(){
        Product2 product = new Product2(Name = 'Product0', ExternalId = '0123456789010', ProductCode = '000', IsActive = true);
        insert product;
        
        Product_Backup__c productBackup = new Product_Backup__c(Name = product.Name, Product_External_ID__c = product.ExternalId, Selling_Price__c = 100);
        insert productBackup;
    }
    
    @isTest
    static void testGetProductBackupInfo() {
        Test.startTest();
            Product_Backup__c productBackup = ProductBackupController.getProductBackupInfo([SELECT Id FROM Product_Backup__c LIMIT 1].Id);
        Test.stopTest();
        System.assertEquals('Product0', productBackup.Name);
        System.assertEquals('0123456789010', productBackup.Product_External_ID__c);
        System.assertEquals(100, productBackup.Selling_Price__c);
    }
    
    @isTest
    static void testGetRelatedProductInfo() {
        Test.startTest();
            Product2 product = ProductBackupController.getRelatedProductInfo([SELECT Id FROM Product_Backup__c LIMIT 1].Id);
        Test.stopTest();
        System.assertEquals(true, product.IsActive);
        System.assertEquals([SELECT CreatedDate FROM Product2 LIMIT 1].CreatedDate, product.CreatedDate);
    }
}