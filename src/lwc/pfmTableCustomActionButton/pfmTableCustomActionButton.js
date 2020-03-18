import {LightningElement, api, track} from 'lwc';
import {fireEvent} from 'c/pubsub';

export default class PfmTableCustomActionButton extends LightningElement {
    @api rowId;
    @api actionButtonAttributes;

    @track iconName = '';
    @track iconSize = 'x-small';
    @track buttonType = 'outline';
    @track buttonName = '';
    @track classes = 'pfm-custom_action_button';
    @track backend = false;

    connectedCallback() {
        if(this.actionButtonAttributes) {
            const actionName = this.actionButtonAttributes.actionName;
            this.buttonName = actionName + '-' + this.rowId;
            this.classes += ' pfm-custom_action_button-' + actionName;
            if(this.actionButtonAttributes.additionalClasses) {
                this.classes += ' ' + this.actionButtonAttributes.additionalClasses;
            }
            this.iconName = this.actionButtonAttributes.iconName;
            if(this.actionButtonAttributes.iconSize) {
                this.iconSize = this.actionButtonAttributes.iconSize;
            }
            if (this.actionButtonAttributes.buttonType) {
                this.buttonType = this.actionButtonAttributes.buttonType;
            }
            if (this.actionButtonAttributes.backend) {
                this.backend = this.actionButtonAttributes.backend;
            }
        }
    }

    handleClick() {
        fireEvent(this.actionButtonAttributes.actionName,
            {
                rowId: this.rowId,
                thisButton: this
            }
        );
    }
}