import { LightningElement,api } from 'lwc';
import sendInvitation from '@salesforce/apex/GuidebookApiController.sendInvitation';
import Invite from '@salesforce/label/c.Invite';
import CancelButton from '@salesforce/label/c.Cancel';
import InvitationToastText from '@salesforce/label/c.Invitation_toast_text';
import RequestPendingToastText from '@salesforce/label/c.Request_pending_toast_text';
import InvalidEmailToastText from '@salesforce/label/c.Invalid_email_toast_text';
import RequiredFieldToastText from '@salesforce/label/c.Required_field_toast_text';
import { fireEvent } from 'c/pubsub';
export default class InviteUser extends LightningElement {
   
    @api loaded=false;
    @api ready=false;
    @api hideTable=false;
    
    label = {
        Invite,
        CancelButton,
        InvitationToastText,
        RequestPendingToastText,
        InvalidEmailToastText,
        RequiredFieldToastText
        
      };

    invitation(event){
      const payload = {
        "label": event.target.label
      }  
        var firstName = this.template.querySelector(".FirstName");
        var lastName = this.template.querySelector(".LastName");
        var email = this.template.querySelector(".Email");
        var userFirstName=firstName.value;
        var userLastName=lastName.value;
        var userEmail=email.value;
     if((userFirstName.length && userLastName.length) !=0)
      {
        var mailformat = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
          if(userEmail.match(mailformat))
          {
        sendInvitation({ firstName: userFirstName, lastName:userLastName,email: userEmail})
        .then(result => {
           
          if(result==="Accepted"){
              this.hideTable=true;
              this.loaded=true;
              /*eslint-disable*/
              setTimeout(() => {
                this.ready = true;
                this.dispatchEvent(new CustomEvent('closeQuickAction', { detail: {payload} }));
              }, 2000);
            fireEvent('toast', {
                type: 'success', // optional. default: 'default'
                message: InvitationToastText,
                title: 'Success',// optional. default: 'Success'
                duration: 2
              }); 
        }else{
            this.hideTable=true;
            this.loaded=true;
            setTimeout(() => {
                this.ready = true;
                this.dispatchEvent(new CustomEvent('closeQuickAction', { detail: {payload} }));
              }, 4000);
            fireEvent('toast', {
                type: 'danger', // optional. default: 'default'
                message: RequestPendingToastText,
                title: 'Danger',// optional. default: 'Success'
                duration: 3
              });
        }
        })
    }else{
        this.hideTable=true;
        this.loaded=true;
        fireEvent('toast', {
            type: 'danger', // optional. default: 'default'
            message: InvalidEmailToastText,
            title: 'Danger',// optional. default: 'Success'
            duration: 2
          });
          setTimeout(() => {
            this.ready = true;
            this.loaded=false;
            this.hideTable=false;
          }, 2000);
         
    }
    }else{
        this.hideTable=true;
        this.loaded=true;
        fireEvent('toast', {
            type: 'danger', // optional. default: 'default'
            message: RequiredFieldToastText,
            title: 'Danger',// optional. default: 'Success'
            duration: 2 
          });
          setTimeout(() => {
            this.ready = true;
            this.loaded=false;
            this.hideTable=false;
          }, 2000);    
    }
}
cancelPopUp(event) {
  const payload = {
    "label": event.target.label
  }
  this.dispatchEvent(new CustomEvent('closeQuickAction', { detail: {payload} }));
  }
}