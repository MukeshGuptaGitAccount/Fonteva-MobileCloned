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
public class GuidebookRestApiController {
    
    public static final String GUIDEBOOK_URL = 'https://builder.guidebook.com/open-api/v1';
    public static final String GUIDEBOOK_PRIVATE_URL = 'https://builder.guidebook.com/private-api/v1';
    public static final string GUIDEBOOK_PRIVATE_KEY = 'JWT eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlfa2V5Ijo3NzIsInN1YiI6NTc0NTQ3NywiYXVkIjoib3Blbl9hcGkifQ.N0FaxeMoLdU3DLvDbPZqz1WrewBo1Py7_4dFguFqFVA';
    
    
    
    /*Method to Map Session object Data */
    public static GuidebookSession getSessionData(EventAPI__Schedule_Item__c sessionObj){
        
        List<Decimal> listLocations = new List<Decimal>();
        if (sessionObj.EventApi__Room__r.Location_Id__c != null) {
            listLocations.add(sessionObj.EventApi__Room__r.Location_Id__c);
        }
        List<Decimal> listTracks = new List<Decimal>();
        EventAPI__Schedule_Item__c  sessionObjTrack =  [SELECT Id , Name , Session_Id__c,(SELECT Id , Name , EventApi__Track__c ,EventApi__Track__r.Schedule_Track_Id__c ,EventAPI__Schedule_Item__c FROM EventApi__Track_Schedule_Items__r) FROM EventAPI__Schedule_Item__c WHERE Id =:sessionObj.Id LIMIT 1];
        for(EventApi__Track_Schedule_Item__c obj: sessionObjTrack.EventApi__Track_Schedule_Items__r){
            if (obj.EventApi__Track__c != null) {
                listTracks.add(obj.EventApi__Track__r.Schedule_Track_Id__c);
            }
        }
        GuidebookSession gAtt = new GuidebookSession();
        gAtt.guide = Integer.valueOf(sessionObj.Guide__c);
        gAtt.name = sessionObj.Name;
        gAtt.import_id = sessionObj.id;
        if (String.isNotBlank(sessionObj.EventApi__Description__c)) {
            gAtt.description_html= sessionObj.EventApi__Description__c;
        }
        gAtt.add_to_schedule = sessionObj.EventApi__Disable_Registration__c;
        gAtt.start_time = sessionObj.EventApi__Start_Date_Time__c;
        gAtt.end_time = sessionObj.EventApi__End_Date_Time__c;
        
        if(listLocations.size()>0) {
            gAtt.locations = listLocations;
        }
        if(listTracks.size()>0) {
            gAtt.schedule_tracks = listTracks;
        }
        return gAtt;
    }
    
    /*Method to Map speaker object Data */
    
    public static GuidebookSpeaker getSpeakerData(EventApi__Speaker__c speakerObj){
        
        GuidebookSpeaker speaker = new GuidebookSpeaker();
        speaker.allow_rating = speakerObj.allow_rating__c;
        speaker.disable_todo = speakerObj.Disable_Todo__c;
        speaker.guide =  Integer.valueOf(speakerObj.Guide__c);
        if(String.isNotBlank(speakerObj.Import_Id__c)) {
            speaker.import_id = speakerObj.Import_Id__c;
        }
        speaker.name = speakerObj.Name;
        return speaker;
    }
    
    /*Method to Map menuitems object Data */
    public static GuidebookMenuItem getMenuItemData(GuidebookSpeaker speakerObj){
        
        GuidebookMenuItem objMenuItem = new GuidebookMenuItem();
        objMenuItem.object_id = speakerObj.id;
        objMenuItem.content_type = 'custom_list.customlist';
        objMenuItem.guide =  speakerObj.guide;
        return objMenuItem;
    }
    /*Method to Map CustomlistItem object Data */
    public static GuidebookCustomListItem getCustomListItem(EventApi__Speaker__c speakerObj){
        
        GuidebookCustomListItem objCustomListItem = new GuidebookCustomListItem();
        objCustomListItem.name = speakerObj.Name;
        objCustomListItem.guide = Integer.valueOf(speakerObj.Guide__c);
        if(String.isNotBlank(speakerObj.Import_Id__c)) {
            objCustomListItem.import_id = speakerObj.Import_Id__c;
        }
        objCustomListItem.subtitle = speakerObj.EventApi__Title__c;
        if(String.isNotBlank(speakerObj.EventApi__Bio__c)){
            objCustomListItem.description_html = speakerObj.EventApi__Bio__c;  
        }else{
            objCustomListItem.description_html = speakerObj.Name;
        }
       
        return objCustomListItem;
    }
    /*Method to Map CustomListItemRelation object Data */
    public static GuidebookCustomListItemRelation getCustomRelation(EventApi__Speaker__c speakerObj){
        
        GuidebookCustomListItemRelation objCustomRelation = new GuidebookCustomListItemRelation();
        if(speakerObj.Speaker_Id__c != null){
            objCustomRelation.custom_list = Integer.valueOf(speakerObj.EventApi__Event__r.Custom_List_Id__c);
            objCustomRelation.custom_list_item = Integer.valueOf(speakerObj.Speaker_Id__c);
        }
        return objCustomRelation;
    }
    /* Method to Map attendee object Data */
    public static GuidebookAttendee getAttendeeData(EventApi__Attendee__c attendeeObj){
        
        GuidebookAttendee attendee = new GuidebookAttendee();
        if (String.isNotBlank(attendeeObj.EventApi__First_Name__c)) {
            attendee.first_name = attendeeObj.EventApi__First_Name__c;
        }
        if (String.isNotBlank(attendeeObj.EventApi__Last_Name__c)) {
            attendee.last_name = attendeeObj.EventApi__Last_Name__c;
        }
        attendee.guide_id = Integer.valueOf(attendeeObj.Guide__c);
        attendee.guide = Integer.valueOf(attendeeObj.Guide__c);
        attendee.revoked = attendeeObj.Revoked__c;
        if (String.isNotBlank(attendeeObj.EventApi__Email__c)) {
            attendee.email = attendeeObj.EventApi__Email__c;
        }
        else if(String.isNotBlank(attendeeObj.EventApi__Preferred_Email__c)){
            attendee.email = attendeeObj.EventApi__Preferred_Email__c;
        }
        attendee.import_id = attendeeObj.Id;
        
        return attendee;
        
    }
    
    /* Method to Map Registration object Data */
    public static GuidebookRegistrationItem getRegistrationItemData(EventApi__Registration_Item__c regItemObj){
        List<Integer> listAttendees = new List<Integer>();
        listAttendees.add(Integer.valueOf(regItemObj.Attendee_id__c));
        List<Integer> listSessions = new List<Integer>();
        listSessions.add(Integer.valueOf(regItemObj.Schedule_Item_id__c));
        GuidebookRegistrationItem gAtt= new GuidebookRegistrationItem();
        gAtt.guide = Integer.valueOf(regItemObj.Guide__c);
        if(String.isNotEmpty(regItemObj.Name__c)){
            gAtt.name=regItemObj.Name__c;
        }else{
            gAtt.name = regItemObj.EventApi__Schedule_Item__r.Name+'-'+regItemObj.EventApi__Attendee__r.EventApi__First_Name__c+' '+regItemObj.EventApi__Attendee__r.EventApi__Last_Name__c; 
        }
        
        if(listAttendees.size()>0) {
            gAtt.attendees = listAttendees;
        }
        if(listSessions.size()>0) {
            gAtt.sessions = listSessions;
        }
        
        return gAtt;
    }
    
    /* Method to Create Registration object Data From Guidebook To Fonteva */
    public static list<EventApi__Registration_Item__c> getRegistrationItem(Decimal GuideId){
        
        Map<Decimal,EventApi__Attendee__c> mapAttendee=new Map<Decimal,EventApi__Attendee__c>();
        Map<Decimal,EventAPI__Schedule_Item__c> mapSession=new Map<Decimal,EventAPI__Schedule_Item__c>();
        String endPoint=GUIDEBOOK_URL+'/personalized-schedules/?guide='+GuideId.round(System.RoundingMode.DOWN);
        HttpRequest req =  IntegrationHelper.getRequestObject(endPoint,'GET',GUIDEBOOK_PRIVATE_KEY,null);
        HttpResponse response = IntegrationHelper.GetResponse(req);
        Reponsevalue wrapper = (Reponsevalue) JSON.deserialize(response.getBody(), Reponsevalue.class);
        Set<Decimal> setAttendeeId=new Set<Decimal>();
        Set<Decimal> setSessionId = new Set<Decimal>();
        String attId ;
        String sesId ;
        if(wrapper.results.size() >0 && wrapper.results != null){
            for(results obj: wrapper.results){
                if(obj.attendees.size()>0){
                    for(Decimal attendeeId:obj.attendees){
                        setAttendeeId.add(attendeeId);
                    }
                }
                if(obj.sessions.size()>0){
                    for(Decimal sessionId :obj.sessions){
                        setSessionId.add(sessionId);
                    }
                }
            }
        }
        if(setAttendeeId.size()>0){
            for( EventApi__Attendee__c attendee:[select id,Attendee_Id__c from EventApi__Attendee__c where Attendee_Id__c IN: setAttendeeId]){
                mapAttendee.put(attendee.Attendee_Id__c, attendee);
            }
        }
        if(setSessionId.size()>0){
            for( EventAPI__Schedule_Item__c session:[select id,session_Id__c from EventAPI__Schedule_Item__c where session_Id__c IN: setSessionId]){
                mapSession.put(session.session_Id__c, session);
            }
        }
        List<EventApi__Registration_Item__c> lstItem= new list<EventApi__Registration_Item__c>();
        for(results obj: wrapper.results){
            EventApi__Registration_Item__c regObj = new EventApi__Registration_Item__c();
            for(Decimal attendeeId:obj.attendees){
                if(mapAttendee.containsKey(attendeeId)){
                    attId = mapAttendee.get(attendeeId).Id;
                }
            }
            for(Decimal sessionId:obj.sessions){
                if(mapSession.containsKey(sessionId)){
                    sesId = mapSession.get(sessionId).Id;
                }
            }
            regObj.EventApi__Attendee__c= attId;
            regObj.EventApi__Schedule_Item__c = sesId;
            regObj.Name__c=obj.name;
            regObj.Registration_Id__c=Decimal.valueOf(obj.id);
            if(regObj.EventApi__Attendee__c != null && regObj.EventApi__Schedule_Item__c != null){
                lstItem.add(regObj);
            }
        }
        return lstItem;
    }
    
    public class results{
        public  String id;
        public  decimal guide;
        public  String name;
        public  List<Decimal> attendees;
        public  List<Decimal> sessions;
        public String first_name;
        public String description;
        public String avatar;
    }
    public class Reponsevalue{
        public List<results> results;
    }
    
    /* Method to map Track object records */
    public static GuidebookTrack getTrackData(EventApi__Track__c trackObj){
        Pattern colorPattern = Pattern.compile(Label.Color_Pattern);
        GuidebookTrack gAtt = new GuidebookTrack();
        gAtt.name = trackObj.Name;
        gAtt.guide=Integer.valueOf(trackObj.Guide__c);
        if(String.isNotBlank(trackObj.EventApi__Track_Color__c)){
            String colormatch = colorPattern.matcher(trackObj.EventApi__Track_Color__c).replaceAll('');
            if(String.isBlank(colormatch)){
                gAtt.color = (trackObj.EventApi__Track_Color__c).toUppercase();
            }
        }
        return gAtt;
    }
    
    /* Method to map Venue object records */
    public static GuidebookVenue getVenueData(EventApi__Venue__c venueObj){ 
        String addressdata = '';
        GuidebookVenue gAtt = new GuidebookVenue();
        GuidebookVenue.Address  address = new GuidebookVenue.Address();
        gAtt.name=venueObj.Name;
        gAtt.guide=Integer.valueOf(venueObj.Guide__c);
        if(String.isNotBlank(venueObj.Guidebook_Location_Import_Id__c)){
            gAtt.import_id=venueObj.Guidebook_Location_Import_Id__c;
        }
        if(venueObj.Guidebook_Location_Latitude__c!=null){
            gAtt.latitude=venueObj.Guidebook_Location_Latitude__c;
        }
        if(venueObj.Guidebook_Location_Longitude__c!=null){
            gAtt.longitude=venueObj.Guidebook_Location_Longitude__c;
        }
        if(venueObj.Guidebook_Location_Latitude__c!=null && venueObj.Guidebook_Location_Longitude__c!=null){
            gAtt.location_type=3;
        }else{
            gAtt.location_type=2;
        }
        if(String.isNotBlank(venueObj.EventApi__Street__c)){
            address.street = venueObj.EventApi__Street__c;
            addressdata = address.street + ', ';
        }
        if(String.isNotBlank(venueObj.EventApi__City__c)){
            address.city = venueObj.EventApi__City__c;
            addressdata = addressdata + address.city + ', ';
        }
        if(String.isNotBlank(venueObj.EventApi__State__c)){
            address.state = venueObj.EventApi__State__c;
            addressdata = addressdata + address.state + ' ';
        }
        if(String.isNotBlank(venueObj.EventApi__Postal_Code__c)){
            address.zipcode = venueObj.EventApi__Postal_Code__c;
            addressdata = addressdata + address.zipcode + ', ';
        }
        if(String.isNotBlank(venueObj.EventApi__Country__c)){
            address.country = venueObj.EventApi__Country__c;
            addressdata = addressdata + address.country ;
        }
        address.address = addressdata;
        gAtt.address = address;
        return gAtt;
    }
    /* Method to map MainVenue object record */
    public static GuidebookMainVenue getMainVenueData(EventApi__Venue__c venueObj){ 
        String addressdata = '';
        GuidebookMainVenue gAtt = new GuidebookMainVenue();
        GuidebookMainVenue.Address  address = new GuidebookMainVenue.Address();
        gAtt.name=venueObj.Name;
        gAtt.guide=Integer.valueOf(venueObj.Guide__c);
        if(String.isNotBlank(venueObj.Guidebook_Location_Import_Id__c)){
            gAtt.import_id = venueObj.Guidebook_Location_Import_Id__c;
        }
        if(venueObj.Guidebook_Location_Latitude__c != null){
            gAtt.latitude = venueObj.Guidebook_Location_Latitude__c;
        }
        if(venueObj.Guidebook_Location_Longitude__c != null){
            gAtt.longitude = venueObj.Guidebook_Location_Longitude__c;
        }
        if(venueObj.EventApi__Is_Primary_Venue__c == true){
            gAtt.location_type = 1;
        }
        if(String.isNotBlank(venueObj.EventApi__Street__c)){
            address.street = venueObj.EventApi__Street__c;
            addressdata = address.street + ', ';
        }
        if(String.isNotBlank(venueObj.EventApi__City__c)){
            address.city = venueObj.EventApi__City__c;
            addressdata = addressdata + address.city + ', ';
        }
        if(String.isNotBlank(venueObj.EventApi__State__c)){
            address.state = venueObj.EventApi__State__c;
            addressdata = addressdata + address.state + ' ';
        }
        if(String.isNotBlank(venueObj.EventApi__Postal_Code__c)){
            address.zipcode = venueObj.EventApi__Postal_Code__c;
            addressdata = addressdata + address.zipcode + ', ';
        }
        if(String.isNotBlank(venueObj.EventApi__Country__c)){
            address.country = venueObj.EventApi__Country__c;
            addressdata = addressdata + address.country ;
        }
        address.address = addressdata;
        gAtt.address = address;
        return gAtt;
    }
    /* Method to map Room object records */
    public static GuidebookRoom getRoomData(EventApi__Room__c roomObj){
        
        GuidebookRoom gAtt = new GuidebookRoom();
        GuidebookRoom.Address  address = new GuidebookRoom.Address();
        gAtt.name=roomObj.Name;
        gAtt.guide=Integer.valueOf(roomObj.Guide__c);
        if(String.isNotBlank(roomObj.EventApi__Venue__r.Guidebook_Location_Import_Id__c)){
            gAtt.import_id = roomObj.EventApi__Venue__r.Guidebook_Location_Import_Id__c;
        }
        if(roomObj.EventApi__Venue__r.Guidebook_Location_Latitude__c != null){
            gAtt.latitude=roomObj.EventApi__Venue__r.Guidebook_Location_Latitude__c;
        }
        if(roomObj.EventApi__Venue__r.Guidebook_Location_Longitude__c != null){
            gAtt.longitude=roomObj.EventApi__Venue__r.Guidebook_Location_Longitude__c;
        }
        if(roomObj.EventApi__Venue__r.Guidebook_Location_Latitude__c != null && roomObj.EventApi__Venue__r.Guidebook_Location_Longitude__c != null){
            gAtt.location_type = 3;
        }else{
            gAtt.location_type = 2;
        }
        if(String.isNotBlank(roomObj.EventApi__Venue__r.EventApi__City__c)){
            address.city = roomObj.EventApi__Venue__r.EventApi__City__c;
        }
        if(String.isNotBlank(roomObj.EventApi__Venue__r.EventApi__State__c)){
            address.state = roomObj.EventApi__Venue__r.EventApi__State__c;
        }
        if(String.isNotBlank(roomObj.EventApi__Venue__r.EventApi__Street__c)){
            address.street = roomObj.EventApi__Venue__r.EventApi__Street__c;
        }
        if(String.isNotBlank(roomObj.EventApi__Venue__r.EventApi__Postal_Code__c)){
            address.zipcode = roomObj.EventApi__Venue__r.EventApi__Postal_Code__c;
        }
        if(String.isNotBlank(roomObj.EventApi__Venue__r.EventApi__Country__c)){
            address.country = roomObj.EventApi__Venue__r.EventApi__Country__c;
        }
        gAtt.address = address;
        return gAtt;
    }
    
    /* Method to Create/Update Track object record from Fonteva to Guidebook */
    public static list<EventApi__Track__c> sendTrack(List<String> recordIds){
        List<EventApi__Track__c> trackObj = [select Guide__c ,Schedule_Track_Id__c,Name,EventApi__Track_Color__c from EventApi__Track__c where Id IN : recordIds AND Guide__c != null];
		List<EventApi__Track__c> trackList = new List<EventApi__Track__c>();
        if(trackObj.size() > 0){
		for(Integer i=0;i<trackObj.size();i++){
            GuidebookTrack gAtt = getTrackData(trackObj[i]);
            if(trackObj[i].Schedule_Track_Id__c == null)
            {
                String endPoint=GUIDEBOOK_URL+'/schedule-tracks/';
                HttpResponse response =IntegrationHelper.makeRequest(gAtt,endPoint,'POST');
                if(response.getStatus()=='Created'){
                    
                    GuidebookTrack obj = GuidebookTrack.parse(response.getBody());
                    trackObj[i].Schedule_Track_Id__c=obj.id;
					trackList.add(trackObj[i]);  
                }
            }
            else {
                String endPoint=GUIDEBOOK_URL+'/schedule-tracks/'+((trackObj[i].Schedule_Track_Id__c).round(System.RoundingMode.DOWN))+'/';
                HttpResponse response =IntegrationHelper.makeRequest(gAtt,endPoint,'PUT');
            }
			}
			
			if(trackList.size() > 0){
			Framework.Dispatcher.disableAfterTriggerInContext.put(trackObj.getSObjectType().getDescribe().getName(),true);       
            update trackList;       
            Framework.Dispatcher.disableAfterTriggerInContext.put(trackObj.getSObjectType().getDescribe().getName(),false);
			}
		}
			return null;
        }
        
    
    /* Method to Create custom-lists/menu-items object */
    public static EventApi__Event__c sendCustomList(String recordId){
        EventApi__Speaker__c  speakerObj = [select Guide__c,EventApi__Event__c,EventApi__Bio__c,EventApi__Event__r.Custom_List_Id__c,allow_rating__c,Disable_Todo__c,Name,Import_Id__c,Speaker_Id__c from EventApi__Speaker__c where Id =: recordId AND Guide__c != null];
        EventApi__Event__c event = new EventApi__Event__c();
        if(speakerObj != null){
            if(speakerObj.EventApi__Event__r.Custom_List_Id__c == null){
                String endPointMenuItems = GUIDEBOOK_URL+'/menu-items/';
                String endPoint = GUIDEBOOK_URL+'/custom-lists/';
                GuidebookSpeaker speakerContainer = new GuidebookSpeaker();
                speakerContainer.Name = Label.Guidebook_Speaker;
                speakerContainer.guide = Integer.valueOf(speakerObj.Guide__c);
                HttpResponse response = IntegrationHelper.makeRequest(speakerContainer,endPoint,'POST');
                if(response.getStatus() == 'Created'){
                    GuidebookSpeaker spkContainer = GuidebookSpeaker.parse(response.getBody());
                    GuidebookMenuItem menuItem = getMenuItemData(spkContainer);
                    HttpResponse menuItemResponse = IntegrationHelper.makeRequest(menuItem,endPointMenuItems,'POST');
                    if(menuItemResponse.getStatus() == 'Created'){
                        event.Id = speakerObj.EventApi__Event__c;
                        event.Custom_List_Id__c = spkContainer.id;
                    }
                }  
            } 
        }
        return event;
    }
    /* Method to Create/Update Speaker object record from Fonteva to Guidebook */
    public static list<EventApi__Speaker__c> sendSpeaker(List<String> recordIds){
        List<EventApi__Speaker__c>  speakerObj = [select Guide__c,EventApi__Bio__c,EventApi__Title__c,EventApi__Event__c,EventApi__Event__r.Custom_List_Id__c,allow_rating__c,Disable_Todo__c,Name,Import_Id__c,Speaker_Id__c from EventApi__Speaker__c where Id IN : recordIds AND Guide__c != null];
        List<EventApi__Speaker__c> speakerList = new List<EventApi__Speaker__c>();
        Map<Id,EventApi__Speaker__c> mapEvent = new Map<Id,EventApi__Speaker__c>();
        for(EventApi__Speaker__c spk : speakerObj){
            if(!mapEvent.containsKey(spk.EventApi__Event__c)){
                mapEvent.put(spk.EventApi__Event__c , spk);
            }
        }
        List<EventApi__Event__c> eventList = new List<EventApi__Event__c>();
        List<String> speakerIds = new List<String>();
        for(Id spkEvent :mapEvent.keySet()){
            if(mapEvent.get(spkEvent).EventApi__Event__r.Custom_List_Id__c == null){
                EventApi__Event__c event = sendCustomList(mapEvent.get(spkEvent).Id);
                eventList.add(event);
            }
        }
        if(speakerObj.size() > 0){
            for(Integer i=0;i<speakerObj.size();i++){
                GuidebookSpeaker speaker = getSpeakerData(speakerObj[i]);
                if(speakerObj[i].Speaker_Id__c == null){
                    string endPointCustomItem = GUIDEBOOK_URL+'/custom-list-items/';
                    String endPointCustomRes = GUIDEBOOK_URL+'custom-list-item-relations/';
                    GuidebookCustomListItem customItem = getCustomlistItem(speakerObj[i]);
                    HttpResponse customListItemResp = IntegrationHelper.makeRequest(customItem, endPointCustomItem, 'POST');
                    if(customListItemResp.getStatus() == 'Created'){
                        GuidebookCustomListItem customItemres = GuidebookCustomListItem.parse(customListItemResp.getBody());
                        speakerObj[i].Speaker_Id__c = customItemres.id;
                        speakerList.add(speakerObj[i]);
                        speakerIds.add(speakerObj[i].Id);
                    }                       
                }
                else {
                    GuidebookCustomListItem customItem = getCustomlistItem(speakerObj[i]);
                    String endpointCustomItem = GUIDEBOOK_URL+'/custom-list-items/'+((speakerObj[i].Speaker_Id__c).round(System.RoundingMode.DOWN))+'/';
                    HttpResponse customListItemResponse = IntegrationHelper.makeRequest(customItem, endpointCustomItem, 'PUT');
                }
            }
            if(speakerList.size() >0 ){
                Framework.Dispatcher.disableAfterTriggerInContext.put(speakerObj.getSObjectType().getDescribe().getName(),true);
                if(eventList.size() > 0){
                    update eventList;
                }
                update speakerList; 
              //  System.enqueueJob(new QueueableGuidebook( 'CustomListItemRelations',speakerList ));
              customListItemResponse(speakerIds);
                Framework.Dispatcher.disableAfterTriggerInContext.put(speakerObj.getSObjectType().getDescribe().getName(),false);
            }
        }
        return null;
    }
    
    /* Method to Create/Update Attendee object record from Fonteva to Guidebook */
    public static list<EventApi__Attendee__c> sendAttendee(List<String> recordIds){
        try {
            List<EventApi__Attendee__c> attendeeObj = [SELECT Id,Guidebook_Import_Id__c,Attendee_Id__c,Revoked__c,EventApi__First_Name__c,EventApi__Last_Name__c,EventApi__Email__c,EventApi__Preferred_Email__c,Guide__c,(SELECT Id,Registration_Id__c,EventApi__Attendee__c From EventApi__Registration_Items__r WHERE Registration_Id__c = Null) FROM EventApi__Attendee__c WHERE  Id IN : recordIds AND Guide__c !=null];
            List<EventApi__Attendee__c> attendeeList = new List<EventApi__Attendee__c>();	
            List<String> regItemIds = new List<String>();
            if(attendeeObj.Size() > 0){
                for(Integer i=0;i<attendeeObj.size();i++){
                    if(string.isNotBlank(attendeeObj[i].EventApi__Email__c) || string.isNotBlank(attendeeObj[i].EventApi__Preferred_Email__c)){
                        GuidebookAttendee attendee = getAttendeeData(attendeeObj[i]);
                        if(attendeeObj[i].Attendee_Id__c == null)
                        {
                            String endPoint=GUIDEBOOK_URL+'/attendees/';
                            HttpResponse response =IntegrationHelper.makeRequest(attendee,endPoint,'POST');
                            if(response.getStatus()=='Created'){
                                GuidebookAttendee guideAttendee = GuidebookAttendee.parse(response.getBody());
                                attendeeObj[i].Attendee_Id__c = guideAttendee.Id;
                                attendeeList.add(attendeeObj[i]);         
                            }
                        }
                        else {
                            String endPoint=GUIDEBOOK_URL+'/attendees/'+((attendeeObj[i].Attendee_Id__c).round(System.RoundingMode.DOWN))+'/';
                            GuidebookAttendee attendee1 = getAttendeeData(attendeeObj[i]);
                            HttpResponse response =IntegrationHelper.makeRequest(attendee1,endPoint,'PUT');
                            
                            if(attendeeObj[i].EventApi__Registration_Items__r != null && attendeeObj[i].EventApi__Registration_Items__r.Size() > 0){
                                for(EventApi__Registration_Item__c regItem : attendeeObj[i].EventApi__Registration_Items__r){
                                    regItemIds.add(regItem.id);
                                }
                                if(regItemIds.size() > 0){     
                                    GuidebookRestApiController.sendRegistrationItem(regItemIds);
                                } 
                            }  
                        }
                    }
                }
                if(attendeeList.size() > 0){     
                    update attendeeList;
                } 
            }
        }
        catch (Exception e) {
            System.assertEquals(null,e.getStackTraceString());
        }
        
        return null;
    }
    
    
     /* Method to Create/Update Room object record from Fonteva to Guidebook */
    public static list<EventApi__Room__c> sendRoom(List<String> recordIds){
        List<EventApi__Room__c> roomObj= [SELECT Name,Guide__c,Location_Id__c,EventApi__Venue__r.Guidebook_Location_Import_Id__c,EventApi__Venue__r.Guidebook_Location_Latitude__c,EventApi__Venue__r.Guidebook_Location_Longitude__c,EventApi__Venue__r.EventApi__City__c,EventApi__Venue__r.EventApi__State__c,EventApi__Venue__r.EventApi__Street__c,EventApi__Venue__r.EventApi__Country__c,EventApi__Venue__r.EventApi__Postal_Code__c
                                    FROM EventApi__Room__c WHERE Id IN : recordIds and Guide__c != null];
		List<EventApi__Room__c> roomList = new List<EventApi__Room__c>();							
        if(roomObj.size() > 0){
            for(Integer i=0;i<roomObj.size();i++){
            GuidebookRoom gAtt = getRoomData(roomObj[i]);
            if(roomObj[i].Location_Id__c == null)
            { 
                String endPoint=GUIDEBOOK_URL+'/locations/';
                HttpResponse response =IntegrationHelper.makeRequest(gAtt,endPoint,'POST');
                if(response.getStatus()=='Created'){
                    GuidebookRoom obj = GuidebookRoom.parse(response.getBody());
                    roomObj[i].Location_Id__c=obj.id;
					roomList.add(roomObj[i]);
                    
                }
            }
            else {
                String endPoint=GUIDEBOOK_URL+'/locations/'+((roomObj[i].Location_Id__c).round(System.RoundingMode.DOWN))+'/';
                HttpResponse response =IntegrationHelper.makeRequest(gAtt,endPoint,'PUT');
            }
			}
			if(roomList.size() > 0){
			Framework.Dispatcher.disableAfterTriggerInContext.put(roomObj.getSObjectType().getDescribe().getName(),true);       
            update roomList;       
            Framework.Dispatcher.disableAfterTriggerInContext.put(roomObj.getSObjectType().getDescribe().getName(),false);
			}
        }
        return null;
    }
    
     /* Method to Create/Update Venue object record from Fonteva to Guidebook */
    public static list<EventApi__Venue__c> sendVenue(List<String> recordIds){
        List<EventApi__Venue__c> venueObj = [SELECT Name,Guide__c,EventApi__City__c,EventApi__State__c,EventApi__Is_Primary_Venue__c,EventApi__Country__c,EventApi__Street__c,EventApi__Postal_Code__c,Guidebook_Location_Import_Id__c,Guidebook_Location_Latitude__c,Guidebook_Location_Longitude__c,Location_Id__c
                                       FROM EventApi__Venue__c WHERE Id IN : recordIds AND Guide__c != null];
		List<EventApi__Venue__c> venueList = new List<EventApi__Venue__c>();						   
        if(venueObj.size() > 0){
			for(Integer i=0;i<venueObj.size();i++){
            String endpointGetMainVenue = GUIDEBOOK_URL+'/locations/?location_type=1&guide='+venueObj[i].Guide__c;
            Integer mainVenueId ;
            GuidebookVenue gAtt = getVenueData(venueObj[i]);
            GuidebookMainVenue gattMain = getMainVenueData(venueObj[i]);
            if(venueObj[i].Location_Id__c == null){ 
                if(venueObj[i].EventApi__Is_Primary_Venue__c == true){
                    HttpRequest reqMainVenue =  IntegrationHelper.getRequestObject(endpointGetMainVenue,'GET',GUIDEBOOK_PRIVATE_KEY,null);
                    HttpResponse responseMainVenue = IntegrationHelper.GetResponse(reqMainVenue);
                    JSONParser parser = JSON.createParser(responseMainVenue.getBody());
                    while (parser.nextToken() != null) {
                        if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'id')) {
                            parser.nextToken();
                            mainVenueId = parser.getIntegerValue();
                        }
                    }
                    if(venueObj[i].EventApi__Is_Primary_Venue__c == true){
                        String endPointUpdateMainVenue = GUIDEBOOK_URL+'/locations/'+mainVenueId+'/';
                        HttpResponse responseUpdateMainVenue =IntegrationHelper.makeRequest(gattMain,endPointUpdateMainVenue,'PUT');
                        venueObj[i].Location_Id__c = mainVenueId;
                    }
                }
                else{
                    String endPoint = GUIDEBOOK_URL+'/locations/';
                    HttpResponse response =IntegrationHelper.makeRequest(gAtt,endPoint,'POST');
                    if(response.getStatus() == 'Created'){
                        GuidebookVenue obj = GuidebookVenue.parse(response.getBody());
                        venueObj[i].Location_Id__c = obj.id;
						venueList.add(venueObj[i]);
                    }
                }
                
            }
            else {
                if(venueObj[i].EventApi__Is_Primary_Venue__c == true){
                    String endPointUpdateMainVenue = GUIDEBOOK_URL+'/locations/'+((venueObj[i].Location_Id__c).round(System.RoundingMode.DOWN))+'/';
                    HttpResponse responseUpdateMainVenue =IntegrationHelper.makeRequest(gattMain,endPointUpdateMainVenue,'PUT');
                }else{
                    String endPoint=GUIDEBOOK_URL+'/locations/'+((venueObj[i].Location_Id__c).round(System.RoundingMode.DOWN))+'/';
                    HttpResponse response =IntegrationHelper.makeRequest(gAtt,endPoint,'PUT');
                }
            }
        }
		if(venueList.size() > 0){
			Framework.Dispatcher.disableAfterTriggerInContext.put(venueObj.getSObjectType().getDescribe().getName(),true);       
            update venueList;       
            Framework.Dispatcher.disableAfterTriggerInContext.put(venueObj.getSObjectType().getDescribe().getName(),false);
			
		       }
		}
        return null;
    }
        
    /* Method to Create/Update Schedule object record from Fonteva to Guidebook */
    public static list<EventAPI__Schedule_Item__c> sendSession(List<String> recordIds){
        List<EventAPI__Schedule_Item__c>sessionObj = [SELECT Id,EventApi__Room__c,EventApi__Room__r.Location_Id__c,Guide__c,Session_Id__c,Guidebook_Import_Id__c,EventApi__Start_Date_Time__c,EventApi__End_Date_Time__c,EventApi__Disable_Registration__c,Name,EventApi__Description__c
                                                      , (SELECT id ,Registration_Id__c , EventAPI__Schedule_Item__c  FROM EventApi__Registration_Items__r WHERE Registration_Id__c = Null)FROM EventAPI__Schedule_Item__c WHERE Id IN : recordIds AND Guide__c !=null];
        List<EventAPI__Schedule_Item__c> schList = new List<EventAPI__Schedule_Item__c>();	
        List<String> regItemIds = new List<String>();
        if(sessionObj.size() > 0){
            for(Integer i=0;i<sessionObj.size();i++){
                GuidebookSession gAtt = getSessionData(sessionObj[i]);
                if(sessionObj[i].Session_Id__c == null)
                { 
                    String endPoint=GUIDEBOOK_URL+'/sessions/';
                    HttpResponse response = IntegrationHelper.makeRequest(gAtt,endPoint,'POST');
                    if(response.getStatus() == 'Created'){
                        GuidebookSession session = GuidebookSession.parse(response.getBody());
                        sessionObj[i].Session_Id__c = session.id;
                        schList.add(sessionObj[i]);  
                    }
                }
                else {
                    String endPoint=GUIDEBOOK_URL+'/sessions/'+((sessionObj[i].session_Id__c).round(System.RoundingMode.DOWN))+'/';
                    GuidebookSession gAtt1 = getSessionData(sessionObj[i]);
                    HttpResponse response = IntegrationHelper.makeRequest(gAtt1,endPoint,'PUT');
                    
                    if(sessionObj[i].EventApi__Registration_Items__r.Size() > 0){
                        for(EventApi__Registration_Item__c regItem : sessionObj[i].EventApi__Registration_Items__r){
                            regItemIds.add(regItem.id);
                        }
                        if(regItemIds.size() > 0){     
                            GuidebookRestApiController.sendRegistrationItem(regItemIds);
                        } 
                    } 
                }
            }
            if(schList.Size() > 0){     
                update schList;
            } 
        }
        return null;
    }
    
    /* Method to Create/Update Registration object record from Fonteva to Guidebook */
    public static list<EventApi__Registration_Item__c> sendRegistrationItem(List<String> recordIds){
        try {
            List<EventApi__Registration_Item__c> regItemObj = [SELECT Name__c, Registration_Id__c, Guide__c, Schedule_Item_id__c, Attendee_id__c,EventApi__Schedule_Item__r.Name,EventApi__Attendee__r.EventApi__First_Name__c,EventApi__Attendee__r.EventApi__Last_Name__c
                                                               FROM EventApi__Registration_Item__c WHERE Id IN : recordIds AND Guide__c != null And EventApi__Attendee__c != null And EventApi__Schedule_Item__c != null];
            List<EventApi__Registration_Item__c> regItemList = new List<EventApi__Registration_Item__c>();
            if(regItemObj.size() > 0){
                for(Integer i=0;i<regItemObj.size();i++){
                    GuidebookRegistrationItem gAtt= getRegistrationItemData(regItemObj[i]);
                    if(regItemObj[i].Registration_Id__c == null ){ 
                        String endPoint=GUIDEBOOK_URL+'/personalized-schedules/';
                        HttpResponse response =IntegrationHelper.makeRequest(gAtt,endPoint,'POST');
                        if(response.getStatus() =='Created'){
                            GuidebookRegistrationItem  obj = GuidebookRegistrationItem.parse(response.getBody());
                            regItemObj[i].Registration_Id__c = obj.id;
                            regItemList.add(regItemObj[i]);
                            
                        }
                    }
                    else {
                        String endPoint=GUIDEBOOK_URL+'/personalized-schedules/'+((regItemObj[i].Registration_Id__c).round(System.RoundingMode.DOWN))+'/';
                        HttpResponse response =IntegrationHelper.makeRequest(gAtt,endPoint,'PUT');
                    }
                }
            }
            if(regItemList.size() > 0){
                Framework.Dispatcher.disableAfterTriggerInContext.put(regItemObj.getSObjectType().getDescribe().getName(),true);       
                update regItemList;       
                Framework.Dispatcher.disableAfterTriggerInContext.put(regItemObj.getSObjectType().getDescribe().getName(),false);
            }
        }
        catch (Exception e) {
            System.assertEquals(null,e.getStackTraceString());
        }
        return null;
    }
    
    public static list<EventApi__Event__c> updateGuides(Id recordId){
        try {
            EventApi__Event__c guideObj = [SELECT Guide__c,EventApi__Time_Zone__c, EventApi__Start_Date_Time__c, EventApi__Overview_HTML__c,EventApi__End_Date_Time__c,Name FROM EventApi__Event__c WHERE Id =:recordId AND Guide__c != null];
            String endPoint=GUIDEBOOK_URL+'/guides/'+((guideobj.Guide__c).round(System.RoundingMode.DOWN))+'/';
            if(guideObj != null){
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
        }
        
        catch (Exception e) {
            throw e;
        }
        
        return null;
    }
    
    public static void createOrganizations(){
        // User record will we inserted in post installation script which will have private api-key //
        try{
            Organization org = [SELECT Id,Name FROM Organization LIMIT 1];
            GuidebookOrganization gAtt = new GuidebookOrganization();
            gAtt.first_name = org.Name;
            gAtt.description = org.Name;
            String endPoint = GUIDEBOOK_PRIVATE_URL+'/organizations/';
            HttpResponse response = IntegrationHelper.makeRequest(gAtt,endPoint,'POST');
            if(response.getStatus() == 'Created'){
                GuidebookOrganization obj = GuidebookOrganization.parse(response.getBody());
                Guidebook_Setting__c guidebookapiKey = new Guidebook_Setting__c();
                guidebookapiKey.Name = UserInfo.getUserName();
                guidebookapiKey.Organization_ID__c = obj.id;
                insert guidebookapiKey;
            } 
        }catch(Exception e) {
            throw e;
        }
        
    } 
    public static void setupOrganizationGuidebook(){
        try{
            List<Guidebook_Setting__c> guideList = new List<Guidebook_Setting__c>();
            String endPoint = GUIDEBOOK_PRIVATE_URL+'/organizations/';
            HttpRequest req =  IntegrationHelper.getRequestObject(endPoint,'GET',GUIDEBOOK_PRIVATE_KEY,null);
            HttpResponse response = IntegrationHelper.GetResponse(req);
            Reponsevalue wrapper = (Reponsevalue) JSON.deserialize(response.getBody(), Reponsevalue.class);
            if(wrapper.results !=null && wrapper.results.size() > 0){
                Organization org = [SELECT Id,Name FROM Organization LIMIT 1];
                for(results obj : wrapper.results){
                    if(org.Name == obj.first_name){
                        Guidebook_Setting__c guidebookapiKey = new Guidebook_Setting__c();
                        guidebookapiKey.Name = UserInfo.getUserName();
                        guidebookapiKey.Organization_ID__c = Decimal.valueOf(obj.id);
                        guideList.add(guidebookapiKey);
                    }
                }
                if(guideList.Size() > 0){
                    insert guideList;
                }
                else{
                    GuidebookRestApiController.createOrganizations();
                }
            }
        }
        catch(Exception e) {
            throw e;
        }
    }
    
    @future (callout=true)
    public static void customListItemResponse(List<String> recordIds){
        List<EventApi__Speaker__c>  speakerList = [select Guide__c,allow_rating__c,Disable_Todo__c,Name,Import_Id__c,Speaker_Id__c,Custom_List_Item_Id__c,EventApi__Event__c,EventApi__Event__r.Custom_List_Id__c
                                                   from EventApi__Speaker__c where Id IN : recordIds AND Guide__c != null];
        if(speakerList.Size() > 0){
            for(EventApi__Speaker__c speakerObj : speakerList){
                String endPointCustomRes = GUIDEBOOK_URL +'/custom-list-item-relations/';
                GuidebookCustomListItemRelation customRes = getCustomRelation(speakerObj);
                HttpResponse customResponse = IntegrationHelper.makeRequest(customRes, endPointCustomRes, 'POST'); 
            }
        }
    }
  
}