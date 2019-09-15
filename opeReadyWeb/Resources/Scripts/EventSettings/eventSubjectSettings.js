var rowCount;
var eventSubject = {};

eventSubject.CreateEventSubjectsGrid = function (eSubject) {
    var _langDir;
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            _langDir = "rtl";
        else
            _langDir = "ltr";
    }
    $('#divDefineEventSubject').block({
        css: { border: '0px' },
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    $("#tblEventSubjects").jqGrid({
        direction: _langDir,
        datatype: function (pdata) { eventSubject.getEventSubjectData(eSubject); },
        height: 375,
        colNames: [
                    $('#hidEventSubject_Grid_TrainingEventType_Name').text(),
                    $('#hidEventSubject_Grid_TrainingEventCategory_Name').text(),
                    '', '', 'TrainingEventCategory_ID', 'TrainingEventType_ID', ''],
        colModel: [
               		{ name: 'TrainingEventType_Name', index: 'TrainingEventType_Name', sortable: true, sorttype: 'text', width: 250 },
                    { name: 'TrainingEventCategory_Name', index: 'TrainingEventCategory_Name', sortable: true, sorttype: 'text', width: 250 },
                    { name: 'EditType', index: 'EditType', sortable: false, edittype: 'image', formatter: editFormatter, width: 35, align: 'center' },
                    { name: 'DelType', index: 'DelType', sortable: false, edittype: 'image', formatter: deleteSpecFormatter, width: 45, align: 'center' },
                    { name: 'TrainingEventCategory_ID', hidden: 'true' },
                    { name: 'TrainingEventType_ID', hidden: 'true' },
                    { name: 'isBusy', hidden: 'true' }
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
        pager: '#pgrEventSubjects',
        pgbuttons: false,
        pginput: false,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
            if (rowCount == $(this).getGridParam('records')) {
                $("#waitplease").css({ 'display': 'none' });
                $('#divDefineEventSubject').unblock();
            }
        },
        onCellSelect: function (rowid, iCol, cellcontent, e) {
            switch (iCol) {
                case 2:
                    eventSubject.DefineEventSubjectSetting_Open($(this).getRowData(rowid));
                    break;
                case 3:
                    if ($(this).getRowData(rowid).isBusy == "false")
                        return eventSubject.DefineEventSubjectSetting_Delete($(this).getRowData(rowid).TrainingEventCategory_ID);
                    break;
            }
            return false;
        },
        ondblClickRow: function (rowid, iRow, iCol, e) {
            eventSubject.DefineEventSubjectSetting_Open($(this).getRowData(rowid));
        }
    });
    $("#tblEventSubjects")
        .jqGrid('gridResize', { minWidth: 750, minHeight: 300 })
        .toolbarButtonAdd("#t_tblEventSubjects",
            {
                caption: $('#hidEventSubjects_btnAddEventType').text(),
                position: "first",
                align: (_langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-circle-plus',
                onClickButton: function () {
                    eventSubject.DefineEventSubjectsData_New();
                }
            })
            .toolbarButtonAdd("#t_tblEventSubjects",
            {
                caption: "Excel",
                position: "last",
                align: (_langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                    if (rowCount == 0) return false;
                    $("#tblEventSubjects").jqGrid('excelExport', { url: "/opeReady/Handlers/ExcelExport/EventSubjectSettingsExcel.ashx?es=" + eSubject });
                }
            });
};

eventSubject.getEventSubjectData = function (eSubjectID) {
    PQ.Admin.WebService.EventTypeSettingsService.TrainingEventCategory_SelectAll(eSubjectID,
            function (data, textStatus) {
                eventSubject.ReceivedEventTypeSettingData(JSON.parse(getMain(data)).rows);
            }, function (data, textStatus) {
                return false;
            });
};

eventSubject.ReceivedEventTypeSettingData = function (data) {
    var thegrid = $("#tblEventSubjects");
    thegrid.clearGridData();
    rowCount = data.length;
    if (!rowCount) $('#divDefineEventSubject').unblock();
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

eventSubject.DefineEventSubjectsData_New = function () {
    $("#txtEventSubject").val("");
    $("#ddlEventTypeDetails").val("0").show();
    $("#txtEventTypeDetails").val("").hide();
    $("#hidTrainingEventCategory_ID").val("");
    $("#btnAddNewEventSubjects").val($("#lblEventSubject_btnAddNewEventSubjects").text());
    divDefineEventSubjectsDetails_Open();
};

eventSubject.DefineEventSubjectSetting_Open = function (data) {
    if (data) {
        $("#btnAddNewEventSubjects").val($("#lblEventSettings_btnUpdate").text());
        $("#ddlEventTypeDetails").val(data.TrainingEventType_ID).hide();
        $("#hidTrainingEventCategory_ID").val(data.TrainingEventCategory_ID)
        $("#txtEventTypeDetails").val(data.TrainingEventType_Name).show();
        $("#txtEventSubject").val(data.TrainingEventCategory_Name);
    }
    divDefineEventSubjectsDetails_Open();
};

eventSubject.SaveEventSubjectSettingData = function (saveData) {
    if (saveData) {
        PQ.Admin.WebService.EventTypeSettingsService.TrainingEventCategory_Save(saveData,
        function (result) {
            if (result) {
                $("#tblEventSubjects").GridUnload();
                $("#ddlEventType").val(saveData.TrainingEventType_ID);
                eventSubject.CreateEventSubjectsGrid(saveData.TrainingEventType_ID);
                $("#divDefineEventSubjectsDetails").dialog('destroy');
            }
            $("#waitplease").css({ 'display': 'none' });
        },
        function (e) {
            $("#waitplease").css({ 'display': 'none' });
        });
    }
};


eventSubject.DefineEventSubjectSetting_Delete = function (dataID) {
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
                        PQ.Admin.WebService.EventTypeSettingsService.TrainingEventCategory_Delete(dataID,
                        function (result) {
                            if (result) {
                                $("#tblEventSubjects").GridUnload();
                                eventSubject.CreateEventSubjectsGrid($("#ddlEventType").val());
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


eventSubject.DefineEventTypeSettingRequaredFields = function () {
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

    if (radiobuttons) {
        $("#divRadiobuttons").removeClass('ui-state-error');
        result = true;
    }
    else {
        $("#divRadiobuttons").addClass('ui-state-error');
        return false;
    }

    return result;
};