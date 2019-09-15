var rowCount;
var evaluationType = {};

evaluationType.PopulateTrainingEventCategoryCombo = function (trainingEventTypeID) {
    $("#ddlEventSubject>option").remove();
    PQ.Admin.WebService.AlertSettingService.TrainingEventCategory_Select(trainingEventTypeID, $("#hidEvaluationTpe_GrtTrainingEventCategory").text(),
        function (result) {
            $(result).each(function () {
                $("#ddlEventSubject").append($("<option></option>").val(this['TrainingEventCategory_ID']).html(this['TrainingEventCategory_Name']));
            });
            $("#ddlEventSubject").removeClass("ui-autocomplete-ddl-loading");
        },
    function (e) {
        return false;
    });
};
evaluationType.PopulateTrainingEventCategoryDetailsCombo = function (trainingEventTypeID) {
    $("#ddlEventSubjectDetails>option").remove();
    PQ.Admin.WebService.AlertSettingService.TrainingEventCategory_Select(trainingEventTypeID, $("#hidEvaluationTpe_GrtTrainingEventCategory").text(),
        function (result) {
            $(result).each(function () {
                $("#ddlEventSubjectDetails").append($("<option></option>").val(this['TrainingEventCategory_ID']).html(this['TrainingEventCategory_Name']));
            });
            $("#ddlEventSubjectDetails").removeClass("ui-autocomplete-ddl-loading");
        },
    function (e) {
        return false;
    });
};


//------------------------------------ Begin population grid ----------------------------------------------------
evaluationType.CreateEvaluationTypeGrid = function (trainingEventCategoryID) {
    var langDir = "ltr";
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar") langDir = "rtl";
    }
    $('#divDefineEvaluationType').block({
        css: { border: '0px' },
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    $("#tblEvaluationType").jqGrid({
        direction: langDir,
        datatype: function (pdata) { evaluationType.getEvaluationTypeData(trainingEventCategoryID); },
        height: 375,
        colNames: [
                    $('#hidEvaluationType_Grid_EventType').text(),
                    $('#hidEvaluationType_Grid_EventSubject').text(),
                    $('#hidEvaluationType_Grid_SubEvaluationType').text(),
                    '', '', 'TrainingEventCategory_ID',
                    'SubEvaluationType_ID',
                    'TrainingEventType_ID',
                    'TrainingEventType_Name'],
        colModel: [
                    { name: 'TrainingEventType_Name', index: 'TrainingEventType_Name', sortable: true, sorttype: 'text', width: 250 },
               		{ name: 'TrainingEventCategory_Name', index: 'TrainingEventCategory_Name', sortable: true, sorttype: 'text', width: 250 },
                    { name: 'SubEvaluationType_Name', index: 'SubEvaluationType_Name', sortable: true, sorttype: 'text', width: 250 },
                    { name: 'EditType', index: 'EditType', sortable: false, edittype: 'image', formatter: editFormatter, width: 35, align: 'center' },
                    { name: 'DelType', index: 'DelType', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                    { name: 'TrainingEventCategory_ID', hidden: 'true' },
                    { name: 'SubEvaluationType_ID', hidden: 'true' },
                    { name: 'TrainingEventType_ID', hidden: 'true' },
                    { name: 'TrainingEventType_Name', hidden: 'true' }
               	],
        viewrecords: true,
        sortorder: "asc",
        autoencode: false,
        loadonce: false,
        altRows: true,
        hoverrows: false,
        toolbar: [true, "top"],
        recordpos: (langDir == 'rtl' ? 'left' : 'right'),
        pager: '#pgrEvaluationType',
        pgbuttons: false,
        pginput: false,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
            if (rowCount == $(this).getGridParam('records')) {
                $("#waitplease").css({ 'display': 'none' });
                $('#divDefineEvaluationType').unblock();
            }
        },
        onCellSelect: function (rowid, iCol, cellcontent, e) {
            switch (iCol) {
                case 3:
                    evaluationType.DefineEvaluationTypeSetting_Open($(this).getRowData(rowid));
                    break;
                case 4:
                    return evaluationType.DefineEvaluationType_Delete($(this).getRowData(rowid).SubEvaluationType_ID);
                    break;
            }
            return false;
        },
        ondblClickRow: function (rowid, iRow, iCol, e) {
            evaluationType.DefineEvaluationTypeSetting_Open($(this).getRowData(rowid));
        }
    });
    $("#tblEvaluationType")
        .jqGrid('gridResize', { minWidth: 750, minHeight: 300 })
        .toolbarButtonAdd("#t_tblEvaluationType",
            {
                caption: $('#hidEvaluationType_btnAddEvaluationType').text(),
                position: "first",
                align: (langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-circle-plus',
                onClickButton: function () {
                    evaluationType.DefineEvaluationTypeData_New();
                }
            })
            .toolbarButtonAdd("#t_tblEvaluationType",
            {
                caption: "Excel",
                position: "last",
                align: (langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                    if (rowCount == 0) return false;
                    $("#tblEvaluationType").jqGrid('excelExport', { url: '/opeReady/Handlers/ExcelExport/EvaluationTypeSettingsExcel.ashx?tec=' + $("#"+trainingEventCategoryID).val() });
                }
            });
};

evaluationType.getEvaluationTypeData = function (trainingEventCategory) {
    var values = GetArrayTrainingEventCategoryIDs(trainingEventCategory);
    PQ.Admin.WebService.EventTypeSettingsService.SubEvaluationType_SelectbyXML(values,
            function (data, textStatus) {
                evaluationType.ReceivedEvaluationTypeSettingData(JSON.parse(getMain(data)).rows);
            }, function (data, textStatus) {
                return false;
            });
};

evaluationType.ReceivedEvaluationTypeSettingData = function (data) {
    var thegrid = $("#tblEvaluationType");
    thegrid.clearGridData();
    rowCount = data.length;
    if (!rowCount) { $('#divDefineEvaluationType').unblock();
        setTimeout(function() { $("#waitplease").css({ 'display': 'none' }); }, 500);
    }
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
};

function GetArrayTrainingEventCategoryIDs(ddlEventSubject) {
    var values = new Array();
    if ($('#' + ddlEventSubject).val() == "0") {
        values = $('#' + ddlEventSubject).children('option').map(function (i, e) {
            return e.value;
        }).get();
    }
    else {
        values.push($('#' + ddlEventSubject).val());
    }
    return values;
}
//------------------------------------ End population grid ----------------------------------------------------

evaluationType.DefineEvaluationTypeData_New = function () {
    $("#ddlEventSubjectDetails").val("0").show().removeClass('ui-state-error');
    $("#txtEventSubjectDetails").val("").hide();
    $("#ddlEventTypeDetails").val("0").show().removeClass('ui-state-error');
    $("#txtEventTypeDetails").val("").hide();
    $("#txtSubEvaluationType").val('').removeClass('ui-state-error');
    $("#btnAddNewEvaluationType").val($("#lblEvaluationType_btnAddEvaluationType").text());
    $("#hidSubEvaluationTypeID").val("");
    divDefineEvaluationTypeDetails_Open();
};

evaluationType.DefineEvaluationTypeSetting_Open = function (data) {
    if (data) {
        $("#btnAddNewEvaluationType").val($("#lblEventSettings_btnUpdate").text());
        $("#waitplease").css({ 'display': 'block' });
        $("#ddlEventTypeDetails").val(data.TrainingEventType_ID).hide();
        $("#txtEventTypeDetails").val(data.TrainingEventType_Name).show();
        $("#ddlEventSubjectDetails>option").remove();
        PQ.Admin.WebService.AlertSettingService.TrainingEventCategory_Select(data.TrainingEventType_ID, $("#hidEvaluationTpe_GrtTrainingEventCategory").text(),
        function (result) {
            $(result).each(function () {
                $("#ddlEventSubjectDetails").append($("<option></option>").val(this['TrainingEventCategory_ID']).html(this['TrainingEventCategory_Name']));
            });
            $("#ddlEventSubjectDetails").val(data.TrainingEventCategory_ID).hide();
            $("#txtEventSubjectDetails").val(data.TrainingEventCategory_Name).show();
            $("#ddlEventSubjectDetails").removeClass("ui-autocomplete-ddl-loading");
            $("#hidSubEvaluationTypeID").val(data.SubEvaluationType_ID);
            $("#txtSubEvaluationType").val(data.SubEvaluationType_Name).show();
            divDefineEvaluationTypeDetails_Open();
            $("#waitplease").css({ 'display': 'none' });
        },
        function (e) {
            return false;
        });
    }
};

evaluationType.SaveEvaluationTypeData = function (saveData) {
    if (saveData) {
        PQ.Admin.WebService.EventTypeSettingsService.SubEvaluationType_Save(saveData,
        function (result) {
            if (result) {
                $("#tblEvaluationType").GridUnload();
                evaluationType.CreateEvaluationTypeGrid("ddlEventSubjectDetails");
                $("#divDefineEvaluationTypeDetails").dialog('destroy');
            }
            $("#waitplease").css({ 'display': 'none' });
        },
        function (e) {
            $("#waitplease").css({ 'display': 'none' });
        });
    }
};


evaluationType.DefineEvaluationType_Delete = function (dataID) {
    if (dataID) {
        $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
            open: function (type, data) {
                $(this).parent().appendTo("form");
            },
            buttons: {
                Ok: function (e) {
                    e.preventDefault();
                    $("#waitplease").css({ 'display': 'block' });
                    try {
                        PQ.Admin.WebService.EventTypeSettingsService.SubEvaluationType_Delete(dataID,
                        function (result) {
                            if (result) {
                                $("#tblEvaluationType").GridUnload();
                                evaluationType.CreateEvaluationTypeGrid("ddlEventSubject");
                                $("#waitplease").css({ 'display': 'none' });
                                $('#ConfirmDeleteAttachment').dialog('destroy');
                            }
                        },
                        function (ex) {
                            $("#waitplease").css({ 'display': 'none' });
                            $('#ConfirmDeleteAttachment').dialog('destroy');
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
    }
};


evaluationType.DefineEvaluationTypeRequaredFields = function () {
    var result = new Boolean(true);

    if ($("#ddlEventTypeDetails").val() == "0") {
        $("#ddlEventTypeDetails").addClass('ui-state-error').focus();
        return false;
    }
    else {
        $("#ddlEventTypeDetails").removeClass('ui-state-error', 500);
        result = true;
    }
    if ($("#ddlEventSubjectDetails").val() == "0") {
        $("#ddlEventSubjectDetails").addClass('ui-state-error').focus();
        return false;
    }
    else {
        $("#ddlEventSubjectDetails").removeClass('ui-state-error', 500);
        result = true;
    }
    if ($("#txtSubEvaluationType").val() == "") {
        $("#txtSubEvaluationType").addClass('ui-state-error').focus();
        return false;
    }
    else {
        $("#txtSubEvaluationType").removeClass('ui-state-error', 500);
        result = true;
    }
    return result;
};