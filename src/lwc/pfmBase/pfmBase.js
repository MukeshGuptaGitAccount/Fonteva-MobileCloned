import { LightningElement, api, track } from 'lwc';

export default class PfmBase extends LightningElement {

/**
 *  padding="direction:size"
 *      - direction: top, right, bottom, left, horizontal, vertical, around
 *      - size: xx-small, x-small, small, medium, large, x-large
 *
 *  to provide multiple values, separate with a ','
 *      - padding="top:small, right:large"
 */

    @api
    get padding(){
        return this.paddingStr;
    }
    set padding(value){
        this.paddingStr = value
    }

/**
 *  margin="direction:size"
 *      - direction: top, right, bottom, left, horizontal, vertical, around
 *      - size: xx-small, x-small, small, medium, large, x-large
 *
 *  to provide multiple values, separate with a ','
 *      - margin="top:small, right:large"
 */
    @api
    get margin(){
        return this.marginStr;
    }
    set margin(value){
        this.marginStr = value;
    }

	@track paddingStr;
	@track marginStr;

	@api showAt; // small, medium, large
	@api hideAt; // small, medium, large

	@track classStr;

	connectedCallback(targetComponent) {
	    this.paddingValues();
	    this.marginValues();
		let valPadding = this.paddingStr,
			valMargin = this.marginStr;

		let padding,
			margin;

		padding = (valPadding) ? ' ' + valPadding : '';
		padding = (padding.indexOf(',') > -1) ? padding.replace(',', '') : padding;

		margin = (valMargin) ? ' ' + valMargin : '';
		margin = (margin.indexOf(',') > -1) ? margin.replace(',', '') : margin;

		let show = (this.showAt) ? ' slds-show_' + this.showAt : '';
		let hide = (this.hideAt) ? ' slds-hide_' + this.hideAt : '';

		this.classStr = targetComponent + padding + margin + show + hide;
	}
	renderedCallback(targetComponent) {
	    switch(this.theme){
			case 'shade':
				this.themeRender(targetComponent, 'shade');
				break;
			case 'shade-dark':
				this.themeRender(targetComponent, 'shade-dark');
				break;
			case 'success':
				this.themeRender(targetComponent, 'success');
				break;
			case 'brand':
				this.themeRender(targetComponent, 'brand');
				break;
			case 'danger':
				this.themeRender(targetComponent, 'danger');
				break;
		}
 	}

 	themeRender(targetComponent, theme){
		this.querySelectorAll('.' + targetComponent + '-theme_' + theme + ' c-pfm-button').forEach(function(b){
			b.classList.add('pfm-theme_' + theme);
		});
		this.querySelectorAll('.' + targetComponent + '-theme_' + theme + ' c-pfm-text').forEach(function(t){
			t.classList.add('pfm-theme_' + theme);
		});
	}

	paddingValues() {
		this.paddingMethod('top:', 'slds-p-top_');
		this.paddingMethod('bottom:', 'slds-p-bottom_');
		this.paddingMethod('left:', 'slds-p-left_');
		this.paddingMethod('right:', 'slds-p-right_');
		this.paddingMethod('horizontal:', 'slds-p-horizontal_');
		this.paddingMethod('vertical:', 'slds-p-vertical_');
		this.paddingMethod('around:', 'slds-p-around_');
	}
	paddingMethod (value, replace) {
		if (this.paddingStr) {
			if (typeof this.paddingStr === 'boolean') {
				this.paddingStr = 'slds-p-horizontal_small';
			} else if (typeof this.paddingStr === 'string' && this.paddingStr.indexOf(value) > -1) {
				this.paddingStr = this.paddingStr.replace(value, replace);
			}
		}
	}
	marginValues() {
		this.marginMethod('top:', 'slds-m-top_');
		this.marginMethod('bottom:', 'slds-m-bottom_');
		this.marginMethod('left:', 'slds-m-left_');
		this.marginMethod('right:', 'slds-m-right_');
		this.marginMethod('horizontal:', 'slds-m-horizontal_');
		this.marginMethod('vertical:', 'slds-m-vertical_');
		this.marginMethod('around:', 'slds-m-around_');
	}
	marginMethod (value, replace) {
		if (this.marginStr) {
			if (typeof this.marginStr === 'boolean') {
				this.marginStr = 'slds-m-horizontal_small';
			} else if (typeof this.marginStr === 'string' && this.marginStr.indexOf(value) > -1) {
				this.marginStr = this.marginStr.replace(value, replace);
			}
		}
	}
}