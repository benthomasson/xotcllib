

function ajaxUpdate(target,web,method,argIds) {

    $(target).innerHTML = '<img src="/images/spinner.gif">';
    var submit;
    submit = web + '?method=' + method;
    for (var arg in argIds) {
        submit += '&' + arg + "=" + $(argIds[arg]).value;
    }

    new Ajax.Updater(target,submit, {
    method: 'get',
    evalScripts: true
    });
}


function ajaxLoad(target,web,method,argIds) {

    $(target).innerHTML = '<img src="/images/spinner.gif">';
    var submit;
    submit = web + '?method=' + method;
    for (var arg in argIds) {
        submit += '&' + arg + "=" + argIds[arg];
    }

    new Ajax.Updater(target,submit, {
    method: 'get',
    evalScripts: true
    });
}


function ajaxLoadSilent(target,web,method,argIds) {

    var submit;
    submit = web + '?method=' + method;
    for (var arg in argIds) {
        submit += '&' + arg + "=" + argIds[arg];
    }

    new Ajax.Updater(target,submit, {
    method: 'get',
    evalScripts: true
    });
}


function ajaxLoadSilentAppend(target,web,method,argIds) {

    var submit;
    submit = web + '?method=' + method;
    for (var arg in argIds) {
        submit += '&' + arg + "=" + argIds[arg];
    }

    new Ajax.Updater(target,submit, {
    method: 'get',
    evalScripts: true,
    insertion: Insertion.Bottom
    });
}


function ajaxWidgetCall(target,web,widget,widgetMethod,argIds) {

    var submit;
    submit = web + '?method=processWidget';
    submit += '&id=' + widget;
    submit += '&widgetMethod=' + widgetMethod;
    for (var arg in argIds) {
        submit += '&' + arg + "=" + argIds[arg];
    }

    new Ajax.Updater(target,submit, {
    method: 'get',
    evalScripts: true
    });
}


function ajaxWidgetAction(target,web,widgetMethod,argIds) {

    var submit;
    submit = web + '?method=processWidget';
    submit += '&id=' + target;
    submit += '&widgetMethod=' + widgetMethod;
    for (var arg in argIds) {
        submit += '&' + arg + "=" + argIds[arg];
    }

    new Ajax.Request(submit, {
    method: 'get'
    });
}

function ajaxSimple(target,web,method) {

    $(target).innerHTML = '<img src="/images/spinner.gif">';
    var submit;
    submit = web + '?method=' + method;

    new Ajax.Updater(target,submit, {
    method: 'get',
    evalScripts: true
    });
}

