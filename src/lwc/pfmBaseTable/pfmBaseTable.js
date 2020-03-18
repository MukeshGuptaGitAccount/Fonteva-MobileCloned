import LightningDatatable from 'lightning/datatable';
import pfmBaseTableCurrency from './pfmBaseTableCurrency.html';
import customActionButtonHtml from './customActionButton.html';

export default class PfmBaseTable extends LightningDatatable {
    static customTypes = {
        fonCurrency: {
            template: pfmBaseTableCurrency,
            // Provide template data here if needed
            typeAttributes: ['currencyIsoCode', 'isMultiCurrencyOrg', 'isLeftAligned'],
        },
        customActionButton: {
            template: customActionButtonHtml,
            typeAttributes: ['actionButtonAttributes'],
        }
    };
}