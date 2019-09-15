/// <reference path="../Common/jquery-1.5.2.js" />
/// <reference path="../Common/jquery.jstree.js" />
/// <reference path="~/Resources/Scripts/Common/jquery.common.js" />
var profile = {};

profile.Init = function () {
    profile.GetDataForUserForm();
};

profile.GetDataForUserForm = function () {
    var qPram = getArgs();
    if (qPram.usid) {
        PQ.Admin.WebService.UserProfileService.UserDetails_Select(qPram.usid,
        function (data) {
            profile.PopulateUserForm(data);
        },
        function (e) { });
    }
    else {
        $("#btnSaveUserData").val($("#hidUserProfile_btnAdd").text());
    }
}

profile.PopulateUserForm = function (data) {
    var trainingEventTypeOptions = '', subQualificationTypeOptions = '';
    if (data) {
        $("#txtUserID").val(data.UserID);
        $("#txtFirstName").val(data.User_FirstName);
        $("#txtLastName").val(data.User_LastName);
        $("#txtUserName").val(data.UserName);
        $("#txtOrganizationID").val(data.User_OrganizationID);
        $("#txtEmail").val(data.User_Email);
        $("#txtSMSNum").val(data.User_SMSNum);
        $("#txtDomainID").val(data.User_DomainID);
        $("#btnSaveUserData").val($("#hidUserProfile_btnUpdate").text());
        if (data.IsReadinessMail) $("#chkIsReadinessMail").attr("checked", true);
        if (data.IsAdministrativeMail) $("#chkIsAdministrativeMail").attr("checked", true);
        if (data.IsIncompleteParameterMail) { $("#chkIsIncompleteParameterMail").attr("checked", true); } //$("#btnIsComplianceTaskAlert").fadeIn();
        if (data.IsAssetManagementMail) { $("#chkIsAssetMngMail").attr("checked", true); } //$("#btnIsAdminTaskAlert").fadeIn();
        if (data.IsComplianceTaskAlert) { $("#chkSendComplTaskAlert").attr("checked", true);  $("#btnIsComplianceTaskAlert").fadeIn();}
        if (data.IsAdminTaskAlert) { $("#chkSendAdminTaskAlert").attr("checked", true);  $("#btnIsAdminTaskAlert").fadeIn();}
        $.each(data.TrainigEventTypes, function (name, hash) {
            trainingEventTypeOptions += "<div>";
            trainingEventTypeOptions += '<input type="checkbox" value=' + hash.TrainingEventType_ID + ' id="checkbox-' + hash.TrainingEventType_ID + '" class="" />';
            trainingEventTypeOptions += '<label for="checkbox-' + hash.TrainingEventType_ID + '">' + hash.TrainingEventType_Name + '</label></div>';
        });
        $('#divCompliance').empty().append(trainingEventTypeOptions);
        $.each(data.SubQualificationTypes, function (name, hash) {
            subQualificationTypeOptions += "<div>";
            subQualificationTypeOptions += '<input type="checkbox" value=' + hash.SubQualificationType_ID + ' id="adminCheckbox-' + hash.SubQualificationType_ID + '" class="" />';
            subQualificationTypeOptions += '<label for="adminCheckbox-' + hash.SubQualificationType_ID + '">' + hash.SubQualificationType_Name + '</label></div>';
        });
        $('#divAdmin').empty().append(subQualificationTypeOptions);

        $.each(data.SelectedTrainingEventTypeIDs, function (name, hash) {
            $("#checkbox-" + hash).attr('checked', true);
        });
        $.each(data.SelectedSubQualificationTypeIDs, function (name, hash) {
            $("#adminCheckbox-" + hash).attr('checked', true);
        });

        $("#waitplease").css({ 'display': 'none' });
    }
};

profile.SaveUserData = function () {
    var params = getArgs();
    var usQty = $("#hidUs").val();
    var userData = {
        UserID: params.usid == undefined ? 0 : params.usid,
        User_FirstName: $("#txtFirstName").val(),
        User_LastName: $("#txtLastName").val(),
        UserName: $("#txtUserName").val(),
        User_OrganizationID: $("#txtOrganizationID").val(),
        User_Email: $("#txtEmail").val(),
        User_SMSNum: $("#txtSMSNum").val(),
        User_DomainID: $("#txtDomainID").val(),
        IsReadinessMail: $("#chkIsReadinessMail").attr("checked"),
        IsAdministrativeMail: $("#chkIsAdministrativeMail").attr("checked"),
        IsIncompleteParameterMail: $("#chkIsIncompleteParameterMail").attr("checked"),
        IsAssetManagementMail: $("#chkIsAssetMngMail").attr("checked"),
        IsComplianceTaskAlert:$("#chkSendComplTaskAlert").attr("checked"),
        IsAdminTaskAlert: $("#chkSendAdminTaskAlert").attr("checked")
    };
    PQ.Admin.WebService.UserProfileService.UserDetails_Save(userData,
    function (result) {
        if (result.UserID) {
            window.location.href = "Users.aspx?usid=" + result.UserID;
        }
        else {
            profile.GetDataForUserForm();
        }
    },
    function (e) {
        $("#waitplease").css({ 'display': 'none' });
        return false;
    });

};

profile.RequaredFields = function () {
    var result = new Boolean(true);
    if ($("#txtUserName").val() == "") {
        $("#txtUserName").addClass('ui-state-error').focus();
        return false;
    }
    else {
        $("#txtUserName").removeClass('ui-state-error', 500);
        result = true;
    }
    if ($("#txtFirstName").val() == "") {
        $("#txtFirstName").addClass('ui-state-error').focus();
        return false;
    }
    else {
        $("#txtFirstName").removeClass('ui-state-error', 500);
        result = true;
    }
    if ($("#txtLastName").val() == "") {
        $("#txtLastName").addClass('ui-state-error').focus();
        return false;
    }
    else {
        $("#txtLastName").removeClass('ui-state-error', 500);
        result = true;
    }
    return result;
};

profile.CreateUnitTree = function () {
    $.ajaxSetup({ cache: false });
    var uid = getArgs();
    try {
        if (uid.usid) {
            PQ.Admin.WebService.UserProfileService.GetUserUnitTree({ UserID: uid.usid },
        function (result) {
            if (result) {
                var theme, rtl;
                if ($.cookie("lang")) {
                    var lang = $.cookie("lang");
                    if (lang == 'he-IL' || lang == 'ar') {
                        theme = "default-rtl";
                        rtl = true;
                    }
                    else {
                        theme = "default";
                        rtl = false;
                    }
                }
                try {
                    $('#UnitsTree').jstree(
                    {
                        "xml_data": { "data": result },
                        "plugins": ["themes", "xml_data", "ui", "types", "checkbox", "crrm", "sort"],
                        "core": { "rtl": rtl, "initially_open": ["root2"], "animation": "200" },
                        "themes": { "theme": theme }
                    }).bind("loaded.jstree", function (event, data) {
                        $(this).jstree("open_all");
                        data.inst.open_all();
                    }).bind("reopen.jstree", function (event, data) {
                        data.inst.open_all();
                        setInterval(function () { $("#waitplease").css({ 'display': 'none' }); }, 250);
                    });
                } catch (ex) { $("#waitplease").css({ 'display': 'none' }); }
            }
        }, function () { $("#waitplease").css({ 'display': 'none' }); });
        }
    } catch (e) {
        alert(e.Description);
    }
};

profile.LoadUser2JobID = function (userID) {
    if (userID) {
        PQ.Admin.WebService.UserProfileService.User2Job_Select(userID,
         function (result) {
             $("#cblJobsList input[type=checkbox]").each(function () {
                 var currentValue = $(this).parent().attr('someValue');
             });
         },
         function (e) { $("#waitplease").css({ 'display': 'none' }); return false; });
    }
    $("#waitplease").css({ 'display': 'none' });
};

profile.SaveUser2JobID = function (arrJobID, userID) {
    PQ.Admin.WebService.UserProfileService.User2Job_Save(arrJobID, userID,
        function (result) {
            $("#waitplease").css({ 'display': 'none' });
        },
        function (e) {
            $("#waitplease").css({ 'display': 'none' });
        });
    return false;
};

profile.SaveUser2RoleID = function (arrRoleID, userID) {
    PQ.Admin.WebService.UserProfileService.User2Role_Save(arrRoleID, userID,
        function (result) {
            $("#waitplease").css({ 'display': 'none' });
        },
        function (e) {
            $("#waitplease").css({ 'display': 'none' });
        });
    return false;
};

profile.SaveUser2UnitsID = function (arrUnitID, userID) {
    PQ.Admin.WebService.UserProfileService.User2Unit_Save(arrUnitID, userID,
        function (result) {
            setTimeout(function () { $("#waitplease").css({ 'display': 'none' }); }, 500);
            return false;
        },
        function (e) {
            $("#waitplease").css({ 'display': 'none' });
        });
    return false;
};

profile.SaveComplianceTaskAlert = function () {
    var diagWin = $("#divComplianceTaskAlert").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true,
        open: function (type, data) {
            $(this).parent().appendTo("form");
        },
        buttons: {
            Ok: function (e) {
                e.preventDefault();
                $("#waitplease").css({ 'display': 'block' });
                var params = getArgs();
                params.usid == undefined ? 0 : params.usid;
                var selectedItems = new Array();
                try {
                    $("[id*=divCompliance] input:checked").each(function () {
                        selectedItems.push($(this).val());
                    });
                    var trainigEventTypes = new Array();

                    for (var i = 0; i < selectedItems.length; i++) {
                        trainigEventTypes.push({ UserID: parseInt(params.usid), TrainingEventTypeID: parseInt(selectedItems[i]) });
                    }

                    PQ.Admin.WebService.UserProfileService.UserDetails_SaveComplianceTaskAlert(trainigEventTypes,
                        function (result) {
                            diagWin.dialog('destroy');
                            $("#waitplease").css({ 'display': 'none' });
                        },
                        function () {
                            $("#waitplease").css({ 'display': 'none' });
                            return false;
                        });

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
profile.SaveAdminTaskAlert = function () {
    var diagWin= $("#divAdminTaskAlert").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true,
        open: function (type, data) {
            $(this).parent().appendTo("form");
        },
        buttons: {
            Ok: function (e) {
                e.preventDefault();
                $("#waitplease").css({ 'display': 'block' });
                var params = getArgs();
                params.usid == undefined ? 0 : params.usid;
                var selectedItems = new Array();
                try {
                    $("[id*=divAdmin] input:checked").each(function () {
                        selectedItems.push($(this).val());
                    });
                    var adminTaskAlerts = new Array();

                    for (var i = 0; i < selectedItems.length; i++) {
                        adminTaskAlerts.push({ UserID: parseInt(params.usid), SubQualificationType_ID: parseInt(selectedItems[i]) });
                    }

                    PQ.Admin.WebService.UserProfileService.UserDetails_SaveAdminTaskAlert(adminTaskAlerts,
                        function (result) {
                            diagWin.dialog('destroy');
                            $("#waitplease").css({ 'display': 'none' });
                        },
                        function () {
                            $("#waitplease").css({ 'display': 'none' });
                            return false;
                        });

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
profile.ResetUserData = function (userID) {
    $("#ConfirmResetPassword").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
        open: function (type, data) {
            $(this).parent().appendTo("form");
        },
        buttons: {
            Ok: function (e) {
                e.preventDefault();
                $("#waitplease").css({ 'display': 'block' });
                try {
                    PQ.Admin.WebService.UserProfileService.UserProfile_ResetPassword(userID,
                        function (result) {
                            if (result) {
                                setTimeout(function () {
                                    RaiseDialogSuccessMessage($("#hidResetPasswordSuccessMessage").text());
                                    $("#waitplease").css({ 'display': 'none' });
                                    $('#ConfirmResetPassword').dialog('destroy');
                                }, 500);
                            }
                        },
                        function (ex) {
                            $("#waitplease").css({ 'display': 'none' });
                            $('#ConfirmResetPassword').dialog('destroy');
                            return false;
                        });
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

profile.CheckUserName = function (userName) {
    var result = new Boolean(false);
    $.ajax({
        type: "POST",
        url: "/opeReady/WebService/UserProfileService.asmx/UserDetails_SelectByName",
        data: "{'userName':'" + userName + "'}",
        contentType: "application/json; charset=utf-8",
        async: false,
        dataType: "json",
        success: function (msg) {
            if (getMain(msg))
                result = true;
            else
                result = false;
        },
        error: function (e) {
            result = false;
        }
    });
    return result;
};

profile.SendUserEmail = function (userID) {
    try {
        PQ.Admin.WebService.UserProfileService.UserProfile_SendUserEmail(userID,
            function (result) {
                setTimeout(function () {
                    $("#waitplease").css({ 'display': 'none' });
                }, 500);
            },
            function (ex) {
                $("#waitplease").css({ 'display': 'none' });
                return false;
            });
    } catch (e) {
        return false;
    }
    return false;
};

/// --------------------------------------------------
Sys.Application.add_load(applicationLoadHandler);
Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequestHandler);
Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(beginRequestHandler);

function endRequestHandler(sender, args) {
    if (args.get_error()) {
        args.set_errorHandled(true);
    };
    $("#waitplease").css({ 'display': 'none' });
}

function beginRequestHandler() {
    $("#waitplease").css({ 'display': 'block' });
}