/// <reference path="../Common/jquery-1.6.4.min.js" />
/// <reference path="../Common/jquery.jqGrid.min.js" />

var rowCount;
var employmentHistory = {};

employmentHistory.CreateEmploymentHistoryTypeGrid = function () {
    var _langDir;
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            _langDir = "rtl";
        else
            _langDir = "ltr";
    }
    $('#divEmploymentHistory').block({
        css: { border: '0px' },
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    var employmentHistoryGrid = $("#tblEmploymentHistory").jqGrid({
        direction: _langDir,
        datatype: function (pdata) { employmentHistory.getEmploymentHistoryData(); },
        height: 375,
        width: 'auto',
        colNames: [
                    $('#hidEmployeeHistory_Grid_EmploymentHistoryType_Name').text(),
                    '', '', 'PersonCategory_ID'],
        colModel: [
                    { name: 'EmploymentHistoryType_Name', index: 'EmploymentHistoryType_Name', sortable: true, sorttype: 'text', width: 350 },
                    { name: 'EditAlert', index: 'EditAlert', sortable: false, edittype: 'image', formatter: editFormatter, width: 35, align: 'center' },
                    { name: 'DelAlert', index: 'DelAlert', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                    { name: 'EmploymentHistoryType_ID', hidden: 'true' }
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
        pager: '#pgrEmploymentHistory',
        pgbuttons: false,
        pginput: false,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
            if (rowCount == $(this).getGridParam('records')) {
                $("#waitplease").css({ 'display': 'none' });
                $('#divEmploymentHistory').unblock();
            }
        },
        onCellSelect: function (rowid, iCol, cellcontent, e) {
            switch (iCol) {
                case 1:
                    employmentHistory.DefineEmploymentHistory_Open($(this).getRowData(rowid));
                    break;
                case 2:
                    return employmentHistory.DefineEmploymentHistory_Delete($(this).getRowData(rowid).EmploymentHistoryType_ID);
                    break;
            }
            return false;
        },
        ondblClickRow: function (rowid, iRow, iCol, e) {
            employmentHistory.DefineEmploymentHistory_Open($(this).getRowData(rowid));
        }
    });
    employmentHistoryGrid
        .jqGrid('gridResize', { minWidth: 750, minHeight: 300 })
        .toolbarButtonAdd("#t_tblEmploymentHistory",
            {
                caption: $('#hidEmployeeHistory_btnAddNewCompany').text(),
                position: "first",
                align: (_langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-circle-plus',
                onClickButton: function () {
                    employmentHistory.DefineEmploymentHistory_New();
                }
            })
        .toolbarButtonAdd("#t_tblEmploymentHistory",
            {
                caption: "Excel",
                position: "last",
                align: (_langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                    if (rowCount == 0) return false;
                    employmentHistoryGrid.jqGrid('excelExport', { url: '/opeReady/Handlers/ExcelExport/EmploymentHistoryExcel.ashx' });
                }
            });

};

employmentHistory.getEmploymentHistoryData = function () {
    PQ.Admin.WebService.EmployeeSettingsService.EmploymentHistoryType_SelectAll(
            function (data, textStatus) {
                employmentHistory.ReceivedEmploymentHistoryData(JSON.parse(getMain(data)).rows);
            }, function (data, textStatus) {
                return false;
            });
};

employmentHistory.ReceivedEmploymentHistoryData = function (data) {
    var thegrid = $("#tblEmploymentHistory");
    thegrid.clearGridData();
    rowCount = data.length;
    if (!rowCount) $('#divEmploymentHistory').unblock();
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
};

employmentHistory.DefineEmploymentHistory_New = function () {
    $("#txtEmploymentHistoryTypeName").val("");
    $("#hidEmploymentHistoryTypeID").val("");
    $("#btnAddEmployeeHistoryType").val($("#hidEmployeeHistory_btnAddEmployeeHistory").text());
    divEmploymentHistoryDetails_Open();
};

employmentHistory.DefineEmploymentHistory_Open = function (employeeHistory) {
    $("#hidEmploymentHistoryTypeID").val(employeeHistory.EmploymentHistoryType_ID);
    $("#txtEmploymentHistoryTypeName").val(employeeHistory.EmploymentHistoryType_Name);
    $("#btnAddEmployeeHistoryType").val($("#hidEmployeeHistory_btnUpdateSetting").text());
    divEmploymentHistoryDetails_Open();
};

employmentHistory.DefineEmploymentHistory_Delete = function (employeeHistoryID) {
    if (employeeHistoryID) {
        $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
            open: function (type, data) {
                $(this).parent().appendTo("form");
            },
            buttons: {
                Ok: function (e) {
                    e.preventDefault();
                    $("#waitplease").css({ 'display': 'block' });
                    try {
                        PQ.Admin.WebService.EmployeeSettingsService.EmployeeHistoryType_Delete(employeeHistoryID,
                        function (result) {
                            if (result) {
                                $("#tblEmploymentHistory").GridUnload();
                                employmentHistory.CreateEmploymentHistoryTypeGrid();
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

employmentHistory.EmployeeHistoryType_Save = function (value) {
    PQ.Admin.WebService.EmployeeSettingsService.EmployeeHistoryType_Save(value,
            function (data) {
                if (data) {
                    $("#tblEmploymentHistory").GridUnload();
                    employmentHistory.CreateEmploymentHistoryTypeGrid();
                    $('#divEmploymentHistoryDetails').dialog('destroy');
                }
                $("#waitplease").css({ 'display': 'none' });
            },
            function (e) {
                $("#waitplease").css({ 'display': 'none' });
                return false;
            });
};