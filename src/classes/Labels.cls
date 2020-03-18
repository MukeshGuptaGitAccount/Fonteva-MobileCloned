/*
* -----------------------------------------------------------------------------
* COPYRIGHT (C) 2017, FONTEVA, INC.
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

/**
* Label Class
* @author Gurp Parmar
**/
public with sharing class Labels {
    
    @AuraEnabled
    public static Map<String,String> getLabels() {
        return new Map<String,String>{
            'Guidebook_Name' => System.Label.Guidebook_Name,
                'Sync_button_label' => System.Label.Sync_button_label,
                'Cancel' => System.Label.Cancel,
                'Guidebook_Helptext' => System.Label.Guidebook_Helptext,
                'GuideName_Header' => System.Label.GuideName_Header,
                'GuideDescription_Header' => System.Label.GuideDescription_Header,
                'StartTime_Header' => System.Label.StartTime_Header,
                'EndTime_Header' => System.Label.EndTime_Header,
                'Save' => System.Label.Save,
                'Cancel_Api_Button' => System.Label.Cancel_Api_Button,
                'Already_Synced_Checkbox' => System.Label.Already_Synced_Checkbox,
                'Sync_With_New_Guide_Checkbox' => System.Label.Sync_With_New_Guide_Checkbox,
                'Invitation_toast_text'  => System.Label.Invitation_toast_text,
                'Request_pending_toast_text' => System.Label.Request_pending_toast_text,
                'Invalid_email_toast_text' => System.Label.Invalid_email_toast_text,
                'Required_field_toast_text' => System.Label.Required_field_toast_text,
                'Sync_success_toast_text' => System.Label.Sync_success_toast_text,
                'New_Guide_Creation_Toast' => System.Label.New_Guide_Creation_Toast,
                'Event_Already_Sync_Toast' => System.Label.Event_Already_Sync_Toast,
                'No_Record_Found'  => System.Label.No_Record_Found,
                'Event_Overview_HTML_Msg' => System.Label.Event_Overview_HTML_Msg,
                'New_Guide' => System.Label.New_Guide,
                'Invite' =>System.Label.Invite,
                'Color_Pattern' =>System.Label.Color_Pattern,
                'Event_Room_Guide' => System.Label.Event_Room_Guide ,
                'Guidebook_Speaker'=> System.Label.Guidebook_Speaker  
                };
                    }
}