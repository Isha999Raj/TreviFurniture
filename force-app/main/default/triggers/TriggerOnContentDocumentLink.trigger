trigger TriggerOnContentDocumentLink on ContentDocumentLink (after insert ) 
{
/*
  List<ContentDocumentLink> cdList = Trigger.new;
    system.debug('cdList---->'+cdList);
    List<product2> productList = new List<Product2>();
    set<string> productIds = new set<string>();
     List<ContentVersion> cvtestidset;
    for(ContentDocumentLink cd : cdList)
    {
        
        productIds.add(cd.LinkedEntityId);
        system.debug('cd----->'+cd);
        system.debug('cd.LinkedEntityId====>'+cd.LinkedEntityId);
  //    ContentDocumentLink c =  [select Id,ContentDocumentId from ContentDocumentLink where id =:cdList.Id ]; //productId should pass
    
     cvtestidset = [Select Id,Title from ContentVersion where ContentDocumentId =:cd.ContentDocumentId and Title ='primaryImage'];
        system.debug('cvtestidset-->'+cvtestidset);
   // List<ContentDocumentLink>   cd1 = [select Id,ContentDocumentId from ContentDocumentLink where LinkedEntityId = :cd.product2.id];
    
}
          product2 pList = [select Id,GST__c,Hsn_Code__c,List_Price__c,ProductCode,Quantity__c,Name,Description,ContentVersionId__c from Product2 where id IN :productIds limit 1];
      
         pList.ContentVersionId__c =  cvtestidset[0].Id;
    
     update pList; */
}