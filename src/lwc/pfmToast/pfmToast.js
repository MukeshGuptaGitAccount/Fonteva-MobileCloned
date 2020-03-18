import { LightningElement, api, track } from 'lwc';
import { registerListener, unregisterAllListeners } from 'c/pubsub'

export default class PfmToast extends LightningElement {

    @track classes;
    @track iconColor;
    @track iconName;
    @track titleStr;
    @track messageStr;
    @track durationVal;

    @track type;
    @track title;
    @track duration = 9;

    @track toastList = [];

	@api toggle() { console.log('Not Supported') }

    @api
    show(toastId){
        let tile = this.template.querySelector('[data-id="'+ (toastId - 1) +'"]'),
        	tileHeight = tile.offsetHeight;

        tile.classList.add('js-toast_transition');
        tile.style.height = tileHeight + 'px';
    }
    @api
    hide(evt){
		this.toastList = this.toastList.filter(item => item.id != evt.currentTarget.dataset.target);
    }

    autoHide(toastId){
        let tile = this.template.querySelector('[data-id="'+ (toastId - 1) +'"]'),
			tileHeight = tile.offsetHeight;

		tile.classList.add('js-toast_transition');
		tile.style.height = tileHeight + 'px';
        tile.classList.add('js-toast_progress');

        setTimeout(() => {
            tile.style.height = '0px';
            tile.style.padding = '0px';
            tile.classList.add('js-toast_transition-hide');
        }, ((this.duration * 1000) + 500));

        setTimeout(() => {
            this.toastList = this.toastList.filter(item => item.id != toastId - 1);
        }, ((this.duration * 1000) + 1000));
    }


    connectedCallback() {
        const classBase = 'pfm-toast';

        this.classes = classBase;


        registerListener(
            'toast',
            this.toast,
            this
        );

    }
    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    toast(evt) {
        this.messageStr = evt.message;
        this.type = evt.type;
        this.title = evt.title;
        this.duration = (evt.duration) ? evt.duration : this.duration;
		this.titleTheme();

        const classBase = 'pfm-toast';
        let valType = this.type;

        let theme = (valType) ? ' pfm-toast_' + valType : ' pfm-toast_default';
        let iconColorVal = (valType === 'danger' || valType === 'success') ? 'inverse' : '';

        this.toastList.push({
            messageStr : this.messageStr,
            titleStr : this.titleStr,
            id : this.toastList.length,
            classes : classBase + theme,
            duration : 'transition-duration: ' + this.duration + 's',
            iconColor : iconColorVal

        });

		// Timeout to allow DOM to update
		setTimeout(() => {
		    this.show(this.toastList.length);
			this.autoHide(this.toastList.length);
		}, 1);
    }

    titleTheme() {
        switch (this.type) {
            case 'danger':
                this.titleStr = (this.title) ? this.title : 'Error';
                break;
            case 'warning':
                this.titleStr = (this.title) ? this.title : 'Warning';
                break;
            case 'success':
                this.titleStr = (this.title) ? this.title : 'Success';
                break;
            default:
                this.titleStr = (this.title) ? this.title : 'Notification';
        }
    }
}