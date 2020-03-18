import {LightningElement, api, track} from 'lwc';
import {fireChangeEvent, cloneDeep, updateElementInArray} from 'c/actionutils';
import {registerListener, unregisterAllListeners} from 'c/pubsub';

import {loadStyle} from 'lightning/platformResourceLoader';
import BASE from '@salesforce/resourceUrl/PFM_Base';

export default class PfmTable extends LightningElement {
    @api columns;
    @api tableData;
    @api name;
    @api selectedRows = [];
    @api keyField;
    @api showPager = false;
    @api pageSize = 100;
    @api numberOfRecords;
    @api showRowNumberColumn = false;
    @api suppressBottomBar = false;
    @api hideCheckboxColumn = false;
    @api resizeColumnDisabled = false;
    @api allDataProvided = false;
    @api sortedBy;
    @api sortedDirection = 'asc';
    @api defaultSortDirection = 'asc';
    @api errors;
    @api sortWithCurrentData = false;
    @api backend = false;
    @track draftValues = [];
    @track loading = false;
    @track tablePagedData;
    @track numberOfPages;
    @api maxRowSelection;
    dataSet = false;
    currentPage = 0;
    localDraftValues = [];

    @api readOnly; // boolean. default: false

    connectedCallback() {
        this.loadDependentStyles()
        registerListener(
            'ClearDraftValues',
            this.handleClearDraftValues,
            this
        );

        registerListener(
            'DatatablePicklistChanged',
            this.handleDatatablePicklistChanged,
            this
        );
    }

    get showPageSet() {
        return this.showPager && this.numberOfPages != null && this.numberOfPages > 1;
    }

    @api
    selectRows(selectedRows) {
        this.selectedRows = selectedRows;
    }

    @api
    setErrors(errors) {
        this.errors = errors;
    }

    @api
    updateTableDataOnly(tableData) {
        this.updateTableData(tableData, null);
    }

    @api
    updateTableData(tableData, currentPage, sortBy, sortDirection) {
        if (sortBy) {
            this.sortedBy = sortBy;
        }
        if (sortDirection) {
            this.sortedDirection = sortDirection;
        }
        if (currentPage != null && currentPage > 0) {
            currentPage--;
            this.currentPage = currentPage;
        }
        if (tableData == null || (tableData && tableData.length === 0)) {
            this.tablePagedData = [];
            this.tableData = [];
            this.calculatePages(0);
            return;
        }
        this.dataSet = false;
        this.tableData = cloneDeep(tableData);
        this.processData();
        if (this.showPageSet && currentPage != null) {
            currentPage++;
            const cPager = this.template.querySelector('c-pfm-pager');
            if(cPager) {
                cPager.numberOfPages = this.numberOfPages;
                cPager.setCurrentPage(currentPage);
            }
        }
    }

    renderedCallback() {
        if (this.dataSet) {
            return;
        }
        this.processData();
        if (this.readOnly) {
            this.template.querySelector('.pfm-table').classList.add('js-read-only')
        }
    }

    processData() {
        if (this.tableData != null && this.tableData.length > 0) {
            if (this.numberOfRecords != null) {
                this.calculatePages(this.numberOfRecords);
            } else if (this.allDataProvided) {
                this.calculatePages(this.tableData.length);
            }
            if (!this.allDataProvided) {
                this.dataSet = true;
                this.tablePagedData = this.tableData;
            } else if (this.allDataProvided) {
                this.dataSet = true;
                let splicedData = cloneDeep(this.tableData);
                this.tablePagedData = splicedData.splice(this.currentPage, this.pageSize);
            }
        }
    }

    calculatePages(numberOfRecords) {
        let pages = (numberOfRecords / this.pageSize);
        this.numberOfPages = parseInt((numberOfRecords % this.pageSize) === 0 ? pages : pages + 1);
    }

    disconnectedCallback() {
        unregisterAllListeners(this);
    }

    handleRowAction(evt) {
        fireChangeEvent(this, 'rowaction', {actionName: evt.detail.action.name, row: evt.detail.row});
    }

    handleSaveAction(evt) {
        this.loading = true;
        const recordInputs = evt.detail.draftValues.slice().map(draft => {
            const fields = Object.assign({}, draft);
        return {fields};
    });
        fireChangeEvent(this, 'saveaction', {values: recordInputs});
    }

    handleSortAction(evt) {
        let sortParams = {
            fieldName: evt.detail.fieldName,
            sortDirection: evt.detail.sortDirection
        };
        if (this.sortWithCurrentData) {
            let newSortDirection = '';
            if (this.sortedBy === sortParams.fieldName) {
                if (this.sortedDirection === 'asc') {
                    newSortDirection = 'desc';
                } else {
                    newSortDirection = this.defaultSortDirection;
                }
            } else {
                newSortDirection = this.sortedDirection;
            }
            let sortDir = newSortDirection === 'asc' ? 1 : -1;
            let tableDataCloned = cloneDeep(this.tableData);
            tableDataCloned.sort(
                function (a, b) {
                    return a[sortParams.fieldName] > b[sortParams.fieldName] ? sortDir : -sortDir;
                });
            this.updateTableData(tableDataCloned);
            this.sortedDirection = newSortDirection;
            this.sortedBy = sortParams.fieldName;
            this.template.querySelector('c-pfm-pager').setCurrentPage(1);
        }
        else {
            fireChangeEvent(this, 'sortaction', sortParams);
        }
    }

    handleClearDraftValues(evt) {
        if (this.name === evt.name) {
            this.draftValues = [];
            this.localDraftValues = [];
            this.loading = false;
        }
    }

    @api
    toggleLoading() {
        this.loading = false;
    }

    pageChanged(evt) {
        let currentPage = parseInt(evt.detail.currentPage);
        if (currentPage > 0) {
            currentPage--;
        }
        if (this.allDataProvided) {
            this.dataSet = true;
            let splicedData = cloneDeep(this.tableData);
            let currentPageSize = parseInt(this.pageSize);
            this.tablePagedData = splicedData.splice(currentPage * currentPageSize, currentPageSize);
        } else {
            fireChangeEvent(this, 'pagechanged', {currentPage: currentPage});
            this.dataSet = false;
            this.loading = true;

        }
    }

    handleDatatablePicklistChanged(evt) {
        if (evt.name === this.name) {
            let draftObject = {};
            draftObject[this.keyField] = evt.key;
            draftObject[evt.fieldName] = evt.value;
            if (this.draftValues == null) {
                this.draftValues = [];
            }
            this.localDraftValues = updateElementInArray(this.localDraftValues, draftObject, this.keyField);
            this.draftValues = cloneDeep(this.localDraftValues);
        }
    }

    handleCancelAction() {
        this.handleClearDraftValues({name: this.name});
    }

    handleCellChange(evt) {
        let self = this;
        cloneDeep(evt.detail.draftValues).forEach(function (element) {
            self.localDraftValues = updateElementInArray(self.localDraftValues, element, self.keyField);
        });
    }

    handleRowSelection(evt) {
        fireChangeEvent(this, 'rowselection', {selectedRows: evt.detail.selectedRows});
    }

    loadDependentStyles(){
        if (!window.pfmTableStylesLoaded) {
            loadStyle(this, BASE + '/css/component/table/table.css');
            window.pfmTableStylesLoaded = true;
        }
        if (!window.pfmTableReadOnlyStylesLoaded && this.readOnly) {
            loadStyle(this, BASE + '/css/component/table/table-read-only.css');
            window.pfmTableReadOnlyStylesLoaded = true;
        }
    }
}