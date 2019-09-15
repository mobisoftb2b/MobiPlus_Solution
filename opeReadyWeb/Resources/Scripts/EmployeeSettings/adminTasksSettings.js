var rowCount;
var adminTask = {};

adminTask.CreateAdministrativeRequirementsGrid = function () {
    var langDir = "ltr";
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            langDir = "rtl";
    }
    $('#divAdminTask').block({
        css: { border: '0px' },
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
   var adminTaskGrid = $("#tblAdminTask").jqGrid({
        direction: langDir,
        datatype: function (pdata) { adminTask.getAdminTaskData(pdata) },
        height: 375,
        autowidth: false,
        colNames: [
                $('#hidAdminTask_Grid_AdministrativeRequirements_Name').text(),
                "", "", 'SubQualificationType_ID'],
        colModel: [
           		{ name: 'SubQualificationType_Name', index: 'SubQualificationType_Name', sortable: true, width: 350 },                                                                       //1
                {name: 'EditAdTask', index: 'EditAdTask', sortable: false, edittype: 'image', formatter: editFormatter, width: 32, align: 'center' },
                { name: 'DelAdTask', index: 'DelAdTask', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                { name: 'SubQualificationType_ID', hidden: 'true', key: true }
           	],
        imgpath: '<%= ResolveClientUrl("~/Resources/Styles/redmon/images") %>',
        datefmt: 'd/m/Y',
        viewrecords: true,
        sortorder: "desc",
        autoencode: false,
        loadonce: false,
        recordpos: 'left',
        altRows: true,
        hoverrows: false,
        toolbar: [true, "top"],
        pager: '#pgrAdminTask',
        rowNum: 2000,
        pgbuttons: false,
        pginput: false,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
            if (rowCount == $(this).getGridParam('records')) {
                $("#waitplease").css({ 'display': 'none' });
                $('#divAdminTask').unblock();
            }
        },
        onCellSelect: function (rowid, iCol, cellcontent, e) {
            switch (iCol) {
                case 1:
                    adminTask.AdministrativeTasksEdit_Update($(this).getRowData(rowid));
                    break;
                case 2:
                    return adminTask.DeleteAdministrativeTask($(this).getRowData(rowid).SubQualificationType_ID);
                    break;
            }
            return false;
        },
        ondblClickRow: function (rowid, iRow, iCol, e) {
            adminTask.AdministrativeTasksEdit_Update($(this).getRowData(rowid));
        }
    });
    adminTaskGrid.jqGrid('gridResize', { minWidth: 674, minHeight: 300 });
    adminTaskGrid
    .toolbarButtonAdd("#t_tblAdminTask",
        {
            caption: $('#hidAdminTask_btnAddNewAdministrativeRequirements').text(),
            position: "first",
            align: (langDir == 'rtl' ? 'right' : 'left'),
            buttonicon: 'ui-icon-circle-plus',
            onClickButton: function () {
                adminTask.AdministrativeTasksEdit_New();
            }
        })
        .toolbarButtonAdd("#t_tblAdminTask",
            {
                caption: "Excel",
                position: "last",
                align: (langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                    if (rowCount == 0) return false;
                    adminTaskGrid.jqGrid('excelExport', { url: '/opeReady/Handlers/ExcelExport/adminTaskExcel.ashx' });
                }
            });
}

adminTask.getAdminTaskData = function (pData) {
    PQ.Admin.WebService.EmployeeSettingsService.SubQualificationType_SelectAll(
            function (data, textStatus) {
                adminTask.ReceivedAdminTaskData(JSON.parse(getMain(data)).rows);
            }, function (ex) {
                return false;
            });
};

adminTask.ReceivedAdminTaskData = function (data) {
    var thegrid = $("#tblAdminTask");
    thegrid.clearGridData();
    rowCount = data.length;
    if (!rowCount) $('#divAdminTask').unblock();
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
}


adminTask.AdministrativeTasksEdit_Update = function (subQualificationType) {
    $("#hidSubQualificationTypeID").val(subQualificationType.SubQualificationType_ID);
    $("#txtAdministrativeRequirementsName").val(subQualificationType.SubQualificationType_Name);
    $("#btnAddAdminTaskType").val($("#hidAdminTask_btnUpdateSetting").text());
    divAdministrativeRequirements_Open();
};

adminTask.DeleteAdministrativeTask = function (adminTaskID) {
    if (adminTaskID) {
        $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
            open: function (type, data) {
                $(this).parent().appendTo("form");
            },
            buttons: {
                Ok: function (e) {
                    e.preventDefault();
                    $("#waitplease").css({ 'display': 'block' });
                    try {
                        PQ.Admin.WebService.EmployeeSettingsService.SubQualificationType_Delete(adminTaskID,
                        function (result) {
                            if (result) {
                                $("#tblAdminTask").GridUnload();
                                adminTask.CreateAdministrativeRequirementsGrid();
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

adminTask.AdministrativeTasksEdit_New = function () {
    $("#txtAdministrativeRequirementsName").val("");
    $("#hidSubQualificationTypeID").val("");
    $("#btnAddAdminTaskType").val($("#hidAdminTask_btnAddAdminTask").text());
    divAdministrativeRequirements_Open();
};

adminTask.AdministrativeTasksEdit_Save = function (value) {
    PQ.Admin.WebService.EmployeeSettingsService.SubQualificationType_Save(value,
            function (data) {
                if (data) {
                    $("#tblAdminTask").GridUnload();
                    adminTask.CreateAdministrativeRequirementsGrid();
                    $('#divAdminTaskDetails').dialog('destroy');
                }
                $("#waitplease").css({ 'display': 'none' });
            },
            function (e) {
                $("#waitplease").css({ 'display': 'none' });
                return false;
            });
};
//SubQualificationType_Save