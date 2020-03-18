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
global without sharing class Tracks extends Framework.Domain{
    public Tracks (List<EventApi__Track__c> sObjectList) {
        super(sObjectList);
    }
    
    global class Constructor implements Framework.Domain.DomainConstructor  {
        global Framework.Domain construct(List<SObject> sObjectList) {
            return new Tracks(sObjectList);
        }
    }
    String[] errors = new List<String>();
    public override void afterInsert() {
	List<String> recordIds = new List<String>();
        Framework.Log.push(Tracks.class.getName(),'afterInsert');
        try {
            for (EventApi__Track__c sItem : (EventApi__Track__c[])records) {
                if(sItem.Guide__c != null){
					recordIds.add(sItem.Id); 
                }
            }
			if(recordIds.size() > 0){
			System.enqueueJob(new QueueableGuidebook('Track',recordIds));
			}
            Framework.Log.pop();
        }
        catch (Exception e) {
            errors.add(e.getMessage());
            errors.add(e.getStackTraceString());
            Framework.Log.debugException(e);
            Framework.Message.addMessage(e,Framework.Message.Severity.Danger);
        }
        finally {
            Framework.Log.popAll();
        }
    }
    public override void afterUpdate(Map<Id,SObject> oldMap){
        Framework.Log.push(Tracks.class.getName(),'afterUpdate');
		List<String> recordIds = new List<String>();
        try {
            for (EventApi__Track__c sItem : (EventApi__Track__c[])records) {
                EventApi__Track__c trackOld = (EventApi__Track__c)oldMap.get(sItem.Id);
                if(sItem.Guide__c != null && (trackOld.id == sItem.Id) && (trackOld.Name != sItem.Name || trackOld.EventApi__Track_Color__c != sItem.EventApi__Track_Color__c)){   
					recordIds.add(sItem.Id);
                     }
            }
			if(recordIds.size() > 0){
			System.enqueueJob(new QueueableGuidebook('Track',recordIds));
			}
            Framework.Log.pop();
        }
        catch (Exception e) {
            errors.add(e.getMessage());
            errors.add(e.getStackTraceString());
            Framework.Log.debugException(e);
            Framework.Message.addMessage(e,Framework.Message.Severity.Danger);
        }
        finally {
            Framework.Log.popAll();
        }
    }
}