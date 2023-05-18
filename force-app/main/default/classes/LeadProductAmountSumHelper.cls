/**
 * @author [Dinesh Baddawar]
 * @email dinesh.b@utilitarianLab.com
 * @create date 2023-05-04 17:02:01
 * @modify date 2023-05-04 17:02:01
 * @desc [description]
 */

public with sharing class LeadProductAmountSumHelper {
    
    Public Static Void UpdateProductAmountOnLead(List<Lead> ledList){
        try{
            if(ledList.size() > 0){
             Set<Id> LeadIdSet = new Set<Id>();
             Set<Id> ProductIdSet = new Set<Id>();
             Decimal ProductUnitPrice = 0;
             List<Product2> productListToUpdate = new List<Product2>();
             List<Lead> LeadListToUpdate = new List<Lead>();
             for(Lead led : ledList){
                LeadIdSet.add(led.id);
             }
             System.debug('LeadIdSet == >'+LeadIdSet);
          List<Lead> leadList = [SELECT Id,Name,(SELECT Id,Name,Product__c   fROM Product_Interests__r) from lead where id IN:LeadIdSet];

         if(leadList.size() > 0){
            for(lead pro : leadList){
               for(Product_Interest__c pd : pro.Product_Interests__r){
                ProductIdSet.add(pd.Product__c);
                }
              }
              System.debug('ProductIdSet == >'+ProductIdSet);
                    productListToUpdate = [SELECT Id,Name,(SELECT Id,UnitPrice FROM PricebookEntries) FROM Product2 WHERE Id IN:ProductIdSet];
                   if(productListToUpdate.size() > 0){
                    for(Product2 pro : productListToUpdate){
                        for(PricebookEntry pri : pro.PricebookEntries){
                         if(pri.UnitPrice !=null){
                             ProductUnitPrice = ProductUnitPrice +  pri.UnitPrice;
                         }
                      }
                    }
                   }
                   System.debug('ProductUnitPrice === >'+ProductUnitPrice);
                   LeadListToUpdate = [SELECt Id,Name,Total_Product_Interest_Price__c FROM Lead WHERE Id IN:LeadIdSet];
                   for(lead led : LeadListToUpdate){
                    led.Total_Product_Interest_Price__c = ProductUnitPrice;
                   }
                   update LeadListToUpdate;
                   System.debug('Updated Lead === >'+LeadListToUpdate);
              }
            }
        }catch(Exception e){
            System.debug('The Error ::'+e.getMessage() +' AND Error Line No :'+e.getLineNumber());
        }
    }
}