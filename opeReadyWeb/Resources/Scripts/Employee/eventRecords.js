/// <reference path="../Common/jquery-1.6.4.min.js" />
/// <reference path="~/Resources/Scripts/Common/jquery.common.js" />
var rowCount = 0;
var thresholdData;
var eventRecords = {
    availableTags: null,
    rowObject: null,
    selctedID: null
};

eventRecords.Init = function () {

};

eventRecords.DeleteEventSubject = function (trainingEvent, btnClose) {
    try {
        PQ.Admin.WebService.PQWebService.DeleteEventSubject(trainingEvent, this.ExecuteDeleteEventSubjectCallbackResult, this.ExecuteFailResult, btnClose);
    } catch (e) {
        alert(e.Description);
    }
};

eventRecords.ExecuteDeleteEventSubjectCallbackResult = function (result, btnClose) {
    if (result) {
        eventRecords.PopulateSubEvaluationTypeCombo(_trainingEventType_ID, $('#hidtrainingEventID').val());
        btnClose.slideUp(500, function () { $(this).remove(); });
    }
};

function deleteEventSubjects(element) {
    if ($.cookie("userRole") != "6") {
        $(element).each(function () {
            $(this).append('<div class="click_to_close"></div>');
        });
        $(".click_to_close").click(function () {
            var trainingEvent = { TrainingEventCategory_ID: $(this).parent().attr('tecat'), TrainingEvent_ID: $(this).parent().attr('te') };
            eventRecords.DeleteEventSubject(trainingEvent, $(this).parent());
        }); 
    }
    
};

///----------------------------------------------------- Event Records Grid Population ----------------------------------------------
function CreateAndPopulateEventRecordsGrid(trainingEventTypeID, eEventTypeID, isSimfoxData) {
    $("#waitplease").css({ 'display': 'block' });
    trainingEventTypeID = trainingEventTypeID == undefined ? null : trainingEventTypeID;
    var langDir = "ltr", editable = false;
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            langDir = "rtl";
        else
            langDir = "ltr";
    }
    if ($.cookie("userRole")) {
        if ($.cookie("userRole") == "6")
            editable = true;

    } 

    $("#tblEventHistory").jqGrid({
        direction: langDir,
        datatype: function (pdata) { eventRecords.getEventRecordsData(pdata, trainingEventTypeID, isSimfoxData); },
        height: 375,
        autowidth: false,
        colNames: [$('div span[id=hidEventRecordsFromDate]').text(),
				$('div span[id=hidEventType]').text(),
				$('div span[id=hidTrainingEventCategoryName]').text(),
				$('div span[id=hidReadinessLabel]').text(),
				$('div span[id=hidEventScore]').text(),
				$('div span[id=hidQuantity]').text(),
                $("#hidTrainingEventAttachCount").text(),
				$('div span[id=hidEventRecordsEdit]').text(),
				$('div span[id=hidEventRecordsDelete]').text(),
				'TrainingEvent_ID', 'TrainingEventType_ID', '', '', '', ''],
        colModel: [
				{ name: 'DateModificationSrt', index: 'DateModificationSrt', formatter: 'date', sortable: true, sorttype: 'date', width: 100 },
				{ name: 'TrainingEventType_Name', index: 'TrainingEventType_Name', sortable: true, width: 200 },
				{ name: 'TrainingEventCategory_Name', index: 'TrainingEventCategory_Name', sortable: true, sorttype: 'text', width: 200 },
				{ name: 'ExecutionLevel_ORGName', index: 'ExecutionLevel_ORGName', sortable: true, sorttype: 'text', formatter: thresholdReadinessFormatter, width: 130 },
				{ name: 'TrainingEvent2Person_Score', index: 'TrainingEvent2Person_Score', sortable: true, formatter: thresholdScoreFormatter, sorttype: 'number', width: 65 }, //
				{ name: 'TrainingEvent2Person_Quantity', index: 'TrainingEvent2Person_Quantity', sortable: true, formatter: thresholdQtyFormatter, sorttype: 'number', width: 65 }, //
                { name: 'TrainingEventAttachCount', index: 'TrainingEventAttachCount', sortable: false, formatter: countFormatter, width: 32, align: 'center' },
				{ name: 'EditUnit', index: 'EditUnit', sortable: false, formatter: editFormatter, width: 32, align: 'center' },
				{ name: 'delUnit', index: 'delUnit', hidden: editable, sortable: false, formatter: deleteFormatter, width: 50, align: 'center' },
				{ name: 'TrainingEvent_ID', hidden: 'true', key: true },
				{ name: 'TrainingEventType_ID', hidden: 'true' },
				{ name: 'ExecutionLevelColor', hidden: 'true' },
				{ name: 'ScoreColor', hidden: 'true' },
				{ name: 'QuantityColor', hidden: 'true' },
				{ name: 'BestPerformance', hidden: 'true' }
			],
        viewrecords: true,
        sortname: "DateModificationSrt",
        sortorder: "desc",
        autoencode: false,
        loadonce: false,
        recordpos: 'left',
        altRows: true,
        pager: '#pagerEventHistory',
        hoverrows: false,
        toolbar: [true, "top"],
        pgbuttons: false,
        pginput: false,
        rowNum: 2000,
        gridComplete: function (row) {
            $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
            if (rowCount == $(this).getGridParam('records')) {
                switch (eEventTypeID) {
                    case 0:
                        $(this).jqGrid('hideCol', ["ExecutionLevel_ORGName", "TrainingEvent2Person_Score", "TrainingEvent2Person_Quantity"]);
                        $('#ddlPerfomanceLevel').val('0'); $('#txtTotalScore').val(''); $('#txtQuality').val('');
                        break;
                    case 1:
                        $(this).jqGrid('hideCol', ["TrainingEvent2Person_Score", "TrainingEvent2Person_Quantity"]);
                        $('#txtQuality').val(''); $('#txtTotalScore').val('');
                        break;
                    case 2:
                        $(this).jqGrid('hideCol', ["ExecutionLevel_ORGName", "TrainingEvent2Person_Quantity"]);
                        $('#ddlPerfomanceLevel').val('0'); $('#txtQuality').val('');
                        break;
                    case 3:
                        $(this).jqGrid('hideCol', ["ExecutionLevel_ORGName"]);
                        $('#ddlPerfomanceLevel').val('0');
                        break;
                }
                $("#waitplease").css({ 'display': 'none' });
                $(this).trigger('reloadGrid');
                rowCount = 0;
            }
        },
        onCellSelect: function (rowid, iCol, cellcontent, e) {
            switch (iCol) {
                case 7:
                    $("#waitplease").css({ 'display': 'block' });
                    TrainingEventForm_click($(this).getRowData(rowid).TrainingEvent_ID, e);
                    break;
                case 8:
                    return eventRecords.TrainingEvent2Person_Delete($(this).getRowData(rowid).TrainingEvent_ID, rowid);
            }
            return false;
        },
        ondblClickRow: function (rowid, iRow, iCol, e) {
            $("#waitplease").css({ 'display': 'block' });
            TrainingEventForm_click($(this).getRowData(rowid).TrainingEvent_ID, e);
        }
    });
    $("#tblEventHistory")
	.jqGrid('gridResize', { minWidth: 800, minHeight: 300 });
    if ($.cookie("userRole") != "6") {
        $("#tblEventHistory").toolbarButtonAdd("#t_tblEventHistory",
		{
		    caption: $('#hidER_btnAddEvent').text(),
		    position: "first",
		    align: (langDir == 'rtl' ? 'right' : 'left'),
		    buttonicon: 'ui-icon-circle-plus',
		    onClickButton: function (e) {
		        btnAddEventHistoryItem_Click(e);
		    }
		});
    }

}

eventRecords.getEventRecordsData = function (pData, trainingEventTypeID, isSimfoxData) {
    var pid = getArgs();
    if (pid.eid) {
        PQ.Admin.WebService.EventRecords.TrainingEvent2Person_SelectByEvent(pid.eid, trainingEventTypeID, isSimfoxData == undefined ? false : isSimfoxData,
			function (data) {
			    eventRecords.ReceivedEventRecordsData(JSON.parse(getMain(data)).rows);
			}, function (e) {
			    alert('An error has occured retrieving data!');
			});
    }
};

eventRecords.ReceivedEventRecordsData = function (data) {
    var thegrid = $("#tblEventHistory");
    thegrid.clearGridData();
    rowCount = data.length;
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
};

function thresholdReadinessFormatter(cellvalue, options, rowObject) {
    var cValue = cellvalue == null ? "" : cellvalue;
    if (rowObject.ExecutionLevelColor) {
        return '<span  style="color:' + rowObject.ExecutionLevelColor + ';">' + cValue + '</span>';
    }
    else return cellvalue == undefined ? '' : cellvalue;
}

function thresholdScoreFormatter(cellvalue, options, rowObject) {
    var cValue = cellvalue == null ? "" : cellvalue;
    if (rowObject.ScoreColor) {
        return '<span  style="color:' + rowObject.ScoreColor + ';">' + cValue + '</span>';
    }
    else return cellvalue == undefined ? '' : cellvalue;
}
function countFormatter(cellvalue, options, rowObject) {
    if (rowObject.TrainingEventAttachCount > 0) {
        var img = new Image(32, 30);
        $(img).attr("src", "/opeReady/Resources/images/attachment.png");
        $(img).attr("style", "cursor:pointer;vertical-align:middle");
        return img.outerHTML || new XMLSerializer().serializeToString(img);
    }
    else return '';
}
function thresholdQtyFormatter(cellvalue, options, rowObject) {
    var cValue = cellvalue == null ? "" : cellvalue;
    if (rowObject.QuantityColor) {
        return '<span  style="color:' + rowObject.QuantityColor + ';">' + cValue + '</span>';
    }
    else return cellvalue == undefined ? '' : cellvalue;
}
eventRecords.TrainingEvent2Person_Delete = function (args, rowID) {
    if (args != undefined) {
        var _pid = getArgs();
        $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
            open: function (type, data) {
                $(this).parent().appendTo("form");
            },
            buttons: {
                Ok: function (e) {
                    e.preventDefault();
                    $("#waitplease").css({ 'display': 'block' });
                    try {
                        PQ.Admin.WebService.EventRecords.TrainingEvent2Person_Delete(args, _pid.eid,
							function (result) {
							    if (result) {
							        $("#" + rowID).hide('slow');
							        $("#tblEventHistory").resetSelection();
							        $("#waitplease").css({ 'display': 'none' });
							        $('#ConfirmDeleteAttachment').dialog('destroy');
							    }
							}, function () {
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

function TrainingEventForm_click(sender, e) {
    e.preventDefault();
    var isSimfox = $("#chkIsSimfox").attr("checked");
    $('#divGeneralInfo').block({
        css: { border: '0px' },
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    var pid = getArgs();
    if (sender) {
        PQ.Admin.WebService.EventRecords.TrainingEvent2Person_Select(pid.eid, sender, isSimfox,
		function (result) {
		    if (result) {
		        $('#spanPerfomanceLevel').text(" (" + result.MatchScore + ") ");
		        $('#btnAddEventSubject').removeAttr('disabled');
		        window._trainingEventType_ID = result.TrainingEventType_ID;
		        window._trainingEventID = result.TrainingEvent_ID;
		        $('#hidtrainingEventID').val(result.TrainingEvent_ID);
		        $('#hidTrainingEventTypeID').val(result.TrainingEventType_ID);
		        $('#ddlEventType').val(result.TrainingEventType_ID).addClass("no-display");
		        $('#txtEventDate').val(result.DateModificationSrt);
		        $("#editRemarks").val(unescape(result.TrainingEventRemarks));
		        $('#txtEventType').val(result.TrainingEventType_Name).removeClass("no-display");
		        $('#txtPerfomanceLevel').val(result.ExecutionLevel_ORGName);
		        $('#lblUpdaterName').text(result.UserFullName);
		        $("#txtManagerName").val(result.ManagerName);
		        $("#txtEventLocation").val(result.TrainingEventLocation);
		        $('#lblUpdateTime').text(result.UpdateTimeStampStr);
		        TrainingEvent2Categories_Select();
		        SetVisibilityText(window._trainingEventType_ID, true);
		        $("#tabs").tabs({ selected: 0, disabled: false });
		        eventRecords.PopulateSubEvaluationTypeCombo(result.TrainingEventType_ID, result.TrainingEvent_ID);
		        eventRecords.ReloadDetailEvaluationGrid(pid.eid, result.TrainingEvent_ID, result.TrainingEventType_ID);
		    }
		});
    }
    eventRecords.AutocompleteLocationField();
    eventRecords.AutocompleteManageField();
    divTrainingEventForm_Open();
    $("#waitplease").css({ 'display': 'none' });
    return false;
}

//--------------------------------------End Event Records Grid Population ----------------------------------------------


//-------------------------------------- Event Subjects Grid Population ----------------------------------------------------
/// <summary>
/// Create grid  Event Subjects for adding  event subjects to the form
/// </summary>
/// <param name="trainingEventTypeID">new/existing trainingEventTypeID</param>
/// <returns></returns>
eventRecords.AddEventSubjectsGrid = function (trainingEventTypeID) {
    var _langDir;
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            _langDir = "rtl";
        else
            _langDir = "ltr";
    }
    $('#divAddEventSubject').block({
        css: { border: '0px' },
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    $("#tblEventSubjects").jqGrid({
        direction: _langDir,
        datatype: function (pdata) { getEventSubjectsData(trainingEventTypeID); },
        autowidth: true,
        colNames: ['ID', $('div span[id=hidTrainingEventCategoryName]').text()],
        colModel: [
				{ name: 'TrainingEventCategory_ID', index: 'TrainingEventCategory_ID', formatter: 'integer', key: true, hidden: true },
				{ name: 'TrainingEventCategory_Name', index: 'TrainingEventCategory_Name', sortable: true, sorttype: 'text', width: 350 }
			],
        viewrecords: true,
        sortorder: "",
        pginput: true,
        recordpos: 'left',
        pager: '#pgrUnitHistory',
        pgbuttons: false,
        pginput: false,
        altRows: true,
        multiselect: true,
        sortname: 'TrainingEventCategory_ID',
        loadonce: true,
        rowNum: 2000,
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
            if (e) eventRecords.selctedID = rowid;
            else eventRecords.selctedID = null;
            return false;
        }
    });

};

function getEventSubjectsData(trainingEventTypeID) {
    setTimeout(function () { $("#waitplease").css({ 'display': 'block' }); }, 500);
    PQ.Admin.WebService.EventRecords.TrainingEventCategory_Select(trainingEventTypeID,
			function (data, textStatus) {
			    ReceivedEventSubjectsData(JSON.parse(getMain(data)).rows);
			}, function (data, textStatus) {
			    alert('An error has occured retrieving data!');
			});
};

function ReceivedEventSubjectsData(data) {
    var thegrid = $("#tblEventSubjects");
    thegrid.clearGridData();
    rowCount = data.length;
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
}




//-------------------------------------- End Event Subjects Grid Population ------------------------------------------------

function getSelectedIDs() {
    var arrIDs = new Array();
    $("#waitplease").css({ 'display': 'block' });
    arrIDs = $("#tblEventSubjects").getGridParam("selarrrow");
    if (arrIDs[0] == undefined) arrIDs[0] = "0";
    try {
        $("#divEmployeeEvaluation").block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        }); ;
        PQ.Admin.WebService.EventRecords.TrainingEventSubject_Save($('#hidtrainingEventID').val(), arrIDs, function (result) {
            if (result) {
                divEmployeeEvaluation.innerHTML = result;
                $("#waitplease").css({ 'display': 'none' });
                $("#divEmployeeEvaluationTotal").removeClass('ui-state-error').unblock();
                eventRecords.PopulateSubEvaluationTypeCombo(_trainingEventType_ID == undefined ? $('#ddlEventType').val() : _trainingEventType_ID, $('#hidtrainingEventID').val());
                $('#divAddEventSubject').dialog('destroy');
                eventRecords.SetDeleteEventSubjects();

            }
        }, this.ExecuteFailResult);
    } catch (e) {
    }
}


function TrainingEvent2Categories_Select() {
    try {
        var pid = getArgs();
        var isSimfox = $("#chkIsSimfox").attr("checked");
        if (pid.eid) {
            PQ.Admin.WebService.EventRecords.TrainingEvent2Categories_Select(pid.eid, $('#hidtrainingEventID').val(), isSimfox,
            function (result) {
                if (result) {
                    divEmployeeEvaluation.innerHTML = result.HtmlTrainingEvent2Categories;
                    $('#txtTotalScore').val(result.TrainingEvent2Person_Score == null ? "" : result.TrainingEvent2Person_Score);
                    $('#ddlPerfomanceLevel').val(result.ExecutionLevel_ID == null ? "0" : result.ExecutionLevel_ID);
                    $('#txtQuality').val(result.TrainingEvent2Person_Quantity == null ? "" : result.TrainingEvent2Person_Quantity);
                    $('#txtRemarksEvaluation').val(result.TrainingEvent2Person_Remarks == null ? "" : result.TrainingEvent2Person_Remarks);
                    $('#hidExecutionLevel_ID').val(result.ExecutionLevel_ID);
                    $("#txtPerformanceTime").val(result.ExecutionTimeStr);
                    eventRecords.SetDeleteEventSubjects();
                }
            }, this.ExecuteFailResult);
        }
    } catch (e) {
        alert(e.Description);
    }
}


function ReloadEventHistoryGrid(trainingEventTypeID) {
    $("#waitplease").css({ 'display': 'block' });
    //    $('#divEventHistoryTable').block({
    //        css: { border: '0px' },
    //        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.8 },
    //        message: ''
    //    });
    var isSimfox = $("#chkIsSimfox").attr("checked");
    if ($('#ddlTrainingEventType').val() == "0") {
        _trainEvTypeID = null;
        $("#hidEventTypeID").val("");
    }
    else
        _trainEvTypeID = trainingEventTypeID;
    PQ.Admin.WebService.EventRecords.TrainingEventType_SelectRequiredField(trainingEventTypeID,
	function (result) {
	    if (!isNaN(result)) {
	        $('#tblEventHistory').GridUnload();
	        $('#hidEventTypeID').val(result);

	        CreateAndPopulateEventRecordsGrid(trainingEventTypeID, result, isSimfox);
	        //            $('#divEventHistoryTable').unblock();
	    }
	},
	function (e) { $('#divEventHistoryTable').unblock(); $("#waitplease").css({ 'display': 'none' }); return false; });
};

function getRowIDs() {
    var ids = $("#tblEventSubjects").getDataIDs();
    var dataString = '';
    for (var i = 0; i < ids.length; i++) {
        dataString += 'postion: ' + i + ' ' + ids[i] + '\n';
    }
    alert(dataString);
}

eventRecords.SetDeleteEventSubjects = function () {
    deleteEventSubjects(".closeable");
}; //-------------------------------------- Population Detailed Evaluation Form -----------------------------------------------
eventRecords.ReloadDetailEvaluationGrid = function (personID, trainingEventID, trainingEventTypeID) {
    $("#waitplease").css({ 'display': 'block' });
    PQ.Admin.WebService.EventRecords.TrainingEventType_SelectRequiredField(trainingEventTypeID,
	function (result) {
	    if (!isNaN(result)) {
	        $("#divTrainingEventForm").unblock();
	        $('#tlbDetailedEvaluation').GridUnload();
	        eventRecords.DetalEvaluationGrid(personID, trainingEventID, result);
	    }
	},
	function (e) { return false; });
};


eventRecords.DetalEvaluationGrid = function (personID, trainingEventID, trainingEventTypeID) {
    var _langDir, editable = false;
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            _langDir = "rtl";
        else
            _langDir = "ltr";
    }
    if ($.cookie("userRole")) {
        if ($.cookie("userRole") == "6")
            editable = true;
    }
    $("#waitplease").css({ 'display': 'block' });
    $('#divDetailedEvaluation').block({
        css: { border: '0px' },
        timeout: 500,
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });

    $("#tlbDetailedEvaluation").jqGrid({
        direction: _langDir,
        datatype: function (pdata) { eventRecords.getDetailedEvaluationData(pdata, personID, trainingEventID); },
        height: 375,
        width: 680,
        autowidth: true,
        colNames: ['', $('#hidSubEvaluationType_Incomplete').text(),
				   $('div#hiddFuildCaptions span[id=hidSubEvaluationType]').text(),
				   $('div#hiddFuildCaptions span[id=hidEventScore]').text(),
				   $('div#hiddFuildCaptions span[id=hidReadinessLabel]').text(),
				   $('div#hiddFuildCaptions span[id=hidQuantity]').text(),
				   $('div#hiddFuildCaptions span[id=hidEventRecordsEdit]').text(),
				   $('div#hiddFuildCaptions span[id=hidEventRecordsDelete]').text(),
				   'SubEvaluationType_ID', 'ExecutionLevel_ID', 'SubEvaluationType_Remarks'],
        colModel: [
				{ name: 'TrainingEvent_ID', index: 'TrainingEvent_ID', formatter: 'integer', key: true, hidden: true },
				{ name: 'isMark4Alert', index: 'isMark4Alert', sortable: false, editable: true, width: 55, align: 'center', formatter: checkboxFormatter },
				{ name: 'SubEvaluationType_Name', index: 'SubEvaluationType_Name', sortable: true, sorttype: 'text', width: 200 },
				{ name: 'SubEvaluation2TrainingEvent_Score', index: 'SubEvaluation2TrainingEvent_Score', sortable: true, sorttype: 'number', width: 150 },
				{ name: 'ExecutionLevel_ORGName', index: 'ExecutionLevel_ORGName', sortable: true, sorttype: 'text', width: 150 },
				{ name: 'SubEvaluation2TrainingEvent_Quantity', index: 'SubEvaluation2TrainingEvent_Quantity', sortable: true, sorttype: 'int', width: 150 },
				{ name: 'EditEval', index: 'EditEval', sortable: false, edittype: 'image', formatter: editFormatter, width: 32, align: 'center' },
				{ name: 'DelEval', index: 'DelEval', sortable: false, hidden: editable, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
				{ name: 'SubEvaluationType_ID', index: 'SubEvaluationType_ID', formatter: 'integer', hidden: true },
				{ name: 'ExecutionLevel_ID', index: 'ExecutionLevel_ID', formatter: 'integer', hidden: true },
				{ name: 'SubEvaluationType_Remarks', index: 'SubEvaluationType_Remarks', hidden: true }
			],
        imgpath: '<%= ResolveClientUrl("~/Resources/Styles/redmon/images") %>',
        viewrecords: true,
        sortorder: "desc",
        autoencode: false,
        pginput: true,
        recordpos: 'left',
        rowNum: 2000,
        altRows: true,
        loadonce: false,
        pager: '#pgrDetailedEvaluation',
        toolbar: [true, "top"],
        hoverrows: false,
        pgbuttons: false,
        pginput: false,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
            switch (trainingEventTypeID) {
                case 1:
                    $(this).jqGrid('hideCol', ["SubEvaluation2TrainingEvent_Score", "SubEvaluation2TrainingEvent_Quantity"]);
                    break;
                case 2:
                    $(this).jqGrid('hideCol', ["ExecutionLevel_ORGName", "SubEvaluation2TrainingEvent_Quantity"]);
                    break;
                case 3:
                    $(this).jqGrid('hideCol', ["ExecutionLevel_ORGName"]);
                    break;
                default:
                    $(this).jqGrid('hideCol', ["ExecutionLevel_ORGName", "SubEvaluation2TrainingEvent_Score", 'SubEvaluation2TrainingEvent_Quantity']);
                    break;
            }
        },
        onCellSelect: function (rowid, iCol, cellcontent, e) {
            switch (iCol) {
                case 6:
                    eventRecords.btnUpdateDeatilEvaluation_Click($(this).getRowData(rowid));
                    break;
                case 7:
                    return eventRecords.btnDeleteDeatilEvaluation_Click($(this).getRowData(rowid));
                    break;
            }
            return false;
        },
        ondblClickRow: function (rowid, iRow, iCol, e) {
            $("#waitplease").css({ 'display': 'block' });
            eventRecords.btnUpdateDeatilEvaluation_Click($(this).getRowData(rowid));
        },
        afterInsertRow: function (rowid, rowdata) {
            if (rowdata.isMark4Alert) {
                $(this).jqGrid('setRowData', rowid, false, { color: 'red' });
            }
        }
    });
    if ($.cookie("userRole") != "6") {
        $("#tlbDetailedEvaluation").toolbarButtonAdd("#t_tlbDetailedEvaluation",
		{
		    caption: $('#hidER_DetailedEvaluation_Edit_btnAdd').text(),
		    position: "first",
		    align: (_langDir == 'rtl' ? 'right' : 'left'),
		    buttonicon: 'ui-icon-circle-plus',
		    onClickButton: function (e) {
		        btnAddDetailedEvaluation_Click();
		    }
		});
    }
};

function checkboxFormatter(cellvalue, options, rowObject) {
    var html;
    if (cellvalue) {
        html = "<input type='checkbox' onclick=\"eventRecords.SaveCheckBoxValue('" + rowObject.TrainingEvent_ID + "','" + rowObject.SubEvaluationType_ID + "', this,'" + options.rowId + "','" + rowObject + "');\" checked='checked' />";
        $("#" + options.rowId, $('#tlbDetailedEvaluation')).removeClass('ui-widget-content');
        $("#tlbDetailedEvaluation").setRowData(options.rowId, rowObject, { color: 'red' });
    }
    else
        html = "<input type='checkbox' onclick=\"eventRecords.SaveCheckBoxValue('" + rowObject.TrainingEvent_ID + "','" + rowObject.SubEvaluationType_ID + "', this,'" + options.rowId + "','" + rowObject + "');\"  />";
    return html;
}

eventRecords.getDetailedEvaluationData = function (pData, personID, trainingEventID) {
    var pid = getArgs();
    if (pid.eid) {
        PQ.Admin.WebService.EventRecords.SubEvaluation2TrainingEvent_Select(pid.eid, trainingEventID,
			function (data, textStatus) {
			    try {
			        ReceivedDetailedEvaluationData(JSON.parse(getMain(data)).rows);
			        $("#waitplease").css({ 'display': 'none' });
			    } catch (e) {

			    }

			}, function (data, textStatus) {
			    alert('An error has occured retrieving data!');
			});
    }
};

function ReceivedDetailedEvaluationData(data) {
    var thegrid = $("#tlbDetailedEvaluation");
    thegrid.clearGridData();
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
}


eventRecords.SaveCheckBoxValue = function (trainingEventID, subEvaluationType_ID, sender, rowID, rowObject) {
    $("#waitplease").css({ 'display': 'block' });
    var pid = getArgs();
    if (sender.checked)
        $("#tlbDetailedEvaluation").setRowData(rowID, rowObject, { color: 'red' });
    else
        $("#tlbDetailedEvaluation").setRowData(rowID, rowObject, { color: 'black' });
    if (pid.eid) {
        PQ.Admin.WebService.EventRecords.SubEvaluationType_SaveCheckBoxValue(trainingEventID, pid.eid, sender.checked, subEvaluationType_ID,
		function (data) {
		    setTimeout(function () { $("#waitplease").css({ 'display': 'none' }); }, 250);
		},
		function (e) { });
    }
};
eventRecords.btnUpdateDeatilEvaluation_Click = function (sender, args) {
    if (sender) {
        $('#hidtrainingEventID').val(sender.TrainingEvent_ID);
        $('#ddlSubEvaluationType').val(sender.SubEvaluationType_ID);
        $("#txtSubEvaluationTypeEdit").val(sender.SubEvaluationType_Name);
        $('#txtDetailEvaluationScore').val(sender.SubEvaluation2TrainingEvent_Score == "&nbsp;" ? null : sender.SubEvaluation2TrainingEvent_Score);
        $('#ddlDetEvalPerfomanceLabel').val(sender.ExecutionLevel_ID);
        SetVisibilityText($('#ddlEventType').val());
        $('#btnAddDeatilEvaluation').val($('#hidUpdate').text());
        $("#txtSubEvaluationTypeEdit").removeClass("no-display");
        $('#ddlSubEvaluationType').addClass("no-display");
        $('#txtSubEvaluation2TrainingEvent_Remarks').val(sender.SubEvaluationType_Remarks);
    }
    divAddDetailEvaluation_Open();
};
eventRecords.btnDeleteDeatilEvaluation_Click = function (args) {
    if (args != undefined) {
        var _pid = getArgs();
        var _subEvaluation = {
            Person_ID: _pid.eid,
            TrainingEvent_ID: args.TrainingEvent_ID,
            SubEvaluationType_ID: args.SubEvaluationType_ID
        };
        this.rowObject = args;

        $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
            open: function (type, data) {
                $(this).parent().appendTo("form");
            },
            buttons: {
                Ok: function (e) {
                    e.preventDefault();
                    $("#waitplease").css({ 'display': 'block' });
                    try {

                        PQ.Admin.WebService.EventRecords.SubEvaluation2TrainingEvent_Delete(_subEvaluation,
							function (result) {
							    if (result) {
							        $('#tlbDetailedEvaluation').GridUnload();
							        eventRecords.ReloadDetailEvaluationGrid(_subEvaluation.Person_ID, _subEvaluation.TrainingEvent_ID, $('#ddlEventType').val());
							        $("#waitplease").css({ 'display': 'none' });
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
    }
}; //-------------------------------------- End Population Detailed Evaluation Form --------------------------------------------

function btnAddDeatilEvaluation_Click() {
    $("#waitplease").css({ 'display': 'block' });
    var pid = getArgs();
    if (pid.eid) {
        var subevaluationtype = {
            TrainingEvent_ID: $('#hidtrainingEventID').val().trim() == "" ? null : $('#hidtrainingEventID').val().replace(/\s+/gi, ''),
            SubEvaluationType_ID: $('#ddlSubEvaluationType').val(),
            SubEvaluation2TrainingEvent_Score: $('#txtDetailEvaluationScore').val().trim() == "" ? null : $('#txtDetailEvaluationScore').val(),
            SubEvaluation2TrainingEvent_Quantity: $('#txtDetEvalQuantity').val().trim() == "" ? null : $('#txtDetEvalQuantity').val(),
            ExecutionLevel_ID: $('#ddlDetEvalPerfomanceLabel').val() == "0" ? null : $('#ddlDetEvalPerfomanceLabel').val(),
            Person_ID: pid.eid,
            SubEvaluationType_Remarks: $('#txtSubEvaluation2TrainingEvent_Remarks').val()
        };
        try {
            PQ.Admin.WebService.EventRecords.SubEvaluation2TrainingEvent_Save(subevaluationtype,
			function (result) {
			    $('#tlbDetailedEvaluation').GridUnload();
			    eventRecords.ReloadDetailEvaluationGrid(pid.eid, subevaluationtype.TrainingEvent_ID, $('#ddlEventType').val());
			    $("#waitplease").css({ 'display': 'none' });
			    $('#divAddDetailEvaluation').dialog('destroy');
			}, function () {
			    $("#waitplease").css({ 'display': 'none' });
			    $('#divAddDetailEvaluation').dialog('destroy');
			});
        } catch (e) {
            alert(e.Description);
        }
    }
    return false;
}

//-------------------------------------- Population Event Attachment Form ---------------------------------------------------

eventRecords.EventAttachmentGrid = function (trainingEventID) {
    var _langDir, editable = false;
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            _langDir = "rtl";
        else
            _langDir = "ltr";
    }
    $('#divDetailedEvaluation').block({
        css: { border: '0px' },
        timeout: 500,
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    if ($.cookie("userRole")) {
        if ($.cookie("userRole") == "6")
            editable = true;
    }
    $("#waitplease").css({ 'display': 'block' });
    $("#tlbEventAttachment").jqGrid({
        direction: _langDir,
        datatype: function (pdata) { eventRecords.getEventAttachmentData(pdata, trainingEventID); },
        height: 375,
        autowidth: true,
        colNames: [$('div#hiddFuildCaptions span[id=hidDate]').text(),
				   $('div#hiddFuildCaptions span[id=hidPersonAttachName]').text(),
				   $('div#hiddFuildCaptions span[id=hidEventRecordsEdit]').text(),
				   $('div#hiddFuildCaptions span[id=hidEventRecordsDelete]').text(),
				   'TrainingEvent_ID', 'TrainingEventAttachmentsID'],
        colModel: [
				{ name: 'DateCreated', index: 'DateCreated', sortable: true, sorttype: 'date', width: 200 },
				{ name: 'TrainingEventAttachmentsName', index: 'TrainingEventAttachmentsName', sortable: true, sorttype: 'number', width: 450 },
				{ name: 'OpenAttach', index: 'OpenAttach', sortable: false, edittype: 'image', formatter: attachFormatter, width: 32, align: 'center' },
				{ name: 'DelAttach', index: 'DelAttach', hidden: editable, sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
				{ name: 'TrainingEvent_ID', index: 'TrainingEvent_ID', hidden: true },
				{ name: 'TrainingEventAttachmentsID', index: 'TrainingEventAttachmentsID', key: true, hidden: true }
			],
        datefmt: 'd/m/Y',
        viewrecords: true,
        sortorder: "desc",
        autoencode: false,
        rowNum: 2000,
        altRows: true,
        recordpos: 'left',
        loadonce: false,
        toolbar: [true, "top"],
        hoverrows: false,
        pager: '#pgrEventAttachment',
        pgbuttons: false,
        pginput: false,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
        },
        onCellSelect: function (rowid, iCol, cellcontent, e) {
            switch (iCol) {
                case 2:
                    ImgPreviewDocument_click($(this).getRowData(rowid));
                    break;
                case 3:
                    eventRecords.btnDeleteEventAttachment_Click($(this).getRowData(rowid));
                    break;
            }
            return false;
        },
        ondblClickRow: function (rowid, iRow, iCol, e) {
            ImgPreviewDocument_click($(this).getRowData(rowid));
        }
    });
    //    $("#tlbEventAttachment").jqGrid('gridResize', { minWidth: 674, minHeight: 300 });
    if ($.cookie("userRole") != "6") {
        $("#tlbEventAttachment").toolbarButtonAdd("#t_tlbEventAttachment",
		{
		    caption: $('#hidER_DetailedEvaluation_Attach_btnAdd').text(),
		    position: "first",
		    align: (_langDir == 'rtl' ? 'right' : 'left'),
		    buttonicon: 'ui-icon-circle-plus',
		    onClickButton: function (e) {
		        btnAddEventAttachment_Click();
		    }
		});
    }

};

eventRecords.getEventAttachmentData = function (pData, trainingEventID) {
    var pid = getArgs();
    if (pid.eid) {
        PQ.Admin.WebService.EventRecords.TrainingEventAttachments_Select(null, trainingEventID,
			function (data, textStatus) {
			    try {
			        ReceivedEventAttachmentData(JSON.parse(getMain(data)).rows);
			        $("#waitplease").css({ 'display': 'none' });
			    } catch (e) { }

			}, function (data, textStatus) {
			    $("#waitplease").css({ 'display': 'none' });
			});
    }
};

function ReceivedEventAttachmentData(data) {
    var thegrid = $("#tlbEventAttachment");
    thegrid.clearGridData();
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
}


eventRecords.btnDeleteEventAttachment_Click = function (args) {
    if (args != undefined) {
        var _pid = getArgs();
        var trainingEventAttachmentsId = args.TrainingEventAttachmentsID;
        this.rowObject = args;

        $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
            open: function (type, data) {
                $(this).parent().appendTo("form");
            },
            buttons: {
                Ok: function (e) {
                    e.preventDefault();
                    $("#waitplease").css({ 'display': 'block' });
                    try {
                        PQ.Admin.WebService.EventRecords.TrainingEventAttachments_Delete(trainingEventAttachmentsId,
							function (result) {
							    if (result) {
							        $("#tlbEventAttachment").GridUnload();
							        eventRecords.EventAttachmentGrid($('#hidtrainingEventID').val());
							        $("#waitplease").css({ 'display': 'none' });
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
    }
}; //-------------------------------------- End Population Event Attachment Form -----------------------------------------------

//-------------------------------------- Population Event Records Comboes  ----------------------------------------------------

eventRecords.PopulateTrainingEventTypeCombo = function () {
    $("#ddlTrainingEventType>option").remove();
    $("#ddlEventType>option").remove();
    PQ.Admin.WebService.EventRecords.TrainingEventType_SelectAll($("#hidGrtTrainingEventType").text(), true,
		function (result) {
		    $(result).each(function () {
		        $("#ddlTrainingEventType").append($("<option></option>").val(this['TrainingEventType_ID']).html(this['TrainingEventType_Name']));
		        $("#ddlEventType").append($("<option></option>").val(this['TrainingEventType_ID']).html(this['TrainingEventType_Name']));
		    });
		},
	function (e) {
	    return false;
	});

};


//MatchScore
eventRecords.PopulatlPerfomanceLevelCombo = function () {
    $("#ddlPerfomanceLevel>option").remove();
    $("#ddlDetEvalPerfomanceLabel>option").remove();
    PQ.Admin.WebService.EventRecords.PerfomanceLevel_SelectAll($("#hidGrtPerfomanceLabel").text(),
	function (result) {
	    $(result).each(function () {
	        $("#ddlPerfomanceLevel").append($("<option></option>").val(this['ExecutionLevel_ID']).html(this['ExecutionLevel_ORGName']).attr("rel", this['MatchScore']));
	        $("#ddlDetEvalPerfomanceLabel").append($("<option></option>").val(this['ExecutionLevel_ID']).html(this['ExecutionLevel_ORGName']).attr("rel", this['MatchScore']));
	    });
	},
	function (e) {
	    return false;
	});
};

/// <summary>
/// Detailed Evaluation - population dropdown Task type
/// </summary>
/// <param name="trainingEventTypeID">Value from ddlEventType dropdown</param>
/// <param name="defaultGreeting"></param>
/// <returns></returns>
eventRecords.PopulateSubEvaluationTypeCombo = function (trainingEventTypeID, trainingEvent_ID) {
    $("#ddlSubEvaluationType>option").remove();
    PQ.Admin.WebService.EventRecords.SubEvaluationType_Select(trainingEventTypeID, trainingEvent_ID, $("#hidGrtSubEvaluationType").text(),
		 function (result) {
		     $(result).each(function () {
		         $("#ddlSubEvaluationType").append($("<option></option>").val(this['SubEvaluationType_ID']).html(this['SubEvaluationType_Name']));
		     });
		 },
	function (e) {
	    return false;
	});
};

eventRecords.AutocompleteManageField = function () {
    try {
        $("#txtManagerName").autocomplete({
            source: function (request, response) {
                PQ.Admin.WebService.EventRecords.AutocompleteManageField(request.term,
				  function (data) {
				      if (data) {
				          response($.map(getMain(data), function (item) {
				              return {
				                  value: item.ManagerName
				              };
				          }));
				      };
				  },
					function () {
					},
					null);
            }, minLength: 1
        });
    } catch (e) {
        return false;
    }
};

eventRecords.AutocompleteLocationField = function () {
    try {
        $("#txtEventLocation").autocomplete({
            source: function (request, response) {
                PQ.Admin.WebService.EventRecords.AutocompleteLocationField(request.term,
				  function (data) {
				      if (data) {
				          response($.map(getMain(data), function (item) {
				              return {
				                  value: item.TrainingEventLocation
				              };
				          }));
				      };
				  },
					function () {
					},
					null);
            }, minLength: 1
        });
    } catch (e) {
        return false;
    }
};


//-------------------------------------- End Population Event Records Combo  ------------------------------------------------
//-------------------------------------- Saving Training Event Form --------------------------------------------------------
function btnUpdate_onclick(flag) {
    if (RequaredTrainingEventFields(flag)) {
        $("#waitplease").css({ 'display': 'block' });
        var pid = getArgs();
        if (pid.eid) {
            var trainingEvent = {
                TrainingEvent2Person_Score: $('#txtTotalScore').val(),
                ExecutionLevel_ID: $('#ddlPerfomanceLevel').val(),
                TrainingEvent2Person_Quantity: $('#txtQuality').val() == "" ? null : $('#txtQuality').val(),
                TrainingEventRemarks: $("#editRemarks").val(),
                TrainingEvent_ID: $('#hidtrainingEventID').val() == "" ? null : $('#hidtrainingEventID').val(),
                TrainingEvent_Date: $('#txtEventDate').val(),
                TrainingEventType_ID: $('#ddlEventType').val() == "0" ? $("#hidTrainingEventTypeID").val() : $('#ddlEventType').val(),
                TrainingEvent2Person_Remarks: $('#txtRemarksEvaluation').val(),
                ExecutionTimeStr: $("#txtPerformanceTime").val(),
                Person_ID: pid.eid,
                UserFullName: $("#lnkAdmin").text(),
                ManagerName: $("#txtManagerName").val(),
                TrainingEventLocation: $("#txtEventLocation").val()
            };
            try {
                PQ.Admin.WebService.EventRecords.TrainingEvent_Save(trainingEvent, function (result) {
                    if (result) {
                        $('#hidtrainingEventID').val(result);
                        $('#btnAddEventSubject').removeAttr('disabled');
                        $("#tabs").tabs("option", "disabled", false);
                        $('#lblUpdaterName').text($("#lnkAdmin").text());
                        $('#lblUpdateTime').text(new Date("dd/MM/yy hh:mm:ss"));
                        eventRecords.ReloadDetailEvaluationGrid(pid.eid, result, trainingEvent.TrainingEventType_ID);
                    }
                    $('#tblEventHistory').GridUnload();
                    _trainEvTypeID = _trainEvTypeID == undefined ? null : _trainEvTypeID;
                    _evTypeID = $('#ddlTrainingEventType').val() == '0' ? null : parseInt($('#hidEventTypeID').val());
                    var isSimfox = $("#chkIsSimfox").attr("checked");
                    CreateAndPopulateEventRecordsGrid(_trainEvTypeID, _evTypeID, isSimfox);
                    $("#waitplease").css({ 'display': 'none' });
                }, function () {
                    $("#waitplease").css({ 'display': 'none' });
                    $('#divTrainingEventForm').dialog('destroy');
                });
            } catch (e) {
                alert(e.Description);
            }
        }
    }
    return false;
};
//-------------------------------------- End Saving Training Event Form ----------------------------------------------------
//-------------------------------------- Event Attachment Form Population --------------------------------------------------
function btnAddEventAttachment_Click() {
    $('#txtEventAttachmentName').val('');
    clearContents();
    divEventAttachment_Opent();
};

function RequaredEventAttachFields() {
    if ($('#txtEventAttachmentName').val() == '')
        $('#txtEventAttachmentName').addClass('ui-state-error').focus();
    else {
        $('#txtEventAttachmentName').removeClass('ui-state-error', 500);
        return true;
    }
    return false;
}

function btnUploadEventAttachment_Click() {

};

function EventAttachmentOnClientUploadComplete(sender, args) {
    $("#waitplease").css({ 'display': 'none' });
    $("#tlbEventAttachment").GridUnload();
    eventRecords.EventAttachmentGrid($('#hidtrainingEventID').val());
    $("#divEventAttachment").dialog('destroy');
};

function EventAttachmentOnClientUploadError(sender, args) {
    $("#waitplease").css({ 'display': 'none' });
    $('#divErrorMessage').removeClass('no-display');
    clearContents();
};

function EventAttachmentOnClientUploadStarted(sender, args) {
    $("#waitplease").css({ 'display': 'block' });
    return false;
};
function ImgPreviewDocument_click(args) {
    var _imgID = args.TrainingEventAttachmentsID;
    $('#hidEventAttachmentsID').val(_imgID);
    $('#btnReviewDownloadEventFile').click();
}
//-------------------------------------- End Attachment Form Population ----------------------------------------------------

//-------------------------------------- RequaredTrainingEventFields -------------------------------------------------------

function RequaredTrainingEventFields(flag) {
    var result = new Boolean(true);
    if ($("#txtEventDate").val() == "") {
        $('#txtEventDate').addClass('ui-state-error').focus();
        return false;
    }
    else {
        $('#txtEventDate').removeClass('ui-state-error', 500);
    }
    if ($("#ddlEventType").val() == "0" && $('#hidTrainingEventTypeID').val() == "") {

        $('#ddlEventType').addClass('ui-state-error').focus();
        return false;
    }
    else {
        $('#ddlEventType').removeClass('ui-state-error', 500);
    }
    $("#divHiddenFields .wrapper").each(function () {
        if (!$(this).hasClass('no-display')) {
            if ($(this).find('.wrappered').is("select")) {
                if ($(this).find('.wrappered').val() == "0") {
                    $(this).find('.wrappered').addClass('ui-state-error').focus();
                    result = false;
                    return false;
                }
                else $(this).find('.wrappered').removeClass('ui-state-error', 500);
            }
            if ($(this).find('.wrappered').is("input")) {
                if ($(this).find('.wrappered').val() == "") {
                    $(this).find('.wrappered').addClass('ui-state-error').focus();
                    result = false;
                    return false;
                }
                else $(this).find('.wrappered').removeClass('ui-state-error', 500);
            }
            if (flag) { //check otkuda prishel vyzov
                if ($("#divEmployeeEvaluation").is(':empty')) {
                    $("#divEmployeeEvaluationTotal").addClass('ui-state-error');
                    result = false;
                    return false;
                }
                else {
                    $("#divEmployeeEvaluationTotal").removeClass('ui-state-error', 500);
                }
            }
        }
        else {
            if (flag) { //check otkuda prishel vyzov
                if ($("#divEmployeeEvaluation").is(':empty')) {
                    $("#divEmployeeEvaluationTotal").addClass('ui-state-error');
                    result = false;
                    return false;
                }
                else {
                    $("#divEmployeeEvaluationTotal").removeClass('ui-state-error', 500);
                }
            }
        }
        if (CheckTimeValid()) {
            $("#txtPerformanceTime").removeClass('ui-state-error', 200);
        }
        else {
            $("#txtPerformanceTime").addClass('ui-state-error');
            result = false;
            return false;
        }
    });

    if (result) return true;
    else return false;
}

function CheckTimeValid() {
    var result = new Boolean(true);
    if ($("#txtPerformanceTime").val() != "" && $("#txtPerformanceTime").val() != "hh:mm:ss") {
        var re = new RegExp('^((([0]?[1-9]|1[0-2])(:|\.)[0-5][0-9]((:|\.)[0-5][0-9])?( )?(AM|am|aM|Am|PM|pm|pM|Pm))|(([0]?[0-9]|1[0-9]|2[0-3])(:|\.)[0-5][0-9]((:|\.)[0-5][0-9])?))$');
        result = re.test($("#txtPerformanceTime").val());
    }
    return result;
}

//-------------------------------------- End RequaredTrainingEventFields ---------------------------------------------------

eventRecords.PopulateJobsListCombo = function (unitID) {
    $("#ddlJobEventCopy").addClass("ui-autocomplete-loading");
    $("#ddlJobEventCopy>option").remove();
    unitID = unitID == "" ? 0 : unitID;
    try {
        PQ.Admin.WebService.PQWebService.GetJobByUnitID(unitID, $("#hidEventCopy_grtSelectJobs").text(),
			function (result) {
			    $(result).each(function () {
			        $("#ddlJobEventCopy").append($("<option></option>").val(this['Job_ID']).html(this['Job_Name']));
			    });
			    setTimeout(function () { $("#ddlJobEventCopy").removeClass("ui-autocomplete-loading"); }, 500);
			},
			function (e) { });
    } catch (e) { $("#waitplease").css({ 'display': 'none' }); }
    return false;
};
eventRecords.GetEventCopyEmlpoyeeGrid = function () {
    var _langDir;
    var lastsel;
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            _langDir = "rtl";
        else
            _langDir = "ltr";
    }
    $("#tlbEventCopyEmlpoyeeGrid").jqGrid({
        direction: _langDir,
        datatype: function (pdata) { eventRecords.getEventCopyEmlpoyeeListGrid(); },
        height: 375,
        width: 800,
        colNames: [$('#hidEmployeeID').text(),
				$('#hidFirstName').text(),
				$('#hidLastName').text(),
				$('#hidJob').text(),
				$('#hidUnit').text()
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
        loadonce: false,
        recordpos: 'left',
        pager: '#pgrEventCopyEmlpoyeeGrid',
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
            if (e) eventRecords.selctedID = rowid;
            else eventRecords.selctedID = null;
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
    $("#tlbEventCopyEmlpoyeeGrid").jqGrid('gridResize', { minWidth: 900, minHeight: 300 });
};

eventRecords.getEventCopyEmlpoyeeListGrid = function () {
    var pid = getArgs();
    var personList;
    if (pid.eid) personList = $.makeArray(pid.eid);
    try {
        var _person = {
            Person_FirstName: $("#txtFirstName").val(),
            Person_LastName: $("#txtLastName").val(),
            Job_ID: $("#ddlJobEventCopy").val(),
            UnitID: $("#hidECUnitID").val(),
            IsActive: true,
            IsReadiness: true
        };
        PQ.Admin.WebService.EmployeeSearchWS.EmployeeSearching(_person, personList,
			function (data) {
			    eventRecords.EventCopyReceivedEmployeeListData(JSON.parse(getMain(data)).rows);
			}, function (data, textStatus) {
			    RaiseWarningAlert('An error has occured retrieving data!');
			});
    } catch (e) { }
};

eventRecords.EventCopyReceivedEmployeeListData = function (data) {
    var thegrid = $("#tlbEventCopyEmlpoyeeGrid");
    thegrid.clearGridData();
    rowCount = data.length;
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
};

eventRecords.EventCopySelectedEmployeeIDs = function (person) {
    var pid = getArgs();
    var flag = new Boolean();
    var arrIDs = new Array();
    var persons = new Array();
    $("#waitplease").css({ 'display': 'block' });
    arrIDs = $("#tlbEventCopyEmlpoyeeGrid").getGridParam("selarrrow");
    if (arrIDs[0] == undefined) arrIDs[0] = "0";
    try {
        $(arrIDs).each(function () {
            var tempPerson = $("#tlbEventCopyEmlpoyeeGrid").getRowData(this);
            try {
                persons.push({
                    Person_ID: tempPerson.Person_ID
                });
            } catch (e) { }
        });
        person.PersonList = persons;
        try {
            PQ.Admin.WebService.EventRecords.EmployeeProfile_EventCopy(person,
				function (result) {
				    if (result) {
				        setTimeout(function () { $("#btnECClose").trigger("click"); $("#waitplease").css({ 'display': 'none' }); }, 500);
				    }

				}, function (e) {
				    $("#waitplease").css({ 'display': 'none' });
				    $("#btnECClose").trigger("click");
				});
        } catch (e) { }
    } catch (e) { }
};

eventRecords.SetFirstNameArray = function () {
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

eventRecords.SetLastNameArray = function () {
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

eventRecords.CreateUnitTree = function (userData, sender) {
    try {
        PQ.Admin.WebService.PQWebService.GetUserMenu(userData == undefined ? null : userData,
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
						    $('#txtEventCopyUnit').val($(data.rslt.obj.find("a").get(0)).text()).removeClass('ui-state-error', 100);
						    $("#hidECUnitID").val(data.rslt.obj.get(0).id);
						    eventRecords.PopulateJobsListCombo(data.rslt.obj.get(0).id);
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
