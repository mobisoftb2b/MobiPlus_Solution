/// <reference path="../Common/_references.js" />
var rowCount;
var groupTask = {

    Init: function () {
        $("#txtCounter").ForceNumericOnly();
        this.AutocompleteItemSearch_ItemLocation();
        this.AutocompleteItemSearch_ItemName();
        this.CreateMaintItemsGrid();
    },
    TaskTypePopulation: function (itemCatID) {
        $("#ddlTaskType>option").remove();
        $("#ddlTaskType").addClass("ui-autocomplete-ddl-loading");
        AssetManagement.MaintTypes_Select(itemCatID,
		function (result) {
		    $(result).each(function () {
		        $("#ddlTaskType").append($("<option></option>").val(this['MaintType_ID']).html(this['MaintType_Name']));
		    });
		    if (itemCatID != undefined) $("#ddlTaskType").val(itemCatID);
		    $("#ddlTaskType").removeClass("ui-autocomplete-ddl-loading");
		    $("#ddlItemCategorySearch").val(itemCatID).trigger("change").attr("disabled", "disabled");
		    $("#tblItemsList").GridUnload();
		    groupTask.CreateMaintItemsGrid(null);
		},
	    function (e) {
	        return false;
	    });
    },
    TaskTypeSearchPopulation: function (catID) {
        $("#ddlTaskTypeSearch>option").remove();
        $("#ddlTaskTypeSearch").addClass("ui-autocomplete-ddl-loading");
        AssetManagement.ItemType_Select(catID,
		function (result) {
		    $(result).each(function () {
		        $("#ddlTaskTypeSearch").append($("<option></option>").val(this['ItemType_ID']).html(this['ItemType_Name']));
		    });
		    if (catID != undefined) $("#ddlTaskTypeSearch").val(catID);
		    $("#ddlTaskTypeSearch").removeClass("ui-autocomplete-ddl-loading");
		},
	    function (e) {
	        return false;
	    });

    },
    CreateUnitTree: function () {
        PQ.Admin.WebService.PQWebService.GetUserMenu(null, function (result) {
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
					    "core": { "rtl": rtl, "initially_open": [arrayIDs], "animation": "100" },
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
        }, function (ex) {
        });
    },
    CreateMaintItemsGrid: function (selectedData) {
        var langDir = "ltr";
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
                langDir = "rtl";
        }
        //        $('#divItemsList').block({
        //            css: { border: '0px' },
        //            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        //            message: ''
        //        });
        $("#tblItemsList").jqGrid({
            direction: langDir,
            datatype: function () { groupTask.ReceivedPlannedTasksData(selectedData); },
            height: 200,
            autowidth: true,
            colNames: [
				$('#hidGroupTask_Grid_ItemCategory').text(),
				$('#hidGroupTask_Grid_ItemTask').text(),
				$('#hidGroupTask_Grid_ManufacturerName').text(),
                $('#hidGroupTask_Grid_SerialNumber').text(),
                $('#hidGroupTask_Grid_ItemModel').text(),
                $('#hidGroupTask_Grid_Location').text(),
                $('#hidGroupTask_Grid_Delete').text(),
            //$('#hidGroupTask_Grid_Counter').text(),
                ''
				],
            colModel: [
				{ name: 'ItemCategory_Name', index: 'ItemCategory_Name', sortable: true, width: 80 },
                { name: 'ItemType_Name', index: 'ItemType_Name', sortable: true, width: 80 },
                { name: 'Item_Name', index: 'Item_Name', sortable: true, width: 80 },
                { name: 'Item_Serial', index: 'Item_Serial', sortable: true, width: 50 },
                { name: 'Item_Model', index: 'Item_Model', sortable: true, width: 80 },
                { name: 'Item_Location', index: 'Item_Location', sortable: true, width: 80 },
                { name: 'Delete', index: 'Delete', sortable: false, width: 45, formatter: deleteFormatter, align: 'center' },
                { name: 'Item_ID', hidden: 'true', key: true }

			],
            datefmt: 'd/m/Y',
            viewrecords: true,
            sortorder: "desc",
            autoencode: false,
            loadonce: true,
            recordpos: 'left',
            altRows: true,
            hoverrows: false,
            toolbar: [$('#ddlItemCategories').val() == "0" ? false : true, "top"],
            pager: '#pgrItemsList',
            pgbuttons: false,
            pginput: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (rowCount == $(this).getGridParam('records')) {
                    RaiseLoader(false);
                }
            },
            onCellSelect: function (rowid, iCol, cellcontent, e) {
                if (iCol == 6) {
                    return groupTask.ItemsListDataDelete($(this).getRowData(rowid).Item_ID);
                }
                return false;
            }
        })
        .jqGrid('gridResize', { minWidth: 900, minHeight: 300 })
        .toolbarButtonAdd("#t_tblItemsList",
		{
		    caption: $('#hidGroupTask_btnAddTask').text(),
		    position: "first",
		    align: (langDir == 'rtl' ? 'right' : 'left'),
		    buttonicon: 'ui-icon-circle-plus',
		    onClickButton: function () {
		        groupTask.AddTasksForGroup();
		    }
		});
    },
    ReceivedPlannedTasksData: function (selectedData) {
        if (selectedData)
            groupTask.ReceivedEmlpoymentEvaluationData(selectedData);
        $('#divItemsList').unblock();
    },
    ReceivedEmlpoymentEvaluationData: function (data) {
        var thegrid = $("#tblItemsList");
        thegrid.clearGridData();
        rowCount = data.length;
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },
    AddTasksForGroup: function () {
        $("#divTaskSearch").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, width: 800, height: 600,
            title: $('#hidGroupTask_HeaderTitle').text(),
            open: function () {
                $(this).parent().appendTo("form");
                $("#tblTaskResult").GridUnload();
                $("#btnAddSelectedTasks").hide();
                $("#ddlUnit,#hidUnitID").val("");
            },
            buttons: {
                Close: function (e) {
                    e.preventDefault();
                    $(this).dialog('destroy');
                    return false;
                }
            }
        });
        return false;
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
    CreateItemsCollectionGrid: function () {
        var langDir = "ltr";
        var lastsel;
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
                langDir = "rtl";
        }
        $('#divTaskResult').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        $("#tblTaskResult").jqGrid({
            direction: langDir,
            datatype: function () { groupTask.GetItemCollectionData(); },
            height: 200,
            autowidth: true,
            colNames: [
             $('#hidGroupTask_Grid_ItemCategory').text(),
				$('#hidGroupTask_Grid_ItemTask').text(),
				$('#hidGroupTask_Grid_ManufacturerName').text(),
                $('#hidGroupTask_Grid_SerialNumber').text(),
                $('#hidGroupTask_Grid_ItemModel').text(),
                $('#hidGroupTask_Grid_Location').text(),
                '', ''
            ],
            colModel: [
                { name: 'ItemCategory_Name', index: 'ItemCategory_Name', sortable: true, width: 80 },
                { name: 'ItemType_Name', index: 'ItemType_Name', sortable: true, width: 80 },
                { name: 'Item_Name', index: 'Item_Name', sortable: true, width: 80 },
                { name: 'Item_Serial', index: 'Item_Serial', sortable: true, width: 50 },
                { name: 'Item_Model', index: 'Item_Model', sortable: true, width: 80 },
                { name: 'Item_Location', index: 'Item_Location', sortable: true, width: 80 },
                { name: 'Item_ID', hidden: 'true', key: true },
                { name: 'ItemType_ID', hidden: 'true' }
            ],
            gridview: true,
            datefmt: 'd/m/Y',
            viewrecords: true,
            sortorder: "desc",
            autoencode: false,
            loadonce: false,
            recordpos: 'left',
            hoverrows: false,
            pager: '#pgrItems',
            pgbuttons: false,
            rowNum: 20000,
            multiselect: true,
            pginput: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local' });
                var ids = $(this).jqGrid('getDataIDs');
                if (rowCount == $(this).getGridParam('records')) {
                    $("#waitplease").css({ 'display': 'none' });
                    $('#divTaskResult').unblock();
                }
            },
            onSelectRow: function (id) {
                if (id && id !== lastsel) {
                    $(this).jqGrid('restoreRow', lastsel);
                    $(this).jqGrid('editRow', id, true);
                    lastsel = id;
                }
                var selected = $("#tblTaskResult").getGridParam("selarrrow");
                if (selected.length > 0) {
                    $("#btnAddSelectedTasks").show(100);
                } else {
                    $("#btnAddSelectedTasks").hide("slow");
                }
            },
            onSelectAll: function (id, status) {
                if (id && id !== lastsel) {
                    $(this).jqGrid('restoreRow', lastsel);
                    $(this).jqGrid('editRow', id, true);
                    lastsel = id;
                }
                var selected = $("#tblTaskResult").getGridParam("selarrrow");
                if (selected.length > 0) {
                    $("#btnAddSelectedTasks").show(100);
                } else {
                    $("#btnAddSelectedTasks").hide("slow");
                }
            }
        }).jqGrid('gridResize', { minWidth: 900, minHeight: 300 });
    },
    GetItemCollectionData: function () {
        var itSearch = {
            ItemCategory_ID: parseInt($("#ddlItemCategorySearch").val()),
            ItemType_ID: parseInt($("#ddlTaskTypeSearch").val()),
            Item_Name: $("#txtItemName").val(),
            Item_UnitID: $("#hidUnitID").val() == "" ? 0 : parseInt($("#hidUnitID").val()),
            Item_Location: $("#txtItemLocation").val(),
            Item_IsActive: true
        };
        AssetManagement.ItemSearch_Select(itSearch,
            function (data) {
                groupTask.ReceivedItemCollectionData(JSON.parse(getMain(data)).rows);
            }, function () {
                return false;
            }, null);
        return false;
    },
    ReceivedItemCollectionData: function (data) {
        var thegrid = $("#tblTaskResult");
        thegrid.clearGridData();
        rowCount = data.length;
        if (!rowCount) {
            $('#divTaskResult').unblock();
            RaiseLoader(false);
        }
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },
    getSelectedTasks: function () {
        var tasks = new Array();
        var exists = $("#tblItemsList").getGridParam("data");
        var arrIDs = $("#tblTaskResult").getGridParam("selarrrow");
        $(arrIDs).each(function () {
            var temp = $("#tblTaskResult").getRowData(this);
            if (temp.Item_ID) {
                tasks.push({
                    ItemCategory_Name: temp.ItemCategory_Name,
                    ItemType_Name: temp.ItemType_Name,
                    Item_Name: temp.Item_Name,
                    Item_Serial: temp.Item_Serial,
                    Item_Model: temp.Item_Model,
                    Item_Location: temp.Item_Location,
                    Item_ID: temp.Item_ID
                });
            }
        });

        $(exists).each(function () {
            var id = this.Item_ID;
            for (var i = 0; i < tasks.length; i++) {
                if (tasks[i].Item_ID == id)
                    return;
            }
            tasks.push({
                ItemCategory_Name: this.ItemCategory_Name,
                ItemType_Name: this.ItemType_Name,
                Item_Name: this.Item_Name,
                Item_Serial: this.Item_Serial,
                Item_Model: this.Item_Model,
                Item_Location: this.Item_Location,
                Item_ID: this.Item_ID
            });
        });
        $("#tblItemsList").GridUnload();
        var fieldArray = $.unique(tasks);
        groupTask.CreateMaintItemsGrid(fieldArray);
        $('#divTaskSearch').dialog('destroy');
        RaiseLoader(false);
    },
    SaveGroupMaintTask: function () {
        if (groupTask.RequaredFeilds()) {
            var mydata = $("#tblItemsList").jqGrid('getGridParam', 'data');
            if (mydata.length > 0) {
                var arrItems = new Array();
                for (var i = 0; i < mydata.length; i++) {
                    arrItems.push({ Item_ID: mydata[i].Item_ID });
                }
                var saveObj = {
                    ItemModels: arrItems,
                    MaintType_ID: $("#ddlTaskType").val(),
                    ItemMaint_DateStr: $("#txtGroupTaskDate").val(),
                    ItemMaint_Name: $("#txtResponsibleName").val(),
                    ItemMaint_Counter: $("#txtCounter").val() == "" ? 0 : $("#txtCounter").val(),
                    ItemMaint_Remarks: $("#txtRemarks").val()
                };
                AssetManagement.MaintItem_GroupSave(saveObj,
                    function (data) {
                        if (data) {
                            $("#dialogSuccessMessage").dialog({ autoOpen: true, resizable: true, closeOnEscape: true, modal: true, height: 150,
                                open: function () {
                                    $("#lblSuccessMessage").text($("#hidSaveSuccessMessage").text());
                                },
                                buttons: {
                                    Ok: function () {
                                        $(this).dialog("destroy");
                                        window.location.href = "/opeReady/Presentation/AssetMng/ItemsSearch.aspx";
                                    }
                                }
                            });

                        }
                    }, function (ex) {
                        $("#divErrorMessageAlert").dialog({ autoOpen: true, resizable: true, closeOnEscape: true, modal: true, height: 150,
                                open: function () {
                                    $("#lblErrorMessageAlert").text(ex._message);
                                },
                                buttons: {
                                    Close: function () {
                                        $(this).dialog("destroy");  
                                    }
                                }
                            });
                        return false;
                    }, null);

            } else {
                return false;
            }
        }
        return false;
    },
    RequaredFeilds: function () {
        if ($("#txtGroupTaskDate").val() == "") {
            $('#txtGroupTaskDate').addClass('ui-state-error').focus();
            return false;
        }
        else
            $('#txtGroupTaskDate').removeClass('ui-state-error', 100);

        if ($("#ddlTaskType").val() == "0") {
            $('#ddlTaskType').addClass('ui-state-error').focus();
            return false;
        }
        else
            $('#ddlTaskType').removeClass('ui-state-error', 100);
        return true;
    },
    ItemsListDataDelete: function (itemID) {
        if (itemID) {
            $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
                open: function (type, data) {
                    $(this).parent().appendTo("form");
                },
                buttons: {
                    Ok: function (e) {
                        e.preventDefault();
                        RaiseLoader(true);
                        $(this).dialog('destroy');
                        var tasks = new Array();
                        var mydata = $("#tblItemsList").jqGrid('getGridParam', 'data');


                        var myremoveddata = $.grep(mydata, function (value) {
                            return value.Item_ID !== itemID;
                        });

                        $(myremoveddata).each(function () {
                            tasks.push({
                                ItemCategory_Name: this.ItemCategory_Name,
                                ItemType_Name: this.ItemType_Name,
                                Item_Name: this.Item_Name,
                                Item_Serial: this.Item_Serial,
                                Item_Model: this.Item_Model,
                                Item_Location: this.Item_Location,
                                Item_ID: this.Item_ID
                            });
                        });
                        $("#tblItemsList").GridUnload();
                        groupTask.CreateMaintItemsGrid(tasks);
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
    }
};
$("#ddlUnit").live("click", function () {
    if ($('#treeUnits').is(':visible')) {
        $('#treeUnits').fadeOut('slide');
    }
    else {
        $('#treeUnits').fadeIn('slide');
        groupTask.CreateUnitTree();
    }
    return false;
});
$("#btnTaskSearch").live("click", function () {
    $("#tblTaskResult").GridUnload();
    groupTask.CreateItemsCollectionGrid();
});
$("#btnAddSelectedTasks").live("click", function () {
    groupTask.getSelectedTasks();
});
$("#btnSaveGroupMaintTask").live("click", function () {
    groupTask.SaveGroupMaintTask();
});