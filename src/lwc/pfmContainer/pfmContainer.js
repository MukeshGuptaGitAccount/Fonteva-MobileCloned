import { LightningElement, api, track } from 'lwc';

import PFM_Base from 'c/pfmBase';

export default class Container extends PFM_Base {

    @api scroll; // boolean
    @api isRelative; // boolean

    @track background;
    @track classes;

    @api
    get theme() {
        return this.background;
    }
    set theme(value) {
        this.background = value;
    }

    @api
    get padding() {
        return super.paddingStr;
    }
    set padding(value) {
        super.paddingStr = value;
    }

    @api
    get margin() {
        return super.marginStr;
    }
    set margin(value) {
        super.marginStr = value;
    }

    connectedCallback() {
		super.connectedCallback('pfm-cmp-container');
        let valScroll = this.scroll,
            valBackground = this.background,
            valIsRelative = this.isRelative;

        let scroll,
            background,
            relative;

        background = (valBackground) ? ' pfm-container-theme_' + valBackground : ''; // brand, danger, success, shade, shade-dark
        scroll = (valScroll) ? ' slds-scrollable_y' : '';

        relative = (valIsRelative) ? ' slds-is-relative' : '';


        this.classes = this.classStr + scroll + background + relative;

    }
    renderedCallback(){
        super.renderedCallback('pfm-container');
    }
}