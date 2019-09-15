var rowCount;
var eSettings = {

};

eSettings.CreateEmployerSettingsGrid = function () {
    var _langDir;
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            _langDir = "rtl";
        else
            _langDir = "ltr";
    }
    $('#divEmployers').block({
        css: { border: '0px' },
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    var employersGrid = $("#tblEmployers").jqGrid({
        direction: _langDir,
        datatype: function (pdata) { eSettings.getEmployerSettingsData(); },
        height: 375,
        width: 'auto',
        colNames: [
                    $('#hidEmployer_Grid_PersonCategory_Name').text(),
                    '', '', 'PersonCategory_ID'],
        colModel: [
                    { name: 'PersonCategory_Name', index: 'PersonCategory_Name', sortable: true, sorttype: 'text', width: 350 },
                    { name: 'EditAlert', index: 'EditAlert', sortable: false, edittype: 'image', formatter: editFormatter, width: 35, align: 'center' },
                    { name: 'DelAlert', index: 'DelAlert', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                    { name: 'PersonCategory_ID', hidden: 'true' }
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
        pager: '#pgrEmployers',
        rowNum: 2000,
        pgbuttons: false,
        pginput: false,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
            if (rowCount == $(this).getGridParam('records')) {
                $("#waitplease").css({ 'display': 'none' });
                $('#divEmployers').unblock();
            }
        },
        onCellSelect: function (rowid, iCol, cellcontent, e) {
            switch (iCol) {
                case 1:
                    eSettings.DefineEmployerSettings_Open($(this).getRowData(rowid));
                    break;
                case 2:
                    return eSettings.DefineEmployerSettings_Delete($(this).getRowData(rowid).PersonCategory_ID);
                    break;
            }
            return false;
        },
        ondblClickRow: function (rowid, iRow, iCol, e) {
            eSettings.DefineEmployerSettings_Open($(this).getRowData(rowid));
        }
    });
    employersGrid
        .jqGrid('gridResize', { minWidth: 750, minHeight: 300 })
        .toolbarButtonAdd("#t_tblEmployers",
            {
                caption: $('#hidEmployers_btnAddNewCompany').text(),
                position: "first",
                align: (_langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-circle-plus',
                onClickButton: function () {
                    eSettings.DefineEmployerSettings_New();
                }
            });
    employersGrid.toolbarButtonAdd("#t_tblEmployers",
            {
                caption: "Excel",
                position: "last",
                align: (_langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                    if (rowCount == 0) return false;
                    employersGrid.jqGrid('excelExport', { url: '/opeReady/Handlers/ExcelExport/EmployerExcel.ashx' });
                }
            }); 
};

eSettings.getEmployerSettingsData = function () {
    PQ.Admin.WebService.EmployeeSettingsService.Employer_SelectAll(
            function (data, textStatus) {
                eSettings.ReceivedEmployerSettingsData(JSON.parse(getMain(data)).rows);
            }, function (data, textStatus) {
                return false;
            });
};

eSettings.ReceivedEmployerSettingsData = function (data) {
    var thegrid = $("#tblEmployers");
    thegrid.clearGridData();
    rowCount = data.length;
    if (!rowCount) $('#divEmployers').unblock();
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
};

eSettings.DefineEmployerSettings_New = function () {
    $("#txtPersonCategoryName").val("");
    $("#hidPersonCategoryID").val("");
    $("#btnAddEmployerSetting").val($("#hodEmployer_btnAddEmployerSetting").text());
    divPersonCategoryDetails_Open();
};

eSettings.DefineEmployerSettings_Open = function (personCategory) {
    $("#hidPersonCategoryID").val(personCategory.PersonCategory_ID);
    $("#txtPersonCategoryName").val(personCategory.PersonCategory_Name);
    $("#btnAddEmployerSetting").val($("#hidEmployer_btnUpdateSetting").text());
    divPersonCategoryDetails_Open();
};

eSettings.DefineEmployerSettings_Delete = function (personCategoryID) {
    if (personCategoryID) {
        $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
            open: function (type, data) {
                $(this).parent().appendTo("form");
            },
            buttons: {
                Ok: function (e) {
                    e.preventDefault();
                    $("#waitplease").css({ 'display': 'block' });
                    try {
                        PQ.Admin.WebService.EmployeeSettingsService.PersonCategory_Delete(personCategoryID,
                        function (result) {
                            if (result) {
                                $("#tblEmployers").GridUnload();
                                eSettings.CreateEmployerSettingsGrid();
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

eSettings.EmployerSettings_Save = function (value) {
    PQ.Admin.WebService.EmployeeSettingsService.PersonCategory_Save(value,
            function (data) {
                if (data) {
                    $("#tblEmployers").GridUnload();
                    eSettings.CreateEmployerSettingsGrid();
                    $('#divPersonCategoryDetails').dialog('destroy');
                }
                $("#waitplease").css({ 'display': 'none' });
            },
            function (e) {
                $("#waitplease").css({ 'display': 'none' });
                return false;
            });
};