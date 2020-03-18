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
global without sharing class Speakers extends Framework.Domain {
    public Speakers (List<EventApi__Speaker__c> sObjectList) {
        super(sObjectList);
    }
    global class Constructor implements Framework.Domain.DomainConstructor  {
        global Framework.Domain construct(List<SObject> sObjectList) {
            return new Speakers(sObjectList);
        }
    }
    public override void afterInsert() {
        List<String> speakerList = new List<String>();
        Framework.Log.push(Speakers.class.getName(),'afterInsert');
        String[] errors = new List<String>();
        try {
            for (EventApi__Speaker__c sItem : (EventApi__Speaker__c[])records) {
                if(sItem.Guide__c != null){
                    speakerList.add(sItem.Id);
                }
            }
            if(speakerList.Size() > 0){
           	 System.enqueueJob(new QueueableGuidebook( 'Speaker',speakerList ));
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
        Framework.Log.push(Speakers.class.getName(),'afterUpdate');
        String[] errors = new List<String>();
        List<String> speakerList = new List<String>();
        try {
            for (EventApi__Speaker__c sItem : (EventApi__Speaker__c[])records) {
                EventApi__Speaker__c speakerold = (EventApi__Speaker__c)oldMap.get(sItem.Id);
                if(sItem.Guide__c != null && (speakerold.id == sItem.id) && (speakerold.Name != sItem.name || speakerold.Disable_Todo__c != sItem.Disable_Todo__c 
                                                                             || speakerold.allow_rating__c != sItem.allow_rating__c 
                                                                             || speakerold.Import_Id__c != sItem.Import_Id__c
                                                                             || speakerold.EventApi__Bio__c != sItem.EventApi__Bio__c
                                                                             || speakerold.EventApi__Title__c != sItem.EventApi__Title__c)){ 
                                                                                 speakerList.add(sItem.Id);
                                                                             }
                
            }
            if(speakerList.Size() > 0){
              System.enqueueJob(new QueueableGuidebook('Speaker',speakerList));  
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