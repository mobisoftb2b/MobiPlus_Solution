var rowCount = 0;
var groupEvent = {
    availableTags: null,
    rowObject: null,
    selctedID: null,
    rowCount: 0
};

groupEvent.Init = function () {

};

groupEvent.TrainingEvent2Categories_Select = function (trainingEventTypeID) {
    try {
        PQ.Admin.WebService.EventRecords.TrainingEvent2Categories_SelectXML(trainingEventTypeID,
			function (result) {
			    if (result) {
			        divEmployeeEvaluation.innerHTML = result;
			        SetDeleteEventSubjects();
			    }
			}, this.ExecuteFailResult);
    } catch (e) {
        RaiseWarningAlert(e.Description);
    }
};

function deleteEventSubjects(element) {
    var _divElement;
    $(element).each(function () {
        $(this).append('<div class="click_to_close"></div>')
    });
    $(".click_to_close").click(function () {
        _divElement = $(this).parent();
        var trainingEvent = { TrainingEventCategory_ID: $(this).parent().attr('tecat'), TrainingEvent_ID: $(this).parent().attr('te') };
        try {
            PQ.Admin.WebService.PQWebService.DeleteEventSubject(trainingEvent,
			function (result) {
			    if (result) {
			        _divElement.fadeOut('slow', function () { $(this).remove(); });
			    }
			}, this.ExecuteFailResult);
        } catch (e) {
            RaiseWarningAlert(e.Description);
        }
    });
}

//-------------------------------------- Event Subjects Grid Population ----------------------------------------------------

groupEvent.AddEventSubjectsGrid = function (trainingEventTypeID) {
    var  langDir = "ltr";
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            langDir = "rtl";
           
    }
    $('#divAddEventSubject').block({
        css: { border: '0px' },
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    $("#tblEventSubjects").jqGrid({
        direction: langDir,
        datatype: function (pdata) { groupEvent.getEventSubjectsData(trainingEventTypeID); },
        autowidth: true,
        height: 200,
        colNames: ['ID', $('div span[id=hidTrainingEventCategoryName]').text()],
        colModel: [
				{ name: 'TrainingEventCategory_ID', index: 'TrainingEventCategory_ID', formatter: 'integer', key: true, hidden: true },
				{ name: 'TrainingEventCategory_Name', index: 'TrainingEventCategory_Name', sortable: true, sorttype: 'text', width: 350 }
			],
        viewrecords: true,
        sortorder: "",
        recordpos: 'left',
        pager: '#pgrEventSubjects',
        pgbuttons: false,
        pginput: false,
        altRows: true,
        multiselect: true,
        sortname: 'TrainingEventCategory_ID',
        loadonce: true,
        rowNum: 20000,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local' });
            if (rowCount == $(this).getGridParam('records')) {
                $(this).trigger('reloadGrid');
                $('#divAddEventSubject').unblock();
                rowCount = 0;
                setTimeout(function () { $("#waitplease").css({ 'display': 'none' }); }, 500);
            }
        },
        onSelectAll: function (rowid, e) {
            if (e) groupEvent.selctedID = rowid;
            else groupEvent.selctedID = null;
            return false;
        }
    }).jqGrid('navGrid', '#pgrUnitHistory', { add: false, del: false, edit: false, position: 'right' });

}

groupEvent.getEventSubjectsData = function (trainingEventTypeID) {
    PQ.Admin.WebService.EventRecords.TrainingEventCategory_Select(trainingEventTypeID,
			function (data, textStatus) {
			    groupEvent.ReceivedEventSubjectsData(JSON.parse(getMain(data)).rows);
			}, function (ex) {
			});
};

groupEvent.ReceivedEventSubjectsData = function (data) {
    var thegrid = $("#tblEventSubjects");
    thegrid.clearGridData();
    rowCount = data.length;
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
}

groupEvent.getSelectedIDs = function () {
    var arrIDs = new Array();
    var trainingEventCategory = new Array();
    $("#waitplease").css({ 'display': 'block' });
    arrIDs = $("#tblEventSubjects").getGridParam("selarrrow");
    if (arrIDs[0] == undefined) arrIDs[0] = "0";
    try {
        for (var i = 0; i < arrIDs.length; i++) {
            trainingEventCategory[i] = { TrainingEventCategory_ID: arrIDs[i], TrainingEventCategory_Name: $("#tblEventSubjects").getRowData(arrIDs[i]).TrainingEventCategory_Name };
        }
        PQ.Admin.WebService.EventRecords.TrainingEventSubject_Display($("#ddlTrainingEventType").val(), trainingEventCategory,
		function (result) {
		    if (result) {
		        divEmployeeEvaluation.innerHTML = result;
		        $("#waitplease").css({ 'display': 'none' });
		        $("#divEmployeeEvaluationTotal").removeClass('ui-state-error', 500);
		        $('#divAddEventSubject').dialog('close');
		        SetDeleteEventSubjects();
		    }
		}, function (ex) { });
    } catch (e) {

    }
}

//-------------------------------------- End Event Subjects Grid Population ------------------------------------------------

//-------------------------------------- Emlpoyment Evaluation Grid Population ------------------------------------------------


groupEvent.EmlpoymentEvaluationsGrid = function (persons2event, eventTypeID) {
    var _langDir;
    eventTypeID = eventTypeID == "" ? 0 : parseInt(eventTypeID);
    $('#ConfirmDeleteAttachment').dialog('destroy');
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            _langDir = "rtl";
        else
            _langDir = "ltr";
    }
    $('#divGroupEvents').block({
        css: { border: '0px' },
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    $("#tblEmlpoymentEvaluation").jqGrid({
        direction: _langDir,
        datatype: function (pdata) { groupEvent.getEmlpoymentEvaluationData(persons2event); },
        height: 280,
        autowidth: false,
        colNames: [$('#hiddFuildCaptions span[id=hidEmployeeID]').text(),
				$('#hiddFuildCaptions span[id=hidFirstName]').text(),
				$('#hiddFuildCaptions span[id=hidLastName]').text(),
				$('#hiddFuildCaptions span[id=hidJob]').text(),
				$('#hiddFuildCaptions span[id=hidUnit]').text(),
				$('#hiddFuildCaptions span[id=hidReadinessLabel]').text(),
				$('#hiddFuildCaptions span[id=hidEventScore]').text(),
				$('#hiddFuildCaptions span[id=hidQuantity]').text(),
				$('#hiddFuildCaptions span[id=hidEventRecordsDelete]').text(),
				'ExecutionLevel_ID'
			],
        colModel: [
				{ name: 'Person_ID', index: 'Person_ID', key: true, sortable: true, sorttype: 'int', width: 100 },
				{ name: 'Person_FirstName', index: 'Person_FirstName', sortable: true, sorttype: 'text', width: 100 },
				{ name: 'Person_LastName', index: 'Person_LastName', sortable: true, sorttype: 'text', width: 100 },
				{ name: 'Job_Name', index: 'Job_Name', sortable: true, sorttype: 'text', width: 120 },
				{ name: 'Unit_Name', index: 'Unit_Name', sortable: true, sorttype: 'text', width: 120 },
				{ name: 'ExecutionLevel_ORGName', index: 'ExecutionLevel_ORGName', editable: true, sortable: true, sorttype: 'text', width: 160 },
				{ name: 'TrainingEvent2Person_Score', index: 'TrainingEvent2Person_Score', sortable: true, sorttype: 'int', width: 120 },
				{ name: 'TrainingEvent2Person_Quantity', index: 'TrainingEvent2Person_Quantity', sortable: true, sorttype: 'int', width: 120 },
				{ name: 'DeleteEmployee', index: 'DeleteEmployee', sortable: false, width: 60, formatter: deleteFormatter, align: 'center' },
				{ name: 'ExecutionLevel_ID', hidden: 'true' }
			],
        imgpath: '<%= ResolveClientUrl("~/Resources/Styles/redmon/images") %>',
        datefmt: 'd/m/Y',
        viewrecords: true,
        sortorder: "asc",
        autoencode: false,
        loadonce: true,
        hoverrows: false,
        toolbar: [$('#ddlTrainingEventType').val() == "0" ? false : true, "top"],
        pgbuttons: false,
        pginput: false,
        recordpos: 'left',
        pager: '#pgrEmlpoymentEvaluation',
        altRows: true,
        rowNum: 2000,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
            var ids = $(this).jqGrid('getDataIDs');
            if (rowCount == $(this).getGridParam('records')) {
                $(this).jqGrid('sortGrid', "Person_ID", true);
                $('#divGroupEvents').unblock();
                rowCount = 0;
                $("#waitplease").css({ 'display': 'none' });
            }
            switch (eventTypeID) {
                case 0:
                    $(this).jqGrid('hideCol', ["ExecutionLevel_ORGName", "TrainingEvent2Person_Score", "TrainingEvent2Person_Quantity"]);
                    break;
                case 1:
                    $(this).jqGrid('hideCol', ["TrainingEvent2Person_Score", "TrainingEvent2Person_Quantity"]);
                    break;
                case 2:
                    $(this).jqGrid('hideCol', ["ExecutionLevel_ORGName", "TrainingEvent2Person_Quantity"]);
                    break;
                case 3:
                    $(this).jqGrid('hideCol', ["ExecutionLevel_ORGName", "TrainingEvent2Person_Score"]);
                    break;
            }

        },
        onCellSelect: function (rowid, iCol, cellcontent, e) {
            if (iCol == 8) {
                return groupEvent.TrainingEvent2Person_Delete($(this).getRowData(rowid).Person_ID);
            }
            return false;
        },
        ondblClickRow: function (rowid, iRow, iCol, e) {
            SetVisibilityText(eventTypeID);
            groupEvent.TrainingEventGroup2Person_Update($(this).getRowData(rowid)); //divPersonDetails
        }
    });

    $("#tblEmlpoymentEvaluation").jqGrid('gridResize', { minWidth: 674, minHeight: 300 });
    $("#tblEmlpoymentEvaluation").toolbarButtonAdd("#t_tblEmlpoymentEvaluation",
		{
		    caption: $('#hidGroupEvent_btnAddEmployee').text(),
		    position: "first",
		    align: (_langDir == 'rtl' ? 'right' : 'left'),
		    buttonicon: 'ui-icon-circle-plus',
		    onClickButton: function () {
		        if (groupEvent.RequaredTrainingEventFields()) AddEmployeeForEvent();
		        else return false;
		    }
		});
};

groupEvent.getEmlpoymentEvaluationData = function (data) {
    if (data)
        groupEvent.ReceivedEmlpoymentEvaluationData(JSON.parse(getMain(data)).rows);
};

groupEvent.ReceivedEmlpoymentEvaluationData = function (data) {
    var thegrid = $("#tblEmlpoymentEvaluation");
    thegrid.clearGridData();
    rowCount = data.length;
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
};

groupEvent.HightLigthRowData = function (rowData) {
    if (rowData) {
        $('#txtTotalScore').val(rowData.TrainingEvent2Person_Score);
        $('#ddlPerfomanceLevel').val(rowData.ExecutionLevel_ID);
        $('#txtQuality').val(rowData.TrainingEvent2Person_Quantity);
        $('#txtRemarksEvaluation').val(rowData.TrainingEvent2Person_Remarks);
        $('#divGeneralEvaluation').fadeIn('slow');
        $('html, body').animate({
            scrollTop: $('#divGeneralEvaluation').offset().top
        }, 500);
    }
};

groupEvent.TrainingEventGroup2Person_Update = function (personData) {
    if (personData) {
        $('#txtEmployeeIDUpd').val(personData.Person_ID);
        $('#txtFirstNameUpd').val(personData.Person_FirstName);
        $('#txtLastNameUpd').val(personData.Person_LastName);
        $('#txtUnitUpd').val(personData.Unit_Name);
        $('#txtJobUpd').val(personData.Job_Name);
        $('#ddlPerfomanceLevelUpdate').val(personData.ExecutionLevel_ID);
        $('#txtQuantityUpd').val(personData.TrainingEvent2Person_Quantity);
        $('#txtEventScoreUpd').val(personData.TrainingEvent2Person_Score);
        divPersonDetails_Open();
    }
};

groupEvent.CreateUnitTree = function (userData, sender) {
    try {
        PQ.Admin.WebService.PQWebService.GetUserMenu(userData,
		function (result) {
		    if (result) {
		        var _theme, _rtl;
		        if ($.cookie("lang")) {
		            var _lang = $.cookie("lang");
		            if (_lang == 'he-IL' || _lang == 'ar') {
		                _theme = "default-rtl";
		                _rtl = true;
		            }
		            else {
		                _theme = "default";
		                _rtl = false;
		            }
		        }
		        try {
		            var level = $("#lblTreeLebel").text() == "" ? 0 : parseInt($("#lblTreeLebel").text());
		            var arrayIDs = GetArrayTreeIDs(result, level);
		            $('#' + sender.id).jstree(
						{ "xml_data": { "data": result },
						    "plugins": ["themes", "xml_data", "ui", "types"],
						    "core": { "rtl": _rtl, "initially_open": [arrayIDs], "animation": "100" },
						    "themes": { "theme": _theme },
						    "types": { "types":
								{ "file": {
								    "valid_children": ["default"],
								    "icon": { "image": "/opeReady/Resources/images/active.png" }
								},
								    "folder": {
								        "valid_children": "all",
								        "icon": { "image": "/opeReady/Resources/images/close.png" },
								        "select_node": function () { return false; }
								    }
								}
						    }
						}).bind("select_node.jstree", function (event, data) {
						    $('#hidUnitID,#hidATUnitID').val(data.rslt.obj.get(0).id);
						    $('#ddlUnit,#txtAT_Unit').val($(data.rslt.obj.find("a").get(0)).text()).removeClass('ui-state-error', 100);

						    groupEvent.PopulateJobsListCombo(data.rslt.obj.get(0).id);
						    $('#' + sender.id).fadeOut('slow');
						    return false;
						});
		        } catch (e) {
		        }
		    }

		}, function () {

		});
    } catch (e) {
        RaiseWarningAlert(e.Description);
    }
};

groupEvent.PopulateJobsListCombo = function (unitID) {
    $("#ddlJob, #ddlJobAT").addClass("ui-autocomplete-loading");
    $("#ddlJob>option").remove();
    $("#ddlJobAT>option").remove();
    unitID = unitID == "" ? 0 : unitID;
    try {
        PQ.Admin.WebService.PQWebService.GetJobByUnitID(unitID, $("#hidGroupEvent_grtSelectJobs").text(),
			function (result) {
			    $(result).each(function () {
			        $("#ddlJob,#ddlJobAT").append($("<option></option>").val(this['Job_ID']).html(this['Job_Name']));
			    });
			    $("#ddlJob, #ddlJobAT").removeClass("ui-autocomplete-loading");
			},
			function (e) { });
    } catch (e) { }
    $("#waitplease").css({ 'display': 'none' });

    return false;
};


groupEvent.RequaredTrainingEventFields = function () {
    var result = new Boolean(true);
    if ($("#txtGroupEventDate").val() == "") {
        $('#txtGroupEventDate').addClass('ui-state-error').focus();
        return false;
    }
    else {
        $('#txtGroupEventDate').removeClass('ui-state-error', 500);
    }
    if ($("#ddlTrainingEventType").val() == "0") {
        $('#ddlTrainingEventType').addClass('ui-state-error').focus();
        return false;
    }
    else {
        $('#ddlTrainingEventType').removeClass('ui-state-error', 500);
    }

    if ($("#divEmployeeEvaluation").is(':empty')) {
        $("#divEmployeeEvaluationTotal").addClass('ui-state-error');
        return false;
    }
    else {
        $("#divEmployeeEvaluationTotal").removeClass('ui-state-error', 500);
    }

    return result;
}



//-------------------------------------- End Emlpoyment Evaluation Grid Population ------------------------------------------------

//-------------------------------------- List Emlpoyees Grid Population ------------------------------------------------

groupEvent.GetEmlpoyeeGrid = function (person, eventTypeID) {
    var _langDir;
    var lastsel;
    eventTypeID = eventTypeID == "" ? 0 : parseInt(eventTypeID);
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            _langDir = "rtl";
        else
            _langDir = "ltr";
    }
    $("#tlbEmlpoyee").jqGrid({
        direction: _langDir,
        datatype: function (pdata) { groupEvent.getEmlpoyeeListData(person); },
        height: 375,
        width: 800,
        colNames: [$('#hiddFuildCaptions span[id=hidEmployeeID]').text(),
				$('#hiddFuildCaptions span[id=hidFirstName]').text(),
				$('#hiddFuildCaptions span[id=hidLastName]').text(),
				$('#hidReadinessLabel').text(),
				$('#hidEventScore').text(),
				$('#hidQuantity').text(),
				'', ''
			],
        colModel: [
				{ name: 'Person_ID', index: 'Person_ID', key: true, sortable: true, sorttype: 'int', width: 100 },
				{ name: 'Person_FirstName', index: 'Person_FirstName', sortable: true, sorttype: 'text', width: 100 },
				{ name: 'Person_LastName', index: 'Person_LastName', sortable: true, sorttype: 'text', width: 100 },
				{ name: 'ReadinessLevel_Name', index: 'ReadinessLevel_Name', formatter: selectFormatter, width: 150 },
				{ name: 'TrainingEvent2Person_Score', index: 'TrainingEvent2Person_Score', width: 100, formatter: textBoxScoreFormatter },
				{ name: 'TrainingEvent2Person_Quantity', index: 'TrainingEvent2Person_Quantity', width: 100, formatter: textBoxQuantityFormatter },
				{ name: 'Job_Name', hidden: 'true' },
				{ name: 'Unit_Name', hidden: 'true' }
			],
        imgpath: '<%= ResolveClientUrl("~/Resources/Styles/redmon/images") %>',
        datefmt: 'd/m/Y',
        viewrecords: true,
        sortorder: "asc",
        autoencode: false,
        loadonce: true,
        recordpos: 'left',
        rowNum: 10000,
        pager: '#pgrEmployee',
        pgbuttons: false,
        pginput: false,
        multiselect: true,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local' });
            var ids = $(this).jqGrid('getDataIDs');
            if (rowCount == $(this).getGridParam('records')) {
                $("#waitplease").css({ 'display': 'none' });
                $(this).trigger('reloadGrid');
                $(this).jqGrid('sortGrid', "Person_ID", true);
                rowCount = 0;
                switch (eventTypeID) {
                    case 0:
                        $(this).jqGrid('hideCol', ["ReadinessLevel_Name", "TrainingEvent2Person_Score", "TrainingEvent2Person_Quantity"]);
                        break;
                    case 1:
                        $(this).jqGrid('hideCol', ["TrainingEvent2Person_Score", "TrainingEvent2Person_Quantity"]);
                        break;
                    case 2:
                        $(this).jqGrid('hideCol', ["ReadinessLevel_Name", "TrainingEvent2Person_Quantity"]);
                        break;
                    case 3:
                        $(this).jqGrid('hideCol', ["ReadinessLevel_Name", "TrainingEvent2Person_Score"]);
                        break;
                }
            }
        },
        onSelectAll: function (rowid, e) {
            if (e) groupEvent.selctedID = rowid;
            else groupEvent.selctedID = null;
            return false;
        },
        onSelectRow: function (id) {
            if (id && id !== lastsel) {
                $(this).jqGrid('restoreRow', lastsel);
                $(this).jqGrid('editRow', id, true);
                lastsel = id;
            }
        }
    });
    $("#tlbEmlpoyee").jqGrid('gridResize', { minWidth: 900, minHeight: 300 });

};

groupEvent.getEmlpoyeeListData = function (_person) {
    if (_person) {
        try {
            var temp = $("#tblEmlpoymentEvaluation").getDataIDs();
            PQ.Admin.WebService.EmployeeSearchWS.EmployeeSearching(_person, temp,
			function (data) {
			    groupEvent.ReceivedEmployeeListData(JSON.parse(getMain(data)).rows);
			}, function (data, textStatus) {
			    RaiseWarningAlert('An error has occured retrieving data!');
			});
        } catch (e) { }
    }
};

groupEvent.ReceivedEmployeeListData = function (data) {
    var thegrid = $("#tlbEmlpoyee");
    thegrid.clearGridData();
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
};

function textBoxScoreFormatter(cellvalue, options, rowObject) {
    var el = document.createElement("input");
    el.type = "text";
    el.id = "txtScore" + rowObject.Person_ID;
    $(el).addClass("input-medium");
    el.value = cellvalue == undefined ? '' : cellvalue;
    el.onkeypress = "return isNumberKey(event)";
    return el.outerHTML || new XMLSerializer().serializeToString(el);
}

function textBoxQuantityFormatter(cellvalue, options, rowObject) {
    var el = document.createElement("input");
    try {
        el.type = "text";
        el.id = "txtQty" + rowObject.Person_ID;
        $(el).addClass("input-medium");
        el.value = cellvalue == undefined ? '' : cellvalue;
        el.onkeypress = "return isNumberKey(event)";
    } catch (e) { }
    return el.outerHTML || new XMLSerializer().serializeToString(el);
};

function selectFormatter(cellvalue, options, rowObject) {
    var el = document.createElement("select");
    try {
        el.value = cellvalue == undefined ? '' : cellvalue;
        el.id = "ddl" + rowObject.Person_ID;
        $(el).addClass("select");
        $(optionReadiness).each(function () {
            $(el).append($("<option></option>").val(this['ExecutionLevel_ID']).html(this['ExecutionLevel_ORGName']));
        });
    } catch (e) {
    }
    return el.outerHTML || new XMLSerializer().serializeToString(el);
};

groupEvent.getSelectedEmployeeIDs = function () {
    var flag = new Boolean();
    var arrIDs = new Array();
    var persons = new Array();
    $("#waitplease").css({ 'display': 'block' });
    arrIDs = $("#tlbEmlpoyee").getGridParam("selarrrow");
    if (arrIDs[0] == undefined) arrIDs[0] = "0";
    try {
        $(arrIDs).each(function () {
            var tempPerson = $("#tlbEmlpoyee").getRowData(this);
            switch ($("#hidEventTypeID").val()) {
                case "0":
                    try {
                        persons.push({
                            TrainingEvent_Date: $('#txtGroupEventDate').val(),
                            Person_FirstName: tempPerson.Person_FirstName,
                            Person_LastName: tempPerson.Person_LastName,
                            Job_Name: tempPerson.Job_Name,
                            Unit_Name: tempPerson.Unit_Name,
                            TrainingEventType_ID: $('#ddlTrainingEventType').val(),
                            Person_ID: tempPerson.Person_ID
                        });
                    } catch (e) { }
                    break;
                case "1":
                    if ($("#ddl" + tempPerson.Person_ID + " option:selected").val() == "0") {
                        $("#ddl" + tempPerson.Person_ID).addClass("ui-state-error");
                        flag = false;
                        $("#waitplease").css({ 'display': 'none' });
                    } else {
                        $("#ddl" + tempPerson.Person_ID).removeClass("ui-state-error");
                        try {
                            persons.push({
                                ExecutionLevel_ID: $("#ddl" + tempPerson.Person_ID + " option:selected").val(),
                                ExecutionLevel_ORGName: $("#ddl" + tempPerson.Person_ID + " option:selected").text(),
                                TrainingEvent_Date: $('#txtGroupEventDate').val(),
                                Person_FirstName: tempPerson.Person_FirstName,
                                Person_LastName: tempPerson.Person_LastName,
                                Job_Name: tempPerson.Job_Name,
                                Unit_Name: tempPerson.Unit_Name,
                                TrainingEventType_ID: $('#ddlTrainingEventType').val(),
                                Person_ID: tempPerson.Person_ID
                            });
                        } catch (e) { }
                    }
                    break;
                case "2":
                    if ($("#txtScore" + tempPerson.Person_ID).val() == "") {
                        $("#txtScore" + tempPerson.Person_ID).addClass("ui-state-error");
                        flag = false;
                        $("#waitplease").css({ 'display': 'none' });
                    } else {
                        $("#txtScore" + tempPerson.Person_ID).removeClass("ui-state-error");
                        try {
                            persons.push({
                                TrainingEvent_Date: $('#txtGroupEventDate').val(),
                                TrainingEventType_ID: $('#ddlTrainingEventType').val(),
                                Person_ID: tempPerson.Person_ID,
                                Person_FirstName: tempPerson.Person_FirstName,
                                Person_LastName: tempPerson.Person_LastName,
                                Job_Name: tempPerson.Job_Name,
                                Unit_Name: tempPerson.Unit_Name,
                                TrainingEvent2Person_Score: $("#txtScore" + tempPerson.Person_ID).val() == "" ? null : $("#txtScore" + tempPerson.Person_ID).val()
                            });
                        } catch (e) {
                        }
                    }
                    break;
                case "3":
                    if ($("#txtQty" + tempPerson.Person_ID).val() == "") {
                        $("#txtQty" + tempPerson.Person_ID).addClass("ui-state-error");
                        flag = false;
                        $("#waitplease").css({ 'display': 'none' });
                    } else {
                        $("#txtQty" + tempPerson.Person_ID).removeClass("ui-state-error");
                        try {
                            persons.push({
                                TrainingEvent_Date: $('#txtGroupEventDate').val(),
                                TrainingEventType_ID: $('#ddlTrainingEventType').val(),
                                Person_ID: tempPerson.Person_ID,
                                Person_FirstName: tempPerson.Person_FirstName,
                                Person_LastName: tempPerson.Person_LastName,
                                Job_Name: tempPerson.Job_Name,
                                Unit_Name: tempPerson.Unit_Name,
                                TrainingEvent2Person_Quantity: $("#txtQty" + tempPerson.Person_ID).val() == "" ? null : $("#txtQty" + tempPerson.Person_ID).val()
                            });
                        } catch (e) { }
                    }
                    break;
            }
        });
        if (flag) {
            try {
                PQ.Admin.WebService.EventRecords.TrainingGroupEvent2Person_Save(persons,
				function (result) {
				    if (result) {
				        $("#tblEmlpoymentEvaluation").GridUnload();
				        groupEvent.EmlpoymentEvaluationsGrid(result, $("#hidEventTypeID").val());
				        $('#divEmployeeForEvent').dialog('destroy');
				    }
				    $("#waitplease").css({ 'display': 'none' });
				}, function (e) {
				    $("#waitplease").css({ 'display': 'none' });
				    $('#divEmployeeForEvent').dialog('destroy');
				});
            } catch (e) { }
        }
    } catch (e) { }
};

groupEvent.GetPerfomanceLevelArray = function () {
    var tempStr = '{';
    try {
        PQ.Admin.WebService.EventRecords.PerfomanceLevel_SelectAll($("#hidGroupEvent_GrtPerfomanceLabel").text(),
	 function (result) {
	     optionReadiness = result;
	     $(result).each(function () {
	         tempStr += this.ExecutionLevel_ID + ':"' + this.ExecutionLevel_ORGName + '",';
	     });
	     tempStr = tempStr.substring(0, tempStr.length - 1);
	     tempStr += '}';
	     optionsArray = tempStr;
	 },
	 function (e) { });
    } catch (e) {
    }
};

groupEvent.TrainingEvent2Person_Delete = function (personID) {
    if (personID != undefined) {
        $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
            open: function (type, data) {
                $(this).parent().appendTo("form");
            },
            buttons: {
                Ok: function (e) {
                    e.preventDefault();
                    $("#waitplease").css({ 'display': 'block' });
                    $(this).dialog('destroy');
                    try {
                        PQ.Admin.WebService.EventRecords.TrainingGroupEvent_Delete(personID,
							function (result) {
							    if (result) {
							        $("#tblEmlpoymentEvaluation").GridUnload();
							        groupEvent.EmlpoymentEvaluationsGrid(result, $("#hidEventTypeID").val());
							    }
							    $("#waitplease").css({ 'display': 'none' });
							}, function (e) {
							    $("#waitplease").css({ 'display': 'none' });
							    return false;
							});
                    } catch (e) {
                        $("#waitplease").css({ 'display': 'none' });
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

groupEvent.GetEventSubjectItems = function () {
    //    $("#divEmployeeEvaluation");
};

//-------------------------------------- End List Emlpoyees Grid Population ------------------------------------------------

function SetVisibilityText(selectedValue) {
    $('#divPersonDetails').block({
        css: { border: '0px' },
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 }
    });
    if (!isNaN(selectedValue)) {
        selectedValue = parseInt(selectedValue);
        switch (selectedValue) {
            case 1:
                $('#divPerfomanceLevel').css({ 'display': 'block' });
                $('#divTotalScore').css({ 'display': 'none' });
                $('#divQuality').css({ 'display': 'none' });
                $('#txtQuantityUpd').val('');
                $('#txtEventScoreUpd').val('');
                break;
            case 2:
                $('#divTotalScore').css({ 'display': 'block' });
                $('#divPerfomanceLevel').css({ 'display': 'none' });
                $('#divQuality').css({ 'display': 'none' });
                $('#ddlPerfomanceLevelUpdate').val('0'); $('#txtQuantityUpd').val('');
                break;
            case 3:
                $('#divQuality').css({ 'display': 'block' });
                $('#divPerfomanceLevel').css({ 'display': 'none' });
                $('#divTotalScore').css({ 'display': 'none' });
                $('#ddlPerfomanceLevelUpdate').val('0'); $('#txtEventScoreUpd').val('');
                break;
        }
        $('#divPersonDetails').unblock();
    }
}

groupEvent.RequaredFields = function () {
    var result = new Boolean(true);
    if ($("#txtGroupEventDate").val() == "") {
        $('#txtGroupEventDate').addClass('ui-state-error').focus(); result = false;
        return false;
    }
    else {
        $('#txtGroupEventDate').removeClass('ui-state-error', 100);
        result = true;
    }
    if ($("#ddlTrainingEventType").val() == "0") {
        $('#ddlTrainingEventType').addClass('ui-state-error').focus(); result = false;
        return false;
    }
    else {
        $('#ddlTrainingEventType').removeClass('ui-state-error', 100);
        result = true;
    }
    return result;
};

groupEvent.TrainingEventGroup_Save = function (eventSubjects, gridParam, upload) {
    if (gridParam.length != 0) {
        var _eventSubjectsList = new Array();
        try {
            for (var i = 0; i < eventSubjects.length; i++) {
                _eventSubjectsList.push({ TrainingEventCategory_ID: eventSubjects[i], TrainingEventType_ID: $("#ddlTrainingEventType").val() });
            }
            var _trainingEvents = {
                TrainingEventTypeID: $("#ddlTrainingEventType").val(),
                TrainingEventDate: $("#txtGroupEventDate").val(),
                TrainingEventRemarks: $("#editRemarks").val(),
                UserFullName: $("#hidFullName").val(),
                ManagerName: $("#txtManagerName").val()
            };
            var groupTrainingEvent = { TrainingEvent2PersonCollection: gridParam, TrainingEventCategoryCollection: _eventSubjectsList, TrainingEvents: _trainingEvents };
            PQ.Admin.WebService.EventRecords.TrainingEventGroup_Save(groupTrainingEvent,
		function (result) {
		    if (result) {
		        $("#dialogSuccessMessage").dialog({ autoOpen: true, resizable: true, closeOnEscape: true, modal: true, height: 150,
		            open: function (type, data) {
		                $("#lblSuccessMessage").text($("#hidSaveSuccessMessage").text());
		            },
		            buttons: {
		                Ok: function () {
		                    $(this).dialog("destroy");
		                    location.href = "/opeReady/Default.aspx";
		                }
		            }
		        });
		        upload.setData({ "EventPersons": JSON.stringify(result) });
		        upload.submit();
		    }
		    $("#waitplease").css({ 'display': 'none' });
		}, function (e) {
		    $("#waitplease").css({ 'display': 'none' });
		    return false;
		});
        } catch (e) {

        }
    }
    else {
        setTimeout(function () {
            $("#waitplease").css({ 'display': 'none' });
            RaiseWarningAlert($("#hidNoPersonInEvent").text());
        }, 500);

    }
};
//=============================================================================================================================
//---------------------------------------- Admin Task employee grouped events -------------------------------------------------

//--------------------------------------------------------- Begin grid settings --------------------------------------------------------------------------------

groupEvent.AdminTaskEmployeesGrid = function (person) {
    var _langDir;
    var lastsel;
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            _langDir = "rtl";
        else
            _langDir = "ltr";
    }
    $("#tblAdminTaskEmployee").jqGrid({
        direction: _langDir,
        datatype: function (pdata) { groupEvent.getAdminTaskEmlpoyeeListData(person); },
        height: 305,
        width: 800,
        colNames: [$('#hiddFuildCaptions span[id=hidEmployeeID]').text(),
				$('#hiddFuildCaptions span[id=hidFirstName]').text(),
				$('#hiddFuildCaptions span[id=hidLastName]').text(),
				$('#hiddFuildCaptions span[id=hidJob]').text(),
				$('#hiddFuildCaptions span[id=hidUnit]').text(),
				$('#hiddFuildCaptions span[id=hidEventRecordsDelete]').text()
			],
        colModel: [
				{ name: 'Person_ID', index: 'Person_ID', key: true, sortable: true, sorttype: 'int', width: 100 },
				{ name: 'Person_FirstName', index: 'Person_FirstName', sortable: true, sorttype: 'text', width: 100 },
				{ name: 'Person_LastName', index: 'Person_LastName', sortable: true, sorttype: 'text', width: 100 },
				{ name: 'Job_Name', index: 'Job_Name', sortable: true, sorttype: 'text', width: 120 },
				{ name: 'Unit_Name', index: 'Unit_Name', sortable: true, sorttype: 'text', width: 120 },
				{ name: 'DeleteEmployee', index: 'DeleteEmployee', sortable: false, width: 60, formatter: deleteFormatter, align: 'center' },
			],
        viewrecords: true,
        sortorder: "asc",
        autoencode: false,
        loadonce: true,
        recordpos: 'left',
        pager: '#pgrEmployee',
        toolbar: [true, "top"],
        pgbuttons: false,
        pginput: false,
        rowNum: 10000,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local' });
            var ids = $(this).jqGrid('getDataIDs');
            if (rowCount == $(this).getGridParam('records')) {
                $("#waitplease").css({ 'display': 'none' });
                $(this).jqGrid('sortGrid', "Person_ID", true);
            }
        },
        onCellSelect: function (rowid, iCol, cellcontent, e) {
            if (iCol == 5) {
                return groupEvent.AdminTaskEmployeeListData_Delete($(this).getRowData(rowid).Person_ID);
            }
            return false;
        }
    })
	.toolbarButtonAdd("#t_tblAdminTaskEmployee",
		{
		    caption: $('#hidGroupEvent_btnAddEmployee').text(),
		    position: "first",
		    align: (_langDir == 'rtl' ? 'right' : 'left'),
		    buttonicon: 'ui-icon-circle-plus',
		    onClickButton: function () {
		        groupEvent.AddAdminTaskEmployeeForEvent();
		    }
		})
	.jqGrid('gridResize', { minWidth: 900, minHeight: 300 });
};

groupEvent.getAdminTaskEmlpoyeeListData = function (data) {
    if (data) {
        groupEvent.ReceivedAdminTaskEmployeeListData(data);
    }
};

groupEvent.ReceivedAdminTaskEmployeeListData = function (data) {
    var thegrid = $("#tblAdminTaskEmployee");
    thegrid.clearGridData();
    rowCount = data.length;
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
};

groupEvent.AdminTaskEmployeeListData_Delete = function (personID) {
    if (personID != undefined) {
        $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
            open: function (type, data) {
                $(this).parent().appendTo("form");
            },
            buttons: {
                Ok: function (e) {
                    e.preventDefault();
                    $("#waitplease").css({ 'display': 'block' });
                    $(this).dialog('destroy');
                    try {
                        PQ.Admin.WebService.EventRecords.AdminTaskEventGroup_Delete(personID,
							function (result) {
							    if (result) {
							        $("#tblAdminTaskEmployee").GridUnload();
							        groupEvent.AdminTaskEmployeesGrid(result);
							    }
							    $("#waitplease").css({ 'display': 'none' });
							}, function (e) {
							    $("#waitplease").css({ 'display': 'none' });
							    return false;
							});
                    } catch (e) {
                        $("#waitplease").css({ 'display': 'none' });
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

//--------------------------------------------------------- End grid settings --------------------------------------------------------------------------------
groupEvent.AddAdminTaskEmployeeForEvent = function () {
    if (groupEvent.RequaredAadminTaskFields()) {
        $('#divAdminTaskEmployeeList input:text').each(function () {
            $(this).val('');
        });
        $('#hidUnitID').val('');
        $("#ddlJobAT>option").remove();
        $("#ddlJobAT").append($("<option></option>").val(0).html($("#hidGroupEvent_grtSelectJobs").text()));
        $("#tlbEmlpoyeeAdminTaskGrid").GridUnload();
        $("#divAdminTaskEmployeeList").dialog({ autoOpen: true, resizable: true, closeOnEscape: true, width: '1024px', modal: true, zIndex: 50,
            open: function (event, ui) {
                $(this).parent().appendTo("form");
                $('#hidATUnitID').val("");
            }
        });
    }
};

$("#btnAT_SerchEmployee").live("click", function () {
    $("#waitplease").css({ 'display': 'block' });
    var _person = {
        Person_FirstName: $('#txtAT_FirstName').val(),
        Person_LastName: $('#txtAT_LastName').val(),
        Job_ID: $('#ddlJobAT').val(),
        UnitID: $('#hidATUnitID').val(),
        IsActive: true,
        IsReadiness: true
    };
    $("#tlbEmlpoyeeAdminTaskGrid").GridUnload();
    groupEvent.GetAdminTaskEmlpoyeeGrid(_person);
    return false;
});

groupEvent.GetAdminTaskEmlpoyeeGrid = function (person) {
    var _langDir;
    var lastsel;
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            _langDir = "rtl";
        else
            _langDir = "ltr";
    }
    $("#tlbEmlpoyeeAdminTaskGrid").jqGrid({
        direction: _langDir,
        datatype: function (pdata) { groupEvent.getAdminTaskEmlpoyeeListGrid(person); },
        height: 375,
        width: 800,
        colNames: [$('#hiddFuildCaptions span[id=hidEmployeeID]').text(),
				$('#hiddFuildCaptions span[id=hidFirstName]').text(),
				$('#hiddFuildCaptions span[id=hidLastName]').text(),
				$('#hiddFuildCaptions span[id=hidJob]').text(),
				$('#hiddFuildCaptions span[id=hidUnit]').text()
			],
        colModel: [
				{ name: 'Person_ID', index: 'Person_ID', key: true, sortable: true, sorttype: 'int', width: 100 },
				{ name: 'Person_FirstName', index: 'Person_FirstName', sortable: true, sorttype: 'text', width: 100 },
				{ name: 'Person_LastName', index: 'Person_LastName', sortable: true, sorttype: 'text', width: 100 },
				{ name: 'Job_Name', index: 'Job_Name', sortable: true, sorttype: 'text', width: 100 },
				{ name: 'Unit_Name', index: 'Unit_Name', sortable: true, sorttype: 'text', width: 100 }
			],
        viewrecords: true,
        sortorder: "asc",
        autoencode: false,
        loadonce: true,
        recordpos: 'left',
        pager: '#pgrEmlpoyeeAdminTask',
        pgbuttons: false,
        pginput: false,
        multiselect: true,
        rowNum: 10000,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local' });
            var ids = $(this).jqGrid('getDataIDs');
            if (rowCount == $(this).getGridParam('records')) {
                $("#waitplease").css({ 'display': 'none' });
                $(this).trigger('reloadGrid');
                $(this).jqGrid('sortGrid', "Person_ID", true);
            }
        },
        onSelectAll: function (rowid, e) {
            if (e) groupEvent.selctedID = rowid;
            else groupEvent.selctedID = null;
            return false;
        },
        onSelectRow: function (id) {
            if (id && id !== lastsel) {
                $(this).jqGrid('restoreRow', lastsel);
                $(this).jqGrid('editRow', id, true);
                lastsel = id;
            }
        }
    });
    $("#tlbEmlpoyeeAdminTaskGrid").jqGrid('gridResize', { minWidth: 900, minHeight: 300 });

};
groupEvent.getAdminTaskEmlpoyeeListGrid = function (_person) {
    if (_person) {
        try {
            var temp = $("#tblAdminTaskEmployee").getDataIDs();
            PQ.Admin.WebService.EmployeeSearchWS.EmployeeSearching(_person, temp,
			function (data) {
			    groupEvent.AdminTaskReceivedEmployeeListData(JSON.parse(getMain(data)).rows);
			}, function (data, textStatus) {
			    RaiseWarningAlert('An error has occured retrieving data!');
			});
        } catch (e) { }
    }
};

groupEvent.AdminTaskReceivedEmployeeListData = function (data) {
    var thegrid = $("#tlbEmlpoyeeAdminTaskGrid");
    thegrid.clearGridData();
    rowCount = data.length;
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
};

groupEvent.AdminTaskSelectedEmployeeIDs = function () {
    var flag = new Boolean();
    var arrIDs = new Array();
    var persons = new Array();
    $("#waitplease").css({ 'display': 'block' });
    arrIDs = $("#tlbEmlpoyeeAdminTaskGrid").getGridParam("selarrrow");
    if (arrIDs[0] == undefined) arrIDs[0] = "0";
    try {
        $(arrIDs).each(function () {
            var tempPerson = $("#tlbEmlpoyeeAdminTaskGrid").getRowData(this);
            try {
                persons.push({
                    PersonQualification_FromDateStr: $('#txtAdminTaskDate').val(),
                    Person_FirstName: tempPerson.Person_FirstName,
                    Person_LastName: tempPerson.Person_LastName,
                    Job_Name: tempPerson.Job_Name,
                    Unit_Name: tempPerson.Unit_Name,
                    SubQualificationType_ID: $('#ddlAdminTaskTrainingEventType').val(),
                    Person_ID: tempPerson.Person_ID,
                    PersonQualification_Remarks: $('#txtAdminTaskRemarks').val()
                });
            } catch (e) { }
        });
        try {
            PQ.Admin.WebService.EventRecords.AdminTaskGroupEvent2Person_Save(persons,
				function (result) {
				    if (result) {
				        var temp = JSON.parse(getMain(result)).rows;
				        $("#tblAdminTaskEmployee").GridUnload();
				        groupEvent.AdminTaskEmployeesGrid(temp);
				        $('#divAdminTaskEmployeeList').dialog('destroy');
				    }
				    $("#waitplease").css({ 'display': 'none' });
				}, function (e) {
				    $("#waitplease").css({ 'display': 'none' });
				    $('#divAdminTaskEmployeeList').dialog('destroy');
				});
        } catch (e) { }
    } catch (e) { }
};

groupEvent.RequaredAadminTaskFields = function () {
    var result = new Boolean(true);
    if ($("#txtAdminTaskDate").val() == "") {
        $('#txtAdminTaskDate').addClass('ui-state-error').effect("pulsate").focus(); result = false;
        return false;
    }
    else {
        $('#txtAdminTaskDate').removeClass('ui-state-error', 100);
        result = true;
    }
    if ($("#ddlAdminTaskTrainingEventType").val() == "0") {
        $('#ddlAdminTaskTrainingEventType').addClass('ui-state-error').effect("pulsate").focus(); result = false;
        return false;
    }
    else {
        $('#ddlAdminTaskTrainingEventType').removeClass('ui-state-error', 100);
        result = true;
    }
    return result;
};

//------------------------------------ Autocomplete Admin task fist & last name ---------------------------------------------------

groupEvent.SetFirstNameArray = function () {
    try {
        $("#txtAT_FirstName").autocomplete({
            source: function (request, response) {
                PQ.Admin.WebService.PQWebService.GetFirstNameCompletionList(request.term,
				  function (data) {
				      if (data) {
				          response($.map(getMain(data), function (item) {
				              return {
				                  value: item.Person_FirstName
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
groupEvent.SetLastNameArray = function () {
    try {
        $("#txtAT_LastName").autocomplete({
            source: function (request, response) {
                PQ.Admin.WebService.PQWebService.GetLastNameCompletionList(request.term,
				  function (data) {
				      if (data) {
				          response($.map(getMain(data), function (item) {
				              return {
				                  value: item.Person_LastName
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

//------------------------------------ End Autocomplete Admin task fist & last name ---------------------------------------------------


//========================================= Save Admin Task employee group ============================================================

groupEvent.AdminTaskEmploeeGroup_Save = function (gridParam) {
    if (gridParam.length != 0) {
        var _ategeList = new Array();

        try {

            for (var i = 0; i < gridParam.length; i++) {
                _ategeList.push({ Person_ID: gridParam[i].Person_ID,
                    SubQualificationType_ID: $("#ddlAdminTaskTrainingEventType").val(),
                    PersonQualification_FromDateStr: $("#txtAdminTaskDate").val(),
                    PersonQualification_Remarks: $("#txtAdminTaskRemarks").val()
                });
            }
            var groupAdminTaskEvent = { PersonList: _ategeList, AdminTaskGroupEventXML: '' };
            PQ.Admin.WebService.EventRecords.AdminTaskEventGroup_Save(groupAdminTaskEvent,
				function (result) {
				    if (result) {
				        $("#dialogSuccessMessage").dialog({ autoOpen: true, resizable: true, closeOnEscape: true, modal: true, height: 150,
				            open: function (type, data) {
				                $("#lblSuccessMessage").text($("#hidSaveSuccessMessage").text());
				            },
				            buttons: {
				                Ok: function () {
				                    $(this).dialog("destroy");
				                    location.href = "/opeReady/Default.aspx";
				                }
				            }
				        });
				    }
				    $("#waitplease").css({ 'display': 'none' });
				}, function (e) {
				    $("#waitplease").css({ 'display': 'none' });
				    return false;
				});
        } catch (e) {

        }
    }
    else {
        setTimeout(function () {
            $("#waitplease").css({ 'display': 'none' });
            RaiseWarningAlert($("#hidNoPersonInEvent").text());
        }, 500);

    }
};
