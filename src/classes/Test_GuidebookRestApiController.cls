/*
* @author Hirdesh 
* @Date   22 May 2019
* @purpose This class will be used to cover TestCoverage of GuidebookRestApiController   
*/

@isTest
private class Test_GuidebookRestApiController{
    @testSetup static void setup() {
        // Create common test Event
        
        
        EventApi__Event__c event = new EventApi__Event__c();
        event.Name = 'MyEvent';
        event.Guide__c = 100976;
        event.EventApi__Description__c = 'Event Description';
        event.EventApi__Start_Date__c = system.today().addDays(2);
        event.EventApi__End_Date__c = system.today().addDays(3);
        event.EventApi__Event_Key__c = 'Event Key';
        event.EventApi__Overview_HTML__c ='Event Description';
        insert event;
        
        EventAPI__Schedule_Item__c sessionObj = new EventAPI__Schedule_Item__c();
        sessionObj.Name = 'MySession';
        sessionObj.EventApi__Event__c = event.id;    
        sessionObj.EventApi__Description__c = 'Session Description';
        sessionObj.Guidebook_Import_Id__c = 'SessionImportId';
        sessionObj.EventApi__Disable_Registration__c = true;
        sessionObj.EventApi__Start_Date_Time__c = event.EventApi__Start_Date__c;
        sessionObj.EventApi__End_Date_Time__c = event.EventApi__End_Date__c;
        insert sessionObj;
        
        EventApi__Track__c trackObj = new EventApi__Track__c();
        trackObj.Name = 'MyTrack';
        trackObj.EventApi__Event__c = event.Id;
        trackObj.EventApi__Track_Color__c = '#A85546';
        insert trackObj;
        
        EventApi__Attendee__c attendeeObj = new EventApi__Attendee__c();
        attendeeObj.EventApi__First_Name__c = 'MyFirstName';
        attendeeObj.EventApi__Last_Name__c = 'MyLastName';
        attendeeObj.EventApi__Event__c = event.id;
        attendeeObj.Revoked__c = true;
        attendeeObj.Guidebook_Import_Id__c = 'AttendeeImportId';
        attendeeObj.EventApi__Email__c = 'attendee@unique.com';
        attendeeObj.EventApi__Preferred_Email__c = 'attendee@unique.com';
        insert attendeeObj;
        
        EventApi__Speaker__c speakerObj = new EventApi__Speaker__c();
        speakerObj.Name = 'MySpeaker';
        speakerObj.Disable_Todo__c = true;
        speakerObj.allow_rating__c = true;
        speakerObj.Import_Id__c = 'SpeakerImportId';
        speakerObj.EventApi__Event__c = event.Id;
        insert speakerObj;
        
        EventApi__Registration_Item__c regItemObj = new EventApi__Registration_Item__c();
        regItemObj.Name__c = 'MyRegistrationItem';
        regItemObj.EventApi__Attendee__c = attendeeObj.id;
        regItemObj.EventApi__Schedule_Item__c = sessionObj.id;
        insert regItemObj;
        
        EventApi__Venue__c venueObj = new EventApi__Venue__c();
        venueObj.Guidebook_Location_Import_Id__c = 'LoacationImportId';
        venueObj.name = 'MyLocation' ;
        venueObj.Guidebook_Location_Latitude__c = 10.1251;
        venueObj.Guidebook_Location_Longitude__c = 10.8751;
        venueObj.EventApi__Event__c = event.id;
        venueObj.EventApi__City__c = 'Noida';
        venueObj.EventApi__Country__c = 'india';
        venueObj.EventApi__State__c = 'UP';
        venueObj.EventApi__Postal_Code__c ='111111';
        venueObj.EventApi__Street__c = 'TechZone';
        insert venueObj;
        
        EventApi__Venue__c venueObj1 = new EventApi__Venue__c();
        venueObj1.Guidebook_Location_Import_Id__c = 'LoacationImportId';
        venueObj1.name = 'MyLocation1' ;
        venueObj1.Guidebook_Location_Latitude__c = 10.1251;
        venueObj1.Guidebook_Location_Longitude__c = 10.8751;
        venueObj1.EventApi__Event__c = event.id;
        venueObj1.EventApi__City__c = 'Noida';
        venueObj1.EventApi__Country__c = 'india';
        venueObj1.EventApi__State__c = 'UP';
        venueObj1.EventApi__Is_Primary_Venue__c = true;
        venueObj1.EventApi__Postal_Code__c ='111111';
        venueObj1.EventApi__Street__c = 'TechZone';
        insert venueObj1;
        
        EventApi__Room__c roomObj = new EventApi__Room__c();
        roomObj.name = 'MyLocation' ;
        roomObj.EventApi__Event__c = event.id;
        roomObj.EventApi__Venue__c = venueObj.id;
        insert roomObj;
        
        Guidebook_Setting__c guide = new Guidebook_Setting__c();
        guide.Name = UserInfo.getUserName();
        guide.Api_Key__c = 'JWT '+'Test';
        insert guide;
        
        event.EventApi__Description__c = 'Event Description Updated';
        Update event;
        sessionObj.Session_Id__c = 2578965;
        update sessionObj;
        
        trackObj.Schedule_Track_Id__c = 4561552;
        update trackObj;
        
        attendeeObj.Attendee_Id__c = 165156;
        update attendeeObj;
        
        speakerObj.Speaker_Id__c = 561561;
        update speakerObj;
        
        roomObj.Location_Id__c = 64542;
        update roomObj;
        
        venueObj.Location_Id__c = 64542;
        update venueObj;
        
        regItemObj.Registration_Id__c = 120303;
        update regItemObj;
    }
    @isTest
    static void guidebookRestApiControllerPutTestMethod(){
        Test.StartTest();
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        List<EventApi__Event__c> eventobj = [select id , name ,EventApi__Time_Zone__c,EventApi__End_Date_Time__c,EventApi__Start_Date_Time__c, Guide__c,EventApi__Overview_HTML__c,EventApi__Start_Date__c,EventApi__Description__c,EventApi__End_Date__c from EventApi__Event__c where name = 'MyEvent' limit 1]; 
        Events events = new Events(eventobj);
        Map<Id,SObject>  EventMap= new Map<Id,SObject>();
        EventMap.put(eventobj[0].id, eventobj[0]);
        events.afterUpdate(EventMap);
        events.Constructor obnasd=new events.Constructor();
        obnasd.construct(eventobj);
        GuidebookRestApiController.updateGuides(eventobj[0].id);
        
        List<EventAPI__Schedule_Item__c> sessionObj = [select id, Name ,EventApi__Room__r.Location_Id__c,EventApi__Session_Start_Time__c,EventApi__Session_End_Time__c,EventApi__Start_Date__c,EventApi__End_Date__c,Guide__c,Guidebook_Import_Id__c,EventApi__End_Date_Time__c,EventApi__Disable_Registration__c,EventApi__Start_Date_Time__c,EventApi__Event__c,EventApi__Description__c,Session_Id__c  from EventAPI__Schedule_Item__c where Name = 'MySession' limit 1];
        ScheduleItems vSchedule = new ScheduleItems(sessionObj);
        Map<Id,SObject>  ScheduleMap= new Map<Id,SObject>();
        ScheduleMap.put(sessionObj[0].id, sessionObj[0]);
        vSchedule.afterUpdate(ScheduleMap);
        
        GuidebookRestApiController.sendSession(new List<String>{sessionObj[0].Id});
        
        List<EventApi__Room__c> roomObj = [select id , Name ,Location_Id__c,EventApi__Event__c,EventApi__Venue__c,EventApi__Venue__r.EventApi__City__c,EventApi__Venue__r.EventApi__Country__c,EventApi__Venue__r.EventApi__State__c,EventApi__Venue__r.EventApi__Street__c,EventApi__Venue__r.EventApi__Postal_Code__c,EventApi__Venue__r.Guidebook_Location_Import_Id__c,EventApi__Venue__r.Guidebook_Location_Latitude__c,EventApi__Venue__r.Guidebook_Location_Longitude__c,Guide__c from EventApi__Room__c where Name = 'MyLocation' limit 1];
        Rooms rooms = new Rooms(roomObj);
        roomObj[0].Name = 'My Location Updated';
        Map<Id,SObject> roomMap= new Map<Id,SObject>();
        roomMap.put(roomObj[0].id, roomObj[0]);
        rooms.afterUpdate(roomMap);
        
        GuidebookRestApiController.sendRoom(new List<String>{roomObj[0].id});
        
        List<EventApi__Venue__c> venuObj = [select id , Name ,Location_Id__c,EventApi__City__c,EventApi__Country__c,EventApi__State__c,EventApi__Street__c, EventApi__Postal_Code__c,Guidebook_Location_Import_Id__c,Guidebook_Location_Latitude__c,Guidebook_Location_Longitude__c,EventApi__Event__c,Guide__c from EventApi__venue__c where Name = 'MyLocation' limit 1];
        Venues venue = new Venues(venuObj);
        Map<Id,SObject> venueMap= new Map<Id,SObject>();
        venueMap.put(venuObj[0].id, venuObj[0]);
        venue.afterUpdate(venueMap);
        
        GuidebookRestApiController.sendVenue(new List<String>{venuObj[0].id});
        
        List<EventApi__Registration_Item__c> regItemObj = [select id ,Name,Registration_Id__c,Name__c,Guide__c,EventApi__Attendee__r.Attendee_Id__c, EventApi__Attendee__r.Guide__c , EventApi__Schedule_Item__c , EventApi__Schedule_Item__r.Guide__c,EventApi__Schedule_Item__r.Session_Id__c,Attendee_id__c,Schedule_Item_id__c From EventApi__Registration_Item__c where Name__c ='MyRegistrationItem' Limit 1];
        RegistrationItems regItem = new RegistrationItems(regItemObj);
        Map<Id,SObject> regItemMap= new Map<Id,SObject>();
        regItemMap.put(regItemObj[0].id, regItemObj[0]);
        regItem.afterUpdate(regItemMap);
        
        GuidebookRestApiController.sendRegistrationItem(new List<String>{regItemObj[0].id});
        
        List<EventApi__Track__c> trackObj = [select id, Schedule_Track_Id__c,Name, EventApi__Event__c ,EventApi__Track_Color__c ,Guide__c from EventApi__Track__c where Name = 'MyTrack' limit 1];
        Tracks tracks = new Tracks(trackObj);
        Map<Id,SObject> trackObjMap= new Map<Id,SObject>();
        trackObjMap.put(trackObj[0].id, trackObj[0]);
        tracks.afterUpdate(trackObjMap);
        
        GuidebookRestApiController.sendTrack(new List<String>{trackObj[0].id});
        
        
        List<EventApi__Speaker__c> speakerObj = [select id , Name ,Speaker_Id__c,EventApi__Event__r.Custom_List_Id__c, Disable_Todo__c,allow_rating__c,Import_Id__c,EventApi__Event__c ,Guide__c from EventApi__Speaker__c where Name = 'MySpeaker' limit 1];
        Speakers speakers = new Speakers(speakerObj);
        Map<Id,SObject> speakerObjMap= new Map<Id,SObject>();
        speakerObjMap.put(speakerObj[0].id, speakerObj[0]);
        speakers.afterUpdate(speakerObjMap);
        List<String> speakerList = new List<String>();
        speakerList.add(speakerObj[0].id);
      
        List<EventApi__Attendee__c> attendeeObj = [select id ,Name,Attendee_Id__c,EventApi__Preferred_Email__c,Revoked__c,EventApi__First_Name__c,EventApi__Last_Name__c, EventApi__Event__c,Guidebook_Import_Id__c,EventApi__Email__c ,Guide__c from EventApi__Attendee__c where EventApi__Email__c ='attendee@unique.com' limit 1];
        Attendees attendees = new Attendees(attendeeObj);
        Map<Id,SObject> attendeeObjMap= new Map<Id,SObject>();
        attendeeObjMap.put(attendeeObj[0].id, attendeeObj[0]);
        attendees.afterUpdate(attendeeObjMap);
        
      
        
        try{GuidebookRestApiController.getRegistrationItem(eventobj[0].Guide__c);}catch(exception e){}
        GuidebookSpeaker gs = new GuidebookSpeaker();
        GuidebookRestApiController.getMenuItemData(gs);
        GuidebookRestApiController.getcustomrelation(speakerObj[0]);
        Test.StopTest();
        
    }
    @isTest
    static void guidebookCommonTestMethod(){
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        string json = '{"example":"test"}';
        GuidebookSession.parse(json);
        GuidebookRoom.parse(json);
        GuidebookAttendee.parse(json);
        GuidebookSpeaker.parse(json);
        GuidebookRegistrationItem.parse(json);
        GuidebookSpeaker.parse(json);
        GuidebookGuide.parse(json);
        GuidebookTrack.parse(json);
        GuidebookVenue.parse(json);
        GuidebookOrganization.parse(json);
        GuidebookInvitation.parse(json);
        GuidebookProvisionProduct.parse(json);
        GuidebookMainVenue.parse(json);
        GuidebookMenuItem.parse(json);
        GuidebookCustomListItem.parse(json);
        GuidebookCustomListItemRelation.parse(json);
        Test.stopTest();
    }
    @istest
    static void getTrackDataTestMethod(){
        
        EventApi__Event__c event = [select id , name ,EventApi__Time_Zone__c,EventApi__End_Date_Time__c,EventApi__Start_Date_Time__c, Guide__c,EventApi__Overview_HTML__c,EventApi__Start_Date__c,EventApi__Description__c,EventApi__End_Date__c from EventApi__Event__c where name = 'MyEvent' limit 1]; 
        
        EventApi__Track__c track = new EventApi__Track__c();
        track.Name = 'MyTrack1';
        track.EventApi__Event__c = event.Id;
        track.EventApi__Track_Color__c = '#A85546';
        insert track;
        
        GuidebookTrack trackobj = GuidebookRestApiController.getTrackData(track);
        System.assertEquals(trackobj.color, '#A85546');
        
        EventApi__Track__c track1 = new EventApi__Track__c();
        track1.Name = 'MyTrack1';
        track1.EventApi__Event__c = event.Id;
        track1.EventApi__Track_Color__c = '#A85';
        insert track1;
        
        GuidebookTrack trackobj1 = GuidebookRestApiController.getTrackData(track1);
        System.assertEquals(trackobj1.color, null);
    }
    
    @isTest
    static void guidebookCommonTestMethod1(){
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        GuidebookRestApiController.createOrganizations();
        try{GuidebookRestApiController.setupOrganizationGuidebook();}catch(exception e){}
        Test.StopTest();
    } 
    @isTest
    static void guidebookRestApiControllerPutTestMethodNew(){
        Test.StartTest();
        
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        List<EventApi__Event__c> eventobj = [select id  ,EventApi__Time_Zone__c,EventApi__Start_Date_Time__c, Guide__c,EventApi__Overview_HTML__c,EventApi__Start_Date__c,EventApi__Description__c,EventApi__End_Date__c from EventApi__Event__c where name = 'MyEvent' limit 1]; 
        Events events = new Events(eventobj);
        Map<Id,SObject>  EventMap= new Map<Id,SObject>();
        EventMap.put(eventobj[0].id, eventobj[0]);
        events.afterUpdate(EventMap);
        
        List<EventAPI__Schedule_Item__c> sessionObj = [select id ,EventApi__Room__r.Location_Id__c,EventApi__Session_Start_Time__c,EventApi__Session_End_Time__c,EventApi__Start_Date__c,EventApi__End_Date__c,Guide__c,Guidebook_Import_Id__c,EventApi__End_Date_Time__c,EventApi__Disable_Registration__c,EventApi__Start_Date_Time__c,EventApi__Event__c,EventApi__Description__c,Session_Id__c  from EventAPI__Schedule_Item__c where Name = 'MySession' limit 1];
        ScheduleItems vSchedule = new ScheduleItems(sessionObj);
        Map<Id,SObject>  ScheduleMap= new Map<Id,SObject>();
        ScheduleMap.put(sessionObj[0].id, sessionObj[0]);
        vSchedule.afterUpdate(ScheduleMap);
        
        List<EventApi__Room__c> roomObj = [select id  ,Location_Id__c,EventApi__Event__c,EventApi__Venue__r.EventApi__City__c,EventApi__Venue__r.EventApi__Country__c,EventApi__Venue__r.EventApi__State__c,EventApi__Venue__r.EventApi__Street__c,EventApi__Venue__r.EventApi__Postal_Code__c,EventApi__Venue__r.Guidebook_Location_Import_Id__c,EventApi__Venue__r.Guidebook_Location_Latitude__c,EventApi__Venue__r.Guidebook_Location_Longitude__c,Guide__c from EventApi__Room__c where Name = 'MyLocation' limit 1];
        Rooms rooms = new Rooms(roomObj);
        Map<Id,SObject> roomMap= new Map<Id,SObject>();
        roomMap.put(roomObj[0].id, roomObj[0]);
        rooms.afterUpdate(roomMap);
        
        List<EventApi__Venue__c> venuObj = [select id  ,Location_Id__c,EventApi__City__c,EventApi__Country__c,EventApi__State__c,EventApi__Street__c, EventApi__Postal_Code__c,Guidebook_Location_Import_Id__c,Guidebook_Location_Latitude__c,Guidebook_Location_Longitude__c,EventApi__Event__c,Guide__c from EventApi__venue__c where Name = 'MyLocation' limit 1];
        Venues venue = new Venues(venuObj);
        Map<Id,SObject> venueMap= new Map<Id,SObject>();
        venueMap.put(venuObj[0].id, venuObj[0]);
        venue.afterUpdate(venueMap);
        
        List<EventApi__Registration_Item__c> regItemObj = [select id ,Name,Registration_Id__c,Guide__c,EventApi__Attendee__r.Attendee_Id__c, EventApi__Attendee__r.Guide__c , EventApi__Schedule_Item__c , EventApi__Schedule_Item__r.Guide__c,EventApi__Schedule_Item__r.Session_Id__c,Attendee_id__c,Schedule_Item_id__c From EventApi__Registration_Item__c where Name__c ='MyRegistrationItem' Limit 1];
        RegistrationItems regItem = new RegistrationItems(regItemObj);
        Map<Id,SObject> regItemMap= new Map<Id,SObject>();
        regItemMap.put(regItemObj[0].id, regItemObj[0]);
        regItem.afterUpdate(regItemMap);
        
        
        List<EventApi__Track__c> trackObj = [select id, Schedule_Track_Id__c,Name, EventApi__Event__c  ,Guide__c from EventApi__Track__c where Name = 'MyTrack' limit 1];
        Tracks tracks = new Tracks(trackObj);
        Map<Id,SObject> trackObjMap= new Map<Id,SObject>();
        trackObjMap.put(trackObj[0].id, trackObj[0]);
        tracks.afterUpdate(trackObjMap);
        
        
        List<EventApi__Speaker__c> speakerObj = [select id , Name ,Speaker_Id__c, Disable_Todo__c,Import_Id__c,EventApi__Event__c ,Guide__c from EventApi__Speaker__c where Name = 'MySpeaker' limit 1];
        Speakers speakers = new Speakers(speakerObj);
        Map<Id,SObject> speakerObjMap= new Map<Id,SObject>();
        speakerObjMap.put(speakerObj[0].id, speakerObj[0]);
        speakers.afterUpdate(speakerObjMap);
        
        List<EventApi__Attendee__c> attendeeObj = [select id ,Name,Attendee_Id__c,EventApi__Preferred_Email__c,Revoked__c,EventApi__Last_Name__c, EventApi__Event__c,Guidebook_Import_Id__c,EventApi__Email__c ,Guide__c from EventApi__Attendee__c where EventApi__Email__c ='attendee@unique.com' limit 1];
        Attendees attendees = new Attendees(attendeeObj);
        Map<Id,SObject> attendeeObjMap= new Map<Id,SObject>();
        attendeeObjMap.put(attendeeObj[0].id, attendeeObj[0]);
        attendees.afterUpdate(attendeeObjMap);
        
        Test.StopTest();
        
    }    
}