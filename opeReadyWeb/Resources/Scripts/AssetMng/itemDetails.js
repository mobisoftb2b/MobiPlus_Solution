/// <reference path="../Common/_references.js" />
/// <reference path="~/Resources/Scripts/Common/jquery.ajax_upload.0.6.js" />
/// <reference path="~/Resources/Scripts/AssetMng/maintTask.js" />
var rowCount;
var itemDetail = {
    Init: function () {
        itemDetail.AutocompleteItemSearch_ItemLocation();
        itemDetail.AutocompleteItemSearch_ItemName();
        itemDetail.AutocompleteItemSearch_ItemStatus();
        itemDetail.AutocompleteItemSearch_Model();
        itemDetail.AutocompleteItemSearch_SerialNumber();
        itemDetail.AutocompleteItemSearch_ServiceProviderName();
        itemDetail.AutocompleteItemSearch_MaintTask();
    },
    ChoosePhoto: function () {
        var pid = getArgs();
        if (pid.iid) {
            $("#ucPhotoUploader")
			.addClass("dialog")
			.appendTo("body")
			.dialog({
			    open: function () {
			        var param = getArgs();
			        var button = $('#btnPhotoBrowse');
			        var upload = new AjaxUpload(button, {
			            action: '/opeReady/Handlers/itemPhotoUpload.ashx?iid=' + param.iid,
			            name: 'myfile',
			            autoSubmit: false,
			            onChange: function (file, ext) {
			                if (!checkFileExtension(null, ext)) {
			                    $("#btnAddPhoto").attr("disabled", true);
			                }
			                else { $("#btnAddPhoto").removeAttr("disabled", 100); }
			                $("#lblPhotoFileName").block({
			                    css: { border: '0px' },
			                    overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
			                    message: ''
			                });
			                setTimeout(function () { $("#lblPhotoFileName").unblock().text(file); }, 500);

			            },
			            onSubmit: function (file, ext) {
			                $("#waitplease").css({ 'display': 'block' });
			                $("#loader").empty().addClass('loading');
			                this.disable();
			            },
			            onComplete: function (file, response) {
			                this.enable();
			                setTimeout(function () {
			                    itemDetail.LoadPhoto();
			                    $("#waitplease").css({ 'display': 'none' });
			                }, 500);
			                if (response != "") {
			                    RaiseWarningAlert($("#lblGeneral_FIleUploadErrorMessage").text());
			                }
			            }
			        });

			        $("#btnAddPhoto").live("click", function () {
			            upload.submit();
			        });
			    },
			    close: function () { $(this).dialog("destroy"); },
			    modal: true,
			    autoOpen: true,
			    resizable: true,
			    width: '350px',
			    closeOnEscape: true
			});
        }
        return false;
    },
    PopulationItemDetailsData: function (itemID) {
        if (itemID) {
            try {
                AssetManagement.ItemDetails_Select(itemID,
				function (data) {
				    if (data) {
				        $("#hidItem_ID").val(data.Item_ID);
				        $("#hidUnitID").val(data.Item_Unit_ID);
				        $("#hidItemCategory_ID").val(data.ItemCategory.ItemCategory_ID);
				        $("#ddlUnit").val(data.Item_Unit_Name);
				        itemDetail.PopulateItemTypesCombo(data.ItemCategory.ItemCategory_ID, data.ItemType.ItemType_ID);
				        //					itemDetail.PopulateMaintTypesCombo(data.ItemCategory.ItemCategory_ID);
				        itemDetail.PopulateFaultTypeCombo(data.ItemCategory.ItemCategory_ID);
				        $("#ddlItemCategory").val(data.ItemCategory.ItemCategory_ID);
				        $("#txtItemName").val(data.Item_Name);
				        $("#txtSerialNumber").val(data.Item_Serial);
				        $("#txtItemLocation").val(data.Item_Location);
				        $("#txtItemStatus").val(data.Item_Status);
				        $("#txtItemModel").val(data.Item_Model);
				        $("#txtCheckIn").val(data.Item_StartDateStr);
				        $("#txtCheckOut").val(data.Item_EndDateStr);
				        $("#txtCounterDate").val(data.Item_CounterDateStr);
				        $("#txtCounter").val(data.Item_Counter);
				        $("#chkIsActive").attr("checked", data.Item_EndDate == null ? true : false);
				        $("#txtServiceProviderName").val(data.ServiceProviderName);
				        $("#txtServiceProviderDetails").val(data.ServiceProviderDetails);
				        $("#txtEndServiceDate").val(data.EndServiceDateStr);
				        $("#txtRemarks").val(data.ItemRemarks);
				        if (data.Item_isMaintAlert) {
				            $("#lblMaintAlertDesc").show();
				            $("#tdMaintAlert").show();
				        }
				        itemDetail.ItemDetails_PlannedMaint(data.MaintItems);
				    }
				    setTimeout(function () {
				        $("#waitplease").css({ 'display': 'none' });
				    }, 550);
				},
				function (ex) {
				    $("#waitplease").css({ 'display': 'none' });
				    return false;
				}, null);
            } catch (e) {
                $("#waitplease").css({ 'display': 'none' });
            }
        }
    },
    LoadPhoto: function () {
        var img = new Image(145, 167);
        var currdate = new Date();
        currdate = encodeURI(currdate.toString());
        var pid = getArgs();
        if (pid.iid) {
            $(img).hide();
            $(img).attr("src", "/opeReady/Handlers/itemPhotoHandler.ashx?iid=" + pid.iid + "&d=" + currdate);
            $(img).waitForImages(function () {
                $("#loader").removeClass('loading').append(img);
                $(img).fadeIn();
            });
        }
        else {
            $(img).attr("src", "/opeReady/Resources/images/shoplist.gif?d=" + currdate);
            $(img).waitForImages(function (result) {
                $("#loader").removeClass('loading').append(img);
                $(img).fadeIn();
            });
        }
    },
    ItemDetails_Save: function () {
        var pid = getArgs();
        if (itemDetail.RequaredFeilds()) {
            $("#waitplease").css({ 'display': 'block' });
            var itemDetails = {
                Item_ID: $("#hidItem_ID").val() == "" ? null : parseInt($("#hidItem_ID").val()),
                ItemCategory: {
                    ItemCategory_ID: parseInt($("#ddlItemCategory").val())
                },
                ItemType: {
                    ItemType_ID: parseInt($("#ddlItemType").val())
                },
                Item_Unit_ID: $("#hidUnitID").val() == "" ? null : parseInt($("#hidUnitID").val()),
                Item_Name: $("#txtItemName").val(),
                Item_Serial: $("#txtSerialNumber").val(),
                Item_Location: $("#txtItemLocation").val(),
                Item_Status: $("#txtItemStatus").val(),
                Item_Model: $("#txtItemModel").val(),
                Item_Counter: $("#txtCounter").val() == "" ? null : parseInt($("#txtCounter").val()),
                Item_StartDateStr: $("#txtCheckIn").val() == "" ? null : $("#txtCheckIn").val(),
                Item_EndDateStr: $("#txtCheckOut").val() == "" ? null : $("#txtCheckOut").val(),
                Item_CounterDateStr: $("#txtCounterDate").val() == "" ? null : $("#txtCounterDate").val(),
                ServiceProviderName: $("#txtServiceProviderName").val(),
                ServiceProviderDetails: $("#txtServiceProviderDetails").val(),
                ItemRemarks: $("#txtRemarks").val(),
                EndServiceDateStr: $("#txtEndServiceDate").val() == "" ? null : $("#txtEndServiceDate").val()
            };
            AssetManagement.ItemDetails_Save(itemDetails,
			function (data) {
			    if (!pid.iid) {
			        window.location = '/opeReady/Presentation/AssetMng/ItemDetails.aspx?iid=' + data;
			    }
			    setTimeout(function () {
			        $("#waitplease").css({ 'display': 'none' });
			        $("#btnUpdate").removeAttr("disabled");
			    }, 500);
			},
			function (ex) {
			    return false;
			});
        }
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
    AutocompleteItemSearch_Model: function () {
        $("#txtItemModel").autocomplete({
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
AutocompleteItemSearch_MaintTask: function () {
    var pid = getArgs();
    if (pid.iid) {
        $("#txtMaintTask").autocomplete({
            source: function(request, response) {
                AssetManagement.GetItem_MaintTaskList(pid.iid, request.term,
                    function(data) {
                        if (data) {
                            response($.map(data, function(item) {
                                return {
                                    value: item.ItemMaint_Name
                                };
                            }));
                        };
                    },
                    function(e) {
                    },
                    null);
            },
            minLength: 1
        });
    }
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
					function (e) {
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
					function (e) {
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
					function (e) {
					},
					null);
            }, minLength: 1
        });
    },
    PopulateItemTypesCombo: function (catID, itemTypeID) {
        $("#ddlItemType>option").remove();
        $("#ddlItemType").addClass("ui-autocomplete-ddl-loading");
        AssetManagement.ItemType_Select(catID,
		function (result) {
		    $(result).each(function () {
		        $("#ddlItemType").append($("<option></option>").val(this['ItemType_ID']).html(this['ItemType_Name']));
		    });
		    if (itemTypeID != undefined) $("#ddlItemType").val(itemTypeID);
		    $("#ddlItemType").removeClass("ui-autocomplete-ddl-loading");
		},
	function (e) {
	    return false;
	});
    },
    PopulateMaintTypesCombo: function (catID) {
        $("#ddlTaskType>option").remove();
        $("#ddlTaskTypeDetails>option").remove();
        $("#ddlTaskType,#ddlTaskTypeDetails").addClass("ui-autocomplete-ddl-loading");
        AssetManagement.MaintTypes_Select(catID,
		function (result) {
		    $(result).each(function () {
		        $("#ddlTaskType,#ddlTaskTypeDetails").append($("<option></option>").val(this['MaintType_ID']).html(this['MaintType_Name']));
		    });
		    $("#ddlTaskType,#ddlTaskTypeDetails").removeClass("ui-autocomplete-ddl-loading");
		},
		function (e) {
		    return false;
		});
    },
    PopulateFaultTypeCombo: function (catID) {
        $("#ddlFaultType>option").remove();
        $("#ddlFaultTypeDetails>option").remove();
        $("#ddlFaultType,#ddlFaultTypeDetails").addClass("ui-autocomplete-ddl-loading");
        AssetManagement.FaultTypes_SelectAll(catID,
		function (result) {
		    $(result).each(function () {
		        $("#ddlFaultType,#ddlFaultTypeDetails").append($("<option></option>").val(this['FaultType_ID']).html(this['FaultType_Name']));
		    });
		    $("#ddlFaultType,#ddlFaultTypeDetails").removeClass("ui-autocomplete-ddl-loading");
		},
		function (e) {
		    return false;
		});
    },
    RequaredFeilds: function () {
        if ($("#ddlItemCategory").val() == "0") {
            $("#ddlItemCategory").addClass('ui-state-error');
            return false;
        }
        if ($("#ddlItemType").val() == "0") {
            $("#ddlItemType").addClass('ui-state-error');
            return false;
        }
        if ($("#hidUnitID").val() == "") {
            $("#ddlUnit").addClass('ui-state-error');
            return false;
        }
        if ($("#txtItemName").val() == "") {
            $("#txtItemName").addClass('ui-state-error');
            return false;
        }
        if ($("#txtSerialNumber").val() == "") {
            $("#txtSerialNumber").addClass('ui-state-error');
            return false;
        }
        if ($("#txtCheckIn").val() == "") {
            $("#txtCheckIn").addClass('ui-state-error');
            return false;
        }
        return true;
    },
    ItemDetails_Delete: function () {
        var pid = getArgs();
        if (pid.iid) {
            $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
                open: function (type, data) {
                    $(this).parent().appendTo("form");
                },
                buttons: {
                    Ok: function (e) {
                        e.preventDefault();
                        $("#waitplease").css({ 'display': 'block' });
                        try {

                            AssetManagement.ItemDetails_Delete(pid.iid,
							function (result) {
							    if (result) {
							        $("#waitplease").css({ 'display': 'none' });
							        $('#ConfirmDeleteAttachment').dialog('destroy');
							        window.location = "/opeReady/Presentation/AssetMng/ItemsSearch.aspx";
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
    ItemDetails_PlannedMaint_Open: function () {
        $("#divMaintPlanning").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, width: 600,
            title: $('#hidMaintPlanning_HeaderTitle').text(),
            open: function (type, data) {
                $(this).parent().appendTo("form");
            },

            buttons: {
                Close: function (e) {
                    e.preventDefault();
                    $(this).dialog('destroy');
                    return false;
                }
            }
        });
    },
    ItemDetails_PlannedMaint: function (planMaintData) {
        var langDir;
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
                langDir = "rtl";
            else
                langDir = "ltr";
        }
        $('#divMaintPlanning').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        $("#tblMaintPlanning").jqGrid({
            direction: langDir,
            datatype: function (pdata) { itemDetail.ReceivedPlannedMaintData(planMaintData); },
            height: 200,
            autowidth: false,
            colNames: [
				$('#hidMaintPlanning_Grid_MaintType').text(),
				$('#hidMaintPlanning_Grid_NextTask').text(),
				$('#hidMaintPlanning_Grid_LastTask').text()
				],
            colModel: [
				{ name: 'MaintType_Name', index: 'MaintType_Name', sortable: true, width: 200 },
				{ name: 'MaintItem_FutureMaintStr', index: 'MaintItem_FutureMaintStr', sortable: true, width: 150, align: 'center' },
				{ name: 'MaintItem_LastMaintStr', index: 'MaintItem_LastMaintStr', sortable: true, width: 150, align: 'center' }
			],
            datefmt: 'd/m/Y',
            viewrecords: true,
            sortorder: "desc",
            autoencode: false,
            loadonce: false,
            recordpos: 'left',
            altRows: true,
            hoverrows: false,
            pager: '#pgrMaintPlanning',
            pgbuttons: false,
            pginput: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (rowCount == $(this).getGridParam('records')) {
                    $("#waitplease").css({ 'display': 'none' });
                    $('#divMaintPlanning').unblock();
                }
            }
        });
    },
    ReceivedPlannedMaintData: function (data) {
        var thegrid = $("#tblMaintPlanning");
        thegrid.clearGridData();
        rowCount = data.length;
        if (!rowCountmaintTask) $('#divMaintPlanning').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    }
};


$("#loader").live("click", function () {
    var pid = getArgs();
    if (pid.iid) {
        itemDetail.ChoosePhoto();
    }
    return false;
});
$("#lblMaintAlertDesc").live("click", function () {
    $("#waitplease").css({ 'display': 'block' });
    var pid = getArgs();
    if (pid.iid) {
        setTimeout(function () { $("#waitplease").css({ 'display': 'none' }); }, 500);
        itemDetail.ItemDetails_PlannedMaint_Open();
    }
    return false;
});
$("#btnUpdate").live("click", function () {
    itemDetail.ItemDetails_Save();
});

$("#ddlUnit").live("click", function () {
    if ($('#treeUnits').is(':visible')) {
        $('#treeUnits').fadeOut('slide');
    }
    else {
        $('#treeUnits').fadeIn('slide');
        itemDetail.CreateUnitTree();
    }
    return false;
});
$("#btnDeleteItem").live("click", function () {
    itemDetail.ItemDetails_Delete();
});

