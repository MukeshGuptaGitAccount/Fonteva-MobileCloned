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
public class QueueableGuidebook implements Queueable, Database.AllowsCallouts{
    public String Id;
    public String objectName;
    public List<String> ids;
	public List<Sobject> sObjList ;
    public QueueableGuidebook (String recordId ,String sObjectName) {
        Id = recordId;
        objectName = sObjectName;
    }
    public QueueableGuidebook (String sObjectName,List<String> recordIds) {
        objectName = sObjectName;
        ids = recordIds;
    }
    public void execute(QueueableContext context) {
        if(objectName.equals('Room')){
            GuidebookRestApiController.sendRoom(Ids);
        }
        else if(objectName.equals('Venue')){
            GuidebookRestApiController.sendVenue(Ids);
        }
        else if(objectName.equals('ScheuleItem')){
            GuidebookRestApiController.sendSession(ids);
        }
        else if(objectName.equals('Attendee')){
            GuidebookRestApiController.sendAttendee(Ids);
        }
        else if(objectName.equals('Speaker')){
            GuidebookRestApiController.sendSpeaker(Ids);
        }
        else if(objectName.equals('Track')){
            GuidebookRestApiController.sendTrack(Ids);
        }
        else if(objectName.equals('Event')){
            GuidebookRestApiController.updateGuides(Id);
        }
        else if(objectName.equals('RegistrationItem')){
            GuidebookRestApiController.sendRegistrationItem(Ids);
        }
        else if(objectName.equals('PackscriptCreateOrgranisation')){
            if(!Test.isRunningTest()){
            GuidebookRestApiController.setupOrganizationGuidebook();
            }
        }
      
    }
}