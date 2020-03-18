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
global without sharing class Attendees extends Framework.Domain {
    public Attendees (List<EventApi__Attendee__c> sObjectList) {
        super(sObjectList);
    }
    global class Constructor implements Framework.Domain.DomainConstructor  {
        global Framework.Domain construct(List<SObject> sObjectList) {
            return new Attendees(sObjectList);
        }
    }
    
    String[] errors = new List<String>();
    public override void afterInsert() {
        Framework.Log.push(Attendees.class.getName(),'afterInsert');
        
        try {
            List<String> recordsIds = new List<String>();
            for (EventApi__Attendee__c sItem : (EventApi__Attendee__c[])records) {
                if(sItem.Guide__c != null){
                    recordsIds.add(sItem.Id);
                }
            }
            if (recordsIds.size() > 0) {
                System.enqueueJob(new QueueableGuidebook('Attendee',recordsIds));
            }
            Framework.Log.pop();
        }
        catch (Exception e) {
            errors.add(e.getMessage());
            errors.add(e.getStackTraceString());
            Framework.Log.debugException(e);
            Framework.Message.addMessage(e,Framework.Message.Severity.Danger);
        }
        finally
        {
            Framework.Log.popAll();
        }
    }
    public override void afterUpdate(Map<Id,SObject> oldMap){
        Framework.Log.push(Attendees.class.getName(),'afterUpdate');
        List<String> AttendeeId = new List<String>();
        try {
            for(EventApi__Attendee__c sItem : (EventApi__Attendee__c[])records) {
                EventApi__Attendee__c Attendeeold = (EventApi__Attendee__c)oldMap.get(sItem.Id);
                if(sItem.Guide__c != null && (Attendeeold.id == sItem.id) && (Attendeeold.Name != sItem.name || Attendeeold.EventApi__First_Name__c != sItem.EventApi__First_Name__c 
                                                                              || Attendeeold.EventApi__Last_Name__c != sItem.EventApi__Last_Name__c 
                                                                              || Attendeeold.Attendee_Id__c != sItem.Attendee_Id__c 
                                                                              || Attendeeold.EventApi__Email__c != sItem.EventApi__Email__c 
                                                                              || Attendeeold.EventApi__Preferred_Email__c != sItem.EventApi__Preferred_Email__c 
                                                                              || Attendeeold.Guidebook_Import_Id__c != sItem.Guidebook_Import_Id__c)) {   
                                                                                  AttendeeId.add(sItem.id);
                                                                              }
            }
            if (AttendeeId.size() > 0) {
                System.enqueueJob(new QueueableGuidebook('Attendee',AttendeeId));
            }
            Framework.Log.pop();
        }
        catch (Exception e) {
            errors.add(e.getMessage());
            errors.add(e.getStackTraceString());
            Framework.Log.debugException(e);
            Framework.Message.addMessage(e,Framework.Message.Severity.Danger);
        }
        finally
        {
            Framework.Log.popAll();
        }
    }
}