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
global without sharing class Rooms extends Framework.Domain{
    public Rooms (List<EventApi__Room__c> sObjectList) {
        super(sObjectList);
    }
    
    global class Constructor implements Framework.Domain.DomainConstructor  {
        global Framework.Domain construct(List<SObject> sObjectList) {
            return new Rooms(sObjectList);
        }
    }
    public override void afterInsert() {
        Framework.Log.push(Rooms.class.getName(),'afterInsert');
        String[] errors = new List<String>();
		List<String> recordIds = new List<String>();
        try {
            for (EventApi__Room__c sItem : (EventApi__Room__c[])records) {
                if(sItem.Guide__c != null){
					recordIds.add(sItem.Id); 
                }
            }
			if(recordIds.size() > 0){
			System.enqueueJob(new QueueableGuidebook('Room',recordIds));
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
        Framework.Log.push(Rooms.class.getName(),'afterUpdate');
        String[] errors = new List<String>();
		List<String> recordIds = new List<String>();
        try {
            for(EventApi__Room__c sItem : (EventApi__Room__c[])records) {
                EventApi__Room__c roomOld = (EventApi__Room__c)oldMap.get(sItem.Id);
                if(sItem.Guide__c != null && (roomOld.id == sItem.Id) && (roomOld.Name != sItem.Name  
                                                || roomOld.EventApi__Venue__r.Guidebook_Location_Import_Id__c != sItem.EventApi__Venue__r.Guidebook_Location_Import_Id__c 
                                                || roomOld.EventApi__Venue__r.Guidebook_Location_Latitude__c != sItem.EventApi__Venue__r.Guidebook_Location_Latitude__c
                                                || roomOld.EventApi__Venue__r.Guidebook_Location_Longitude__c != sItem.EventApi__Venue__r.Guidebook_Location_Longitude__c
                                                || roomOld.EventApi__Venue__r.EventApi__City__c != sItem.EventApi__Venue__r.EventApi__City__c
                                                || roomOld.EventApi__Venue__r.EventApi__State__c != sItem.EventApi__Venue__r.EventApi__State__c
                                                || roomOld.EventApi__Venue__r.EventApi__Street__c != sItem.EventApi__Venue__r.EventApi__Street__c
                                                || roomOld.EventApi__Venue__r.EventApi__Country__c != sItem.EventApi__Venue__r.EventApi__Country__c
                                                || roomOld.EventApi__Venue__r.EventApi__Postal_Code__c != sItem.EventApi__Venue__r.EventApi__Postal_Code__c)){ 
													recordIds.add(sItem.Id); 
                                                }
            }
			if(recordIds.size() > 0){
			System.enqueueJob(new QueueableGuidebook('Room',recordIds));
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