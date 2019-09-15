var rowCount;
var userSearch = {};
userSearch.Init = function () { };

userSearch.CreateUserCollectionGrid = function (userInfo) {
    var _langDir;
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            _langDir = "rtl";
        else
            _langDir = "ltr";
    }
    $('#divResultPanel').block({
        css: { border: '0px' },
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    $("#tblUserDetailsGrid").jqGrid({
        direction: _langDir,
        datatype: function (pdata) { userSearch.getUserCollectionData(); },
        height: 375,
        colNames: [

                    $('#hidUserSearch_Grid_UserName').text(),
                    $('#hidUserSearch_Grid_FirstName').text(),
                    $('#hidUserSearch_Grid_LastName').text(),
                    $('#hidUserSearch_Grid_User_OrganizationID').text(),
                    $('#hidUserSearch_Grid_UserEmail').text(),
                    '', '', 'UserID'],
        colModel: [
                    { name: 'UserName', index: 'UserName', sortable: true, sorttype: 'text', width: 120 },
                    { name: 'User_FirstName', index: 'User_FirstName', sortable: true, sorttype: 'text', width: 120 },
               		{ name: 'User_LastName', index: 'User_LastName', sorttype: 'int', sortable: true, align: 'center', width: 120 },
                    { name: 'User_OrganizationID', index: 'User_OrganizationID', sortable: true, sorttype: 'text', width: 180 },
               		{ name: 'User_Email', index: 'User_Email', sortable: true, sorttype: 'int', align: 'center', width: 150 },
                    { name: 'EditUser', index: 'EditUser', sortable: false, edittype: 'image', formatter: editFormatter, width: 35, align: 'center' },
                    { name: 'DelUser', index: 'DelUser', sortable: false, edittype: 'image', formatter: deleteSpecFormatter, width: 45, align: 'center' },
                    { name: 'UserID', hidden: 'true' }
               	],
        viewrecords: true,
        autoencode: false,
        rowNum: 10000,
        loadonce: true,
        altRows: false,
        hoverrows: false,
        pager: '#pgrUserDetailsGrid',
        recordpos: 'left',
        pgbuttons: false,
        pginput: false,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
            if (rowCount == $(this).getGridParam('records')) {
                $("#waitplease").css({ 'display': 'none' });
                $('#divResultPanel').unblock();
                rowCount = 0;
            }
        },
        onCellSelect: function (rowid, iCol, cellcontent, e) {
            switch (iCol) {
                case 5:
                    userSearch.DefineUserCollection_Open($(this).getRowData(rowid).UserID);
                    break;
                case 6:
                    if ($(this).getRowData(rowid).UserID != "1")
                        return userSearch.DefineUserCollection_Delete($(this).getRowData(rowid).UserID);
                    break;
            }
            return false;
        },
        ondblClickRow: function (rowid, iRow, iCol, e) {
            userSearch.DefineUserCollection_Open($(this).getRowData(rowid).UserID);
        }
    });
};

userSearch.getUserCollectionData = function () {
    var userInfo = {
        UserID: $("#txtUserID").val() == "" ? 0 : $("#txtUserID").val(),
        UserName: $("#txtUserName").val(),
        User_FirstName: $("#txtFirstName").val(),
        User_LastName: $("#txtLastName").val()
    };
    PQ.Admin.WebService.UserProfileService.User_SelectAll(userInfo,
            function (data, textStatus) {                
                userSearch.ReceivedUserCollectionData(JSON.parse(getMain(data)).rows);
            }, function (data, textStatus) {
                return false;
            });
};

userSearch.ReceivedUserCollectionData = function (data) {
    var thegrid = $("#tblUserDetailsGrid");
    thegrid.clearGridData();
    rowCount = data.length;
    if (!rowCount) { $('#divResultPanel').unblock(); setTimeout(function () { $("#waitplease").css({ 'display': 'none' }); }, 500); }
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
};

function deleteSpecFormatter(ellvalue, options, rowObject) {
    var img;
    try {
        img = new Image(32, 32);
        if (rowObject.UserID!="1") {
            $(img).attr("src", "/opeReady/Resources/icons/trash.png");
            $(img).attr("style", "cursor:pointer");
        }
        else {
            $(img).attr("src", "/opeReady/Resources/images/empty.png");
        }
    } catch (e) { }
    return img.outerHTML || new XMLSerializer().serializeToString(img);
}

userSearch.DefineUserCollection_Open = function (userID) {
    if (userID) {
        $("#waitplease").css({ 'display': 'block' });
        window.location.href = "Users.aspx?usid=" + userID;
    }
}



userSearch.SetUserNameArray = function (result) {
    try {
        $("#txtUserName").autocomplete({
            source: function (request, response) {
                PQ.Admin.WebService.UserProfileService.GetUserNameList(request.term,
                  function (data) {
                      if (data) {
                          response($.map(getMain(data), function (item) {
                              return {
                                  value: item.UserName
                              }
                          }))
                      };
                  },
                    function (e) {
                    },
                    null);
            }, minLength: 1
        });
    } catch (e) {
        return false;
    }
};
userSearch.SetUserFirstNameArray = function (result) {
    try {
        $("#txtFirstName").autocomplete({
            source: function (request, response) {
                PQ.Admin.WebService.UserProfileService.GetUserFirstNameList(request.term,
                  function (data) {
                      if (data) {
                          response($.map(getMain(data), function (item) {
                              return {
                                  value: item.User_FirstName
                              }
                          }))
                      };
                  },
                    function (e) {
                    },
                    null);
            }, minLength: 1
        });
    } catch (e) {
        return false;
    }
};
userSearch.SetUserLastNameArray = function (result) {
    try {
        $("#txtLastName").autocomplete({
            source: function (request, response) {
                PQ.Admin.WebService.UserProfileService.GetUserLastNameList(request.term,
                  function (data) {
                      if (data) {
                          response($.map(getMain(data), function (item) {
                              return {
                                  value: item.User_LastName
                              }
                          }))
                      };
                  },
                    function (e) {
                    },
                    null);
            }, minLength: 1
        });
    } catch (e) {
        return false;
    }
};



userSearch.DefineUserCollection_Delete = function (userID) {
    $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
        open: function (type, data) {
            $(this).parent().appendTo("form");
        },
        buttons: {
            Ok: function (e) {
                e.preventDefault();
                try {
                    PQ.Admin.WebService.UserProfileService.UserDetails_Delete(userID,
                    function (result) {
                        if (result) {
                            $("#waitplease").css({ 'display': 'block' });
                            $("#tblUserDetailsGrid").GridUnload();
                            userSearch.CreateUserCollectionGrid();
                            $('#ConfirmDeleteAttachment').dialog('destroy');
                        }
                    }, this.ExecuteFailResult);
                } catch (e) {
                    return false;
                }
                return false;
            },
            Cancel: function (e) {
                e.preventDefault();
                $(this).dialog('destroy');
                return false;
            }
        }
    });
    return false;
};

/// --------------------------------------------------
Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequestHandler);
Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(beginRequestHandler);

function endRequestHandler(sender, args) {

}

function beginRequestHandler() {

}