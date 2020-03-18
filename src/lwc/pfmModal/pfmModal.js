import { LightningElement, api, track } from 'lwc';

export default class Modal extends LightningElement {
    
    @api tagline;
    @api open;
    @api backend;
    @api center;
    @api closeLabel = 'Close';
    @api customFooter;
    @api saveLabel = 'Save';
    @api size; // small, medium, large

    @api additionalCloseClasses;
    @api additionalSaveClasses;

    @track classes;
    @track bdClasses;
    @track contentClasses;
    @track hasTagline;
    @track closeVariant;
    @track closeButtonVariant;
    @track headerWeight;

    connectedCallback() {
        this.headerWeight = (this.backend) ? 'light' : 'bold';
    }

    renderedCallback() {
        this.modalBody();
        this.modalContent();
        this.backdrop();
        this.endLoader('closeButtonModal');
        this.endLoader('saveButtonModal');
    }

    modalBody() {
        const classBase = 'pfm-modal slds-modal';

        let valOpen = this.open,
            valTagline = this.tagline,
            valCenter = this.center,
            valBackend = this.backend,
            valSize = this.size;

        let str,
            backend,
            size,
            type,
            open;

        open = (valOpen) ? ' slds-fade-in-open' : '';
        backend = (valBackend) ? '' : ' pfm-modal_portal';
        size = (valSize) ? ' slds-modal_' + valSize : '';

        this.classes = classBase + size + backend + open;

        this.hasTagline = (valTagline) ? true : false;
        this.closeVariant = (valBackend) ? 'inverse' : false;
        this.closeButtonVariant = (valBackend) ? ' slds-button slds-button_icon slds-modal__close slds-button_icon-inverse' : ' slds-button slds-button_icon slds-modal__close'

        if (valOpen) {
            document.body.setAttribute('style', 'overflow-y: hidden');
        } else {
            document.body.removeAttribute('style');
        }
    }
    backdrop() {
        const classBase = 'slds-backdrop';

        let valOpen = this.open;

        let str,
            open;

        open = (valOpen) ? ' slds-backdrop_open' : '';

        this.bdClasses = classBase + open;
    }
    modalContent() {
        const classBase = 'slds-modal__content slds-p-horizontal_large slds-p-vertical_x-large';
        let valCenter = this.center;
        let center;

        center = (valCenter) ? ' slds-text-align_center' : '';

        this.contentClasses = classBase + center;
    }

    closeHandler() {
        this.dispatchEvent(new CustomEvent('close'));
    }

    saveHandler() {
        this.dispatchEvent(new CustomEvent('save'));
    }

    @api
    endLoader(buttonType) {
        let buttonTarget = this.template.querySelector("c-pfm-button[data-name='" + buttonType + "']");
        if (buttonTarget != null) {
            buttonTarget.endLoader();
        }
    }
}