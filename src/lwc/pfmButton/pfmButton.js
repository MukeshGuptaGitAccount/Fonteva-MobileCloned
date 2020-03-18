import { LightningElement, api, track } from 'lwc';
import { loadStyle } from 'lightning/platformResourceLoader';
import BASE from '@salesforce/resourceUrl/PFM_Base';

export default class PfmButton extends LightningElement {
    @api type; // default, outline, success, danger, link
    @api disableLoader = false;
    @api submit = false;
    @api name;
    @api group;
    @api disabled; // boolean
    @api theme; // open attribute, but will be over written by parent component
    @api grouped; // open attribute, but will be over written by parent component
    @api icon; // only use utility icons found here: https://www.lightningdesignsystem.com/icons/#utility
    @api label; // string to be displayed inside of button
    @api iconPosition; // left, right
    @api additionalClasses; // should not be used in portal. should only be used in older products such as events
    @api iconSize = 'xx-small'; // xx-small, x-small, small, medium, large, x-large
    @api backend; // boolean

    @track classes;
    @track isSubmit;
    @track leftIcon;
    @track rightIcon;
    @track iconVariant;
    @track status = false;

    connectedCallback(){
        this.loadDependentStyles();

        const classBase = 'pfm-button';

        this.iconValue();

        let type = (this.type) ? ' pfm-button_' + this.type : ' pfm-button_default';
        let additionalClasses = (this.additionalClasses) ? ' ' + this.additionalClasses: '';
        let backend = (this.backend) ? ' pfm-button_backend' : '';

        if (this.theme) { this.themeValue() }

        if (this.submit) {
            this.isSubmit = 'submit'
        }

        this.classes = classBase + type + additionalClasses + backend;

    }

    themeValue(){
        const theme = 'pfm-theme_'
        switch(this.theme) {
            case 'success':
                this.classList.add(theme + 'success');
                break;
            case 'danger':
                this.classList.add(theme + 'danger');
                break;
            case 'brand':
                this.classList.add(theme + 'brand');
                break;
            case 'shade':
                this.classList.add(theme + 'shade');
                break;
            case 'shade-dark':
                this.classList.add(theme + 'shade-dark');
                break;
        }
    }

//    loading methods
    @api
    startLoader() {
        if (!this.disableLoader){

            this.status = true;
            this.template.querySelector('button').classList.add('js-load');

            const changeEvent = new CustomEvent('submit', {
                detail: {}
            });
            this.dispatchEvent(changeEvent);
        }
    }

    @api
    endLoader() {
        const btn = this.template.querySelector('button');
        btn.classList.remove('js-load');
        btn.classList.add('js-load-transition');
        setTimeout(function(){
            btn.classList.remove('js-load-transition');
        },1000)
        this.status = false;
    }

    iconValue() {
        if (this.icon) {
            if (this.iconPosition === 'right') {
                this.rightIcon = true;
            } else {
                this.leftIcon = true;
            }
            switch (this.type) {
                case 'default':
                    this.iconVariant = 'inverse';
                    break;
                case 'success':
                    this.iconVariant = 'inverse';
                    break;
                case 'danger':
                    this.iconVariant = 'inverse';
                    break;
                case 'outline':
                    this.iconVariant = '';
                    break;
                case 'bare':
                    this.iconVariant = '';
                    break;
                case 'link':
                    this.iconVariant = '';
                    break;
                default:
                    this.iconVariant = 'inverse';
            }
        }
    }
    loadDependentStyles(){
        if (!window.pfmButtonStyleLoaded) {
            loadStyle(this, BASE + '/css/component/button/button.css');
            loadStyle(this, BASE + '/css/component/button/button-animation.css');
            window.pfmButtonStyleLoaded = true;
        }
    }
}