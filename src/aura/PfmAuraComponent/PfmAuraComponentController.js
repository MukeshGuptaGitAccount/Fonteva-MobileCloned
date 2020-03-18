({
    doInit : function(component, event, helper) { 
       component.set("v.loadSpinner",true);  
        var action = component.get("c.getUIThemeDescription");
        action.setParams({
        }); 
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if (state === "SUCCESS") {
                var uiTheme = response.getReturnValue();
                component.set("v.uiTheme",uiTheme);
            }
        });
        $A.enqueueAction(action) 
        
        var action = component.get("c.getCustomSetting");
        action.setParams({
        }); 
        action.setCallback(this, function(response){
            var state = response.getState(); 
            if (state === "SUCCESS") {
                var customSettingObj = response.getReturnValue();
                var theme = component.get("v.uiTheme");
               
                if(theme =='Theme4d'){
                   
                    if(customSettingObj.MobileApi__Is_Admin_Guidebook__c){
                        component.set("v.loadSpinner",false);
                        component.set("v.isLightning",true); 
                        component.set("v.isClassic",false);
                        component.set("v.GuidebookModal",true); 
                        component.set("v.AdminModal",false);    
                    }else{
                        component.set("v.loadSpinner",false);
                        component.set("v.isLightning",true); 
                        component.set("v.isClassic",false);
                        component.set("v.AdminModal",true);
                        component.set("v.GuidebookModal",false); 
                    }
                }else{
                    
                    if(customSettingObj.MobileApi__Is_Admin_Guidebook__c){
                        component.set("v.loadSpinner",false);
                        component.set("v.isLightning",false); 
                        component.set("v.isClassic",true);
                        component.set("v.GuidebookModal",true); 
                        component.set("v.AdminModal",false);    
                    }else{
                        component.set("v.loadSpinner",false);
                        component.set("v.isLightning",false); 
                        component.set("v.isClassic",true);
                        component.set("v.AdminModal",true);
                        component.set("v.GuidebookModal",false); 
                    }
                }
            }
            else
            {
                alert("Failed");
            }
        });
        
        $A.enqueueAction(action)  
    },
    closeModalWindow  : function(component, event, helper) {
        var theme = component.get("v.uiTheme");   
        if(theme =='Theme4d'){
            var dismissActionPanel = $A.get("e.force:closeQuickAction");
            dismissActionPanel.fire();  
        }else{
            var btn =  event.getParam("payload");
            var msgMethod = component.get("v.vfMsgMethod");
            msgMethod(btn.label, function(){
                //handle callback
            });
        }
        
    },
    refreshView: function(component, event) {
        $A.get('e.force:refreshView').fire();
    },
    
})