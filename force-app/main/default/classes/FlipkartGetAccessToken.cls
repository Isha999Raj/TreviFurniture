/**
 * Author: Isha Raaz
 */

public with sharing class FlipkartGetAccessToken {

    public FlipkartGetAccessToken() {

    }

    public static string getAccessToken(){
        
    string endpoint = 'https://sandbox-api.flipkart.net/oauth-service/oauth/token';
    string clientId = '46647abb58a34183541b896715b90aa52356';
    string clientSecret = '3eb90e3f7de786460d7881cb85b82e522';
    
    Http http = new Http();
    HttpRequest request = new HttpRequest();
    string endpointParams = 'grant_type=client_credentials&scope=Seller_Api';
    endpoint = endpoint+'?'+endpointParams;
    system.debug('endpoint ------->'+endpoint);
    request.setEndpoint(endpoint);
    request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
    request.setMethod('GET');
    string reqbody = 'Username='+clientId+'&Password='+clientSecret;

    Blob headerValue = Blob.valueOf(clientId + ':' + clientSecret);
    String authorizationHeader = 'Basic ' +EncodingUtil.base64Encode(headerValue);
    request.setHeader('Authorization', authorizationHeader);
    HttpResponse response = http.send(request);
    system.debug(response);
    if(response.getStatusCode() == 200){
        Map<String,Object> results = (Map<String,Object>) JSON.deserializeUntyped(response.getBody());
        string access_token = (string) results.get('access_token');
        system.debug('access_token = '+access_token);
        return access_token;
    }
    return null;
    }
}