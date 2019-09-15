/// <reference path="../Common/_references.js" />

var rowCount;
$("#btnAddNewMaintTypes").live("click", function () {
    if ($("#ddlItemCategoriesDetails").val() == "0") {
        $("#ddlItemCategoriesDetails").addClass('ui-state-error');
        return false;
    }
    if ($("#txtMaintTypes").val() == "") {
        $("#txtMaintTypes").addClass('ui-state-error');
        return false;
    }
    $("#waitplease").css({ 'display': 'block' });
    var maintTypes = {
        ItemCategory: {
            ItemCategory_ID: $("#ddlItemCategoriesDetails").val()
        },
        MaintType_ID: $("#hidMaintTypes_ID").val() == "" ? 0 : $("#hidMaintTypes_ID").val(),
        MaintType_Name: $("#txtMaintTypes").val()
    };
    maintType.MaintType_Save(maintTypes);
});



$("#btnFilter").live("click", function () {
    $("#tblMaintTypes").GridUnload();
    AssetMngSettingsService.MaintTypes_SelectAll($("#ddlItemCategories").val(),
            function (data, textStatus) {
                maintType.PopulationMaintTypeGrid(data);
            }, function (ex) {
                return false;
            }, null);
});

var maintType = {
    PopulationMaintTypeGrid: function (newData) {
        var _langDir;
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
                _langDir = "rtl";
            else
                _langDir = "ltr";
        }
        $('#divDefineMaintTypes').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var maintTypesGrid = $("#tblMaintTypes").jqGrid({
            direction: _langDir,
            datatype: function (pdata) { maintType.getMaintTypeData(pdata, newData) },
            height: 375,
            autowidth: false,
            colNames: [
                $('#hidMaintTypes_Grid_ItemCategory_Name').text(),
                $('#hidMaintTypes_Grid_MaintType_Name').text(),
                "", "", 'MaintType_ID', 'ItemCategory_ID'],
            colModel: [
           		{ name: 'ItemCategory.ItemCategory_Name', index: 'ItemCategory.ItemCategory_Name', sortable: true, width: 350 },
                { name: 'MaintType_Name', index: 'MaintType_Name', sortable: true, width: 350 },
                { name: 'Edit', index: 'Edit', sortable: false, edittype: 'image', formatter: editFormatter, width: 32, align: 'center' },
                { name: 'Delete', index: 'Delete', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                { name: 'MaintType_ID', hidden: 'true' },
                { name: 'ItemCategory.ItemCategory_ID', hidden: 'true' }
           	],
            datefmt: 'd/m/Y',
            viewrecords: true,
            sortorder: "desc",
            autoencode: false,
            loadonce: false,
            pginput: true,
            recordpos: 'left',
            altRows: true,
            hoverrows: false,
            toolbar: [true, "top"],
            pager: '#pgrMaintTypes',
            pgbuttons: false,
            pginput: false,
            rowNum: 2000,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (rowCount == $(this).getGridParam('records')) {
                    $("#waitplease").css({ 'display': 'none' });
                    $('#divDefineMaintTypes').unblock();
                }
            },
            onCellSelect: function (rowid, iCol, cellcontent, e) {
                switch (iCol) {
                    case 2:
                        maintType.MaintType_Update($(this).getRowData(rowid));
                        break;
                    case 3:
                        return maintType.DeleteMaintType($(this).getRowData(rowid).MaintType_ID);
                        break;
                }
                return false;
            },
            ondblClickRow: function (rowid, iRow, iCol, e) {
                maintType.MaintType_Update($(this).getRowData(rowid));
            }
        });
        maintTypesGrid.jqGrid('gridResize', { minWidth: 674, minHeight: 300 });
        maintTypesGrid
    .toolbarButtonAdd("#t_tblMaintTypes",
        {
            caption: $('#lblMaintTypes_btnAddNewMaintTypes').text(),
            position: "first",
            align: (_langDir == 'rtl' ? 'right' : 'left'),
            buttonicon: 'ui-icon-circle-plus',
            onClickButton: function () {
                maintType.MaintType_New();
            }
        })
        .toolbarButtonAdd("#t_tblMaintTypes",
            {
                caption: "Excel",
                position: "last",
                align: (_langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                    if (rowCount == 0) return false;
                    maintTypesGrid.jqGrid('excelExport', { url: '/opeReady/Handlers/ExcelExport/MaintTypesExcel.ashx' });
                }
            });
    },

    getMaintTypeData: function (pData, newData) {
        if (!newData) {            
            AssetMngSettingsService.MaintTypes_SelectAll($("#ddlItemCategories").val(),
            function (data, textStatus) {
                maintType.ReceivedMaintTypeData(JSON.parse(getMain(data)).rows);
            }, function (ex) {
                return false;
            }, null);
        } else {
            maintType.ReceivedMaintTypeData(JSON.parse(getMain(newData)).rows);
        }
    },

    ReceivedMaintTypeData: function (data) {
        var thegrid = $("#tblMaintTypes");
        thegrid.clearGridData();
        rowCount = data.length;
        if (!rowCount) $('#divDefineMaintTypes').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },

    MaintType_Update: function (items) {
        $("#hidMaintTypes_ID").val(items.MaintType_ID);
        $("#ddlItemCategoriesDetails").val(items['ItemCategory.ItemCategory_ID']);
        $("#txtMaintTypes").val(items.MaintType_Name);
        $("#btnAddNewMaintTypes").val($("#lblMaintTypes_btnUpdate").text());
        maintType.divMaintType_Open();
    },

    DeleteMaintType: function (maintTypeID) {
        if (maintTypeID) {
            $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
                open: function (type, data) {
                    $(this).parent().appendTo("form");
                },
                buttons: {
                    Ok: function (e) {
                        e.preventDefault();
                        $("#waitplease").css({ 'display': 'block' });
                        try {
                            AssetMngSettingsService.MaintType_Delete(maintTypeID,
                        function (result) {
                            if (result) {
                                $("#tblMaintTypes").GridUnload();
                                maintType.PopulationMaintTypeGrid(result);
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
    },

    MaintType_New: function () {
        $("#ddlItemCategoriesDetails").val("0");
        $("#txtMaintTypes,#hidMaintTypes_ID").val("");
        $("#btnAddNewMaintTypes").val($("#lblMaintTypes_btnAddNewMaintTypes").text());
        maintType.divMaintType_Open();
    },

    MaintType_Save: function (value) {
        AssetMngSettingsService.MaintType_Save(value,
            function (data) {
                if (data) {
                    $("#tblMaintTypes").GridUnload();
                    maintType.PopulationMaintTypeGrid(data);
                    $('#divDefineMaintTypesDetails').dialog('destroy');
                }
                $("#waitplease").css({ 'display': 'none' });
            },
            function (e) {
                $("#waitplease").css({ 'display': 'none' });
                return false;
            }, null);
    },

    divMaintType_Open: function () {
        $("#divDefineMaintTypesDetails").dialog({ autoOpen: true, bgiframe: true, resizable: false, closeOnEscape: true, width: '650px', modal: true, zIndex: 50,
            title: $('#hidMaintTypes_MainGreeting').text(),
            create: function (event, ui) {
                $(this).block({
                    css: { border: '0px' },
                    overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                    message: ''
                });
            },
            open: function (type, data) {
                $(this).parent().appendTo("form");
                $(this).unblock();
                $("#ddlItemCategoriesDetails, #txtMaintTypes").removeClass('ui-state-error');
            }
        });
        return false;
    }
};

 