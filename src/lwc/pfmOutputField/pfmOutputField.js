import {LightningElement, api, track} from 'lwc';
import currency from './currency.html'
import phone from './phone.html'
import email from './email.html'
import richtext from './richtext.html'
import url from './url.html'
import percent from './percent.html'
import date from './date.html'
import number from './number.html'
import time from './time.html'
import string from './string.html'

export default class PfmOutputField extends LightningElement {

    @api
    value;
    @api
    type;
    @api
    currencyIsoCode = 'USD';
    @api
    isMultiCurrencyOrg = false;
    @api
    options;

    @track
    currencySymbolType = 'symbol';
    @track
    isNegative = false;

    @track dateOptions = {};
    @track dateOptionYear = 'numeric';
    @track dateOptionMonth = 'numeric';
    @track dateOptionDay = 'numeric';

    prevRenderedCallbackVal;

    connectedCallback() {
        if (this.type != null) {
            switch (this.type.toLowerCase()) {
                case 'date':
                    this.options;
                    if (this.options) {
                        this.dateOptions = {
                            year: this.options.year ? this.options.year : 'numeric',
                            month: this.options.month ? this.options.month : 'numeric',
                            day: this.options.day ? this.options.day : 'numeric'
                        }
                    }
                    break;
            }
        }
    }

    renderedCallback() {
        if (this.prevRenderedCallbackVal != this.value) {
            if (this.type != null) {
                switch (this.type.toLowerCase()) {
                    case 'currency':
                        if (this.isMultiCurrencyOrg) {
                            this.currencySymbolType = 'name'
                        }
                        if (this.value != null && this.value < 0) {
                            this.value = this.value * -1;
                            this.isNegative = true;
                        }
                        else if(this.isNegative) {
                            this.isNegative = false;
                        }
                        break;
                }
            }
            this.prevRenderedCallbackVal = this.value;
        }
    }

    render() {
        if (this.type != null) {
            switch (this.type.toLowerCase()) {
                case 'currency':
                    return currency;
                case 'phone':
                    return phone;
                case 'email':
                    return email;
                case 'richtext':
                    return richtext;
                case 'url':
                    return url;
                case 'percent':
                    return percent;
                case 'date':
                    return date;
                case 'integer':
                case 'double':
                case 'long':
                    return number;
                case 'time':
                    return time;
                default:
                    return string;
            }
        }
        return string;
    }
}