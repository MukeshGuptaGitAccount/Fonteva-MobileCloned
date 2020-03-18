import { LightningElement, api, track } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import BASE from '@salesforce/resourceUrl/PFM_Base';

export default class PfmHelpText extends LightningElement {
    @api label;
    @api required;
    @api content;
    @api backend;

    @track valLabel = false;

    connectedCallback(){
        if (this.label !== undefined ){
            this.valLabel = true;
        }
    }

    renderedCallback(){
        const self = this;
        if (this.label !== undefined && this.backend ){
            this.loadDependentBackendStyles();
            self.template.querySelector('c-pfm-text').classList.add('pfm-text_backend');
        }
    }

    loadDependentBackendStyles () {
		if (!window.pfmHelpTextStyleLoaded) {
		    loadStyle(this, BASE + '/css/component/input/help-text-backend.css');
			window.pfmHelpTextStyleLoaded = true;
		}
	}
}