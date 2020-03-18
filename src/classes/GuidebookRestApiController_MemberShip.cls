public class GuidebookRestApiController_MemberShip {
    public static final String GUIDEBOOK_PRIVATE_URL = 'https://builder.guidebook.com/private-api/v1';
    public static final String GUIDEBOOK_PUBLIC_URL = 'https://builder.guidebook.com/open-api/v1';
    public static final string GUIDEBOOK_PRIVATE_KEY = 'JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlfa2V5Ijo3NzIsInN1YiI6NTc0NTQ3NywiYXVkIjoib3Blbl9hcGkifQ.N0FaxeMoLdU3DLvDbPZqz1WrewBo1Py7_4dFguFqFVA';
    public static final String GUIDEBOOK_FRONTDOOR_URL = 'https://builder.guidebook.com/service/v5/sfdc-frontdoor';
    
    
    @AuraEnabled
    public static List<LTE__Site__c> getSite(){
        List<LTE__Site__c> siteList = [SELECT id,Name,LTE__Site_URL__c,Guide__c FROM LTE__Site__c WHERE Guide__c = null];
        return siteList;
    }
    
    public static void createWebview(decimal guideId , string domain , String guideName){
        List<Framework__Registry__mdt> pageList = Framework.Registry.getEntriesByCat(Label.Fonteva_Mobile_Filter);
        if(pageList.Size() > 0){
            for(Framework__Registry__mdt pageObj : pageList){
                GuidebookWebview gAtt = new GuidebookWebview();
                gAtt.name = pageObj.Framework__Key__c;
                gAtt.webview_type = 'url';
                gAtt.guide = guideId;
                gAtt.url = GUIDEBOOK_FRONTDOOR_URL + '/?domain='+domain + '&path=' +EncodingUtil.urlEncode(pageObj.Framework__Value__c, 'UTF-8');
                String endPoint = GUIDEBOOK_PUBLIC_URL+'/webviews/';
                HttpResponse response = IntegrationHelper.makeRequest(gAtt,endPoint,'POST');
                if(response.getStatus() == 'Created'){
                    GuidebookWebview obj = GuidebookWebview.parse(response.getBody());
                    GuidebookMenuItem objMenuItem = new GuidebookMenuItem();
                    objMenuItem.object_id = obj.id;
                    objMenuItem.content_type = 'uri_resource.webview';
                    objMenuItem.guide =  Integer.valueOf(obj.guide);
                    String menuItemEndPoint = GUIDEBOOK_PUBLIC_URL+'/menu-items/';
                    HttpResponse response1 = IntegrationHelper.makeRequest(objMenuItem,menuItemEndPoint,'POST');   
                    
                }
            }
        }
    } 
    
    @future(callout=true)
    public static void SyncOrgGuides_Membership(ID communitySiteId , decimal guideId ,String guideName ,String guideDescription ){
        
        LTE__Site__c CommunitySiteObj = [SELECT Id , Name, Guide__c , LTE__Site_URL__c FROM LTE__Site__c WHERE id=:communitySiteId limit 1];
        
        String domain ;
         domain = CommunitySiteObj.LTE__Site_URL__c.substringBetween('https://','/');
         domain = 'https://'+domain;
        // String path ='TestPage';  //To do - This will be replaced by actual PathName 
        String endPoint='https://builder.guidebook.com/open-api/v1/guides/'+((guideId).round(System.RoundingMode.DOWN))+'/';
        GuidebookGuide guide = new GuidebookGuide();
        guide.Name = guideName;
        guide.start_date = System.today();
        guide.end_date = System.today().addYears(5);
        guide.description_html = guideDescription;
        HttpResponse response =IntegrationHelper.makeRequest(guide,endPoint,'PUT');
        if(response.getStatus() == 'OK'){
            GuidebookRestApiController_MemberShip.createWebview(guideId , domain , guide.Name);
        }
    }
    
    @AuraEnabled
    public static String createGuide_Membership(ID communitySiteId, String guideName , String guideDescription){
        LTE__Site__c CommunitySiteObj = [SELECT Id , Name, Guide__c FROM LTE__Site__c WHERE id=:communitySiteId limit 1];
        HttpResponse response;
        Guidebook_Setting__c guidebookapiKey = GuidebookApiController.getCustomSetting();
        if(guidebookapiKey != null && guidebookapiKey.Organization_ID__c != null){
            GuidebookProvisionProduct provisionProduct = new GuidebookProvisionProduct();
            provisionProduct.owner = guidebookapiKey.Organization_ID__c.round(System.RoundingMode.DOWN);
            provisionProduct.guide_quantity = 1;
            String endPoint= GUIDEBOOK_PRIVATE_URL+'/provision-products/';
            response =IntegrationHelper.makeRequest(provisionProduct,endPoint,'POST'); 
            Responsevalue wrapper = (Responsevalue) JSON.deserialize(response.getBody(), Responsevalue.class);
            if(response.getStatus()=='Created'){
                for(Products obj: wrapper.products){
                    if(obj.guide!=null){
                        CommunitySiteObj.Guide__c=obj.guide;
                        update CommunitySiteObj;
                    }
                }
            }
            if(CommunitySiteObj.Guide__c!=null){
                GuidebookRestApiController_MemberShip.SyncOrgGuides_Membership(CommunitySiteObj.Id, CommunitySiteObj.Guide__c ,  guideName ,  guideDescription  );
            }
        }
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
    public class Responsevalue{
        public List<Products> products;
        public List<results> results;
    }
}