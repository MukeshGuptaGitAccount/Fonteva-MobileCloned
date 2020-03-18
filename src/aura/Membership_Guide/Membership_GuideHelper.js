({
    getSites : function(component, event, helper) {
        var action = component.get("c.getSite");
        action.setParams({
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var results = response.getReturnValue();
                var siteNames = [];
                for(var i=0; i<results.length;i++){
                    siteNames.push(results[i]);
                }
                component.set('v.sitesName',siteNames); 
            }
        });
        $A.enqueueAction(action);
    }
    
})