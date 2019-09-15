var rowCount;
var readinessAlert = {
    rowCount: 0
};

readinessAlert.Init = function () {
};

readinessAlert.CreateReadinessAlertGrid = function (readAlert) {
    var langDir = "ltr";
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            langDir = "rtl";
    }
    $('#divReadinessAlert').block({
        css: { border: '0px' },
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    $("#tblReadinessAlert").jqGrid({
        direction: langDir,
        datatype: function (pdata) { readinessAlert.getReadinessAlertData(readAlert); },
        height: 300,
        colNames: [
                    $('#hidReadinessAlert_Grid_Job_Name').text(),
                    $('#hidReadinessAlert_Grid_TrainingEventTypeName').text(),
                    $('#hidReadinessAlert_Grid_TrainingEventCategoryName').text(),
                    $('#hidReadinessAlert_Grid_Quantity4Period').text(),
                    $('#hidReadinessAlert_Grid_MinQuantity4Period').text(),
                    '', '', 'Job_ID', 'TrainingEventType_ID', 'TrainingEventCategory_ID'],
        colModel: [
                    { name: 'Job_Name', index: 'Job_Name', sortable: true, sorttype: 'text', width: 220 },
               		{ name: 'TrainingEventType_Name', index: 'TrainingEventType_Name', sortable: true, sorttype: 'text', width: 180 },
                    { name: 'TrainingEventCategory_Name', index: 'TrainingEventCategory_Name', sortable: true, sorttype: 'text', width: 180 },
               		{ name: 'Quantity4Period', index: 'Quantity4Period', sorttype: 'int', sortable: true, align: 'center', width: 120 },
               		{ name: 'MinQuantity4Period', index: 'MinQuantity4Period', sortable: true, sorttype: 'int', align: 'center', width: 100 },
                    { name: 'EditAlert', index: 'EditAlert', sortable: false, edittype: 'image', formatter: editFormatter, width: 35, align: 'center' },
                    { name: 'DelAlert', index: 'DelAlert', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                    { name: 'Job_ID', hidden: 'true' },
                    { name: 'TrainingEventType_ID', hidden: 'true' },
                    { name: 'TrainingEventCategory_ID', hidden: 'true' },
               	],
        viewrecords: true,
        sortorder: "asc",
        autoencode: false,
        loadonce: false,
        pginput: true,
        altRows: true,
        rowNum: 2000,
        hoverrows: false,
        toolbar: [true, "top"],
        recordpos: (langDir == 'rtl' ? 'left' : 'right'),
        pager: '#pgrReadinessAlert',
        pgbuttons: false,
        pginput: false,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
            if (rowCount == $(this).getGridParam('records')) {
                $("#waitplease").css({ 'display': 'none' });
                $('#divReadinessAlert').unblock();
            }
        },
        onCellSelect: function (rowid, iCol, cellcontent, e) {
            switch (iCol) {
                case 5:
                    readinessAlert.DefineReadinessAlert_Open($(this).getRowData(rowid));
                    break;
                case 6:
                    return readinessAlert.DefineReadinessAlert_Delete($(this).getRowData(rowid));
                    break;
            }
            return false;
        },
        ondblClickRow: function (rowid, iRow, iCol, e) {
            readinessAlert.DefineReadinessAlert_Open($(this).getRowData(rowid));
        }
    });
    $("#tblReadinessAlert")
        .jqGrid('gridResize', { minWidth: 750, minHeight: 300 })
        .toolbarButtonAdd("#t_tblReadinessAlert",
        {
            caption: $('#hidReadinessAlert_btnAddReadinessAlert').text(),
            position: "first",
            align: (langDir == 'rtl' ? 'right' : 'left'),
            buttonicon: 'ui-icon-circle-plus',
            onClickButton: function () {
                readinessAlert.DefineReadinessAlert_New();
            }
        }).toolbarButtonAdd("#t_tblReadinessAlert",
        {
            caption: "Excel",
            position: "last",
            align: (langDir == 'rtl' ? 'right' : 'left'),
            buttonicon: 'ui-icon-contact',
            onClickButton: function () {
                if (rowCount == 0) return false;
                $("#tblReadinessAlert").jqGrid('excelExport', { url: '/opeReady/Handlers/ExcelExport/ReadinessAlertExcel.ashx?jid=' + readAlert.Job_ID });
            }
        }).jqGrid('sortGrid', "TrainingEventType_Name", true);

};

readinessAlert.getReadinessAlertData = function (_readAlert) {
    PQ.Admin.WebService.AlertSettingService.ReadinessAlert_Select(_readAlert,
            function (data, textStatus) {
                readinessAlert.ReceivedReadinessAlertData(JSON.parse(getMain(data)).rows);
            }, function (data, textStatus) {
                return false;
            });
};

readinessAlert.ReceivedReadinessAlertData = function (data) {
    var thegrid = $("#tblReadinessAlert");
    thegrid.clearGridData();
    rowCount = data.length;
    if (!rowCount) $('#divReadinessAlert').unblock();
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
};
readinessAlert.DefineReadinessAlert_New = function () {
    $("#ddlJobs").val("0").show();
    $("#txtJobs").val("").hide();
    $("#ddlTrainingEventType").val("0").show();
    $("#txtTrainingEventType").val("").hide();
    $("#ddlEventCategory").val("0").show();
    $("#txtEventCategory").val("").hide();
    $("#txtQuantity4Period,#txtMinQuantuty4Period").val("").removeAttr('readonly');
    $("#txtThresholdLevelInDays").val("");
    $("#txtGraceInDay").val("");
    $("#txtNumOfFailures4Alert").val("-1");
    $("#ddlPerfomanceLevel").val("0");
    $("#txtQuality").val("");
    $("#txtTotalScore").val("0");
    $("#txtMinTipImages").val("");
    $("#btnAddReadinessAlert").val($("#lblReadinessAlert_btnAddAlert").text());
    $("#chkCumulativeQuantity").attr('checked', false);
    divReadinessAlertDetails_Open();
};

readinessAlert.DefineReadinessAlert_Open = function (rowObj) {
    if (rowObj) {
        var readAlert = {
            Job_ID: rowObj.Job_ID,
            TrainingEventType_ID: rowObj.TrainingEventType_ID,
            TrainingEventCategory_ID: rowObj.TrainingEventCategory_ID
        };
        $("#btnAddReadinessAlert").val($("#lblReadinessAlert_btnUpdate").text());
        PQ.Admin.WebService.AlertSettingService.TrainingEventsBar_Select(readAlert,
        function (data) {
            if (data) {
                $("#ddlJobs").val(data.Job_ID).hide();
                $("#txtJobs").val($("#ddlJobs option:selected").text()).show();
                $("#ddlTrainingEventType").val(data.TrainingEventType_ID).hide();
                $("#txtTrainingEventType").val(data.TrainingEventType_Name).show();
                $("#ddlEventCategory").val(data.TrainingEventCategory_ID).hide();
                $("#txtEventCategory").val(data.TrainingEventCategory_Name).show();
                $("#hidTrainingEventCategoryID").val(data.TrainingEventCategory_ID);
                $("#chkCumulativeQuantity").attr('checked', data.isCumulativeQuantity == null ? false : data.isCumulativeQuantity);
                if (data.isCumulativeQuantity) {
                    $("#txtQuantity4Period,#txtMinQuantuty4Period").val("").attr("readonly", true);
                }
                else {
                    $("#txtQuantity4Period").val(data.Quantity4Period).removeAttr('readonly');
                    $("#txtMinQuantuty4Period").val(data.MinQuantity4Period).removeAttr('readonly');
                }
                $("#txtThresholdLevelInDays").val(data.ThresholdLevelInDays);
                $("#txtGraceInDay").val(data.GraceInDays);
                $("#txtNumOfFailures4Alert").val(data.NumOfFailures4Alert);
                $("#ddlPerfomanceLevel").val(data.ThresholdExecutionLevel == null ? "0" : data.ThresholdExecutionLevel);
                $("#txtQuality").val(data.ThresholdQuantity);
                $("#txtTotalScore").val(data.ThresholdScore);
                $("#txtMinTipImages").val(data.MinTipImages);
            }
            divReadinessAlertDetails_Open();
        },
        function (ex) {
            return false;
        });

    }
};

readinessAlert.DefineReadinessAlert_Save = function () {
    if (readinessAlert.ReadinessAlertRequaredFields()) {
        $("#waitplease").css({ 'display': 'block' });
        var readAlert = {
            Job_ID: $("#ddlJobs").val(),
            TrainingEventType_ID: $("#ddlTrainingEventType").val(),
            TrainingEventCategory_ID: $("#ddlEventCategory").val() == "0" ? $("#hidTrainingEventCategoryID").val() : $("#ddlEventCategory").val(),
            Quantity4Period: $("#txtQuantity4Period").val(),
            MinQuantity4Period: $("#txtMinQuantuty4Period").val(),
            ThresholdLevelInDays: $("#txtThresholdLevelInDays").val(),
            GraceInDays: $("#txtGraceInDay").val(),
            NumOfFailures4Alert: $("#txtNumOfFailures4Alert").val(),
            ThresholdQuantity: $("#txtQuality").val(),
            ThresholdScore: $("#txtTotalScore").val(),
            ThresholdExecutionLevel: $("#ddlPerfomanceLevel").val(),
            isCumulativeQuantity: $("#chkCumulativeQuantity").attr('checked'),
            MinTipImages: $("#txtMinTipImages").val()
        };
        PQ.Admin.WebService.AlertSettingService.TrainingEventsBar_Save(readAlert,
      function (data) {
          if (data) {
              $("#tblReadinessAlert").GridUnload();
              readinessAlert.CreateReadinessAlertGrid({ Job_ID: $("#ddlJobsList").val() });
              $("#waitplease").css({ 'display': 'none' });
              $("#divReadinessAlertDetails").dialog("destroy");
          }
      },
      function (ex) {
          $("#waitplease").css({ 'display': 'none' });
          return false;
      });
    }
};

readinessAlert.PopulateTrainingEventCategoryCombo = function (trainingEventTypeID) {
    $("#ddlEventCategory>option").remove();
    PQ.Admin.WebService.AlertSettingService.TrainingEventCategory_Select(trainingEventTypeID, $("#hidReportsParam_GrtTrainingEventCategory").text(),
        function (result) {
            $(result).each(function () {
                $("#ddlEventCategory").append($("<option></option>").val(this['TrainingEventCategory_ID']).html(this['TrainingEventCategory_Name']));
            });
            $("#ddlEventCategory").removeClass("ui-autocomplete-ddl-loading");
        },
    function (e) {
        return false;
    });
};

readinessAlert.UpdateActivateComplianceStatus = function (status) {
    PQ.Admin.WebService.AlertSettingService.UpdateActivateComplianceStatus(status,
        function (result) {
            setTimeout(function () { RaiseLoader(false); }, 500);
        },
    function (e) {
        RaiseLoader(false);
        return false;
    });
};

readinessAlert.GetActivateComplianceStatus = function () {
    PQ.Admin.WebService.AlertSettingService.GetComplianceStatus(
        function (data) {
            $("#chkActivateComplStatus").attr("checked", data);
        }, function (ex) {
            return false;
        });
};

readinessAlert.ReadinessAlertRequaredFields = function () {
    var result = new Boolean(true);
    if ($("#ddlJobs").val() == "0") {
        $("#ddlJobs").addClass('ui-state-error');
        return false;
    }
    else {
        $("#ddlJobs").removeClass('ui-state-error', 500);
        result = true;
    }
    if ($("#ddlTrainingEventType").val() == "0") {
        $("#ddlTrainingEventType").addClass('ui-state-error').focus();
        return false;
    }
    else {
        $("#ddlTrainingEventType").removeClass('ui-state-error', 500);
        result = true;
    }
    if ($("#ddlEventCategory").val() == "0" && $("#hidTrainingEventCategoryID").val() == "") {
        $("#ddlEventCategory").addClass('ui-state-error').focus();
        return false;
    }
    else {
        $("#ddlEventCategory").removeClass('ui-state-error', 500);
        result = true;
    }
    if ($("#txtQuantity4Period").val() == "") {
        if (!$("#chkCumulativeQuantity").attr('checked')) {
            $("#txtQuantity4Period").addClass('ui-state-error').focus();
            return false;
        }
    }
    else {
        $("#txtQuantity4Period").removeClass('ui-state-error', 500);
        result = true;
    }
    if ($("#txtMinQuantuty4Period").val() == "") {
        if (!$("#chkCumulativeQuantity").attr('checked')) {
            $("#txtMinQuantuty4Period").addClass('ui-state-error').focus();
            return false;
        }
    }
    else {
        $("#txtMinQuantuty4Period").removeClass('ui-state-error', 500);
        result = true;
    }
    if ($("#txtThresholdLevelInDays").val() == "") {
        $("#txtThresholdLevelInDays").addClass('ui-state-error').focus();
        return false;
    }
    else {
        $("#txtThresholdLevelInDays").removeClass('ui-state-error', 500);
        result = true;
    }
    var req = $("#ScoreArea").find(".selecting").find("input, select");
    if (req.val() == "" || req.val() == "0") {
        req.addClass('ui-state-error').focus();
        return false;
    } else {
        req.removeClass('ui-state-error', 500);
        result = true;
    }
    return result;
};


readinessAlert.DefineReadinessAlert_Delete = function (rowObj) {
    if (rowObj) {
        var readAlert = {
            Job_ID: rowObj.Job_ID,
            TrainingEventType_ID: rowObj.TrainingEventType_ID,
            TrainingEventCategory_ID: rowObj.TrainingEventCategory_ID
        };
        $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
            open: function (type, data) {
                $(this).parent().appendTo("form");
            },
            buttons: {
                Ok: function (e) {
                    e.preventDefault();
                    $("#waitplease").css({ 'display': 'block' });
                    try {
                        PQ.Admin.WebService.AlertSettingService.TrainingEventsBar_Delete(readAlert,
                        function (result) {
                            if (result) {
                                $("#tblReadinessAlert").GridUnload();
                                readinessAlert.CreateReadinessAlertGrid({ Job_ID: $("#ddlJobsList").val() });
                                $("#waitplease").css({ 'd isplay': 'none' });
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
    }
    return false;
}