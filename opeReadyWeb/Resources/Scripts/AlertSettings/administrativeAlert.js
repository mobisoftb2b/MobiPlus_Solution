var rowCount;
var adminAlert = {
    rowCount: 0
};

adminAlert.Init = function () {
};

adminAlert.CreateAdministrativeAlertGrid = function (adAlert) {
    var _langDir;
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            _langDir = "rtl";
        else
            _langDir = "ltr";
    }
    $('#divAdministrativeAlert').block({
        css: { border: '0px' },
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    $("#tblAdministrativeAlert").jqGrid({
        direction: _langDir,
        datatype: function (pdata) { adminAlert.getAdministrativeAlertData(adAlert); },
        height: 375,
        colNames: [
                    $('#hidAdminAlert_Grid_Job_Name').text(),
                    $('#hidAdminAlert_Grid_SubQualificationName').text(),
                    $('#hidAdminAlert_Grid_ThresholdLevelInDays').text(),
                    $('#hidAdminAlert_Grid_GraceInDays').text(),
                    '', '', 'Job_ID', 'SubQualificationType_ID'],
        colModel: [
       		        { name: 'Job_Name', index: 'Job_Name', sortable: true, sorttype: 'text', width: 220 },
               		{ name: 'SubQualificationType_Name', index: 'SubQualificationType_Name', sortable: true, sorttype: 'text', width: 200 },
                    { name: 'ThresholdLevelInDays', index: 'ThresholdLevelInDays', sortable: true, sorttype: 'int', align: 'center', width: 100 },
               		{ name: 'GraceInDays', index: 'GraceInDays', sorttype: 'int', sortable: true, sorttype: 'int', align: 'center', width: 100 },                                                                       //1
                    {name: 'EditAlert', index: 'EditAlert', sortable: false, edittype: 'image', formatter: editFormatter, width: 35, align: 'center' },
                    { name: 'DelAlert', index: 'DelAlert', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                    { name: 'Job_ID', hidden: 'true' },
                    { name: 'SubQualificationType_ID', hidden: 'true' },
               	],
        viewrecords: true,
        sortorder: "asc",
        autoencode: false,
        loadonce: false,
        altRows: true,
        hoverrows: false,
        rowNum: 2000,
        toolbar: [true, "top"],
        recordpos: (_langDir == 'rtl' ? 'left' : 'right'),
        pager: '#pgrAdministrativeAlert',
        pgbuttons: false,
        pginput: false,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
            if (rowCount == $(this).getGridParam('records')) {
                $("#waitplease").css({ 'display': 'none' });
                $('#divAdministrativeAlert').unblock();
            }
        },
        onCellSelect: function (rowid, iCol, cellcontent, e) {
            switch (iCol) {
                case 4:
                    adminAlert.DefineAdministrativeAlert_Open($(this).getRowData(rowid));
                    break;
                case 5:
                    return adminAlert.DefineAdministrativeAlert_Delete($(this).getRowData(rowid));
                    break;
            }
            return false;
        },
        ondblClickRow: function (rowid, iRow, iCol, e) {
            adminAlert.DefineAdministrativeAlert_Open($(this).getRowData(rowid));
        }
    });
    $("#tblAdministrativeAlert")
        .jqGrid('gridResize', { minWidth: 750, minHeight: 300 })
        .toolbarButtonAdd("#t_tblAdministrativeAlert",
            {
                caption: $('#hidAdminAlert_btnAddAdminAlert').text(),
                position: "first",
                align: (_langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-circle-plus',
                onClickButton: function () {
                    adminAlert.DefineAdministrativeAlert_New();
                }
            })
            .toolbarButtonAdd("#t_tblAdministrativeAlert",
            {
                caption: "Excel",
                position: "last",
                align: (_langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                    if (rowCount == 0) return false;
                    $("#tblAdministrativeAlert").jqGrid('excelExport', { url: '/opeReady/Handlers/ExcelExport/AdministrativeAlertExcel.ashx?jid=' + adAlert.Job_ID });
                }
            }).jqGrid('sortGrid', "Job_Name", true);
};

adminAlert.getAdministrativeAlertData = function (_readAlert) {
    PQ.Admin.WebService.AlertSettingService.AdministrativeAlert_SelectAll(_readAlert.Job_ID,
            function (data, textStatus) {
                adminAlert.ReceivedAdministrativeAlertData(JSON.parse(getMain(data)).rows);
            }, function (data, textStatus) {
                $('#divAdministrativeAlert').unblock();
                return false;
            });
};

adminAlert.ReceivedAdministrativeAlertData = function (data) {
    var thegrid = $("#tblAdministrativeAlert");
    thegrid.clearGridData();
    rowCount = data.length;
    if (!rowCount) $('#divAdministrativeAlert').unblock();
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
};

adminAlert.DefineAdministrativeAlert_New = function () {
    $("#ddlJobs").val("0").show();
    $("#txtJobs").val("").hide();
    $("#ddlSubQualification").val("0").show();
    $("#txtSubQualification").val("").hide();
    $("#txtThresholdLevelInDays").val("");
    $("#txtGraceInDay").val("");
    $("#txtAlertInDay").val("");
    $("#chkInitialEntryAlert").val("-1");
    $("#btnAddReadinessAlert").val($("#lblReadinessAlert_btnAddAlert").text());
    divAdminAlertDetails_Open();
};

adminAlert.DefineAdministrativeAlert_Delete = function (rowObj) {
    if (rowObj) {
        $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
            open: function (type, data) {
                $(this).parent().appendTo("form");
            },
            buttons: {
                Ok: function (e) {
                    e.preventDefault();
                    $("#waitplease").css({ 'display': 'block' });
                    try {
                        PQ.Admin.WebService.AlertSettingService.AdministrativeAlert_Delete(rowObj.Job_ID, rowObj.SubQualificationType_ID,
                        function (result) {
                            if (result) {
                                $("#tblAdministrativeAlert").GridUnload();
                                adminAlert.CreateAdministrativeAlertGrid({ Job_ID: $("#ddlJobsList").val() });
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
    }
    return false;
};

adminAlert.DefineAdministrativeAlert_Save = function () {
    if (adminAlert.AdminAlertRequaredFields()) {
        $("#waitplease").css({ 'display': 'block' });
        var _adminAlert = {
            Job_ID: $("#ddlJobs").val(),
            SubQualificationType_ID: $("#ddlSubQualification").val(),
            ThresholdLevelInDays: $("#txtThresholdLevelInDays").val(),
            GraceInDays: $("#txtGraceInDay").val(),
            AlertInDays: $("#txtAlertInDay").val(),
            InitialEntryAlert: $("#chkInitialEntryAlert").val()
        };
        PQ.Admin.WebService.AlertSettingService.AdministrativeAlert_Save(_adminAlert,
      function (data) {
          if (data) {
              $("#tblAdministrativeAlert").GridUnload();
              adminAlert.CreateAdministrativeAlertGrid({ Job_ID: $("#ddlJobsList").val() });
              $("#waitplease").css({ 'display': 'none' });
              $("#divAdminAlertDetails").dialog("destroy");
          }
      },
      function (ex) {
          $("#waitplease").css({ 'display': 'none' });
          return false;
      });
    }
};

adminAlert.DefineAdministrativeAlert_Open = function (rowObj) {
    if (rowObj) {
        $("#btnAddReadinessAlert").val($("#lblReadinessAlert_btnUpdate").text());
        PQ.Admin.WebService.AlertSettingService.AdministrativeAlert_Select(rowObj.Job_ID, rowObj.SubQualificationType_ID,
        function (data) {
            if (data) {
                $("#ddlJobs").val(data.Job_ID).hide();
                $("#txtJobs").val($("#ddlJobs option:selected").text()).show();
                $("#ddlSubQualification").val(data.SubQualificationType_ID).hide();
                $("#txtSubQualification").val(data.SubQualificationType_Name).show();
                $("#txtThresholdLevelInDays").val(data.ThresholdLevelInDays);
                $("#txtGraceInDay").val(data.GraceInDays);
                $("#txtAlertInDay").val(data.AlertInDays);
                $("#chkInitialEntryAlert").val(data.InitialEntryAlert);
            }
            divAdminAlertDetails_Open();
        },
        function (ex) {
            return false;
        });
    }
};

adminAlert.AdminAlertRequaredFields = function () {
    var result = new Boolean(true);
    if ($("#ddlJobs").val() == "0") {
        $("#ddlJobs").addClass('ui-state-error');
        return false;
    }
    else {
        $("#ddlJobs").removeClass('ui-state-error', 200);
        result = true;
    }

    if ($("#ddlSubQualification").val() == "0") {
        $("#ddlSubQualification").addClass('ui-state-error');
        return false;
    }
    else {
        $("#ddlSubQualification").removeClass('ui-state-error', 200);
        result = true;
    }
    if ($("#txtThresholdLevelInDays").val() == "") {
        $("#txtThresholdLevelInDays").addClass('ui-state-error');
        return false;
    }
    else {
        $("#txtThresholdLevelInDays").removeClass('ui-state-error', 200);
        result = true;
    }
    return result;
};
/// --------------------------------------------------
Sys.Application.add_load(applicationLoadHandler);
Sys.WebForms.PageRequestManager.getInstance().add_endRequest(endRequestHandler);
Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(beginRequestHandler);

function applicationLoadHandler() {
    adminAlert.Init();
}
function endRequestHandler(sender, args) {

}

function beginRequestHandler() {

}