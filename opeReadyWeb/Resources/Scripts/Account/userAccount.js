/// <reference name="MicrosoftAjax.js"/>

var userAccount = {
};


userAccount.Init = function () {
};


userAccount.DBAuthentication = function (userData) {
    try {
        PQ.Admin.WebService.PQWebService.DBAuthentication(userData, this.ExecuteCallbackResult, this.ExecuteFailResult);
    } catch (e) {
        alert(e);
    }
};
userAccount.ExecuteCallbackResult = function (result) {
    if (result) {
        $('#hidUserName').val(result.UserID);
        $('#hidLogIn').click();
    }
    else {
        $('#divError').css('visibility', 'visible');
        $('#txtPassword').val("");
        return false;
    }
};
userAccount.ExecuteFailResult = function (error) {
    $('#divError').css('visibility', 'visible');
    return false;
};

/// --------------------------------------------------
/// Page events processing
/// --------------------------------------------------

Sys.Application.add_load(applicationLoadHandler);
Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequestHandler);
Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(beginRequestHandler);

function applicationLoadHandler() {
    /// <summary>
    /// Raised after all scripts have been loaded and 
    /// the objects in the application have been created 
    /// and initialized.
    /// </summary>
    userAccount.Init();
}

function endRequestHandler(sender, args) {
    /// <summary>
    /// Raised before processing of an asynchronous 
    /// postback starts and the postback request is 
    /// sent to the server.
    /// </summary>

    // TODO: Add your custom processing for event
}

function beginRequestHandler() {
    /// <summary>
    /// Raised after an asynchronous postback is 
    /// finished and control has been returned 
    /// to the browser.
    /// </summary>
    // TODO: Add your custom processing for event
}