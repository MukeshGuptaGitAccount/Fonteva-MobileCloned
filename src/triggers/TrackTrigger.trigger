trigger TrackTrigger on EventApi__Track__c (before insert, before update, before delete, after insert, after update, after delete) {
    Framework.Dispatcher.dispatchTrigger();
}