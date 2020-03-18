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
global without sharing class RegistrationItems extends Framework.Domain {
    public RegistrationItems (List<EventApi__Registration_Item__c> sObjectList) {
        super(sObjectList);
        
    }
    global class Constructor implements Framework.Domain.DomainConstructor  {
        global Framework.Domain construct(List<SObject> sObjectList) {
            return new RegistrationItems(sObjectList);
        }
    }
    public override void afterInsert() {
        Framework.Log.push(RegistrationItems.class.getName(),'afterInsert');
        String[] errors = new List<String>();
        List<String> regItemIds = new List<String>();
        try {
            for (EventApi__Registration_Item__c sItem : (EventApi__Registration_Item__c[])records) {
                if(sItem.Registration_Id__c == null && String.isNotBlank(sItem.Name__c) && sItem.Guide__c != null){
                    regItemIds.add(sItem.Id );
                } 
            }
            if(regItemIds.size() > 0){
                System.enqueueJob(new QueueableGuidebook('RegistrationItem',regItemIds));
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
        Framework.Log.push(RegistrationItems.class.getName(),'afterUpdate');
        String[] errors = new List<String>();
        List<String> regItemIds = new List<String>();
        try {
            for(EventApi__Registration_Item__c sItem : (EventApi__Registration_Item__c[])records) {
                EventApi__Registration_Item__c Registrold = (EventApi__Registration_Item__c)oldMap.get(sItem.Id);
                if(Registrold.id == sItem.id && Registrold.Name__c != sItem.Name__c && String.isNotBlank(sItem.Name__c)&& sItem.Guide__c != null ) {     
                    regItemIds.add(sItem.id);
                }
            } 
            if(regItemIds.size() > 0){
                System.enqueueJob(new QueueableGuidebook('RegistrationItem',regItemIds));
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