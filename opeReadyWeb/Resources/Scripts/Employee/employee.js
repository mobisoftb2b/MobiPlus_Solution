/// <reference path="../Common/jquery-1.5.2.js" />
/// <reference path="~/Resources/Scripts/Employee/eventRecords.js" />
/// <reference path="~/Resources/Scripts/Employee/unitsJobs.js" />
/// <reference path="~/Resources/Scripts/Employee/employmentHistory.js" />
/// <reference path="~/Resources/Scripts/Employee/administrativeTasks.js" />
/// <reference path="~/Resources/Scripts/Employee/personAttachment.js" />
/// <reference path="~/Resources/Scripts/Employee/readinessInfo.js" />
/// <reference path="compException.js" />


var employeePages = {
    availableTags: null,
    rowObject: null,
    pathSrc: null,
    employeeDetailsPath: null,
    employeeListPage: null
};


employeePages.Init = function () {
    employeePages.SetFirstNameArray();
    employeePages.SetLastNameArray();
    employeePages.SetMiddleNameArray();
};

employeePages.CreateUnitTree = function (userData) {
    try {
        PQ.Admin.WebService.PQWebService.GetUserMenu(userData, this.ExecuteUnitTreeCallbackResult, this.ExecuteFailResult);
    } catch (e) {
        alert(e.Description);
    }
};

employeePages.ExecuteUnitTreeCallbackResult = function (result) {
    if (result) {
        var theme = "default", rtl = false;
        if ($.cookie("lang")) {
            var lang = $.cookie("lang");
            if (lang == 'he-IL' || lang == 'ar') {
                theme = "default-rtl";
                rtl = true;
            }
        }
        try {
            var level = $("#lblTreeLebel").text() == "" ? 0 : parseInt($("#lblTreeLebel").text());
            var arrayIDs = GetArrayTreeIDs(result, level);

            $('#treeUnits').jstree(
				{ "xml_data": { "data": result },
				    "plugins": ["themes", "xml_data", "ui", "types"],
				    "core": { "rtl": rtl, "initially_open": arrayIDs, "animation": "100" },
				    "themes": { "theme": theme },
				    "types": { "types":
						{ "file": {
						    "valid_children": ["default"],
						    "icon": { "image": "/opeReady/Resources/images/active.png" }
						},
						    "folder": {
						        "valid_children": "all",
						        "icon": { "image": "/opeReady/Resources/images/close.png" },
						        "hover_node": false,
						        "select_node": function () { return false; }
						    }
						}
				    }
				}).bind("select_node.jstree", function (event, data) {
				    $('#hidUnitID').val(data.rslt.obj.get(0).id);
				    $('#ddlUnit').val($(data.rslt.obj.find("a").get(0)).text());
				    $('#treeUnits').fadeOut('slow');
				    $('#ddlUnit').removeClass('ui-state-error', 100);
				    return false;
				});
        } catch (e) {
        }
    }
};

/// <summary>
/// Get all errors from webservices
/// </summary>
/// <returns></returns>
employeePages.getEmplDataForUpdate = function (parameters) {
    if (parameters) {
        $("#waitplease").css({ 'display': 'block' });
        window.location.href = "EmployeeDetails.aspx?eid=" + parameters;
    }
};

employeePages.SetMiddleNameArray = function (result) {
    try {
        $("#txtMiddleName").autocomplete({
            source: function (request, response) {
                PQ.Admin.WebService.PQWebService.GetMiddleNameCompletionList(request.term,
				  function (data) {
				      if (data) {
				          response($.map(getMain(data), function (item) {
				              return {
				                  value: item.Person_MiddleName
				              };
				          }));
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
employeePages.SetFirstNameArray = function () {
    try {
        $("#txtFirstName").autocomplete({
            source: function (request, response) {
                PQ.Admin.WebService.PQWebService.GetFirstNameCompletionList(request.term,
				  function (data) {
				      if (data) {
				          response($.map(getMain(data), function (item) {
				              return {
				                  value: item.Person_FirstName
				              };
				          }));
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
employeePages.SetLastNameArray = function (result) {
    try {
        $("#txtLastName").autocomplete({
            source: function (request, response) {
                PQ.Admin.WebService.PQWebService.GetLastNameCompletionList(request.term,
				  function (data) {
				      if (data) {
				          response($.map(getMain(data), function (item) {
				              return {
				                  value: item.Person_LastName
				              };
				          }));
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

employeePages.Create_tab = function (wrapper, header, content) {
    var title = header;
    var container_to_hide = content;
    var duration = 200;
    var pid = getArgs();

    if ($.browser.msie) {
        duration = 10;
    }
    disable = false;

    $(title).each(function (i) {
        if (i == 0) {
            $(wrapper).prepend("<div class='jquery_tab_container'><a href='/' class='heading_tab advanced_link active tab" + (i + 1) + "'>" + $(this).html() + "</a></div>");
        }
        else if (pid.eid == undefined) {
            return false;
        }
        else {
            $(".advanced_link:last").after("<a href='/'class='heading_tab advanced_link tab" + (i + 1) + "'>" + $(this).html() + "</a>");
        }
    });

    $(container_to_hide).each(
		function (i) {
		    $(this).addClass("tablist list_" + i);
		    if (i != 0) {
		        $(this).css({ display: "none" });
		    }
		}
	);

    $(".advanced_link").each(
		function (i) {
		    $(this).bind("click", function () {
		        if ($(this).hasClass('active')) {
		            return false;
		        }
		        if (disable == false) {
		            disable = true;
		            $(".advanced_link").removeClass("active");
		            $(this).addClass("active");
		            employeePages.TabPopulateSelector($(this).find('span')[0].id);
		            $(container_to_hide + ":visible").fadeOut(duration, function () {
		                $(".list_" + i).fadeIn(duration, function () { disable = false; });
		            });
		        }
		        return false;

		    });
		});
};

employeePages.Choosetab = function () {
    var hash = window.location.hash;
    try {
        if (hash.match(/^#tab(\d)$/)) {
            var tab = hash.replace(/^#tab/, "");
            var select_tab = tab - 1;
            $(".jquery_tab").css({ display: "none" }).filter(":eq(" + select_tab + ")").css({ display: "block" });
            $(".jquery_tab_container .active").removeClass('active');
            $(".heading_tab").filter(":eq(" + select_tab + ")").addClass('active');
        }
    } catch (e) {
        return false;
    }
};

employeePages.LoadEmployeeDetailsGeneral = function () {
    $("#waitplease").css({ 'display': 'block' });
    $("#loader").empty().addClass('loading');
    var today = new Date();
    var img = new Image(145, 167);
    var pid = getArgs();
    if (pid.eid) {
        PQ.Admin.WebService.PQWebService.Person_SelectByID(pid.eid,
		function (data) {
		    $("#txtEmployeeID").val(data.Person_ID.toString());
		    $("#txtFirstNameDetails").val(data.Person_FirstName);
		    $("#txtLastNameDetails").val(data.Person_LastName);
		    $("#txtMiddleNameDetails").val(data.Person_MiddleName);
		    $("#ddlClassification").val(data.PersonCategory_ID);
		    $("#txtOrganizationID").val(data.Person_OrganizationID);
		    $("#txtBirthDay").val(data.PersonBirthDateStr);
		    $("#txtPhone").val(data.Person_Tel1);
		    $("#txtCellular").val(data.Person_Tel2);
		    $("#txtFax").val(data.Person_Tel3);
		    $("#txtCity").val(data.Person_Address1);
		    $("#txtStreet").val(data.Person_Address2);
		    $("#txtApartment").val(data.Person_Address3);
		    $("#txtEmail").val(data.Person_Email);
		    $("#chkActiveEmployee").attr('checked', data.IsActive);
		    $("#chkIsReadiness").attr('checked', data.IsReadiness);
		    $("#txtAdditionalInfoRemarks").text(data.PersonRemarks);
		    $("#lblNameContaner").text(data.Person_FirstName + " " + data.Person_LastName);
		    $("#txtExtSourceID1").val(data.Person_ExtSourceID1);
		    $("#txtExtSourceID2").val(data.Person_ExtSourceID2);
		    $("#txtExtSourceID3").val(data.Person_ExtSourceID3);
		    $("#txtAddInfo1").val(data.PersonAddInfo1);
		    $("#txtAddInfo2").val(data.PersonAddInfo2);
		    $("#txtAddInfo3").val(data.PersonAddInfo3);
		    if (!isNaN(data.Person_Age)) {
		        $("#lblAge").text(data.Person_Age);
		        $("#spanAge").removeClass("no-display");
		    }
		    else { $("#spanAge").addClass("no-display"); }
		    if (data.IsExistPersonPhoto) {
		        employeePages.LoadPhoto(img);
		    }
		    else {
		        $(img).attr("src", "/opeReady/Resources/images/defaultUser.jpg");
		        $("#loader").removeClass('loading').append(img);
		    }
		    $("#waitplease").css({ 'display': 'none' });

		},
		function (e) { });
    }
    else {
        $(img).attr("src", "/opeReady/Resources/images/defaultUser.jpg");
        $("#loader").removeClass('loading').append(img);
        $("#btnUpdate").val($("#hidAdd").text());
        $("#chkActiveEmployee").attr('checked', true);
        $("#chkIsReadiness").attr('checked', true);
    }

};
employeePages.CheckEmployeeNumber = function (value) {
    var result = new Boolean(false);
    $("#txtEmployeeID").addClass("ui-autocomplete-loading");
    var param = getArgs();
    if (param.eid == undefined) {
        PQ.Admin.WebService.PQWebService.Person_CheckPersonNumber(value,
	 function (data) {
	     $("#waitplease").css({ 'display': 'none' });
	     if (data) {
	         $("#txtEmployeeID").removeClass('ui-autocomplete-loading').addClass("ui-state-error").focus();
	         $("#divEmployeeIDIsExist").removeClass("no-display");
	         return false;
	     }
	     else {
	         $("#divEmployeeIDIsExist").addClass("no-display");
	         $("#txtEmployeeID").removeClass('ui-state-error ui-autocomplete-loading');
	         employeePages.EmployeeDetailsSave();
	     }
	 },
	 function (e) {
	     $("#waitplease").css({ 'display': 'none' });
	     return false;
	 });
    }
    else {
        setTimeout(function () { $("#txtEmployeeID").removeClass("ui-autocomplete-loading"); }, 500);
        employeePages.EmployeeDetailsSave();

    }
    return false;
};

employeePages.EmployeeDetailsSave = function () {
    $("#waitplease").css({ 'display': 'block' });
    var pid = getArgs();

    var personInfo = {
        Person_ID: pid.eid == undefined ? parseInt($("#txtEmployeeID").val()) : parseInt(pid.eid),
        Person_FirstName: $("#txtFirstNameDetails").val(),
        Person_LastName: $("#txtLastNameDetails").val(),
        Person_MiddleName: $("#txtMiddleNameDetails").val(),
        PersonCategory_ID: $("#ddlClassification").val(),
        Person_OrganizationID: $("#txtOrganizationID").val(),
        PersonBirthDateStr: $("#txtBirthDay").val(),
        Person_Tel1: $("#txtPhone").val(),
        Person_Tel2: $("#txtCellular").val(),
        Person_Tel3: $("#txtFax").val(),
        Person_Address1: $("#txtCity").val(),
        Person_Address2: $("#txtStreet").val(),
        Person_Address3: $("#txtApartment").val(),
        Person_Email: $("#txtEmail").val(),
        PersonRemarks: $("#txtAdditionalInfoRemarks").val(),
        IsReadiness: $("#chkIsReadiness").attr('checked'),
        IsActive: $("#chkActiveEmployee").attr('checked'),
        Person_ExtSourceID1: $("#txtExtSourceID1").val(),
        Person_ExtSourceID2: $("#txtExtSourceID2").val(),
        Person_ExtSourceID3: $("#txtExtSourceID3").val(),
        PersonAddInfo1: $("#txtAddInfo1").val(),
        PersonAddInfo2: $("#txtAddInfo2").val(),
        PersonAddInfo3: $("#txtAddInfo3").val()
    };

    PQ.Admin.WebService.PQWebService.Person_Save(personInfo,
		function (data) {
		    if (data) {
		        window.location = employeePages.employeeDetailsPath + "?eid=" + data;
		    } else {
		        employeePages.LoadEmployeeDetailsGeneral();
		    }
		    $("#waitplease").css({ 'display': 'none' });
		},
	 function (e) {
	     $("#waitplease").css({ 'display': 'none' });
	 });
    return false;
};

employeePages.EmployeeDetails_DeleteEmployee = function () {
    var pid = getArgs();
    if (pid.eid) {
        $("#divConfirmDeleteEmployee").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
            open: function (type, data) {
                $(this).parent().appendTo("form");
                $("#txtConfirmDelete").removeClass("ui-state-error").val('');
            },
            buttons: {
                Ok: function (e) {
                    e.preventDefault();
                    try {
                        $("<div></div>")
                                .addClass("dialog")
                                .attr("id", "divConfirmDelete2")
                                .append("<label class='label'>" + $("#hidConfirmDeletePerson").text() + "</label>")
                                .appendTo("body")
                                .dialog({
                                    close: function () { $(this).remove(); },
                                    modal: true,
                                    buttons: {
                                        Ok: function () {
                                            PQ.Admin.WebService.PQWebService.Person_Delete(pid.eid,
								            function (data) {
								                if (data) {
								                    window.location = employeePages.employeeListPage;
								                }
								                $("#waitplease").css({ 'display': 'none' });
								            },
								            function (e) {
								                $("#waitplease").css({ 'display': 'none' });
								            });
                                        },
                                        Cancel: function () {
                                            $(this).dialog("close");
                                        }
                                    }
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
    }
};

employeePages.CheckRequaredFields = function () {
    var result = new Boolean(true);
    //--------------------------------------------------------------
    if ($("#txtFirstNameDetails").val().trim() == "") {
        $("#txtFirstNameDetails").addClass("ui-state-error").focus();
        $("#waitplease").css({ 'display': 'none' });
        result = false;
        return false;
    } else { $("#txtFirstNameDetails").removeClass('ui-state-error', 500); }
    //-----------------------------------------------------------------
    if ($("#txtLastNameDetails").val().trim() == "") {
        $("#txtLastNameDetails").addClass("ui-state-error").focus();
        $("#waitplease").css({ 'display': 'none' });
        return false;
        result = false;
    } else { $("#txtLastNameDetails").removeClass('ui-state-error', 500); }
    //------------------------------------------------------------------
    if ($("#txtEmployeeID").val().trim() == "") {
        $("#txtEmployeeID").addClass("ui-state-error").focus();
        $("#waitplease").css({ 'display': 'none' });
        result = false;
        return false;
    } else {
        if (!employeePages.CheckEmployeeNumber($("#txtEmployeeID").val())) {
            result = false;
            return false;
        }
    }
    return result;
};

employeePages.LoadPhoto = function (img) {
    var currdate = new Date();
    currdate = encodeURI(currdate.toString());
    var pid = getArgs();
    if (pid.eid) {
        $(img).hide();
        $(img).attr("src", "/opeReady/Handlers/PhotoHandler.ashx?eid=" + pid.eid + "&d=" + currdate);
        $(img).waitForImages(function () {
            $("#loader").removeClass('loading').append(img);
            $(img).fadeIn();
        });

    }
    else {
        $(img).attr("src", "/opeReady/Resources/images/defaultUser.jpg?d=" + currdate);
        $(img).waitForImages(function () {
            $("#loader").removeClass('loading').append(img);
            $(img).fadeIn();
        });
    }
};

//--------------------------------------Edit Job History Module --------------------------------
employeePages.imgEditCurrActiveJob_click = function (rowObj) {
    if (rowObj) {
        var curractivejob = rowObj.Job_ID;
        $('#txtFromDateJobHistory').val(rowObj.Person2Job_FromDateStr).attr('readonly', 'readonly').datepicker("destroy");
        $('#txtToDateJobHistory').val(rowObj.Person2Job_ToDateStr);
        $('#ddlJob').val(rowObj.Job_ID).hide();
        $("#txtJobName").val(rowObj.Job_Name).show();
        $('#txtJobStatus').val(rowObj.JobStatus_ORGName).show();
        $('#ddlJobStatus').val(rowObj.JobStatus_ID).hide();
        $('#btnAddJobHistory').val($('#hidUpdate').text());
    }
    else {
        $('#txtFromDateJobHistory').datepicker({
            changeYear: true, changeMonth: true, dateFormat: dateFormats
        }).val("").removeAttr('readonly');
        $('#txtToDateJobHistory').val("");
        $('#txtJobName').hide();
        $('#ddlJob').val('0').show();
        $('#ddlJobStatus').val('0').show();
        $('#txtJobStatus').val("").hide();
        $('#btnAddJobHistory').val($('#hidAdd').text());
    }
    divJobHistoryEdit_Open();
    return false;
};
employeePages.UnitItemHistoryDelete = function (personID, unitID, _fromUnitItem, rowObj) {
    $("#divUnitHistoryEdit").dialog('destroy');
};

employeePages.TabPopulateSelector = function (objectTab) {
    switch (objectTab) {
        case 0:
            employeePages.LoadEmployeeDetailsGeneral();
            $("#divNameContaner").addClass("no-display", 100);
            break;
        case 1:
            $('#gvEmlpoymentHistory').GridUnload();
            employmentHistory.CreateAndPopulateEmploymentHistoryGrid();
            //                employmentHistory.PopulateEmploymentHistoryHightlightFields();
            employmentHistory.PopulateEmploymentHistoryCombo();
            $("#divNameContaner").removeClass("no-display", 500);
            break;
        case 4:
            $("#waitplease").css({ 'display': 'block' });
            var pid = getArgs();
            if (pid.eid) {
                unitJob.ReloadCurrentActiveJob(pid.eid);
                unitJob.ReloadCurrentActiveUnit(pid.eid);
            }
            $('#tblJobHistory').GridUnload();
            unitJob.CreateAndPopulateJobUnitGrid();
            $('#tblUnitHistory').GridUnload();
            unitJob.CreateAndPopulateUnitHistoryGrid();
            unitJob.PopulateJobStatusCombo();
            unitJob.PopulateJobCategoryCombo();
            $("#divNameContaner").removeClass("no-display", 500);
            break;
        case 5:
            $("#waitplease").css({ 'display': 'block' });
            $('#tblEventHistory').GridUnload();
            _trainEvTypeID = _trainEvTypeID == undefined ? null : _trainEvTypeID;
            _evTypeID = $('#hidEventTypeID').val() == '' ? null : parseInt($('#hidEventTypeID').val());
            var isSimfox = $("#chkIsSimfox").attr("checked");
            CreateAndPopulateEventRecordsGrid(_trainEvTypeID, _evTypeID, isSimfox);
            eventRecords.PopulateTrainingEventTypeCombo();
            eventRecords.PopulatlPerfomanceLevelCombo();
            $("#divNameContaner").removeClass("no-display", 100);
            break;
        case 2:
            $("#tblAdminTask").GridUnload();
            administrativeTasks.CreateAndPopulateAdminTasksGrid();
            administrativeTasks.PopulateAdminTasksCombo();
            $("#divNameContaner").removeClass("no-display", 500);
            break;
        case 3:
            $("#tlbPersonAttachments").GridUnload();
            attachment.CreateAttachmentGrid();
            $("#divNameContaner").removeClass("no-display", 500);
            break;
        case 7:
            $("#waitplease").css({ 'display': 'block' });
            readinessInfo.GetReadinessDetails();
            var pid = getArgs();
            if (pid.eid) {
                readinessInfo.ChrtReadinessStatusHistory(pid.eid);
            }
            document.getElementById('frmGauges').contentWindow.location.reload(true);
            $("#divNameContaner").removeClass("no-display", 500);
            $("#waitplease").css({ 'display': 'none' });
            break;
        case 6:
            $("#waitplease").css({ 'display': 'block' });
            perfomance.PopulateTrainingEventTypeCombo();
            $("#divNameContaner").removeClass("no-display", 500);
            break;
    }
};
employeePages.ReviewGauges = function () {
    if (this.pathSrc) {
        $("#frmGauges").attr("src", this.pathSrc);
        $("#waitplease").css({ 'display': 'none' });
    }
};
employeePages.GetCurrentEmployeeQty = function () {
    var result = new Boolean(false);
    $.ajax({
        type: "POST",
        url: "/opeReady/WebService/PQWebService.asmx/GetCurrentEmployeeQty",
        contentType: "application/json; charset=utf-8",
        async: false,
        dataType: "json",
        success: function (msg) {
            var emplQty = parseInt($("#hidEmp").val());
            if (emplQty <= getMain(msg)) { result = true; $("#btnUpdate").attr("disabled", false); }
            else { $("#btnUpdate").attr("disabled", true); }
        },
        error: function (e) {
            result = false;
        }
    });
    return result;
};

employeePages.Person_ChangeID = function (oldID, newID) {
    try {
        PQ.Admin.WebService.PQWebService.Person_ChangeID(oldID, newID,
            function (result) {
                if (result) {
                    employeePages.getEmplDataForUpdate(newID);
                } else $("#divEmployeeIDIsExist").removeClass("no-display").effect("pulsate", { times: 5 }, 1000);
                setTimeout(function () { $("#waitplease").css({ 'display': 'none' }); }, 500);
            },
        function (ex) {
            alert(e.Description);
        });
    } catch (e) {
        alert(e.Description);
    }
    return false;
};

employeePages.ComplianceException_OnClick = function (e) {
    $("#waitplease").css({ 'display': 'block' });
    var excTitle = $("#hidComplException_HeaderParentDialog").text();
    var excCaption = $("#hidComplException_btnCloseParentDialog").text();
    try {
        $("#divComplianceExceptionDetails")
            .addClass("dialog")
            .dialog({
                title: excTitle,
                create: function () { $(this).parent().appendTo("form"); },
                autoOpen: true,
                modal: true,
                resizable: false,
                closeOnEscape: true,
                height: 600,
                width: 800,
                open: function () {
                    $("#tlbComplianceExceptions").GridUnload();
                    compEx.CreateComplianceExceptionsGrid();
                    compEx.PopulationTrainingEventTypeExceptionSelect();
                },
                buttons: [
                {
                    text: excCaption,
                    click: function () { $(this).dialog("destroy"); }
                }]
            });
    } catch (e) {
        return false;
    }
    return false;
};

employeePages.AdminException_OnClick = function (e) {
    $("#waitplease").css({ 'display': 'block' });
    var excTitle = $("#hidAdminException_HeaderParentDialog").text();
    var excCaption = $("#hidAdminException_btnCloseParentDialog").text();
    try {
        $("#divAdminExceptionsDetails")
            .addClass("dialog")
            .dialog({
                title: excTitle,
                create: function () { $(this).parent().appendTo("form"); },
                close: function () { $(this).remove(); },
                autoOpen: true,
                modal: true,
                resizable: false,
                closeOnEscape: true,
                height: 590,
                width: 600,
                open: function () {
                    $("#tlbAdminExceptions").GridUnload();
                    adminEx.CreateAdminExceptionsGrid();
                    adminEx.PopulationSubQualificationTypeSelect();
                },
                buttons: [
                {
                    text: excCaption,
                    click: function () { $(this).dialog("destroy"); }
                }]
            });
    } catch (e) {
        return false;
    }
    return false;
};

///-----------------------------------------------------------------------------------------------------------------
Sys.Application.add_load(applicationLoadHandler);
Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequestHandler);
Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(beginRequestHandler);

function applicationLoadHandler() {
    employeePages.Init();
}

function endRequestHandler(sender, args) {
    if (args.get_error()) {
        args.set_errorHandled(true);
    };
    try {
        $('#gvEmlpoyee tr:even td').addClass('reg alt').hover(
		function () { $(this).addClass(""); },
		function () { }
	);
        $('#divAdminTasksEdit').dialog('destroy');
        $("#waitplease").css({ 'display': 'none' });
        $(".image").hover(function () { $(this).css({ cursor: 'pointer' }); }, function () { $(this).css({ cursor: 'default' }); });

        //        employeePages.CreateUnitTree(null);
    } catch (e) {
        $("#waitplease").css({ 'display': 'none' });
        return false;
    }
};

function beginRequestHandler() {
    $("#waitplease").css({ 'display': 'block' });

}
