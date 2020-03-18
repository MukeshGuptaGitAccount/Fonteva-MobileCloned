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
public class BatchForRegistrationItem implements Database.Batchable<sObject>,Database.Stateful,Database.AllowsCallouts {
    List<EventApi__Registration_Item__c> rList = new List<EventApi__Registration_Item__c>();
    public Database.QueryLocator start(Database.BatchableContext BC) {
        date dateToday = System.today();
        String query='SELECT Id , Guide__c , EventApi__End_Date__c From EventApi__Event__c WHERE EventApi__End_Date__c >= :dateToday ';
        return Database.getQueryLocator(query);
    }
    
    public void execute(Database.BatchableContext BC, List<EventApi__Event__c> records) {
        List<EventApi__Registration_Item__c> RegList = new List<EventApi__Registration_Item__c>();
        for(EventApi__Event__c obj: records){
            if(obj.Guide__c != null){
            RegList = GuidebookRestApiController.getRegistrationItem(obj.Guide__c);
            rList.addAll(RegList);
            }
        }
    }
    public void finish(Database.BatchableContext BC){ 
        if(rList.size() >0){
            upsert rList Registration_Id__c;
        }
    }
}