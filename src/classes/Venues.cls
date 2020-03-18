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
global without sharing class Venues extends Framework.Domain{
    public Venues (List<EventApi__Venue__c> sObjectList) {
        super(sObjectList);
    }
    global class Constructor implements Framework.Domain.DomainConstructor  {
        global Framework.Domain construct(List<SObject> sObjectList) {
            return new Venues(sObjectList);
        }
    }
    public override void afterInsert() {
        Framework.Log.push(Venues.class.getName(),'afterInsert');
        String[] errors = new List<String>();
		List<String> recordIds = new List<String>();
        try {
            for (EventApi__Venue__c sItem : (EventApi__Venue__c[])records) {
                if(sItem.Guide__c != null){
					recordIds.add(sItem.Id); 
                }
                
            }
			if(recordIds.size() > 0){
			System.enqueueJob(new QueueableGuidebook('Venue',recordIds));
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
        Framework.Log.push(Venues.class.getName(),'afterUpdate');
        String[] errors = new List<String>();
		List<String> recordIds = new List<String>();
        try {
            for (EventApi__Venue__c sItem : (EventApi__Venue__c[])records) {
                EventApi__Venue__c venueOld = (EventApi__Venue__c)oldMap.get(sItem.Id);
                if(sItem.Guide__c != null && (venueOld.id == sItem.id) && (venueOld.Name != sItem.name  || venueOld.Guidebook_Location_Import_Id__c != sItem.Guidebook_Location_Import_Id__c || venueOld.Guidebook_Location_Latitude__c != sItem.Guidebook_Location_Latitude__c
                                                 || venueOld.Guidebook_Location_Longitude__c != sItem.Guidebook_Location_Longitude__c
                                                 || venueOld.EventApi__City__c != sItem.EventApi__City__c
                                                 || venueOld.EventApi__State__c != sItem.EventApi__State__c
                                                 || venueOld.EventApi__Street__c != sItem.EventApi__Street__c
                                                 || venueOld.EventApi__Country__c != sItem.EventApi__Country__c
                                                 || venueOld.EventApi__Postal_Code__c != sItem.EventApi__Postal_Code__c ) ){
													recordIds.add(sItem.Id);
                                                 }
            }
			if(recordIds.size() > 0){
			System.enqueueJob(new QueueableGuidebook('Venue',recordIds));
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