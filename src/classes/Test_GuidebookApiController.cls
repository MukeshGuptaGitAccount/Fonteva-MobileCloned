/*
* @author Hirdesh 
* @Date   23 May 2019
* @purpose This class will be used to cover TestCoverage of GuidebookApiController   
*/
@isTest
private class Test_GuidebookApiController {
    @testSetup static void setup() {
        // Create common test Event
        
        EventApi__Event__c event = new EventApi__Event__c();
        event.Name = 'MyEvent';
        event.Guide__c = 100976;
        event.EventApi__Description__c = 'Event Description';
        event.EventApi__Overview_HTML__c = 'Event Description';
        event.EventApi__Start_Date__c = system.today().addDays(2);
        event.EventApi__End_Date__c = system.today().addDays(3);
        event.EventApi__Event_Key__c = 'Event Key New';
        insert event;
        
        
        EventApi__Venue__c venueObj = new EventApi__Venue__c();
        venueObj.Guidebook_Location_Import_Id__c = 'LoacationImportId';
        venueObj.name = 'MyLocation' ;
        venueObj.Guidebook_Location_Latitude__c = 10.1251;
        venueObj.Guidebook_Location_Longitude__c = 10.8751;
        venueObj.EventApi__Event__c = event.id;
        venueObj.EventApi__City__c = 'Noida';
        venueObj.EventApi__Country__c = 'india';
        venueObj.EventApi__State__c = 'UP';
        venueObj.EventApi__Is_Primary_Venue__c = true;
        venueObj.EventApi__Postal_Code__c ='111111';
        venueObj.EventApi__Street__c = 'TechZone';
        insert venueObj;
        
        EventApi__Room__c roomObj = new EventApi__Room__c();
        roomObj.name = 'MyLocation' ;
        roomObj.EventApi__Event__c = event.id;
        roomObj.EventApi__Venue__c = venueObj.id;
        insert roomObj;
        
        EventAPI__Schedule_Item__c sessionObj = new EventAPI__Schedule_Item__c();
        sessionObj.Name = 'MySession';
        sessionObj.EventApi__Event__c = event.id;    
        sessionObj.EventApi__Description__c = 'Session Description';
        sessionObj.Guidebook_Import_Id__c = 'SessionImportId';
        sessionObj.EventApi__Disable_Registration__c = true;
        sessionObj.EventApi__Start_Date_Time__c = event.EventApi__Start_Date__c;
        sessionObj.EventApi__End_Date_Time__c = event.EventApi__End_Date__c;
        sessionObj.EventApi__Room__c = roomObj.id;
        insert sessionObj;
        
        EventApi__Track__c trackObj = new EventApi__Track__c();
        trackObj.Name = 'MyTrack';
        trackObj.EventApi__Event__c = event.Id;
        trackObj.EventApi__Track_Color__c = '#333351';
        insert trackObj;
        
        EventApi__Track_Schedule_Item__c scheduleTrack = new EventApi__Track_Schedule_Item__c();
        scheduleTrack.EventApi__Schedule_Item__c = sessionObj.Id;
        scheduleTrack.EventApi__Track__c =trackObj.Id;
        insert scheduleTrack;
        
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
        
        Guidebook_Setting__c guide = new Guidebook_Setting__c();
        guide.Name = UserInfo.getUserName();
        guide.Api_Key__c = 'JWT '+'Test';
        guide.Organization_ID__c=123456798;
        insert guide;
        
        
    }
    @isTest
    static void guidebookApiControllerTestMethod(){
        Test.startTest();
        EventApi__Event__c event = [select id , name , Guide__c,EventApi__Start_Date__c,EventApi__Description__c,EventApi__End_Date__c from EventApi__Event__c where name = 'MyEvent' limit 1]; 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        GuidebookApiController.SyncData(event.Id, event.Guide__c);
        GuidebookApiController.getEvent(event.Id);
        GuidebookEventRelatedObjectsController.EventRelatedObjects(event.id);
        Test.stopTest();
    }
    @isTest
    static void testMethodGetGuides(){
        Test.startTest();
        EventApi__Event__c event = [select id , name , Guide__c,EventApi__Start_Date__c,EventApi__Description__c,EventApi__End_Date__c from EventApi__Event__c where name = 'MyEvent' limit 1]; 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        try{GuidebookApiController.getGuides();}catch(exception e){}
        GuidebookApiController.SyncOrgGuides(event.Id, event.Guide__c);
        try{GuidebookApiController.sendInvitation('TestFirstname','TestLastName','TestLastName@unquie.com');}catch(Exception e){}
        try{GuidebookApiController.createGuide(event.Id);}catch(Exception e){}
        
        Test.stopTest();
    }
    
    
    @isTest
    static void guidebookRestApiControllerPostTestMethod(){
        Test.StartTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        
        List<EventAPI__Schedule_Item__c> sessionObj = [select id, Name ,EventApi__Room__r.Location_Id__c,Guide__c,Guidebook_Import_Id__c,EventApi__End_Date_Time__c,EventApi__Disable_Registration__c,EventApi__Start_Date_Time__c,EventApi__Event__c,EventApi__Description__c,Session_Id__c  from EventAPI__Schedule_Item__c where Name = 'MySession' limit 1];
        ScheduleItems Schedules = new ScheduleItems(sessionObj);
        Schedules.afterInsert();
        ScheduleItems.Constructor obSchedules=new ScheduleItems.Constructor();
        obSchedules.construct(sessionObj);
        
        List<EventApi__Room__c> roomObj = [select id , Name ,Location_Id__c,EventApi__Event__c,EventApi__Venue__c,EventApi__Venue__r.Location_Id__c,EventApi__Venue__r.EventApi__City__c,EventApi__Venue__r.EventApi__Country__c,EventApi__Venue__r.EventApi__State__c,EventApi__Venue__r.EventApi__Street__c,EventApi__Venue__r.EventApi__Postal_Code__c,EventApi__Venue__r.Guidebook_Location_Import_Id__c,EventApi__Venue__r.Guidebook_Location_Latitude__c,EventApi__Venue__r.Guidebook_Location_Longitude__c,Guide__c from EventApi__Room__c where Name = 'MyLocation' limit 1];
        Rooms rooms = new Rooms(roomObj);
        rooms.afterInsert();
        rooms.Constructor obrooms=new rooms.Constructor();
        obrooms.construct(roomObj);
        
        List<EventApi__Venue__c> venueObj = [select id ,EventApi__Is_Primary_Venue__c, Name ,Location_Id__c,EventApi__City__c,EventApi__Country__c,EventApi__State__c,EventApi__Street__c, EventApi__Postal_Code__c,Guidebook_Location_Import_Id__c,Guidebook_Location_Latitude__c,Guidebook_Location_Longitude__c,EventApi__Event__c,Guide__c from EventApi__venue__c where Name = 'MyLocation' limit 1];
        Venues venues = new Venues(venueObj);
        venues.afterInsert();
        venues.Constructor obvenues=new venues.Constructor();
        obvenues.construct(venueObj);
        
        List<EventApi__Registration_Item__c> regItemObj = [select id ,Registration_Id__c,Name__c,Guide__c,EventApi__Attendee__r.Attendee_Id__c, EventApi__Attendee__r.Guide__c , EventApi__Schedule_Item__c , EventApi__Schedule_Item__r.Guide__c,EventApi__Schedule_Item__r.Session_Id__c,Attendee_id__c,Schedule_Item_id__c From EventApi__Registration_Item__c where Name__c ='MyRegistrationItem' Limit 1];
        RegistrationItems regItem = new RegistrationItems(regItemObj);
        regItem.afterInsert();
        RegistrationItems.Constructor obregItem=new RegistrationItems.Constructor();
        obregItem.construct(regItemObj);
   
        List<EventApi__Track__c> trackObj = [select id, Schedule_Track_Id__c,Name, EventApi__Event__c ,EventApi__Track_Color__c ,Guide__c from EventApi__Track__c where Name = 'MyTrack' limit 1];
        Tracks tracks= new Tracks(trackObj);
        tracks.afterInsert();
        tracks.Constructor obnasd=new tracks.Constructor();
        obnasd.construct(trackObj);
        
        List<EventApi__Attendee__c> attendeeObj = [select id ,Attendee_Id__c,Revoked__c,EventApi__First_Name__c,EventApi__Last_Name__c, EventApi__Event__c,Guidebook_Import_Id__c,EventApi__Preferred_Email__c,EventApi__Email__c ,Guide__c from EventApi__Attendee__c where EventApi__Email__c ='attendee@unique.com' limit 1];
        Attendees attendees= new Attendees(attendeeObj);
        attendees.afterInsert();
        attendees.Constructor obattendees=new attendees.Constructor();
        obattendees.construct(attendeeObj);
        
        List<EventApi__Speaker__c> speakerObj = [select id , Name ,Speaker_Id__c, Disable_Todo__c,allow_rating__c,Import_Id__c,EventApi__Event__c ,Guide__c from EventApi__Speaker__c where Name = 'MySpeaker' limit 1];
        Speakers speakers= new Speakers(speakerObj);
        speakers.afterInsert();
        speakers.Constructor obspeakers=new speakers.Constructor();
        obspeakers.construct(speakerObj);
        
        Test.StopTest();
        
    }
    
    @isTest
    public static void testMethodpackageScripts(){
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        PackageScripts.install();
        PackageScripts.CreateOrganizationGuidebook obj=new PackageScripts.CreateOrganizationGuidebook();
        obj.run();
    }
    @isTest
    public static void testMethodLabels(){
        Labels.getLabels();
    }

    @isTest
    static void testMethodApiKey(){
        Test.startTest();
        EventApi__Event__c event = [select id , name , Guide__c,EventApi__Start_Date__c,EventApi__Description__c,EventApi__End_Date__c from EventApi__Event__c where name = 'MyEvent' limit 1]; 
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        GuidebookApiController.getApiKeyName();
        GuidebookApiController.setMetaData('test');
        Test.stopTest();
    }
}