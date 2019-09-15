/// <reference path="../Common/_references.js" />

var rowCount;
var itemAlert = {
    PopulationMaintCycleGrid: function (newData) {
        var _langDir;
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
                _langDir = "rtl";
            else
                _langDir = "ltr";
        }
        $('#divDefineMaintCycles').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var itemAlertGrid = $("#tblMaintCycle").jqGrid({
            direction: _langDir,
            datatype: function (pdata) { itemAlert.GetMaintCyclesData(pdata, newData) },
            height: 375,
            autowidth: false,
            colNames: [
                $('#hidMaintCycle_Grid_ItemCategory_Name').text(),
                $('#hidMaintCycle_Grid_ItemType_Name').text(),
                $('#hidMaintCycle_Grid_MaintType_Name').text(),
                $('#hidMaintCycle_Grid_MaintCycle_Days').text(),
                $('#hidMaintCycle_Grid_MaintCycle_Counter').text(),
                "", "", 'ItemType_ID', 'MaintType_ID', 'ItemCategory_ID', 'MaintCycle_Counter'],
            colModel: [
           		{ name: 'ItemCategory_Name', index: 'ItemCategory_Name', sortable: true, width: 200 },
                { name: 'ItemType_Name', index: 'ItemType_Name', sortable: true, width: 200 },
                { name: 'MaintType_Name', index: 'MaintType_Name', sortable: true, width: 200 },
                { name: 'MaintCycle_Days', index: 'MaintCycle_Days', sortable: true, width: 100 },
                { name: 'MaintCycle_Counter', index: 'MaintCycle_Counter', sortable: true, width: 100 },
                { name: 'Edit', index: 'Edit', sortable: false, edittype: 'image', formatter: editFormatter, width: 32, align: 'center' },
                { name: 'Delete', index: 'Delete', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                { name: 'ItemType_ID', hidden: 'true' },
                { name: 'MaintType_ID', hidden: 'true' },
                { name: 'ItemCategory_ID', hidden: 'true' },
                { name: 'MaintCycle_Counter', hidden: 'true' }
           	],
            datefmt: 'd/m/Y',
            viewrecords: true,
            sortorder: "desc",
            autoencode: false,
            loadonce: false,
            recordpos: 'left',
            altRows: true,
            hoverrows: false,
            toolbar: [true, "top"],
            pager: '#pgrMaintCycle',
            pgbuttons: false,
            pginput: false,
            rowNum: 2000,
            jsonReader: {
                root: function (obj) { return obj; },
                page: function (obj) { return 1; },
                total: function (obj) { return 1; },
                records: function (obj) { return obj.length; },
                repeatitems: false,
                id: "ItemCategory.ItemCategory_Name"
            },
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (rowCount == $(this).getGridParam('records')) {
                    $("#waitplease").css({ 'display': 'none' });
                    $('#divDefineMaintCycles').unblock();
                }
            },
            onCellSelect: function (rowid, iCol, cellcontent, e) {
                switch (iCol) {
                    case 5:
                        itemAlert.MaintCycles_Updates($(this).getRowData(rowid));
                        break;
                    case 6:
                        return itemAlert.MaintCycles_Delete($(this).getRowData(rowid));
                        break;
                }
                return false;
            },
            ondblClickRow: function (rowid, iRow, iCol, e) {
                itemAlert.MaintCycles_Updates($(this).getRowData(rowid));
            }
        });
        itemAlertGrid.jqGrid('gridResize', { minWidth: 674, minHeight: 300 });
        itemAlertGrid
    .toolbarButtonAdd("#t_tblMaintCycle",
        {
            caption: $('#lblMaintCycle_btnAddNewMaintCycle').text(),
            position: "first",
            align: (_langDir == 'rtl' ? 'right' : 'left'),
            buttonicon: 'ui-icon-circle-plus',
            onClickButton: function () {
                itemAlert.MaintCycles_New();
            }
        })
        .toolbarButtonAdd("#t_tblMaintCycle",
            {
                caption: "Excel",
                position: "last",
                align: (_langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                    if (rowCount == 0) return false;
                    itemAlertGrid.jqGrid('excelExport', { url: '/opeReady/Handlers/ExcelExport/MaintCyclesExcel.ashx' });
                }
            });
    },

    GetMaintCyclesData: function (pData, newData) {
        if (!newData) {
            AssetMngSettingsService.MaintCycles_SelectAll(
            function (data, textStatus) {
                itemAlert.ReceivedMaintCycleData(JSON.parse(getMain(data)).rows);
            }, function (ex) {
                return false;
            }, null);
        } else {
            itemAlert.ReceivedMaintCycleData(JSON.parse(getMain(newData)).rows);
        }
    },

    ReceivedMaintCycleData: function (data) {
        var thegrid = $("#tblMaintCycle");
        thegrid.clearGridData();
        rowCount = data.length;
        if (!rowCount) $('#divDefineMaintCycles').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },

    MaintCycles_Updates: function (values) {
        $("#ddlItemCategoriesDetails").val(values.ItemCategory_ID).addClass("no-display");
        $("#txtItemCategoriesDetails").val(values.ItemCategory_Name).removeClass("no-display");
        $("#ddlItemTypes").val(values.ItemType_ID).addClass("no-display");
        $("#txtItemTypes").val(values.ItemType_Name).removeClass("no-display");
        $("#ddlMaintTypes").val(values.MaintType_ID).addClass("no-display");
        $("#txtMaintTypes").val(values.MaintType_Name).removeClass("no-display");
        $("#txtMaintCycle_Days").val(values.MaintCycle_Days);
        $("#txtCounter").val(values.MaintCycle_Counter);
        $("#btnAddNewMaintCycle").val($("#lblMaintCycle_btnUpdate").text());
        itemAlert.divDefineMaintCycleDetails_Open();
    },

    MaintCycles_New: function () {
        $("#ddlItemCategoriesDetails, #ddlItemTypes, #ddlMaintTypes").val("0").removeClass("no-display");
        $("#txtMaintCycle_Days, #hidItemCategory_ID, #hidItemType_ID, #hidMaintType_ID,#txtCounter").val("");
        $("#txtItemCategoriesDetails, #txtItemTypes, #txtMaintTypes").val("").addClass("no-display");
        $("#btnAddNewMaintCycle").val($("#lblMaintCycle_btnAddNewMaintCycle").text());
        itemAlert.divDefineMaintCycleDetails_Open();
    },

    divDefineMaintCycleDetails_Open: function () {
        $("#divDefineMaintCycleDetails").dialog({ autoOpen: true, bgiframe: true, resizable: false, closeOnEscape: true, width: '650px', modal: true, zIndex: 50,
            title: $('#hidMaintCycle_MainGreeting').text(),
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
                $("#ddlItemCategoriesDetails, #ddlItemTypes, #ddlMaintTypes, #txtMaintCycle_Days").removeClass('ui-state-error');
            }
        });
        return false;
    },

    MaintCycles_Save: function (maintCycle) {
        AssetMngSettingsService.MaintCycles_Save(maintCycle,
            function (data) {
                if (data) {
                    $("#tblMaintCycle").GridUnload();
                    itemAlert.PopulationMaintCycleGrid(data);
                    $('#divDefineMaintCycleDetails').dialog('destroy');
                }
                $("#waitplease").css({ 'display': 'none' });
            },
            function (e) {
                $("#waitplease").css({ 'display': 'none' });
                return false;
            }, null);
    },
    MaintCycles_Delete: function (faultTypeID) {
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
                            var maintCycle = {
                                ItemCategory_ID: faultTypeID.ItemCategory_ID,
                                ItemType_ID: faultTypeID.ItemType_ID,
                                MaintType_ID: faultTypeID.MaintType_ID
                            };
                            AssetMngSettingsService.MaintCycles_Delete(maintCycle,
                        function (result) {
                            if (result) {
                                $("#tblMaintCycle").GridUnload();
                                itemAlert.PopulationMaintCycleGrid(result);
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
    PopulateItemTypesCombo: function (catID) {
        $("#ddlItemTypes>option").remove();
        $("#ddlItemTypes").addClass("ui-autocomplete-ddl-loading");
        AssetMngSettingsService.ItemType_Select(catID,
		function (result) {
		    $(result).each(function () {
		        $("#ddlItemTypes").append($("<option></option>").val(this['ItemType_ID']).html(this['ItemType_Name']));
		    });
		    $("#ddlItemTypes").removeClass("ui-autocomplete-ddl-loading");
		},
	function (e) {
	    return false;
	});
    },
    PopulateMaintTypesCombo: function (catID) {
        $("#ddlMaintTypes>option").remove();
        $("#ddlMaintTypes").addClass("ui-autocomplete-ddl-loading");
        AssetMngSettingsService.MaintTypes_Select(catID,
		function (result) {
		    $(result).each(function () {
		        $("#ddlMaintTypes").append($("<option></option>").val(this['MaintType_ID']).html(this['MaintType_Name']));
		    });
		    $("#ddlMaintTypes").removeClass("ui-autocomplete-ddl-loading");
		},
	function (e) {
	    return false;
	});
    }
};


$("#btnAddNewMaintCycle").live("click", function () {
    if ($("#ddlItemCategoriesDetails").val() == "0") {
        $("#ddlItemCategoriesDetails").addClass('ui-state-error');
        return false;
    }
    if ($("#ddlItemTypes").val() == "0") {
        $("#ddlItemTypes").addClass('ui-state-error');
        return false;
    }
    if ($("#ddlMaintTypes").val() == "0") {
        $("#ddlMaintTypes").addClass('ui-state-error');
        return false;
    }
    if ($("#txtMaintCycle_Days").val() == "" && $("#txtCounter").val() == "") {
        $("#txtMaintCycle_Days").addClass('ui-state-error');
        return false;
    }
    $("#waitplease").css({ 'display': 'block' });
    var maintCycle = {
        ItemCategory_ID: $("#ddlItemCategoriesDetails").val(),
        ItemType_ID: $("#ddlItemTypes").val(),
        MaintType_ID: $("#ddlMaintTypes").val(),
        MaintCycle_Days: $("#txtMaintCycle_Days").val() == "" ? 0 : parseInt($("#txtMaintCycle_Days").val()),
        MaintCycle_Counter: $("#txtCounter").val() == "" ? 0 : parseInt($("#txtCounter").val())
    };
    itemAlert.MaintCycles_Save(maintCycle);
});
