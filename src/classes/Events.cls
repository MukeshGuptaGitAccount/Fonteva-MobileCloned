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
global without sharing class Events extends Framework.Domain {
    public Events (List<EventApi__Event__c> sObjectList) {
        super(sObjectList);
    }
    
    global class Constructor implements Framework.Domain.DomainConstructor  {
        global Framework.Domain construct(List<SObject> sObjectList) {
            return new Events(sObjectList);
        }
    }
    public override void afterUpdate(Map<Id,SObject> oldMap){
        Framework.Log.push(Events.class.getName(),'afterUpdate');
        String[] errors = new List<String>();
        try {
            for (EventApi__Event__c sItem : (EventApi__Event__c[])records) {
                EventApi__Event__c eventOld = (EventApi__Event__c)oldMap.get(sItem.Id);
                if(sItem.Guide__c != null && (eventOld.Id == sItem.Id ) && (eventOld.Name != sItem.Name || eventOld.EventAPI__Start_Date__c != sItem.EventAPI__Start_Date__c 
                                                  || eventOld.EventAPI__End_Date__c != sItem.EventAPI__End_Date__c 
                                                  || eventOld.EventApi__Overview_HTML__c != sItem.EventApi__Overview_HTML__c
                                                  || eventOld.EventApi__Time_Zone__c != sItem.EventApi__Time_Zone__c)){
                                                      System.enqueueJob(new QueueableGuidebook(sItem.Id , 'Event'));
                                                  }
                if(eventOld.Guide__c != sItem.Guide__c){
                    GuidebookEventRelatedObjectsController.EventRelatedObjects(sItem.Id);
                }
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