/**
* @author Kyrylo Mazur
* @date 9/2021
* @description batchable class to make a backup of Project2 records
*
*/
public class ProductBackupBatch  implements Database.Batchable<sObject>{
    
    public Database.QueryLocator start(Database.BatchableContext BC){
        //as agreed, Price will be taken from Pricebook Entry object from Standard Pricebook
        Id standardPricebookId = Test.isRunningTest() ? Test.getStandardPricebookId() : [SELECT Id FROM Pricebook2 WHERE IsStandard = TRUE].Id;
        return Database.getQueryLocator([SELECT Id, Name, ExternalId, (SELECT Product2Id, UnitPrice 
                                                                       FROM Product2.PricebookEntries 
                                                                       WHERE Pricebook2Id =: standardPricebookId) 
                                         FROM Product2 
                                         WHERE IsActive = true
                                         AND ExternalId != null]);
    }
    
    public void execute(Database.BatchableContext BC, List<Product2> productList){
        List<String> productExternalIdList = new List<String>();
        for(Product2 product : productList){
            productExternalIdList.add(product.ExternalId);
        }
        //list of existent backup records
        List<Product_Backup__c> productBackupList = [SELECT Name, Product_External_ID__c, Selling_Price__c 
                                                     FROM Product_Backup__c
                                                     WHERE Product_External_ID__c IN: productExternalIdList];
        Map<String, Product_Backup__c> externalIdToProductBackupMap = new Map<String, Product_Backup__c>();
        for(Product_Backup__c backup: productBackupList){
            externalIdToProductBackupMap.put(backup.Product_External_ID__c, backup);
        }
        for(Product2 product : productList){
            if(product.ExternalId.length() < 14){
                if(externalIdToProductBackupMap.containsKey(product.ExternalId)){
                    //needed to update existing backup records instead of creating new ones
                    Product_Backup__c backup = externalIdToProductBackupMap.get(product.ExternalId);
                    backup.Name = product.Name;
                    backup.Product_External_ID__c = product.ExternalId;
                    if (product.PricebookEntries.size() > 0)
                        backup.Selling_Price__c = product.PricebookEntries[0].UnitPrice;
                }
                else{
                    Product_Backup__c backup = new Product_Backup__c();
                    backup.Name = product.Name;
                    backup.Product_External_ID__c = product.ExternalId;
                    if (product.PricebookEntries.size() > 0)
                        backup.Selling_Price__c = product.PricebookEntries[0].UnitPrice;
                    productBackupList.add(backup);
                }
            }
        }
        Database.upsert(productBackupList, false);
    }
    
    public void finish(Database.BatchableContext BC){
    }
}