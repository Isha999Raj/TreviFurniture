/*
Author : GC 
*/
public without sharing class ProductController 
{
    public String recordId {get;set;}
    public  Quote quotesList {set;get;}
    // System.debug('recordId == >'+recordId);
    public List<QuoteLineItem> quoteLineItems {set;get;}
    public  Product2 products {set;get;}
    public Contentversion cvtestidset {set;get;}
    public String ContentversionId {set;get;}
    
    // list<Contentversion> cvtestidset ;
    public ProductController(ApexPages.StandardController controller)
    {
        try{
        recordId = controller.getId();
        System.debug('recordId == >'+recordId);
        
        String customLabelValue = System.Label.primaryImage;
        System.debug('customLabelValue====>'+customLabelValue);
        
         quotesList = [SELECT Id,Status,Name FROM Quote WHERE id = :recordId];
        system.debug('quotesList===>'+quotesList);
        
        // List<Quote> quotes = new List<Quote>();
        // quotes = [select Id from Quote  where id = :recordId];
        
        if(!String.isBlank(quotesList.id)){
            quoteLineItems = [select Id,TotalPrice,Subtotal,UnitPrice,Quantity,Description,Discount,ListPrice,QuoteId,Product2Id,Product2.Name,Product2.Description,product2.ContentVersionId__c from QuoteLineItem where QuoteId =:quotesList.Id];
             ContentversionId = '0691e000001Hbv7AAC';
        }
        System.debug('quoteLineItems----->'+quoteLineItems);
        // List<Product2> products = new List<product2>();
        for(QuoteLineItem qliRec:quoteLineItems)
        {
            products= [select Id,GST__c,Hsn_Code__c,List_Price__c,ProductCode,Quantity__c,Name,Description,ContentVersionId__c from Product2 where id=:qliRec.Product2Id];
            system.debug('Productsssss--->'+products);
            if(products != null)
            {
                List<ContentDocumentLink> cdl = [select Id,ContentDocumentId from ContentDocumentLink where LinkedEntityId = :products.id];
                system.debug('cdlContentDocumentId----->'+cdl[0].ContentDocumentId);
                if(!String.isBlank(cdl[0].id)){
                    cvtestidset = [Select Id,Title from ContentVersion where ContentDocumentId =:cdl[0].ContentDocumentId and Title = :customLabelValue]; 
                    ContentversionId = cvtestidset.Id;
                    System.debug('ContentDocument====>'+cvtestidset);
                }
                
            }     
        }
             } catch(exception e)
             {
                 system.debug('exception Message=====>'+e.getMessage());
                 system.debug('exception Line Number=====>'+e.getLineNumber());
             }
        
        
    }
    @AuraEnabled
    public static string savePDF(String url,String id,String fileName){
        try {
            
            PageReference ref = new PageReference(url);
            ContentVersion cont = new ContentVersion();
            
            cont.Title = fileName;
            cont.PathOnClient = fileName+'.pdf';
            cont.VersionData = ref.getContentAsPdf();
            cont.Origin = 'H';
            
            insert cont;    
            ContentDocumentLink cdl = createContentLink(cont.Id, id);
            return 'Success';
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    private static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if (contentVersionId == null || recordId == null) { return null; }
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [ SELECT ContentDocumentId FROM ContentVersion WHERE Id =: contentVersionId ].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        cdl.ShareType = 'V';
        try {
            insert cdl;
            return cdl;
        } catch(DMLException e) {
            System.debug(e);
            return null;
        }
    }
    
}
/*
//   cvtestidset = new  list<Contentversion>() ;

List<Product2> products = new List<product2>();
//  products= [select Id,GST__c,Hsn_Code__c,List_Price__c,ProductCode,Quantity__c from Product2 where id='01t1e000001r8WpAAI'];
products= [select Id,GST__c,Hsn_Code__c,List_Price__c,ProductCode,Quantity__c from Product2 where id=:quoteLineItems[0].Product2Id];
system.debug('Productsssss--->'+products);

if(products != null)
{
List<ContentDocumentLink> cdl = [select Id,ContentDocumentId from ContentDocumentLink where LinkedEntityId = :products[0].id];
system.debug('cdl----->'+cdl);

//  List<ContentDocument> cdR = [Select Id, Title, FileExtension, CreatedDate From ContentDocument where id =:cdl[0].ContentDocumentId];
list<Contentversion>  cvtestidset = [Select Id,Title from ContentVersion where ContentDocumentId =:cdl[0].ContentDocumentId and Title = :customLabelValue]; 
System.debug('ContentDocument====>'+cvtestidset);
}*/