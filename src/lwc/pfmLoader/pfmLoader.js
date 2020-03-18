import { LightningElement, api, track } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import BASE from '@salesforce/resourceUrl/PFM_Base';
import { registerListener, unregisterAllListeners } from 'c/pubsub'

export default class PfmLoader extends LightningElement {
    @api full = false;
    @api startOnLoad = false;
    @api identifier;
    @api size; // small, medium, large. default: small
    @track classes;
    @api altText;
    @api
    start(){
        this.template.querySelector('.pfm-loader').classList.add('js-loader');
    }

    @api
    end(){
        this.template.querySelector('.pfm-loader').classList.remove('js-loader');
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    connectedCallback(){
        registerListener(
            'toggleLoader',
            this.toggleLoader,
            this
        );

        loadStyle(this, BASE + '/css/component/loader/loader.css');

        let valFull = (this.full) ? ' pfm-loader_full pfm-loader_large' : '';
        let valSize = (this.size) ? ' pfm-loader_' + this.size : ' pfm-loader_small';

        this.classes = 'pfm-loader' + valFull + valSize;

        if (this.startOnLoad) {
            let self = this;
            setTimeout(() => {
                this.start();
            },50);
        }
    }

    toggleLoader(evt) {
        if (evt.identifier != null && evt.identifier === this.identifier) {
            if (evt.action != null && evt.action.toLowerCase() === 'start') {
                this.start()
            }
            else {
                this.end();
            }
        }
    }
}