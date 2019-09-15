/// <reference path="../Common/_references.js" />
/// <reference path="~/Resources/Scripts/Common/jquery.common.js" />
var rowCount;

var itemSearch = {
    Init: function () {
        itemSearch.AutocompleteItemSearch_Model();
        itemSearch.AutocompleteItemSearch_ItemLocation();
        itemSearch.AutocompleteItemSearch_ItemName();
        itemSearch.AutocompleteItemSearch_ItemStatus();
        itemSearch.AutocompleteItemSearch_SerialNumber();
        itemSearch.AutocompleteItemSearch_ServiceProviderName();
    },
    CreateUnitTree: function () {
        window.PQ.Admin.WebService.PQWebService.GetUserMenu(null, function (result) {
            if (result) {
                var theme, rtl;
                if ($.cookie("lang")) {
                    var lang = $.cookie("lang");
                    if (lang == 'he-IL' || lang == 'ar') {
                        theme = "default-rtl";
                        rtl = true;
                    }
                    else {
                        theme = "default";
                        rtl = false;
                    }
                }
                try {
                    var level = $("#lblTreeLebel").text() == "" ? 0 : parseInt($("#lblTreeLebel").text());
                    var arrayIDs = GetArrayTreeIDs(result, level);
                    $('#treeUnits').jstree(
                    { "xml_data": { "data": result },
                        "plugins": ["themes", "xml_data", "ui", "types"],
                        "core": { "rtl": rtl, "initially_open": arrayIDs, "animation": "100" },
                        "themes": { "theme": theme },
                        "types": { "types":
                        { "file": {
                            "valid_children": ["default"],
                            "icon": { "image": "/opeReady/Resources/images/active.png" }
                        },
                            "folder": {
                                "valid_children": "all",
                                "icon": { "image": "/opeReady/Resources/images/close.png" },
                                "hover_node": false,
                                "select_node": function () { return false; }
                            }
                        }
                        }
                    }).bind("select_node.jstree", function (event, data) {
                        $('#hidUnitID').val(data.rslt.obj.get(0).id);
                        $('#ddlUnit').val($(data.rslt.obj.find("a").get(0)).text());
                        $('#treeUnits').fadeOut('slow');
                        $('#ddlUnit').removeClass('ui-state-error', 100);
                        return false;
                    });
                } catch (e) {
                }
            }
        }, function () {
        });
    },
    CreateItemsCollectionGrid: function (itemsQty) {
        var langDir;
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
                langDir = "rtl";
            else
                langDir = "ltr";
        }
        $('#divResultPanel').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var itemGrid = $("#tblItems").jqGrid({
            direction: langDir,
            datatype: function () { itemSearch.GetItemCollectionData(itemsQty); },
            height: 400,
            autowidth: true,
            colNames: [
                $('#hidAssetMng_Grid_lblItemCategory').text(), $('#hidAssetMng_Grid_lblItemType').text(),
                $('#hidAssetMng_Grid_lblItemName').text(), $('#hidAssetMng_Grid_lblSerialNumber').text(), $('#hidAssetMng_Grid_lblItemModel').text(),
                $('#hidAssetMng_Grid_lblLocation').text(), $('#hidAssetMng_Grid_lblStatus').text(), $('#hidAssetMng_Grid_lblMaintAlert').text(), $('#hidAssetMng_Grid_FaultAlert').text(),
                "", 'Item_ID'],
            colModel: [
                { name: 'ItemCategory_Name', index: 'ItemCategory_Name', sortable: true, width: 80 },
                { name: 'ItemType_Name', index: 'ItemType_Name', sortable: true, width: 80 },
                { name: 'Item_Name', index: 'Item_Name', sortable: true, width: 80 },
                { name: 'Item_Serial', index: 'Item_Serial', sortable: true, width: 50 },
                { name: 'Item_Model', index: 'Item_Model', sortable: true, width: 80 },
                { name: 'Item_Location', index: 'Item_Location', sortable: true, width: 80 },
                { name: 'Item_Status', index: 'Item_Status', sortable: true, width: 40, align: 'center' },
                { name: 'Item_isMaintAlert', index: 'Item_isMaintAlert', formatter: maintAlertFormatter, sortable: false, width: 42, align: 'center' },
                { name: 'Item_IsFaultAlert', index: 'Item_IsFaultAlert', formatter: faultAlertFormatter, sortable: false, width: 35, align: 'center' },
                { name: 'Edit', index: 'Edit', sortable: false, edittype: 'image', formatter: editFormatter, width: 32, align: 'center' },
                { name: 'Item_ID', hidden: 'true', key: true }
            ],
            gridview: true,
            datefmt: 'd/m/Y',
            viewrecords: true,
            sortorder: "desc",
            autoencode: false,
            loadonce: false,
            recordpos: 'left',
            hoverrows: false,
            toolbar: [true, "top"],
            pager: '#pgrItems',
            pgbuttons: false,
            rowNum: 20000,
            pginput: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (rowCount == $(this).getGridParam('records')) {
                    $("#waitplease").css({ 'display': 'none' });
                    $('#divResultPanel').unblock();
                }
            },
            onCellSelect: function (rowid, iCol) {
                switch (iCol) {
                    case 6:
                        itemSearch.ItemDetails_Load($(this).getRowData(rowid).Item_ID);
                        break;
                }
                return false;
            },
            ondblClickRow: function (rowid) {
                itemSearch.ItemDetails_Load($(this).getRowData(rowid).Item_ID);
            }
        });
        itemGrid.jqGrid('gridResize', { minWidth: 674, minHeight: 300 });
        itemGrid
        .toolbarButtonAdd("#t_tblItems",
            {
                caption: "Excel",
                position: "last",
                align: (langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                    if (rowCount == 0) return false;
                    var params = $.param({
                        ItemCategory_ID: parseInt($("#ddlItemCategories").val()),
                        ItemType_ID: parseInt($("#ddlItemType").val()),
                        Item_Model: $("#txtModelName").val(),
                        Item_Name: $("#txtItemName").val(),
                        Item_Serial: $("#txtSerialNumber").val(),
                        Item_UnitID: $("#hidUnitID").val() == "" ? null : parseInt($("#hidUnitID").val()),
                        Item_Location: $("#txtItemLocation").val(),
                        Item_Status: $("#txtItemStatus").val(),
                        Item_isMaintAlert: $("#chkIsActive").attr("checked"),
                        ItemsQty: itemsQty == '' ? 100 : (isNaN(itemsQty) ? 1000 : parseInt(itemsQty))
                    });
                    itemGrid.jqGrid('excelExport', { url: '/opeReady/Handlers/ExcelExport/itemsExcelHandler.ashx?' + params });
                }
            });
    },
    GetItemCollectionData: function (itemsQty) {
        var uid = $("#hidUnitID").val() == "" ? null : parseInt($("#hidUnitID").val());
        var itSearch = {
            ItemCategory_ID: parseInt($("#ddlItemCategories").val()),
            ItemType_ID: parseInt($("#ddlItemType").val()),
            Item_Model: $("#txtModelName").val(),
            Item_Name: $("#txtItemName").val(),
            Item_Serial: $("#txtSerialNumber").val(),
            Item_UnitID: uid,
            Item_Location: $("#txtItemLocation").val(),
            Item_Status: $("#txtItemStatus").val(),
            Item_IsActive: $("#chkIsActive").attr("checked"),
            Item_IsMaintAlert: $("#chkMaintAlert").attr("checked"),
            Item_IsFaultAlert: $("#chkFaultAlert").attr("checked"),
            ServiceProviderName: $("#txtServiceProviderName").val(),
            ItemsQty: itemsQty == '' ? 100 : (isNaN(itemsQty) ? 1000 : parseInt(itemsQty))
        };
        try {
            AssetManagement.ItemSearch_Select(itSearch,
            function (data) {
                itemSearch.ReceivedItemCollectionData(JSON.parse(getMain(data)).rows);
            }, function () {
                return false;
            }, null);
        } catch (e) {
            return false;
        }
        return false;
    },
    ReceivedItemCollectionData: function (data) {
        var thegrid = $("#tblItems");
        thegrid.clearGridData();
        rowCount = data.length;
        if (!rowCount) { $('#divResultPanel').unblock(); $("#waitplease").css({ 'display': 'none' }); }
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
        itemSearch.ShowIconParamsArea();
    },
    ShowIconParamsArea: function () {
        var a = $("#divSearchPanel");
        var b = $("#imgShowParams");
        if (a.is(":visible")) {
            a.toggle(function () {
                b.fadeIn("slow");
            });
        } else {
            a.toggle(function () {
                b.fadeOut("slow");
            });
        }
    },
    ItemDetails_Load: function (itemID) {
        if (itemID) {
            $("#waitplease").css({ 'display': 'block' });
            window.location.href = "ItemDetails.aspx?iid=" + itemID;
        }
    },
    AutocompleteItemSearch_Model: function () {
        $("#txtModelName").autocomplete({
            source: function (request, response) {
                AssetManagement.GetItem_ModelList(request.term,
                  function (data) {
                      if (data) {
                          response($.map(data, function (item) {
                              return {
                                  value: item.Item_Model
                              };
                          }));
                      };
                  },
                    function (e) {
                    },
                    null);
            }, minLength: 1
        });
    },
    AutocompleteItemSearch_ItemName: function () {
        $("#txtItemName").autocomplete({
            source: function (request, response) {
                AssetManagement.GetItem_ItemNameList(request.term,
                  function (data) {
                      if (data) {
                          response($.map(getMain(data), function (item) {
                              return {
                                  value: item.Item_Name
                              };
                          }));
                      };
                  },
                    function (e) {
                    },
                    null);
            }, minLength: 1
        });
    },
    AutocompleteItemSearch_SerialNumber: function () {
        $("#txtSerialNumber").autocomplete({
            source: function (request, response) {
                AssetManagement.GetItem_SerialNumberList(request.term,
                  function (data) {
                      if (data) {
                          response($.map(getMain(data), function (item) {
                              return {
                                  value: item.Item_Serial
                              };
                          }));
                      };
                  },
                    function (e) {
                    },
                    null);
            }, minLength: 1
        });
    },
    AutocompleteItemSearch_ItemLocation: function () {
        $("#txtItemLocation").autocomplete({
            source: function (request, response) {
                AssetManagement.GetItem_LocationList(request.term,
                  function (data) {
                      if (data) {
                          response($.map(getMain(data), function (item) {
                              return {
                                  value: item.Item_Location
                              };
                          }));
                      };
                  },
                    function () {
                    },
                    null);
            }, minLength: 1
        });
    },
    AutocompleteItemSearch_ItemStatus: function () {
        $("#txtItemStatus").autocomplete({
            source: function (request, response) {
                AssetManagement.GetItem_StatusList(request.term,
                  function (data) {
                      if (data) {
                          response($.map(getMain(data), function (item) {
                              return {
                                  value: item.Item_Status
                              };
                          }));
                      };
                  },
                    function () {
                    },
                    null);
            }, minLength: 1
        });
    },
    AutocompleteItemSearch_ServiceProviderName: function () {
        $("#txtServiceProviderName").autocomplete({
            source: function (request, response) {
                AssetManagement.GetItem_ServiceProviderNamesList(request.term,
                  function (data) {
                      if (data) {
                          response($.map(getMain(data), function (item) {
                              return {
                                  value: item.ServiceProviderName
                              };
                          }));
                      };
                  },
                    function () {
                    },
                    null);
            }, minLength: 1
        });
    },
    PopulateItemTypesCombo: function (catID) {
        $("#ddlItemType>option").remove();
        $("#ddlItemType").addClass("ui-autocomplete-ddl-loading");
        AssetManagement.ItemType_Select(catID,
        function (result) {
            $(result).each(function () {
                $("#ddlItemType").append($("<option></option>").val(this['ItemType_ID']).html(this['ItemType_Name']));
            });
            $("#ddlItemType").removeClass("ui-autocomplete-ddl-loading");
        },
    function () {
        return false;
    });
    }
};

$("#ddlUnit").live("click", function () {
    if ($('#treeUnits').is(':visible')) {
        $('#treeUnits').fadeOut('slide');
    }
    else {
        $('#treeUnits').fadeIn('slide');
        itemSearch.CreateUnitTree();
    }
    return false;
});

$("#btnSearch").live("click", function () {
    $("#waitplease").css({ 'display': 'block' });
    $("#tblItems").GridUnload();
    itemSearch.CreateItemsCollectionGrid($("#amount").val());
});

$("#btnClear").live("click", function () {
    $('input:text').each(function () {
        if (this.id != "amount")
            $(this).val('');
    });
    $('.select-hyper').val('0');
    $('#hidUnitID').val('');
});

function formatItem(row) {
    return row[0] + " (<strong>id: " + row[1] + "</strong>)";
}
function formatResult(row) {
    return row[0].replace(/(<.+?>)/gi, '');
}
function log(event, data, formatted) {
    $("<li>").html(!data ? "No match!" : "Selected: " + formatted).appendTo("#result");
}
