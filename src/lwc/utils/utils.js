const parseToObject = (value) => {
    if (typeof value === 'string' || value instanceof String) {
        value = JSON.parse(value);
    }
    if (value == null) {
        value = {};
    }
    return value;
};

const fireChangeEvent = (cmp,name,value) => {
    const changeEvent = new CustomEvent(name, {
        detail: value
    });
    cmp.dispatchEvent(changeEvent);
};

const cloneDeep = (value) => {
    return JSON.parse(JSON.stringify(value));
};

const generateId = (len) => {
    let text = "";
    let possible = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";

    for( let i=0; i < len; i++ ) {
        text += possible.charAt(Math.floor(Math.random() * possible.length));
    }

    return text;
};

const cleanName = (name) => {
    return name.replace(/[^A-Z0-9]+/ig, "_");
};

const isValidUrl = (val) => {
    if(/^(?:https:\/\/)?[\w.-]+(?:\.[\w\.-]+)+[\w\-\._~:\/?#[\]@!\$&\(\)\*\+,;=.]+$/i.test(val)){
        return true;
    }
    return false;
};

const valueProvided = (val) => {
    if (val == null) {
        return false;
    }
    return true;
};

const setValueInObj  = (valueObj,params) => {
    valueObj[params.field] = params.value;
    return valueObj;
};

const addSitePrefix =(url) => {
    let systemPrefixes = ['apex', 's', 'one', 'profile','lightning'];
    let systemPrefix = false;
    let pathSegments = window.location.pathname.split('/');
    //if first element of the current path is not to be ignored, then it's a site prefix
    systemPrefixes.forEach(function (prefix) {
        if (pathSegments[1] === prefix) {
            systemPrefix = true;
        }
    });

    if (systemPrefix) {
        return url;
    }
    else if (pathSegments.length >= 3) {
        if (pathSegments[1] !== '') {
            return '/' + pathSegments[1] + url;
        }
    }
    return url;
};

export { parseToObject,fireChangeEvent,cloneDeep,generateId,cleanName,valueProvided,isValidUrl,setValueInObj,addSitePrefix };