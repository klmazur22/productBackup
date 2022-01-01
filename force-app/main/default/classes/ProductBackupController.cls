/**
* @author Kyrylo Mazur
* @date 9/2021
* @description apex controller for productBackupView LWC
*
*/
public with sharing class ProductBackupController {
    
    /*******************************************************************************************************
    * @description get necessary fields related to current record
    * @param productBackupRecordId the Id of product backup record reviewed
    * @return Product_Backup__c record with fields necessary to be shown in LWC
    */
    @AuraEnabled(cacheable=true)
    public static Product_Backup__c getProductBackupInfo(Id productBackupRecordId){
        return [SELECT Product_External_ID__c, Name, Selling_Price__c 
                FROM Product_Backup__c 
                WHERE Id =: productBackupRecordId LIMIT 1];
    }
    
    /*******************************************************************************************************
    * @description get necessary fields related product associated with current record
    * @param productBackupRecordId the Id of product backup record reviewed
    * @return associated Product2 record with fields necessary to be shown in LWC
    */
    @AuraEnabled(cacheable=true)
    public static Product2 getRelatedProductInfo(Id productBackupRecordId){
        List<Product2> productRecordList = [SELECT IsActive, CreatedDate
                                            FROM Product2 
                                            WHERE ExternalId =: [SELECT Product_External_ID__c
                                                                 FROM Product_Backup__c 
                                                                 WHERE Id =: productBackupRecordId LIMIT 1].Product_External_ID__c LIMIT 1];
        if(productRecordList.size() == 0) throw new ProductException(Label.Related_Product_Not_Found);
        else return productRecordList[0];
    }
    
    public class ProductException extends Exception{}
}