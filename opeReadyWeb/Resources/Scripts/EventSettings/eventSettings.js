var rowCount;
var eventSetting = {};

eventSetting.CreateEventSettingsGrid = function (eSettings) {
    var _langDir, editable = true;
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            _langDir = "rtl";
        else
            _langDir = "ltr";
    }

    if ($.cookie("userRole")) {
        if ($.cookie("userRole") == "6")
            editable = false;
       
    } 

    $('#divDefineEventSettings').block({
        css: { border: '0px' },
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    $("#tblEventTypeSettings").jqGrid({
        direction: _langDir,
        datatype: function (pdata) { eventSetting.getEventSettingData(); },
        height: 375,
        colNames: [
                    $('#hidEventSettings_Grid_EventType').text(),
                    $('#hidEventSettings_Grid_ExecutionLebel').text(),
                    $('#hidEventSettings_Grid_Score').text(),
                    $('#hidEventSettings_Grid_Quantity').text(),
                    '', '', 'TrainingEventType_ID', '', '', '', '', '', '', ''],
        colModel: [
               		{ name: 'TrainingEventType_Name', index: 'TrainingEventType_Name', sortable: true, sorttype: 'text', width: 250 },
                    { name: 'isExecutionLevelRequiredField', index: 'isExecutionLevelRequiredField', align: 'center', formatter: checkboxPic, sortable: false, width: 130 },
                    { name: 'isScoreRequiredField', index: 'isScoreRequiredField', sortable: false, formatter: checkboxPic, align: 'center', width: 100 },
               		{ name: 'isQuantityRequiredField', index: 'isQuantityRequiredField', sortable: false, align: 'center', formatter: checkboxPic, width: 100 },
                    { name: 'EditType', index: 'EditType', sortable: false, edittype: 'image', formatter: editFormatter, width: 35, align: 'center' },
                    { name: 'DelType', index: 'DelType', hidden: editable, sortable: false, edittype: 'image', formatter: deleteSpecFormatter, width: 45, align: 'center' },
                    { name: 'TrainingEventType_ID', hidden: 'true' },
                    { name: 'isExecutionLevelRequiredField', hidden: 'true' },
                    { name: 'isQuantityRequiredField', hidden: 'true' },
                    { name: 'isScoreRequiredField', hidden: 'true' },
                    { name: 'RecoverFromFailureInDays', hidden: 'true' },
                    { name: 'isBusy', hidden: 'true' },
                    { name: 'BestPerformance', hidden: 'true' },
                    { name: 'OverrideStatus', hidden: 'true' }
               	],
        viewrecords: true,
        sortorder: "asc",
        autoencode: false,
        loadonce: false,
        pginput: true,
        altRows: true,
        hoverrows: false,
        toolbar: [true, "top"],
        recordpos: (_langDir == 'rtl' ? 'left' : 'right'),
        pager: '#pgrEventTypeSettings',
        pgbuttons: false,
        pginput: false,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
            if (rowCount == $(this).getGridParam('records')) {
                $("#waitplease").css({ 'display': 'none' });
                $('#divDefineEventSettings').unblock();
            }
        },
        onCellSelect: function (rowid, iCol, cellcontent, e) {
            switch (iCol) {
                case 4:
                    eventSetting.DefineEventTypeSetting_Open($(this).getRowData(rowid));
                    break;
                case 5:
                    if ($(this).getRowData(rowid).isBusy == "false")
                        return eventSetting.DefineEventTypeSetting_Delete($(this).getRowData(rowid).TrainingEventType_ID);
                    break;
            }
            return false;
        },
        ondblClickRow: function (rowid, iRow, iCol, e) {
            eventSetting.DefineEventTypeSetting_Open($(this).getRowData(rowid));
        }
    });
    $("#tblEventTypeSettings")
        .jqGrid('gridResize', { minWidth: 750, minHeight: 300 })
        .toolbarButtonAdd("#t_tblEventTypeSettings",
            {
                caption: $('#hidEventSettings_btnAddEventType').text(),
                position: "first",
                align: (_langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-circle-plus',
                onClickButton: function () {
                    eventSetting.DefineEventSettingData_New();
                }
            })
            .toolbarButtonAdd("#t_tblEventTypeSettings",
            {
                caption: "Excel",
                position: "last",
                align: (_langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                    if (rowCount == 0) return false;
                    $("#tblEventTypeSettings").jqGrid('excelExport', { url: '/opeReady/Handlers/ExcelExport/EventTypeSettingsExcel.ashx' });
                }
            });
};

eventSetting.getEventSettingData = function () {
    PQ.Admin.WebService.EventTypeSettingsService.EventTypeSettings_SelectAll(
            function (data, textStatus) {
                eventSetting.ReceivedEventTypeSettingData(JSON.parse(getMain(data)).rows);
            }, function (data, textStatus) {
                return false;
            });
};

eventSetting.ReceivedEventTypeSettingData = function (data) {
    var thegrid = $("#tblEventTypeSettings");
    thegrid.clearGridData();
    rowCount = data.length;
    if (!rowCount) $('#divDefineEventSettings').unblock();
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
};

function deleteSpecFormatter(ellvalue, options, rowObject) {
    var img;
    try {
        img = new Image(32, 32);
        if (!rowObject.isBusy) {
            $(img).attr("src", "/opeReady/Resources/icons/trash.png");
            $(img).attr("style", "cursor:pointer");
        }
        else {
            $(img).attr("src", "/opeReady/Resources/images/empty.png");
        }
    } catch (e) { }
    return img.outerHTML || new XMLSerializer().serializeToString(img);
}

eventSetting.DefineEventSettingData_New = function () {
    $("#txtEventType").val("");
    $("#rdScore").attr('checked', false);
    $("#rdQuantity").attr('checked', false);
    $("#rdExecutionLevel").attr('checked', false);
    $("#chkOverridelStatus").attr('checked', false);
    $("#rbNone").attr('checked', false);
    $("#txtFailureRecovery").val('');
    $("#hidTrainingEventType_ID").val('');
    $("#btnAddNewEventType").val($("#lblEventSubject_btnAddNewEventSubjects").text());
    divDefineEventSettingsDetails_Open();
};

eventSetting.DefineEventTypeSetting_Open = function (data) {
    if (data) {
        $("#btnAddNewEventType").val($("#lblEventSettings_btnUpdate").text());
        $("#txtEventType").val(data.TrainingEventType_Name);
        if ((data.isScoreRequiredField == "" || data.isScoreRequiredField == "false") && 
        (data.isQuantityRequiredField == "" || data.isQuantityRequiredField == "false") && (data.isExecutionLevelRequiredField == "" || data.isExecutionLevelRequiredField == "false")) {
            $("#rbNone").attr('checked', true);
        } else {
            $("#rdScore").attr('checked', (data.isScoreRequiredField === 'true' ? true : false));
            $("#rdQuantity").attr('checked', (data.isQuantityRequiredField === 'true' ? true : false));
            $("#rdExecutionLevel").attr('checked', (data.isExecutionLevelRequiredField === 'true' ? true : false));
        }
        $("#chkOverridelStatus").attr('checked', (data.OverrideStatus === 'true' ? true : false));
        $("#txtFailureRecovery").val(data.RecoverFromFailureInDays);
        $("#hidTrainingEventType_ID").val(data.TrainingEventType_ID);
        $("#rdoHightLevel").attr('checked', (data.BestPerformance === 'true' ? true : (data.BestPerformance === '' ? true : false)));
        $("#rdoLowLevel").attr('checked', (data.BestPerformance === 'false' ? true : false));
    }
    divDefineEventSettingsDetails_Open();
};

eventSetting.SaveEventTypeSettingData = function (saveData) {
    if (saveData) {
        PQ.Admin.WebService.EventTypeSettingsService.EventTypeSettings_Save(saveData,
        function (result) {
            if (result) {
                $("#tblEventTypeSettings").GridUnload();
                eventSetting.CreateEventSettingsGrid(null);
                $("#divDefineEventSettingsDetails").dialog('destroy');
            }
            $("#waitplease").css({ 'display': 'none' });
        },
        function (e) {
            $("#waitplease").css({ 'display': 'none' });
        });
    }
};


eventSetting.DefineEventTypeSetting_Delete = function (dataID) {
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
                        PQ.Admin.WebService.EventTypeSettingsService.EventTypeSettings_Delete(dataID,
                        function (result) {
                            if (result) {
                                $("#tblEventTypeSettings").GridUnload();
                                eventSetting.CreateEventSettingsGrid(null);
                            }
                            else {
                                RaiseWarningAlert($("#hidEventSettings_DeleteEventSubjectError").text());
                            }
                            $("#waitplease").css({ 'display': 'none' });
                            $('#ConfirmDeleteAttachment').dialog('destroy');
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


eventSetting.DefineEventTypeSettingRequaredFields = function () {
    var result = new Boolean(true);
    var radiobuttons = $('input:radio:checked').val();

    if ($("#txtEventType").val() == "") {
        $("#txtEventType").addClass('ui-state-error').focus();
        return false;
    }
    else {
        $("#txtEventType").removeClass('ui-state-error', 500);
        result = true;
    }
    return result;
};