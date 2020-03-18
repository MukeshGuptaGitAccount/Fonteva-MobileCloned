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
global without sharing class PackageScripts implements InstallHandler, UninstallHandler{
    
    /**

*   Required for UninstallHandler interface implementation
*   ID organizationId();
*   ID uninstallerId();
*   @param  {InstallContext} context Object providing methods to retrieve
*   organization Id and uninstalling user Id.
*/
    global void onInstall(InstallContext context) {
        PackageScripts.install();
    }
    
    /**

*   Required for UninstallHandler interface implementation
*   ID organizationId();
*   ID uninstallerId();
*   @param  {UninstallContext} context Object providing methods to retrieve
*   organization Id and uninstalling user Id.
*/
    global void onUninstall(UninstallContext context) {
        // To Do : Need to resolve - Variable does not exist: PackageUtils
        //  Framework.Config.clear(PackageUtils.namespace);
        
    }
    
    /**

*   Execute the installation scripts for the OrderApi managed package
*/
    global static void install() {
        new rInstall().run();
    }
    
    /**

*   Runs all default installation scripts for the Fonteva Mobile
*   Managed Package
*
*   @implements Framework.Scriptable
*   @author Gurp Parmar
*   @since 1.0
*/
    global class rInstall implements Framework.Scriptable {
        global void run () {
            
            Framework.Log.push(PackageScripts.Install.class.getName(), 'run');
            Framework.Registry.runOnce(new PackageScripts.CreateOrganizationGuidebook(),'CreateOrganizationGuidebook');
            Framework.RegisteredApp otc = new Framework.RegisteredApp();
            otc.namespace = 'MobileApi';
            otc.name = 'Fonteva Mobile Platform';
            otc.description = 'Fonteva Mobile Platform to display information on mobile devices.';
            otc.isManaged = true;
            otc.isEnabled = true;
            otc.installClass = PackageScripts.Install.class.getName();
            Framework.Config.push(otc);
            
            Framework.RegisteredApp appConfig = (Framework.RegisteredApp) JSON.deserialize(Framework.RegisteredApp.export(otc.namespace), Framework.RegisteredApp.class);
            Framework.Config.clear(appConfig.settingsPages);

            Framework.SettingsPage settingpage = new Framework.SettingsPage();
            settingpage.namespace = otc.namespace;
            settingpage.apexClass = 'Settings';
            settingpage.label = 'Fonteva Mobile Membership Setup';
            settingpage.description = 'Setup guide for Fonteva Mobile based on Community Sites.';
            settingpage.apexComponent = otc.namespace + ':Membership_Guide';
            Framework.Config.push(settingpage);

            try {
                List<Framework.RoutingRule> rules= new List<Framework.RoutingRule>();
                
                /* Map Eventhandle class to Event object*/
                Framework.RoutingRule eventRule = new Framework.RoutingRule();
                eventRule.apexClass = Events.class.getName();
                eventRule.namespace = otc.namespace;
                eventRule.isEnabled = true;
                eventRule.sObjectName = 'EventApi__Event__c';
                eventRule.executionOrder = 1;
                rules.add(eventRule);
                
                
                /* Map Venuehandle class to Venue object*/
                Framework.RoutingRule venueRule = new Framework.RoutingRule();
                venueRule.apexClass = Venues.class.getName();
                venueRule.namespace = otc.namespace;
                venueRule.isEnabled = true;
                venueRule.sObjectName = 'EventApi__Venue__c';
                venueRule.executionOrder = 1;
                rules.add(venueRule);
                
                /* Map Roomhandle class to Room object*/
                Framework.RoutingRule rmRule = new Framework.RoutingRule();
                rmRule.apexClass = Rooms.class.getName();
                rmRule.namespace = otc.namespace;
                rmRule.isEnabled = true;
                rmRule.sObjectName = 'EventApi__Room__c';
                rmRule.executionOrder = 1;
                rules.add(rmRule);
                
                
                /* Map Trackhandle class to Track object*/
                Framework.RoutingRule trackRule = new Framework.RoutingRule();
                trackRule.apexClass = Tracks.class.getName();
                trackRule.namespace = otc.namespace;
                trackRule.isEnabled = true;
                trackRule.sObjectName = 'EventApi__Track__c';
                trackRule.executionOrder = 1;
                rules.add(trackRule);
                
                /* Map Speakerhandle class to Speaker object*/
                Framework.RoutingRule speakerRule = new Framework.RoutingRule();
                speakerRule.apexClass = Speakers.class.getName();
                speakerRule.namespace = otc.namespace;
                speakerRule.isEnabled = true;
                speakerRule.sObjectName = 'EventApi__Speaker__c';
                speakerRule.executionOrder = 1;
                rules.add(speakerRule);
                
                /* Map Attendeehandle class to Attendee object*/
                Framework.RoutingRule attendeeRule = new Framework.RoutingRule();
                attendeeRule.apexClass = Attendees.class.getName();
                attendeeRule.namespace = otc.namespace;
                attendeeRule.isEnabled = true;
                attendeeRule.sObjectName = 'EventApi__Attendee__c';
                attendeeRule.executionOrder = 1;
                rules.add(attendeeRule);
                
                Framework.RoutingRule rIrule = new Framework.RoutingRule();
                rIrule.apexClass = RegistrationItems.class.getName();
                rIrule.namespace = otc.namespace;
                rIrule.isEnabled = true;
                rIrule.sObjectName = 'EventApi__Registration_Item__c';
                rIrule.executionOrder = 1;
                rules.add(rIrule);
                
                Framework.RoutingRule scheduleIrule = new Framework.RoutingRule();
                scheduleIrule.apexClass = ScheduleItems.class.getName();
                scheduleIrule.namespace = otc.namespace;
                scheduleIrule.isEnabled = true;
                scheduleIrule.sObjectName = 'EventApi__Schedule_Item__c';
                scheduleIrule.executionOrder = 1;
                rules.add(scheduleIrule);
                
                Framework.Config.push(rules);
                Framework.CustomScript[] customScripts = new List<Framework.CustomScript>();
                
                customScripts.add(createScript(PackageScripts.rInstall.class, otc.namespace, 'Run Install Scripts (Fonteva Mobile Platform)', 'Runs all installation scripts for Fonteva Mobile Platform.'));
                Framework.Config.push(customScripts);
                
            }
            catch ( Exception ex ){  
                Framework.Log.debugException(ex); }
            Framework.Log.pop();
        }
        
        private Framework.CustomScript createScript(Type apexClassName, String namespace, String name, String description){
            Framework.CustomScript cs1 = new Framework.CustomScript();
            cs1.apexClass = apexClassName.getName();
            cs1.namespace = namespace;
            cs1.name = name;
            cs1.description = description;
            return cs1;
        }
        
    }
    
    global without sharing class CreateOrganizationGuidebook implements Framework.Scriptable{
        global void run() {
            try{
                System.enqueueJob(new QueueableGuidebook(null,'PackscriptCreateOrgranisation'));
            }catch (Exception ex) {
                Framework.Log.debugException(ex);
            }
        }
    }
    
}
