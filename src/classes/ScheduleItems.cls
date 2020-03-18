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
global without sharing class ScheduleItems extends Framework.Domain{
    public ScheduleItems (List<EventAPI__Schedule_Item__c> sObjectList) {
        super(sObjectList);
    }
    
    global class Constructor implements Framework.Domain.DomainConstructor  {
        global Framework.Domain construct(List<SObject> sObjectList) {
            return new ScheduleItems(sObjectList);
        }
    }
    public override void afterInsert() {
        List<String> schList = new List<String>();
        Framework.Log.push(ScheduleItems.class.getName(),'afterInsert');
        String[] errors = new List<String>();
        try {
            for (EventAPI__Schedule_Item__c sItem : (EventAPI__Schedule_Item__c[])records) {
                checkRoomAndEventGuide(sItem);
                if(sItem.Guide__c != null){
                    schList.add(sItem.Id);
                }
            }
            if(schList.Size() > 0){
           	 System.enqueueJob(new QueueableGuidebook('ScheuleItem',schList));
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
        Framework.Log.push(ScheduleItems.class.getName(),'afterUpdate');
        String[] errors = new List<String>();
        List<String> schList = new List<String>();
        try {
            for (EventAPI__Schedule_Item__c sItem : (EventAPI__Schedule_Item__c[])records) {
                checkRoomAndEventGuide(sItem);
                EventAPI__Schedule_Item__c scheduleOld = (EventAPI__Schedule_Item__c)oldMap.get(sItem.Id);
                if(sItem.Guide__c != null && (scheduleOld.id == sItem.Id ) && (scheduleOld.Name != sItem.Name || scheduleOld.EventApi__Description__c != sItem.EventApi__Description__c 
                                                                               || scheduleOld.EventApi__Start_Date_Time__c != sItem.EventApi__Start_Date_Time__c 
                                                                               || scheduleOld.EventApi__End_Date_Time__c != sItem.EventApi__End_Date_Time__c
                                                                               || scheduleOld.EventAPI__Start_Date__c != sItem.EventAPI__Start_Date__c
                                                                               || scheduleOld.EventAPI__End_Date__c != sItem.EventAPI__End_Date__c
                                                                               || scheduleOld.EventApi__Session_Start_Time__c != sItem.EventApi__Session_Start_Time__c
                                                                               || scheduleOld.EventApi__Session_End_Time__c != sItem.EventApi__Session_End_Time__c
                                                                               || scheduleOld.EventApi__Room__c != sItem.EventApi__Room__c
                                                                               || scheduleOld.EventAPI__Disable_Registration__c != sItem.EventAPI__Disable_Registration__c)){
                                                                                   schList.add(sItem.Id);
                                                                               }
            }
            if(schList.Size() > 0){
            System.enqueueJob(new QueueableGuidebook('ScheuleItem',schList));
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
     private static void checkRoomAndEventGuide(EventAPI__Schedule_Item__c sItem){
              if(sItem.EventApi__Room__c!=null && sItem.Guide__c!=null && sItem.Room_Guide__c!=sItem.Guide__c){
                      sItem.addError(Label.Event_Room_Guide);                
            }
        }
}