/*
 * -----------------------------------------------------------------------------
 * COPYRIGHT (C) 2019, FONTEVA, INC.
 * ALL RIGHTS RESERVED.
 *
 * ALL INFORMATION CONTAINED HEREIN IS, AND REMAINS THE PROPERTY OF FONTEVA
 * INCORPORATED AND ITS SUPPLIERS, IF ANY. THE INTELLECTUAL AND TECHNICAL
 * CONCEPTS CONTAINED HEREIN ARE PROPRIETARY TO FONTEVA INCORPORATED AND
 * ITS SUPPLIERS AND MAY BE COVERED BY U.S. AND FOREIGN PATENTS, PATENTS IN
 * PROCESS, AND ARE PROTECTED BY TRADE SECRET OR COPYRIGHT LAW. DISSEMINATION
 * OF THIS INFORMATION OR REPRODUCTION OF THIS MATERIAL IS STRICTLY FORBIDDEN
 * UNLESS PRIOR WRITTEN PERMISSION IS OBTAINED FROM FONTEVA, INC.
 * -----------------------------------------------------------------------------
 */
public class IntegrationHelper {
    
    public static HttpRequest getRequestObject(string endPointName, string methodName, string header, string body){
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endPointName);
        if(String.isNotBlank(header)){
            request.setHeader('Authorization' ,header);
        }
        if(String.isNotBlank(body)){             
            request.setBody(body);
        }
        request.setMethod(methodName);
        request.setHeader('content-type','application/json');
        if(methodName <> 'GET'){
            request.setHeader('Content-Length', '0');
        }
        request.setTimeout(120000);
        return request;
    }
    
    public static HttpResponse GetResponse(HttpRequest request){
        Http http = new Http();
        HttpResponse response;
        response = http.send(request);
        return response;
    }
    
     public static HttpResponse makeRequest(Object requestObj, String endPoint,String methodName) {
        String apiKeyValue = 'JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlfa2V5Ijo3NzIsInN1YiI6NTc0NTQ3NywiYXVkIjoib3Blbl9hcGkifQ.N0FaxeMoLdU3DLvDbPZqz1WrewBo1Py7_4dFguFqFVA';
        String jsonString = Json.serialize(requestObj,true);
        if(String.isNotBlank(apiKeyValue)){
            HttpRequest req = getRequestObject(endPoint,methodName,apiKeyValue,jsonString);
            return GetResponse(req);
        } 
        return null;
    }   
}