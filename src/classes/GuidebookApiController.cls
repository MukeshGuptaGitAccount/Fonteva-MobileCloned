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

public class GuidebookApiController {
    public static final String GUIDEBOOK_PRIVATE_URL = 'https://builder.guidebook.com/private-api/v1';
    public static final string GUIDEBOOK_PRIVATE_KEY = 'JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlfa2V5Ijo3NzIsInN1YiI6NTc0NTQ3NywiYXVkIjoib3Blbl9hcGkifQ.N0FaxeMoLdU3DLvDbPZqz1WrewBo1Py7_4dFguFqFVA';
    @AuraEnabled
    public static List<EventApi__Event__c> getGuides(){
        List<EventApi__Event__c> sObjs= new List<EventApi__Event__c>();
        Map<Decimal,EventApi__Event__c> mapObj= new Map<Decimal,EventApi__Event__c>();
        String apiKeyvalue;
        HttpResponse response;
        Guidebook_Setting__c guidebookapiKey = GuidebookApiController.getCustomSetting();
        if(guidebookapiKey!=null){
            String endPoint='https://builder.guidebook.com/open-api/v1/guides/?owner='+((guidebookapiKey.Organization_ID__c).round(System.RoundingMode.DOWN));
            HttpRequest req =  IntegrationHelper.getRequestObject(endPoint,'GET',GUIDEBOOK_PRIVATE_KEY,null);
            response = IntegrationHelper.GetResponse(req);
            if(response.getStatusCode() !=200){
                return null;
            }
            List<EventApi__Event__c> eventList=[SELECT Guide__c,id FROM EventApi__Event__c where Guide__c !=null];
            Reponsevalue wrapper = (Reponsevalue) JSON.deserialize(response.getBody(), Reponsevalue.class);
            for(results obj: wrapper.results){
                EventApi__Event__c regObj = new EventApi__Event__c();
                regObj.Guide__c = obj.id;
                regObj.Name = obj.name;
                regObj.EventApi__End_Date_Time__c = obj.end_date;
                regObj.EventApi__Start_Date_Time__c = obj.start_date;
                regObj.EventApi__Time_Zone__c = obj.timezone;
                if (String.isNotEmpty(obj.description_html)) {
                    regObj.EventApi__Overview_HTML__c = (obj.description_html).replaceAll('<[/a-zAZ0-9]*>','');
                }
                mapObj.put(regObj.Guide__c,regObj); 
            }
            for(EventApi__Event__c event:eventList){
                if( mapObj.containsKey(event.Guide__c))
                {
                    mapObj.remove(event.Guide__c);
                }
            }
            sObjs=mapObj.values();
            return sObjs;
        }else{
            return null;
        }
    } 
    /* Method To Fetch Current Event Record Data */
        @AuraEnabled
        public static EventApi__Event__c getEvent(ID eventId){
            return [SELECT id ,Guide__c,Name, EventApi__End_Date__c,EventApi__Start_Date__c, EventApi__Overview_HTML__c,EventApi__Event_Key__c FROM EventApi__Event__c where Id =: eventId];
        }
    /*Method to update Guides from Fonteva To GuideBook */
    @AuraEnabled
    public static void SyncData(ID eventId , decimal guideId){
        EventApi__Event__c guideObj=[SELECT Guide__c,EventApi__Time_Zone__c, EventApi__Start_Date_Time__c,EventApi__Description__c, EventApi__Overview_HTML__c,EventApi__End_Date_Time__c,Name FROM EventApi__Event__c where id=:eventId limit 1];
        String endPoint='https://builder.guidebook.com/open-api/v1/guides/'+((guideId).round(System.RoundingMode.DOWN))+'/';
        GuidebookGuide guide = new GuidebookGuide();
        if(String.isNotBlank(guideObj.EventApi__Overview_HTML__c)){
            guide.description_html = guideObj.EventApi__Overview_HTML__c;
        }
        guide.timezone  = guideObj.EventApi__Time_Zone__c;
        guide.end_date = guideObj.EventApi__End_Date_Time__c;
        guide.start_date = guideObj.EventApi__Start_Date_Time__c;
        if(String.isNotBlank(guideObj.Name)){
            guide.name = guideobj.Name;
        }
        HttpResponse response =IntegrationHelper.makeRequest(guide,endPoint,'PUT');
        if(response.getStatus()=='OK'){ 
            guideobj.Guide__c=guideId;
            update guideobj;
        }
    }
    
    @future(callout=true)
    public static void SyncOrgGuides(ID eventId , decimal guideId){
        EventApi__Event__c guideObj=[SELECT Guide__c,EventApi__Time_Zone__c, EventApi__Start_Date_Time__c,EventApi__Description__c, EventApi__Overview_HTML__c,EventApi__End_Date_Time__c,Name FROM EventApi__Event__c where id=:eventId limit 1];
        String endPoint='https://builder.guidebook.com/open-api/v1/guides/'+((guideId).round(System.RoundingMode.DOWN))+'/';
        GuidebookGuide guide = new GuidebookGuide();
        if(String.isNotBlank(guideObj.EventApi__Overview_HTML__c)){
            guide.description_html = guideObj.EventApi__Overview_HTML__c;
        }
        guide.timezone  = guideObj.EventApi__Time_Zone__c;
        guide.end_date = guideObj.EventApi__End_Date_Time__c;
        guide.start_date = guideObj.EventApi__Start_Date_Time__c;
        if(String.isNotBlank(guideObj.Name)){
            guide.name = guideobj.Name;
        }
        HttpResponse response =IntegrationHelper.makeRequest(guide,endPoint,'PUT');   
    }
    
    @AuraEnabled
    public static String createGuide(ID eventId){
        EventApi__Event__c guideObj=[SELECT Guide__c,EventApi__Time_Zone__c, EventApi__Start_Date_Time__c,EventApi__Description__c, EventApi__Overview_HTML__c,EventApi__End_Date_Time__c,Name FROM EventApi__Event__c where id=:eventId limit 1];
        HttpResponse response;
        Guidebook_Setting__c guidebookapiKey = GuidebookApiController.getCustomSetting();
        if(guidebookapiKey != null && guidebookapiKey.Organization_ID__c != null){
            GuidebookProvisionProduct provisionProduct = new GuidebookProvisionProduct();
            provisionProduct.owner = guidebookapiKey.Organization_ID__c.round(System.RoundingMode.DOWN);
            provisionProduct.guide_quantity = 1;
            String endPoint= GUIDEBOOK_PRIVATE_URL+'/provision-products/';
            response =IntegrationHelper.makeRequest(provisionProduct,endPoint,'POST'); 
            Reponsevalue wrapper = (Reponsevalue) JSON.deserialize(response.getBody(), Reponsevalue.class);
            if(response.getStatus()=='Created'){
                for(Products obj: wrapper.products){
                    if(obj.guide!=null){
                        guideObj.Guide__c=obj.guide;
                        update guideObj;
                    }
                }
            }
            if(guideObj.Guide__c!=null){
                GuidebookApiController.SyncOrgGuides(eventId, guideObj.Guide__c);
            }
        }   
        system.debug('Response from json '+response.getStatus());
        return response.getStatus();
    }
    public class results{
        public  Decimal id;
        public  String name;
        public  datetime end_date;
        public  String description_html ;
        public  datetime start_date;
        public  String timezone ;
        
    }
    public class Products {
        public String product;
        public Integer guide;
    }
    public class Reponsevalue{
        public List<Products> products;
        public List<results> results;
    }
    @AuraEnabled
    public static Guidebook_Setting__c getCustomSetting(){
        Guidebook_Setting__c guidebookapiKey = [SELECT Name ,Organization_ID__c,Is_Admin_Guidebook__c FROM Guidebook_Setting__c WHERE Organization_ID__c != null LIMIT 1 ];
        if(guidebookapiKey.Organization_ID__c!=null){   
            return guidebookapiKey ;
        }else{
            return null;
        }
    }
    @AuraEnabled
    public static String sendInvitation(String firstName,String lastName,String email){
        system.debug('=======Method Called ');
        HttpResponse response;
        Guidebook_Setting__c guidebookapiKey = GuidebookApiController.getCustomSetting();
        if(guidebookapiKey != null && guidebookapiKey.Organization_ID__c != null){
            GuidebookInvitation invite = new GuidebookInvitation();
            invite.first_name = firstName;
            invite.last_name = lastName;
            invite.email = email;
            String endPoint= GUIDEBOOK_PRIVATE_URL+'/organizations/'+((guidebookapiKey.Organization_ID__c).round(System.RoundingMode.DOWN))+'/invite/';
            response =IntegrationHelper.makeRequest(invite,endPoint,'POST');
            if(response.getStatus() == 'Accepted'){
                guidebookapiKey.Is_Admin_Guidebook__c = true;
                update guidebookapiKey;
            }
        }
        System.debug('=====response.getStatus()==='+response.getStatus());
        return response.getStatus();
    }
    @AuraEnabled
   public static String setMetaData(String apiKeyValue){   
       return null;
    }
     @AuraEnabled
    public static String getApiKeyName(){
        return null;
    }
    @AuraEnabled
    public static String getUIThemeDescription() {
        String theme = UserInfo.getUiThemeDisplayed();
        return theme;
    }
}