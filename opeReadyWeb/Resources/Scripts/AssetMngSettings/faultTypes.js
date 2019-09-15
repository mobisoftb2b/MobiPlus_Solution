var rowCount;
var faultType = {
    PopulationFaultTypeGrid: function (newData) {
        var _langDir;
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
                _langDir = "rtl";
            else
                _langDir = "ltr";
        }
        $('#divDefineFaultTypes').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var itemTypesGrid = $("#tblFaultTypes").jqGrid({
            direction: _langDir,
            datatype: function (pdata) { faultType.GetFaultTypesData(pdata, newData) },
            height: 375,
            autowidth: false,
            colNames: [
                $('#hidFaultTypes_Grid_ItemCategory_Name').text(),
                $('#hidFaultTypes_Grid_FaultType_Name').text(),
                "", "", 'FaultType_ID', 'ItemCategory_ID'],
            colModel: [
           		{ name: 'ItemCategories.ItemCategory_Name', index: 'ItemCategory.ItemCategory_Name', sortable: true, width: 350 },
                { name: 'FaultType_Name', index: 'FaultType_Name', sortable: true, width: 350 },
                { name: 'Edit', index: 'Edit', sortable: false, edittype: 'image', formatter: editFormatter, width: 32, align: 'center' },
                { name: 'Delete', index: 'Delete', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                { name: 'FaultType_ID', hidden: 'true' },
                { name: 'ItemCategories.ItemCategory_ID', hidden: 'true' }
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
            pager: '#pgrFaultTypes',
            pgbuttons: false,
            pginput: false,
            rowNum: 2000,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (rowCount == $(this).getGridParam('records')) {
                    $("#waitplease").css({ 'display': 'none' });
                    $('#divDefineFaultTypes').unblock();
                }
            },
            onCellSelect: function (rowid, iCol, cellcontent, e) {
                switch (iCol) {
                    case 2:
                        faultType.FaultTypes_Updates($(this).getRowData(rowid));
                        break;
                    case 3:
                        return faultType.DeleteFaultType($(this).getRowData(rowid).FaultType_ID);
                        break;
                }
                return false;
            },
            ondblClickRow: function (rowid, iRow, iCol, e) {
                faultType.FaultTypes_Updates($(this).getRowData(rowid));
            }
        });
        itemTypesGrid.jqGrid('gridResize', { minWidth: 674, minHeight: 300 });
        itemTypesGrid
    .toolbarButtonAdd("#t_tblFaultTypes",
        {
            caption: $('#lblFaultTypes_btnAddNewFaultTypes').text(),
            position: "first",
            align: (_langDir == 'rtl' ? 'right' : 'left'),
            buttonicon: 'ui-icon-circle-plus',
            onClickButton: function () {
                faultType.FaultTypes_New();
            }
        })
        .toolbarButtonAdd("#t_tblFaultTypes",
            {
                caption: "Excel",
                position: "last",
                align: (_langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                    if (rowCount == 0) return false;
                    itemTypesGrid.jqGrid('excelExport', { url: '/opeReady/Handlers/ExcelExport/FaultTypesExcel.ashx' });
                }
            });
    },

    GetFaultTypesData: function (pData, newData) {
        if (!newData) {
            AssetMngSettingsService.FaultTypes_SelectAll(
            function (data, textStatus) {
                faultType.ReceivedFaultTypeData(JSON.parse(getMain(data)).rows);
            }, function (ex) {
                return false;
            }, null);
        } else {
            faultType.ReceivedFaultTypeData(JSON.parse(getMain(newData)).rows);
        }
    },

    ReceivedFaultTypeData: function (data) {
        var thegrid = $("#tblFaultTypes");
        thegrid.clearGridData();
        rowCount = data.length;
        if (!rowCount) $('#divDefineFaultTypes').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },

    FaultType_Save: function (faultTypes) {
        AssetMngSettingsService.FaultType_Save(faultTypes,
            function (data) {
                if (data) {
                    $("#tblFaultTypes").GridUnload();
                    faultType.PopulationFaultTypeGrid(data);
                    $('#divDefineFaultTypesDetails').dialog('destroy');
                }
                $("#waitplease").css({ 'display': 'none' });
            },
            function (e) {
                $("#waitplease").css({ 'display': 'none' });
                return false;
            }, null);
    },

    divDefineFaultTypesDetails_Open: function () {
        $("#divDefineFaultTypesDetails").dialog({ autoOpen: true, bgiframe: true, resizable: false, closeOnEscape: true, width: '400px', modal: true, zIndex: 50,
            title: $('#hidFaultTypes_MainGreeting').text(),
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
                $("#ddlItemCategoriesDetails, #txtFaultTypes").removeClass('ui-state-error');
            }
        });
        return false;
    },

    FaultTypes_New: function () {
        $("#ddlItemCategoriesDetails").val("0");
        $("#txtFaultTypes, #hidFaultType_ID").val("");
        $("#btnAddNewFaultTypes").val($("#lblFaultTypes_btnAddNewFaultTypes").text());
        faultType.divDefineFaultTypesDetails_Open();
    },

    FaultTypes_Updates: function (values) {
        $("#hidFaultType_ID").val(values.FaultType_ID);
        $("#ddlItemCategoriesDetails").val(values['ItemCategories.ItemCategory_ID']);
        $("#txtFaultTypes").val(values.FaultType_Name);
        $("#btnAddNewFaultTypes").val($("#lblFaultTypes_btnUpdate").text());
        faultType.divDefineFaultTypesDetails_Open();
    },

    DeleteFaultType: function (faultTypeID) {
        if (faultTypeID) {
            $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
                open: function (type, data) {
                    $(this).parent().appendTo("form");
                },
                buttons: {
                    Ok: function (e) {
                        e.preventDefault();
                        $("#waitplease").css({ 'display': 'block' });
                        try {
                            AssetMngSettingsService.FaultType_Delete(faultTypeID,
                        function (result) {
                            if (result) {
                                $("#tblFaultTypes").GridUnload();
                                faultType.PopulationFaultTypeGrid(result);
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
    }
};

$("#btnFilter").live("click", function () {
    $("#tblFaultTypes").GridUnload();
    AssetMngSettingsService.FaultTypes_SelectByCategory($("#ddlItemCategories").val(),
            function (data, textStatus) {
                faultType.PopulationFaultTypeGrid(data);
            }, function (ex) {
                return false;
            }, null);
});
$("#btnAddNewFaultTypes").live("click", function () {
    if ($("#ddlItemCategoriesDetails").val() == "0") {
        $("#ddlItemCategoriesDetails").addClass('ui-state-error');
        return false;
    }
    if ($("#txtFaultTypes").val() == "") {
        $("#txtFaultTypes").addClass('ui-state-error');
        return false;
    }
    $("#waitplease").css({ 'display': 'block' });
    var faultTypes = {
        ItemCategories: {
            ItemCategory_ID: $("#ddlItemCategoriesDetails").val()
        },
        FaultType_ID: $("#hidFaultType_ID").val() == "" ? 0 : $("#hidFaultType_ID").val(),
        FaultType_Name: $("#txtFaultTypes").val()
    };
    faultType.FaultType_Save(faultTypes);
});