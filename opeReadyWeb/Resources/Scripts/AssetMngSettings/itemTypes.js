/// <reference path="../Common/_references.js" />
var rowCount;
$("#btnAddNewItemTypes").live("click", function () {
    if ($("#ddlItemCategoriesDetails").val() == "0") {
        $("#ddlItemCategoriesDetails").addClass('ui-state-error');
        return false;
    }
    if ($("#txtItemTypes").val() == "") {
        $("#txtItemTypes").addClass('ui-state-error');
        return false;
    }
    $("#waitplease").css({ 'display': 'block' });
    var itemTypes = {
        ItemCategory: {
            ItemCategory_ID: $("#ddlItemCategoriesDetails").val()
        },
        ItemType_ID: $("#hidItemTypes_ID").val() == "" ? 0 : $("#hidItemTypes_ID").val(),
        ItemType_Name: $("#txtItemTypes").val(),
        EndServiceDateAlertInDays: $("#txtEndServiceDateAlertInDays").val() == "" ? 0 : $("#txtEndServiceDateAlertInDays").val()
    };
    itemType.ItemType_Save(itemTypes);
});



$("#btnFilter").live("click", function () {
    $("#tblItemTypes").GridUnload();
    AssetMngSettingsService.ItemType_SelectByCategory($("#ddlItemCategories").val(),
            function (data, textStatus) {
                itemType.PopulationItemTypeGrid(data);
            }, function (ex) {
                return false;
            }, null);
});

var itemType = {
    PopulationItemTypeGrid: function (newData) {
        var langDir = "ltr";
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
                langDir = "rtl";
           
                
        }
        $('#divDefineItemTypes').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var itemTypesGrid = $("#tblItemTypes").jqGrid({
            direction: langDir,
            datatype: function (pdata) { itemType.getItemTypeData(pdata, newData); },
            height: 375,
            autowidth: false,
            colNames: [
                $('#hidItemTypes_Grid_ItemCategory_Name').text(),
                $('#hidItemTypes_Grid_ItemType_Name').text(),
                "", "", 'ItemType_ID', 'ItemCategory_ID', 'EndServiceDateAlertInDays'],
            colModel: [
           		{ name: 'ItemCategory.ItemCategory_Name', index: 'ItemCategory.ItemCategory_Name', sortable: true, width: 350 },
                { name: 'ItemType_Name', index: 'ItemType_Name', sortable: true, width: 350 },
                { name: 'Edit', index: 'Edit', sortable: false, edittype: 'image', formatter: editFormatter, width: 32, align: 'center' },
                { name: 'Delete', index: 'Delete', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                { name: 'ItemType_ID', hidden: 'true' },
                { name: 'ItemCategory.ItemCategory_ID', hidden: 'true' },
                { name: 'EndServiceDateAlertInDays', hidden: 'true' }
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
            pager: '#pgrItemTypes',
            pgbuttons: false,
            rowNum: 2000,
            pginput: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (rowCount == $(this).getGridParam('records')) {
                    $("#waitplease").css({ 'display': 'none' });
                    $('#divDefineItemTypes').unblock();
                }
            },
            onCellSelect: function (rowid, iCol, cellcontent, e) {
                switch (iCol) {
                    case 2:
                        itemType.ItemType_Update($(this).getRowData(rowid));
                        break;
                    case 3:
                        return itemType.DeleteItemType($(this).getRowData(rowid).ItemType_ID);
                        break;
                }
                return false;
            },
            ondblClickRow: function (rowid, iRow, iCol, e) {
                itemType.ItemType_Update($(this).getRowData(rowid));
            }
        });
        itemTypesGrid.jqGrid('gridResize', { minWidth: 674, minHeight: 300 });
        itemTypesGrid
    .toolbarButtonAdd("#t_tblItemTypes",
        {
            caption: $('#lblItemTypes_btnAddNewItemTypes').text(),
            position: "first",
            align: (langDir == 'rtl' ? 'right' : 'left'),
            buttonicon: 'ui-icon-circle-plus',
            onClickButton: function () {
                itemType.ItemType_New();
            }
        })
        .toolbarButtonAdd("#t_tblItemTypes",
            {
                caption: "Excel",
                position: "last",
                align: (langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                    if (rowCount == 0) return false;
                    itemTypesGrid.jqGrid('excelExport', { url: '/opeReady/Handlers/ExcelExport/ItemTypesExcel.ashx' });
                }
            });
    },

    getItemTypeData: function (pData, newData) {
        if (!newData) {
            AssetMngSettingsService.ItemTypes_SelectAll(
            function (data) {
                itemType.ReceivedItemTypeData(JSON.parse(getMain(data)).rows);
            }, function (ex) {
                return false;
            }, null);
        } else {
            itemType.ReceivedItemTypeData(JSON.parse(getMain(newData)).rows);
        }
    },

    ReceivedItemTypeData: function (data) {
        var thegrid = $("#tblItemTypes");
        thegrid.clearGridData();
        rowCount = data.length;
        if (!rowCount) $('#divDefineItemTypes').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },

    ItemType_Update: function (items) {
        $("#hidItemTypes_ID").val(items.ItemType_ID);
        $("#ddlItemCategoriesDetails").val(items['ItemCategory.ItemCategory_ID']);
        $("#txtItemTypes").val(items.ItemType_Name);
        $("#txtEndServiceDateAlertInDays").val(items.EndServiceDateAlertInDays);
        $("#btnAddNewItemTypes").val($("#lblItemTypes_btnUpdate").text());
        itemType.divItemType_Open();
    },

    DeleteItemType: function (itemTypeID) {
        if (itemTypeID) {
            $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
                open: function (type, data) {
                    $(this).parent().appendTo("form");
                },
                buttons: {
                    Ok: function (e) {
                        e.preventDefault();
                        $("#waitplease").css({ 'display': 'block' });
                        try {
                            AssetMngSettingsService.ItemType_Delete(itemTypeID,
                        function (result) {
                            if (result) {
                                $("#tblItemTypes").GridUnload();
                                itemType.PopulationItemTypeGrid(result);
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

    ItemType_New: function () {
        $("#ddlItemCategoriesDetails").val("0");
        $("#txtItemTypes,#hidItemTypes_ID,#txtEndServiceDateAlertInDays").val("");
        $("#btnAddNewItemTypes").val($("#lblItemTypes_btnAddNewItemTypes").text());
        itemType.divItemType_Open();
    },

    ItemType_Save: function (value) {
        AssetMngSettingsService.ItemType_Save(value,
            function (data) {
                if (data) {
                    $("#tblItemTypes").GridUnload();
                    itemType.PopulationItemTypeGrid(data);
                    $('#divDefineItemTypesDetails').dialog('destroy');
                }
                $("#waitplease").css({ 'display': 'none' });
            },
            function (e) {
                $("#waitplease").css({ 'display': 'none' });
                return false;
            }, null);
    },

    divItemType_Open: function () {
        $("#divDefineItemTypesDetails").dialog({ autoOpen: true, bgiframe: true, resizable: false, closeOnEscape: true, width: '600px', modal: true, zIndex: 50,
            title: $('#hidItemTypes_MainGreeting').text(),
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
                $("#ddlItemCategoriesDetails, #txtItemTypes").removeClass('ui-state-error');
            }
        });
        return false;
    }
};

 