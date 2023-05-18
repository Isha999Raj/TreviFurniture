/**
* @description       : 
* @author            : Guru Charan
* @group             : 
* @last modified on  : 04-28-2023
* @last modified by  : Guru Charan
**/
public without sharing class TransferWareHouse 
{
    @AuraEnabled(Cacheable=true)
    public Static  List<Product_Warehouse__c>  getproductWarehouseRecords(String recid)
    {
        List<Product_Warehouse__c> prodWareRecs = new List<Product_Warehouse__c>();
        if(recid != null){
            prodWareRecs = [Select Id, Name, Current_Inventory__c, QuantityToTransfer__c, Unique__c, Warehouse__c, Product__c 
                            from Product_Warehouse__c where Warehouse__c=:recid and Current_Inventory__c >=1];
        }
        return prodWareRecs;
    }
    
    @AuraEnabled
    public static String insertWarehouseTransferLog(List<Product_Warehouse__c> prodList , String warehouseMasterId,string SelectedWareHouseId)
    {
        System.debug('prodList===>'+prodList);
        System.debug('prodList.size()===>'+prodList.size());
        System.debug('warehouseMasterId--->'+warehouseMasterId);
        System.debug('SelectedWareHouseId--->'+SelectedWareHouseId);
        
        Warehouse_Transfer_Log__c wtlRec = new Warehouse_Transfer_Log__c();
        wtlRec.Source_Warehouse__c = warehouseMasterId; //Current recordId
        wtlRec.Destination_Source__c = SelectedWareHouseId; //Selected Record
        wtlRec.Transfered_DateTime__c = System.today();
        
        insert wtlRec;
        if(wtlRec.ID != null)
        {
            System.debug('Hi, WtlRec is created -- ');
            List<Transfered_SKU__c> TrafSKUList = new List<Transfered_SKU__c>();
            for(Product_Warehouse__c prodwh : prodList)
            {
                Transfered_SKU__c tranfRec = new Transfered_SKU__c();
                tranfRec.Warehouse_Transfer_Log__c = wtlRec.Id;
                tranfRec.Product__c = prodwh.Product__c;
                tranfRec.Quantity__c = prodwh.QuantityToTransfer__c;
                tranfRec.UOM__c= 'NOS';
                TrafSKUList.add(tranfRec);
                
                prodwh.Current_Inventory__c = prodwh.Current_Inventory__c - prodwh.QuantityToTransfer__c;
                prodwh.QuantityToTransfer__c = 0;
            }
            insert TrafSKUList;
            update prodList;
        }
        return 'success';
    }
}