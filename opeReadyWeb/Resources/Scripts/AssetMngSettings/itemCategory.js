/// <reference path="../Common/_references.js" />
var rowCount;
var itemCategory = {
    PopulationItemCategoryGrid: function (newData) {
        var _langDir;
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
                _langDir = "rtl";
            else
                _langDir = "ltr";
        }
        $('#divItemCategoriesMain').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var itemCategoriesGrid = $("#tblItemCategoriesMain").jqGrid({
            direction: _langDir,
            datatype: function (pdata) { itemCategory.getItemCategoriesData(pdata, newData) },
            height: 375,
            autowidth: false,
            colNames: [
                $('#hidAMS_Grid_ItemCategory_Name').text(),
                "", "", 'ItemCategory_ID'],
            colModel: [
           		{ name: 'ItemCategory_Name', index: 'ItemCategory_Name', sortable: true, width: 350 },                                                                       //1
                {name: 'Edit', index: 'Edit', sortable: false, edittype: 'image', formatter: editFormatter, width: 32, align: 'center' },
                { name: 'Delete', index: 'Delete', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                { name: 'ItemCategory_ID', hidden: 'true', key: true }
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
            pager: '#pgrItemCategoriesMain',
            pgbuttons: false,
            pginput: false,
            rowNum: 2000,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (rowCount == $(this).getGridParam('records')) {
                    $("#waitplease").css({ 'display': 'none' });
                    $('#divItemCategoriesMain').unblock();
                }
            },
            onCellSelect: function (rowid, iCol, cellcontent, e) {
                switch (iCol) {
                    case 1:
                        itemCategory.ItemCategories_Update($(this).getRowData(rowid));
                        break;
                    case 2:
                        return itemCategory.DeleteItemCategories($(this).getRowData(rowid).ItemCategory_ID);
                        break;
                }
                return false;
            },
            ondblClickRow: function (rowid, iRow, iCol, e) {
                itemCategory.ItemCategories_Update($(this).getRowData(rowid));
            }
        });
        itemCategoriesGrid.jqGrid('gridResize', { minWidth: 674, minHeight: 300 });
        itemCategoriesGrid
    .toolbarButtonAdd("#t_tblItemCategoriesMain",
        {
            caption: $('#hidAMS_ItemCategory_btnAdd').text(),
            position: "first",
            align: (_langDir == 'rtl' ? 'right' : 'left'),
            buttonicon: 'ui-icon-circle-plus',
            onClickButton: function () {
                itemCategory.ItemCategories_New();
            }
        })
        .toolbarButtonAdd("#t_tblItemCategoriesMain",
            {
                caption: "Excel",
                position: "last",
                align: (_langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                    if (rowCount == 0) return false;
                    itemCategoriesGrid.jqGrid('excelExport', { url: '/opeReady/Handlers/ExcelExport/itemCategoriesExcel.ashx' });
                }
            });
    },

    getItemCategoriesData: function (pData, newData) {
        if (!newData) {
            AssetMngSettingsService.ItemCategory_SelectAll(
            function (data, textStatus) {
                itemCategory.ReceivedItemCategoriesData(JSON.parse(getMain(data)).rows);
            }, function (ex) {
                return false;
            }, null);
        } else {
            itemCategory.ReceivedItemCategoriesData(JSON.parse(getMain(newData)).rows);
        }
    },

    ReceivedItemCategoriesData: function (data) {
        var thegrid = $("#tblItemCategoriesMain");
        thegrid.clearGridData();
        rowCount = data.length;
        if (!rowCount) $('#divItemCategoriesMain').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },

    ItemCategories_Update: function (itemCat) {
        $("#hidItemCategory_ID").val(itemCat.ItemCategory_ID);
        $("#txtItemCategoryName").val(itemCat.ItemCategory_Name);
        $("#txtEndServiceDateAlertInDays").val(itemCat.EndServiceDateAlertInDays);
        $("#btnAddItemCategory").val($("#hidAMS_ItemCategory_btnUpdate").text());
        itemCategory.divItemCategories_Open();
    },

    DeleteItemCategories: function (ItemCategoriesID) {
        if (ItemCategoriesID) {
            $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
                open: function (type, data) {
                    $(this).parent().appendTo("form");
                },
                buttons: {
                    Ok: function (e) {
                        e.preventDefault();
                        $("#waitplease").css({ 'display': 'block' });
                        try {
                            AssetMngSettingsService.ItemCategory_Delete(ItemCategoriesID,
                        function (result) {
                            if (result) {
                                $("#tblItemCategoriesMain").GridUnload();
                                itemCategory.PopulationItemCategoryGrid(result);
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

    ItemCategories_New: function () {
        $("#txtItemCategoryName,#txtEndServiceDateAlertInDays").val("");
        $("#hidItemCategory_ID").val("");
        $("#btnAddItemCategoriesType").val($("#hidItemCategories_btnAddItemCategories").text());
        itemCategory.divItemCategories_Open();
    },

    ItemCategories_Save: function (value) {
        AssetMngSettingsService.ItemCategory_Save(value,
            function (data) {
                if (data) {
                    $("#tblItemCategoriesMain").GridUnload();
                    itemCategory.PopulationItemCategoryGrid(data);
                    $('#divItemCategoriesMainDetails').dialog('destroy');
                }
                $("#waitplease").css({ 'display': 'none' });
            },
            function (e) {
                $("#waitplease").css({ 'display': 'none' });
                return false;
            }, null);
        },

    divItemCategories_Open: function () {
        $("#divItemCategoriesMainDetails").dialog({ autoOpen: true, bgiframe: true, resizable: false, closeOnEscape: true, width: '300px', modal: true, zIndex: 50,
            title: $('#hidAMS_ItemCategory_MainGreeting').text(),
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
                $("#txtItemCategoryName").removeClass('ui-state-error');
            }
        });
        return false;
    }
};