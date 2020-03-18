/*
* @author Hirdesh 
* @Date   01 JAN 2020
* @purpose This class will be used to cover TestCoverage of GuidebookRestApiController_MemberShip   
*/

@isTest
Private class Test_GuidebookController_MemberShip {
    
    @testSetup static void setup() {
        LTE__Site__c Comsite = new LTE__Site__c();
        Comsite.Name = 'TestSite';
        Comsite.LTE__Site_URL__c = 'https://google.com';
        Comsite.Guide__c = 10068 ;
        insert Comsite;
        
        LTE__Site__c Comsite1 = new LTE__Site__c();
        Comsite1.Name = 'TestSite1';
        Comsite1.LTE__Site_URL__c = 'http://google.com';
        Comsite1.Guide__c = 10069 ;
        insert Comsite1;
        
        Guidebook_Setting__c guide = new Guidebook_Setting__c();
        guide.Name = UserInfo.getUserName();
        guide.Api_Key__c = 'JWT '+'Test';
        guide.Organization_ID__c = 123456798;
        insert guide;
    }
    @isTest
    static void guidebookRestApiControllerPutTestMethod(){
        
        LTE__Site__c Comsite = [Select Id , Name , LTE__Site_URL__c , Guide__c from LTE__Site__c Where Name = 'TestSite' Limit 1];
        
        LTE__Site__c Comsite1 = [Select Id , Name , LTE__Site_URL__c , Guide__c from LTE__Site__c Where Name = 'TestSite1' Limit 1];
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        GuidebookRestApiController_MemberShip.getSite();
        GuidebookRestApiController_MemberShip.createGuide_Membership(Comsite.Id , 'Testing Guide' , 'Test Description');
        GuidebookRestApiController_MemberShip.createGuide_Membership(Comsite1.Id , 'Testing Guide' , 'Test Description');
        GuidebookRestApiController_MemberShip.createWebview(Comsite.Guide__c, Comsite.LTE__Site_URL__c, 'Testing Guide');
        Test.stopTest();
        
    }
}