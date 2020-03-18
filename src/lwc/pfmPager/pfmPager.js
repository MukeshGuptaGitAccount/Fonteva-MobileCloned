import {LightningElement, api, track} from 'lwc';
import {fireChangeEvent} from 'c/actionutils';

export default class PfmPager extends LightningElement {

    @api numberOfPages;
    @api pageSize = 10;
    @api backend;

    @track classes;
    @track pageListToDisplay;
    @track firstButtonCssClasses;
    @track prevButtonCssClasses;
    @track nextButtonCssClasses;
    @track lastButtonCssClasses;
    currentPageNumber = 1;

    connectedCallback() {
        this.generatePageList();
        const classBase = 'pfm-pager';

        let valBackend = this.backend,
            backend;
        backend = (valBackend === true) ? '' : ' pfm-pager_portal';

        this.classes = classBase + backend;
    }

    updateButtonCssClasses() {
        this.firstButtonCssClasses = 'slds-is-relative' + (this.currentPageNumber <= 1 ? ' js-disabled' : '');
        this.prevButtonCssClasses = (this.currentPageNumber <= 1 ? 'js-disabled' : '');
        this.nextButtonCssClasses = (this.currentPageNumber >= this.numberOfPages ? 'js-disabled' : '');
        this.lastButtonCssClasses = 'slds-is-relative' + (this.currentPageNumber >= this.numberOfPages ? ' js-disabled' : '');
    }

    @api
    setCurrentPage(currentPageNumber) {
        this.currentPageNumber = currentPageNumber;
        this.generatePageList();
    }

    generatePageList() {
        let pageList = [];
        let maxedPages = 5;
        let pagesOnLeftCount = 0;
        let pagesOnRightCount = 0;

        for (let i = 1; i < maxedPages; i++) {
            if ((pagesOnLeftCount + pagesOnRightCount + 1 < maxedPages) && (this.currentPageNumber - pagesOnLeftCount - 1 > 0)) {
                pagesOnLeftCount++;
            }
            if ((pagesOnLeftCount + pagesOnRightCount + 1 < maxedPages) && (this.currentPageNumber + pagesOnRightCount < this.numberOfPages)) {
                pagesOnRightCount++;
            }
        }

        for (let i = pagesOnLeftCount; i > 0; i--) {
            pageList.push(this.buildPageListEntry(this.currentPageNumber - i));
        }

        pageList.push(this.buildPageListEntry(this.currentPageNumber));

        for (let i = 1; i <= pagesOnRightCount; i++) {
            pageList.push(this.buildPageListEntry(this.currentPageNumber + i));
        }
        this.pageListToDisplay = pageList;
        this.updateButtonCssClasses();
    }

    buildPageListEntry(pageNumber) {
        let isCurrentPage = this.currentPageNumber === parseInt(pageNumber);
        return {
            pageNumber: pageNumber, isCurrentPage: isCurrentPage
        }
    }

    switchToPage(evt) {
        this.currentPageNumber = parseInt(evt.currentTarget.dataset.page);
        this.fireChangePageEvent();
        this.generatePageList();
    }

    onNext() {
        if (this.currentPageNumber === parseInt(this.numberOfPages)) {
            return;
        }
        this.currentPageNumber++;
        this.fireChangePageEvent();
        this.generatePageList();
    }

    onPrev() {
        if (this.currentPageNumber === 1) {
            return;
        }
        this.currentPageNumber--;
        this.fireChangePageEvent();
        this.generatePageList();
    }

    onFirst() {
        this.currentPageNumber = 1;
        this.fireChangePageEvent();
        this.generatePageList();
    }

    onLast() {
        this.currentPageNumber = parseInt(this.numberOfPages);
        this.fireChangePageEvent();
        this.generatePageList();
    }

    fireChangePageEvent() {
        fireChangeEvent(this, 'pagechanged', {currentPage: this.currentPageNumber});
    }
}