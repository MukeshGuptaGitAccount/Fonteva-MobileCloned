({
    handleClick : function(component, event, helper) {
        component.set('v.showSpinner',true);
        var communityId =component.find('picklistInput').get('v.value');
        var guideName =component.find('textInput').get('v.value');
        var guideDescription =component.find('guideDes').get('v.value');
        var guideName = guideName.trim();
        var guideDescription = guideDescription.trim();
        if(communityId != ''){
            if(guideName.length != 0){
                if(guideDescription.length !=0){
                    var action = component.get("c.createGuide_Membership");
                    action.setParams({
                        communitySiteId : communityId,
                        guideName : guideName,
                        guideDescription :guideDescription
                    });
                    action.setCallback(this, function(response) {
                        var state = response.getState();
                        if (state === "SUCCESS") {
                            component.set('v.showSpinner',false);
                            component.find('button').stopIndicator();
                            component.find('toastMessages').showMessage('',$A.get("$Label.c.Guide_Created"),false,'success');
                            helper.getSites(component, event, helper);
                            component.find('textInput').set('v.value',null);
                            component.find('guideDes').set('v.value',null);
                        }
                        else {      
                            component.set('v.showSpinner',false);
                            component.find('button').stopIndicator();
                            component.find('toastMessages').showMessage('',$A.get("$Label.c.Error_Creating_Guide"),false,'error');
                        }
                    }); 
                    $A.enqueueAction(action);
                }else{
                    component.set('v.showSpinner',false);
                    component.find('button').stopIndicator();
                    component.find('toastMessages').showMessage('',$A.get("$Label.c.Provide_Description"),false,'error');
                }
                
            }else{
                component.set('v.showSpinner',false);
                component.find('button').stopIndicator();
                component.find('toastMessages').showMessage('',$A.get("$Label.c.Provide_Guide_Name"),false,'error');
                
            }
        }else{
            component.set('v.showSpinner',false);
            component.find('button').stopIndicator();
            component.find('toastMessages').showMessage('',$A.get("$Label.c.Select_Community_Site"),false,'error');
            
        } 
    },
    doInit : function(component, event, helper) {
        helper.getSites(component, event, helper);
    }
})