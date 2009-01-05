

function ajaxUpdate(target,web,method,argIds) {

    $(target).innerHTML = '<h2>Working... </h2>';
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

    $(target).innerHTML = '<h4>Loading... </h4>';
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


