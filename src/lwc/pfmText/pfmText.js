import { LightningElement, api, track } from 'lwc';

import PFM_Base from 'c/pfmBase';

export default class Text extends PFM_Base {
    @api type; // header, body, label
    @api weight; // light, medium, bold
    @api align; // left, center, right
    @api transform; // lowercase, uppercase, capitalize
    @api color; // danger, warning, success, default, detail, brand, link
    @api size; // xx-small, x-small, small, medium, large, x-large
    @api inline; // changes display to inline block
    @api required; // only works when type is label
    @api text;

    @track classes;

    @track isHeader;
    @track isH1;
    @track isH2;
    @track isH3;
    @track isH4;
    @track isH5;
    @track isH6;

    @track isLabel;

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
		super.connectedCallback('pfm-text');

        this.isHeader = this.type === 'heading';
        this.isLabel = this.type === 'label';

        const valWeight = this.weight,
            valColor = this.color,
            valAlign = this.align,
            valSize = this.size,
            valTransform = this.transform,
            valInline = this.inline;

        let align,
            transform,
            color,
            weight,
            size,
            inline,
            base;

        if (this.isHeader) {
            switch (valSize) {
                case 'x-large' :
                    this.isH1 = true;
                    break;
                case 'large' :
                    this.isH2 = true;
                    break;
                case 'medium' :
                    this.isH3 = true;
                    break;
                case 'small' :
                    this.isH4 = true;
                    break;
                case 'x-small' :
                    this.isH5 = true;
                    break;
                case 'xx-small' :
                    this.isH6 = true;
                    break;
                default:
                    this.isH2 = true;
            }
        }

        if (this.isHeader) {
            weight = (valWeight) ? ' pfm-font-weight_' + valWeight : ' pfm-font-weight_bold';
            size = (valSize) ? ' pfm-text-heading_' + valSize : ' pfm-text-heading_small';
        } else {
            weight = (valWeight) ? ' pfm-font-weight_' + valWeight : '';
            size = (valSize) ? ' pfm-text-body_' + valSize : ' pfm-text-body_small';
        }

        transform = (valTransform) ? ' pfm-text-transform_' + valTransform : '';
        color =  (valColor) ? ' pfm-text-color_' + valColor : '';
        align =  (valAlign) ? ' slds-text-align_' + valAlign : '';

        inline = (valInline) ? ' pfm-text_inline' : '';


        this.classes = this.classStr +
					   size +
					   align +
					   weight +
					   color +
					   transform +
					   inline;
    }
}