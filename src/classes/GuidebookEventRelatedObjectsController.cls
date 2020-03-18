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
public class GuidebookEventRelatedObjectsController {
    public Static void EventRelatedObjects(string EventId){
        
        List<String> venueList = new List<String>();
        for(EventApi__Venue__c venue : [SELECT Id ,Location_Id__c,EventApi__Event__c FROM EventApi__Venue__c WHERE EventApi__Event__c =: EventId AND Location_Id__c = null] ){
            venueList.add(venue.Id);
        }
        if(venueList.Size() > 0){
            System.enqueueJob(new QueueableGuidebook('Venue' , venueList));
        } 
        
        List<String> schList = new List<String>();
        for(EventAPI__Schedule_Item__c schedule : [SELECT Id ,EventApi__Event__c,Session_Id__c FROM EventAPI__Schedule_Item__c WHERE EventApi__Event__c =: EventId AND Session_Id__c = null] ){
            schList.add(schedule.id);
        }
        if(schList.Size() > 0){
            System.enqueueJob(new QueueableGuidebook('ScheuleItem' , schList));
        }
        
        List<String> attendeeList = new List<String>();
        for(EventApi__Attendee__c attendee : [SELECT Id ,EventApi__Event__c,Attendee_Id__c FROM EventApi__Attendee__c WHERE EventApi__Event__c =: EventId AND Attendee_Id__c = null] ){
            attendeeList.add(attendee.Id);
        } 
        if(attendeeList.size() > 0) {
            System.enqueueJob(new QueueableGuidebook('Attendee',attendeeList));
        }
        
        List<String> roomList = new List<String>();
        for(EventApi__Room__c room : [SELECT Id ,Location_Id__c,EventApi__Event__c FROM EventApi__Room__c WHERE EventApi__Event__c =: EventId AND Location_Id__c = null] ){
            roomList.add(room.Id);
        }
        if(roomList.Size() > 0){
            System.enqueueJob(new QueueableGuidebook('Room', roomList));
        }
        
        List<String> spkList = new List<String>();
        for(EventApi__Speaker__c speaker : [SELECT Id ,EventApi__Event__c,Speaker_Id__c FROM EventApi__Speaker__c WHERE EventApi__Event__c =: EventId AND Speaker_Id__c = null] ){
            spkList.add(speaker.Id);
        }
        if(spkList.Size() > 0){
            System.enqueueJob(new QueueableGuidebook('Speaker', spkList));
        }
        
        List<String> trackList = new List<String>();
        for(EventApi__Track__c track : [SELECT Id ,EventApi__Event__c,Schedule_Track_Id__c FROM EventApi__Track__c WHERE EventApi__Event__c =: EventId AND Schedule_Track_Id__c = null] ){
            trackList.add(track.Id);
        }
        if(spkList.Size() > 0){
            System.enqueueJob(new QueueableGuidebook('Track', trackList));
        }
    }
}