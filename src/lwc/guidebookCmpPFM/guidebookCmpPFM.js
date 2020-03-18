import { LightningElement, track, api } from 'lwc';
import getGuides from '@salesforce/apex/GuidebookApiController.getGuides';
import createGuide from '@salesforce/apex/GuidebookApiController.createGuide';
import getEvent from '@salesforce/apex/GuidebookApiController.getEvent';
import SyncData from '@salesforce/apex/GuidebookApiController.SyncData';
import SyncButton from '@salesforce/label/c.Sync_button_label';
import CancelButton from '@salesforce/label/c.Cancel';
import GuidebookHelptext from '@salesforce/label/c.Guidebook_Helptext';
import GuidebookNameHeader from '@salesforce/label/c.GuideName_Header';
import GuidebookDescriptionHeader from '@salesforce/label/c.GuideDescription_Header';
import GuidebookStartTimeHeader from '@salesforce/label/c.StartTime_Header';
import GuidebookEndTimeHeader from '@salesforce/label/c.EndTime_Header';
import AlreadySynced from '@salesforce/label/c.Already_Synced_Checkbox';
import SyncWithNewGuide from '@salesforce/label/c.Sync_With_New_Guide_Checkbox';
import OverviewHtmlMsg from '@salesforce/label/c.Event_Overview_HTML_Msg';
import NewGuide from '@salesforce/label/c.New_Guide';
import SyncSuccessToastText from '@salesforce/label/c.Sync_success_toast_text';
import NewGuideCreationToast from '@salesforce/label/c.New_Guide_Creation_Toast';
import EventAlreadySyncToast from '@salesforce/label/c.Event_Already_Sync_Toast';
import NoRecordFound from '@salesforce/label/c.No_Record_Found';
import { fireEvent } from 'c/pubsub';



const columns = [
  { label: GuidebookNameHeader, fieldName: 'Name', type: 'text'},
  { label: GuidebookDescriptionHeader, fieldName: 'EventApi__Overview_HTML__c', type: 'Text', title: 'EventApi__Overview_HTML__c' },
  { label: GuidebookStartTimeHeader, fieldName: 'EventApi__Start_Date_Time__c', type: 'Text' },
  { label: GuidebookEndTimeHeader, fieldName: 'EventApi__End_Date_Time__c', type: 'Text' }
];

export default class Guidebook extends LightningElement {

  @track loaded = false;
  @track data = [];
  @api recordId;
  @api guideId;
  @api guideName;
  @api startDatetime;
  @api endDatetime;
  @api guideDescription;
  @api isChecked = false;
  @api showModal = false;
  @api buttonValue = false;
  @api hideCheckbox = false;
  @api Guide;
  @api columns = columns;
  @api OverviewHtmlLength;
  @api ready = false;
  @api returnValue;
  @api showMsg=false;
  @api checkboxValue=false;
 

  label = {
    NewGuide,
    SyncButton,
    CancelButton,
    GuidebookHelptext,
    AlreadySynced,
    SyncWithNewGuide,
    OverviewHtmlMsg,
    SyncSuccessToastText,
    NewGuideCreationToast,
    EventAlreadySyncToast,
    NoRecordFound
    
  };
  async connectedCallback() {
    
    const datavalue = await getEvent({ eventId: this.recordId });
    var OverviewHtmlSubString;
    var descriptionValue = datavalue.EventApi__Overview_HTML__c;
    if (descriptionValue === undefined) {
       /*eslint-disable*/
      setTimeout(() => {
        this.ready = true;
        const payload = {
          "label": descriptionValue
        }
        this.dispatchEvent(new CustomEvent('closeQuickAction', { detail: {payload} }));
      }, 3000);
      fireEvent('toast', {
        type: 'danger', // optional. default: 'default'
        message: OverviewHtmlMsg,
        title: 'Error in fields',// optional. default: 'Success'
        duration: 2
      });

    } else {
      OverviewHtmlSubString = descriptionValue.substring(3, descriptionValue.length - 4); //removed <p></p> tag from EventApi__Overview_HTML__c fields.
      this.OverviewHtmlLength = OverviewHtmlSubString.replace(/\s/g, '').length;
      if (this.OverviewHtmlLength === 0) {
        /*eslint-disable*/
        fireEvent('toast', {
          type: 'danger', // optional. default: 'default'
          message: OverviewHtmlMsg,
          title: 'Error in fields',// optional. default: 'Success'
          duration: 2
        });
        setTimeout(() => {
          this.ready = true;
         const payload = {
          "label": descriptionValue
        }
        this.dispatchEvent(new CustomEvent('closeQuickAction', { detail: {payload} }));
        }, 3000);
      } else if (datavalue.MobileApi__Guide__c != null) {
        this.guideName = datavalue.Name;
        this.checkedValue = true;
        this.hideCheckbox = true;
      } else {
        this.guideName = datavalue.Name;
        const data = await getGuides({ amountOfRecords: 100 });
        if (data.length ==0) {
          this.isChecked = false;
          this.showMsg=true;
          //this.dispatchEvent(new CustomEvent('callToApiKeyWindow'));
        } else {
          this.buttonValue = true;
          this.isChecked = true;
          this.data = data;
          this.tableLoadingState = true;
        }
      }
    }
  }
  /* Calling Method while Selecting the Guide */
  getSelectedName(event) {
    this.buttonValue = false;
    const selectedRows = event.detail.selectedRows;
    for (let i = 0; i < selectedRows.length; i++) {
      this.guideId = selectedRows[i].MobileApi__Guide__c;
      this.guideName = selectedRows[i].Name;
      this.startDatetime = selectedRows[i].EventApi__Start_Date_Time__c;
      this.endDatetime = selectedRows[i].EventApi__End_Date_Time__c;
      this.guideDescription = selectedRows[i].EventApi__Overview_HTML__c;
    }
  }
  /* Calling to apex class method to sync the Guide with Event */
  syncData(event) {
    
    const payload = {
      "label": event.target.label
    }
    this.loaded = !this.loaded;
    this.isChecked = false;
    SyncData({ eventId: this.recordId, guideId: this.guideId })
      .then(result => {
        this.returnValue = result;
        if (this.returnValue == null) {
          /*eslint-disable*/
          setTimeout(() => {
            this.ready = true;
            this.dispatchEvent(new CustomEvent('closeQuickAction', { detail: {payload} }));
          }, 2000);
          fireEvent('toast', {
            type: 'success', // optional. default: 'default'
            message: SyncSuccessToastText,
            title: 'Success',// optional. default: 'Success'
            duration: 1
          });
          this.dispatchEvent(new CustomEvent('recordChange'));
        } else {
          fireEvent('toast', {
            type: 'danger', // optional. default: 'default'
            message:  this.resultvalue,
            title: 'Error',// optional. default: 'Success'
            duration: 1
          })
        }
      });
  }
  /* Passing an event to aura component for closing Quickaction Window*/
  cancelPopUp(event) {
    
    const payload = {
      "label": event.target.label
    }
    this.dispatchEvent(new CustomEvent('closeQuickAction', { detail: {payload} }));
  }
  /* Calling apex method to get the Guide onchange chcekbox value*/
  handleChange(event) {
    this.loaded=true;
    this.buttonValue = true;
    this.checkboxValue = event.target.checked;
    if (this.checkboxValue) {
      getGuides()
        .then(result => {
          if(result.length==0)
          {
           
            this.isChecked=false;
            this.showMsg=true;
            this.loaded=false;
            
          }else{
            this.isChecked=true;
            this.data = result;
            this.loaded=false;
          }
         
        })
        .catch(error => {
          this.error = error;
        });
    } else {
      this.data = null;
      this.loaded=false;
      this.showMsg=false;
      this.isChecked=false;
    }
  }
  createNewGuide(event){
    const payload = {
      "label": event.target.label
    }
    this.loaded = true;
    this.isChecked = false;
    getEvent({eventId : this.recordId})
    .then(result=>{
      if(result.MobileApi__Guide__c==null){
        createGuide({eventId : this.recordId})
    .then(result =>{
      if(result==="Created"){
        setTimeout(() => {
          this.ready = true;
          this.dispatchEvent(new CustomEvent('closeQuickAction', { detail: {payload} }));
        }, 2000);
        fireEvent('toast', {
          type: 'success', // optional. default: 'default'
          message:  NewGuideCreationToast,
          title: 'Success',// optional. default: 'Success'
          duration: 1
        })
        this.dispatchEvent(new CustomEvent('recordChange'));
      }else{
        setTimeout(() => {
          this.ready = true;
          this.dispatchEvent(new CustomEvent('closeQuickAction', { detail: {payload} }));
        }, 3000);
        fireEvent('toast', {
          type: 'danger', // optional. default: 'default'
          message:  result,
          title: 'Error',// optional. default: 'Success'
          duration: 2
        })
      }
    })
      }
      else{
        setTimeout(() => {
          this.ready = true;
          this.dispatchEvent(new CustomEvent('closeQuickAction', { detail: {payload} }));
        }, 3000);
        fireEvent('toast', {
          type: 'danger', // optional. default: 'default'
          message:  EventAlreadySyncToast,
          title: 'Error',// optional. default: 'Success'
          duration: 2
        })
      }
    })
  }
}