/**
 * Author: DeaGle
 */
public without sharing class HttpUtility {
    
    static final String NO_RESPONSE = 'NO_RESPONSE';
    static final String HTTP_ERROR = 'ERROR WHILE MAKING REQUEST';
    static IntegrationLogConfig__c intLogCon;

    
    static HttpUtility httpUtilityInstance;
    
    private HttpUtility() {}

    public static HttpUtility getInstance() {
        if(httpUtilityInstance == null) {
            httpUtilityInstance = new HttpUtility();
            intLogCon = IntegrationLogConfig__c.getInstance();
        }
        return httpUtilityInstance;
    }

    public String httpReqHelper(Map<String,String> headerMap, String method, String jsonBody, String endPoint) {
        Integration_Log__c logger = new Integration_Log__c();
        logger.HTTP_Method__c = method;
        logger.Integration_Type__c = 'CALLOUT';
        HttpRequest httpRequest = new HttpRequest();
        httpRequest.setEndpoint(endpoint);
        httpRequest.setMethod(method);
        httpRequest.setBody(jsonBody);
        httpRequest.setTimeout(Integer.valueOf(intLogCon.Request_TimeOut__c));
        
        System.debug('Endpoint---'+httpRequest.getEndpoint());

        if(!headerMap.isEmpty()){
            for(String key : headerMap.keySet()){
                httpRequest.setHeader(key,headerMap.get(key)); 
            }
        }
        try {
            Http http = new Http();
            logger.Start_Date_And_Time__c = System.now();
            HTTPResponse response = http.send(httpRequest);
            logger.End_Date_And_Time__c = System.now();
            if(intLogCon != null && intLogCon.Enable_Integration_Logger__c)
                createLog(logger, httpRequest, response);
            if(response.getStatusCode() == 200 || response.getStatusCode() == 201)
                return response.getBody();
            return NO_RESPONSE;
        }catch (Exception e) {
            System.debug('--- e-message '+ e.getMessage());
            System.debug('--- e-line-no '+ e.getLineNumber());
            HandleBusinessException.captureError('HttpUtility', 'httpReqHelper', e);
            return HTTP_ERROR;
        }

    }

    private void createLog(Integration_Log__c logger, HttpRequest httpReq, HttpResponse httpRes) {
        if(httpReq != null) {
            logger.Request_Body__c = httpReq.getBody();
            logger.EndPoint__c = httpReq.getEndPoint();
        }
        if(httpRes != null) {
            logger.Response_Body__c = httpRes.getBody();
            logger.Response_Status_Code__c = httpRes.getStatusCode();
        }
        insert logger;
    }

    public void createServiceLogger(String reqBody, String resBody, String endPoint, String method, Integer statusCode, DateTime startDatetime, DateTime endDateTime, String refferenceId) {
        try {
            if(intLogCon != null && intLogCon.Enable_Apex_Service_Logger__c) {
                Integration_Log__c logger = new Integration_Log__c();
                logger.HTTP_Method__c = method;
                logger.Integration_Type__c = 'SERVICE';
                logger.Request_Body__c = reqBody;
                logger.Response_Body__c = resBody;
                logger.EndPoint__c = endPoint;
                logger.Response_Status_Code__c = statusCode;
                logger.Start_Date_And_Time__c = startDatetime;
                logger.End_Date_And_Time__c = endDatetime;
                logger.Refference_Id__c = refferenceId;
                insert logger;
            }
        }catch(DMLException e){
            System.debug('--- e-message '+ e.getMessage());
            System.debug('--- e-line-no '+ e.getLineNumber());
            HandleBusinessException.captureError('HttpUtility', 'httpReqHelper', e);
        }
    }
    
}