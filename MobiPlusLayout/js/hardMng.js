﻿/// <reference path="_references.js" />
/// <reference path="Main.js" />
var isUpdate = false;
var hard = {
    rowCount: 0,

    Init: function () {
        this.CreateGrid(null);
    },
    CreateGrid: function (data) {
        let langDir = "ltr";

        let lang = $("#hidLanguage").val();
        if (lang != "" && lang != undefined) {
            if (lang.toLowerCase() == "he")
                langDir = "rtl";
        }
        let recordpos = (langDir == 'rtl' ? 'right' : 'left');
        $('#tabsDriverDevices').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var driverGrid = $("#grdHardMng").jqGrid({
            direction: langDir,
            datatype: function (pdata) { hard.GetDevice4DriverData(pdata, data); },
            autowidth: true,
            width: '100%',
            height: 450,
            colNames: [
                        $('#hidDriverID_Grid_Header').val(),
                        $('#hidDriverName_Grid_Header').val(),
                        $('#hidDeviceID_Grid_Header').val(),
                        $('#hidDeviceTypeName_Grid_Header').val(),
                        $('#hidComment_Grid_Header').val(),
                        $('#hidIsActive_Grid_Header').val(),
                        $('#hidEdit_Grid_Header').val(),
                        $('#hidDelete_Grid_Header').val(), ''
            ],
            colModel: [
                        { name: 'DriverID', index: 'DriverID', sortable: true, sorttype: 'int', align: recordpos, width: 100 },
                        { name: 'DriverName', index: 'DriverName', sortable: true, sorttype: 'text', align: recordpos, width: 250 },
                        { name: 'DeviceID', index: 'DeviceID', sortable: true, sorttype: 'text', align: recordpos, width: 250 },
                        { name: 'DeviceTypeName', index: 'DeviceTypeName', sorttype: 'text', sortable: true, align: recordpos, width: 200 },
                        { name: 'Comments', index: 'Comments', sortable: true, sorttype: 'text', align: recordpos, width: 400 },
                        { name: 'IsActive', index: 'IsActive', sortable: true, sorttype: 'int', formatter: checkboxPic, align: 'center', width: 80, search: false },
                        { name: 'Edit', index: 'Edit', sortable: false, edittype: 'image', formatter: editFormatter, width: 35, align: 'center', search: false },
                        { name: 'Del', index: 'Del', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center', search: false },
                        { name: 'ID', hidden: 'true' }
            ],
            viewrecords: true,
            sortorder: "asc",
            autoencode: false,
            loadonce: false,
            pginput: false,
            altRows: true,
            resizable: false,
            shrinkToFit: true,
            rowNum: 2000,
            ignoreCase: true,
            hoverrows: true,
            recordpos: (langDir == 'rtl' ? 'left' : 'right'),
            pager: '#grdHardMngPager',
            pgbuttons: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (hard.rowCount == $(this).getGridParam('records')) {
                    $('#tabsDriverDevices').unblock();
                }
            },
            onCellSelect: function (rowid, iCol, cellcontent, e) {
                switch (iCol) {
                    case 6:
                        isUpdate = false;
                        hard.DefineDevice4DriverData($(this).getRowData(rowid));
                        break;
                    case 7:
                        hard.DeleteDevice4Driver($(this).getRowData(rowid));
                        break;
                }
                return false;
            },
            ondblClickRow: function (rowid, iRow, iCol, e) {
                isUpdate = false;
                hard.DefineDevice4DriverData($(this).getRowData(rowid));
            }
        });
        $("#grdHardMng").navGrid("#grdHardMngPager", { edit: false, add: false, del: false, search: false, refresh: true })
            .navButtonAdd("#grdHardMngPager", {
                caption: $("#hidAddbuttonCaption").val(),
                buttonicon: "ui-icon-plus",
                cursor: 'pointer',
                onClickButton: function () {
                    hard.Devices4DriverDataNew();
                },
                position: "first"
            }).navButtonAdd("#grdHardMngPager", {
                caption: $("#hidSearchButtonCaption").val(),
                buttonicon: "ui-icon-search",
                cursor: 'pointer',
                onClickButton: function () {
                    driverGrid[0].toggleToolbar();
                },
                position: "first"
            });
        $("#grdHardMng").jqGrid('filterToolbar', { stringResult: true, searchOnEnter: true, defaultSearch: 'cn' });
        driverGrid[0].toggleToolbar();
    },
    GetDevice4DriverData: function (pdata, records) {
        if (records) {
            hard.ReceivedDevice4DriverData(JSON.parse(records).rows)
        }
        else {
            let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];
            let did = $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"];
            HardwareWebService.Device4Driver_Select(cid, did, null, null,
                function (data, textStatus) {
                    hard.ReceivedDevice4DriverData(JSON.parse(data).rows);
                }, function (data, textStatus) {
                    console.log(data.message);
                    return false;
                });
        }
        return false;
    },
    ReceivedDevice4DriverData: function (data) {
        var thegrid = $("#grdHardMng");
        thegrid.clearGridData();
        hard.rowCount = data.length;
        if (!hard.rowCount) $('#tabsDriverDevices').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },
    DefineDevice4DriverData: function (objID) {
        if (objID) {
            let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];
            let did = $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"];
            HardwareWebService.Device4Driver_Select(cid, did, objID.DriverID, objID.DeviceID,
            function (result) {
                let data = JSON.parse(result).rows[0];
                if (data) {
                    $("#hidDevices4Driver_ID").val(data.ID);
                    $("#ddlDriversList").val(data.DriverID).prop("disabled", true).trigger("change");
                    $("#ddlDeviceID").val(data.DeviceID).prop("disabled", true).trigger("change");
                    $("#chkIsActive").prop("checked", data.IsActive);
                    $("#txtCommentsD4D").val(data.Comments);
                }
                hard.Device4DriverDataOpen();
            },
            function (ex) {
                console.log(ex.message);
                return false;
            });
        }
        return false;
    },
    Device4DriverDataOpen: function () {
        $("#divAddDevices4Driver")
            .addClass("dialog")
            .dialog({
                autoOpen: true, bgiframe: false, resizable: false, closeOnEscape: true, height: 500, width: 450, modal: true,
                position: ["center", 100],
                title: $("#hidTitleAddD4D").val(),
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

                },
                buttons: [{
                    text: $("#hidSaveButtonCaption").val(),
                    click: function () {
                        if (hard.CheckInputValues()) {
                            hard.CheckDeviceOwner($("#ddlDeviceID").val());
                        }
                    }
                }, {
                    text: $("#hidCancelButtonCaption").val(),
                    click: function () {
                        $(this).dialog("close");

                    }
                }]
            });

        return false;
    },
    Devices4DriverDataNew: function () {
        $("#ddlDriversList").val("0").prop("disabled", false).trigger("change");
        $("#chkIsActive").prop("checked", true);
        $("#ddlDeviceID").val("0").prop("disabled", false).trigger("change");
        $("#txtCommentsD4D").val("");
        $("#hidDevices4Driver_ID").val("");
        hard.Device4DriverDataOpen();
        isUpdate = true;
    },
    SaveDevices4Drivers: function () {
        var params = {
            ID: $("#hidDevices4Driver_ID").val(),
            DriverID: $("#ddlDriversList").val(),
            DeviceTypeID: $("#ddlDeviceType").val(),
            DeviceID: $("#ddlDeviceID").val(),
            IsActive: $("#chkIsActive").prop('checked'),
            Comments: $("#txtCommentsD4D").val(),
            CountryID: $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"],
            DistrID: $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"]
        };
        HardwareWebService.SaveDevices4Drivers(params,
            function (result) {
                $.jgrid.gridUnload("#grdHardMng");
                hard.CreateGrid(result);
                setTimeout(function () { $("#divAddDevices4Driver ").dialog("close"); }, 250);
            },
            function (ex) {

            });
        return false;
    },
    DeleteDevice4Driver: function (rowID) {
        if (rowID) {
            $("<div></div>").dialog({
                autoOpen: true,
                modal: true,
                resizable: false,
                closeOnEscape: true,
                height: 230,
                width: 400,
                title: 'מחיקה',
                open: function (type, data) {
                    $(this).parent().appendTo("form");
                    $(this).html('<p><span class="ui-icon ui-icon-alert" style="float:right; margin:2px 12px 20px 10px;"></span>' + $("#hidConfirmMsg").val() + '</p>');
                },
                buttons: {
                    Ok: function (e) {
                        e.preventDefault();
                        $("#waitplease").css({ 'display': 'block' });
                        try {
                            var params = {
                                ID: rowID.ID,
                                DriverID: rowID.DriverID,
                                DeviceTypeID: rowID.DeviceTypeID,
                                DeviceID: rowID.DeviceID,
                                CountryID: $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"],
                                DistrID: $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"]
                            };
                            HardwareWebService.DeleteDevice4Driver(params,
                               function (result) {
                                   $.jgrid.gridUnload("#grdHardMng")
                                   hard.CreateGrid(result);
                               },
                               function (ex) {
                                   console.log(ex.message);
                               });
                        } catch (e) {
                            return false;
                        }
                        $(this).dialog('destroy');
                        return false;
                    },
                    Cancel: function (e) {
                        e.preventDefault();
                        $(this).dialog('destroy');
                        return false;
                    }
                }
            });
            return false;
        }

    },
    CheckInputValues: function () {
        var result = new Boolean(true);
        if ($("#ddlDriversList").val() == "0") {
            $("#ddlDriversList").addClass('ui-state-error');
            return false;
        }
        else {
            $("#ddlDriversList").removeClass('ui-state-error', 500);
            result = true;
        }

        if ($("#ddlDeviceID").val() == "0") {
            $("#ddlDeviceID").addClass('ui-state-error').focus();
            return false;
        }
        else {
            $("#ddlDeviceID").removeClass('ui-state-error', 500);
            result = true;
        }
        return result;
    },
    AutocompleteDevicesSearch: function () {
        $("#txtDeviceID").autocomplete({
            source: function (request, response) {
                HardwareWebService.Devices_SelectList(request.term,
				  function (data) {
				      if (data) {
				          response($.map(data, function (item) {
				              return {
				                  value: item.DeviceID
				              };
				          }));
				      };
				  },
					function (e) {
					    console.log(e.message);
					},
					null);
            }, minLength: 2
        });
    },
    CheckDeviceOwner: function (deviceID) {
        HardwareWebService.CheckDeviceOwner(deviceID,
            function (result) {
                let check = false;
                if (result) {
                    if (result.DriverID === $("#ddlDriversList").val() && result.DeviceID === $("#ddlDeviceID").val())
                        check = true;
                } else { check = true; }
                if (check) {
                    hard.SaveDevices4Drivers();
                }
                else {
                    let message = $("#hidChangeMesageConfirm").val();
                    message = message.replace('{0}', result.DriverName + ', ' + result.DriverID);

                    $("<div></div>").dialog({
                        autoOpen: true,
                        modal: true,
                        resizable: false,
                        closeOnEscape: true,
                        height: 250,
                        width: 400,
                        title: 'אזהרה',
                        open: function (type, data) {
                            $(this).parent().appendTo("form");
                            $(this).html('<p><span class="ui-icon ui-icon-alert" style="float:right; margin:2px 12px 20px 10px;"></span>' + message + '</p>');
                        },

                        buttons: [{
                            text: $("#hidChangeOwnerButtonCaption").val(),
                            id: "btnChangeOwnerDevice",
                            click: function (e) {
                                e.preventDefault();
                                try {
                                    HardwareWebService.ChangeDeviceOwner(deviceID, $("#ddlDriversList").val(),
                                       function (result) {
                                           if (hard.CheckInputValues()) {
                                               hard.SaveDevices4Drivers();
                                           }
                                       },
                                       function (ex) {
                                           console.log(ex.message);
                                       });
                                } catch (e) {
                                    return false;
                                }
                                $(this).dialog('destroy');
                                return true;
                            }
                        }, {
                            text: $("#hidCancelButtonCaption").val(),
                            id: "btnCancel",
                            click: function (e) {
                                e.preventDefault();
                                $(this).dialog('destroy');
                            }
                        }]
                    });
                }
                return true;
            },
            function (ex) {
                console.log(ex.message);
            });
    },
    PopulationAgentDropdown: function () {
        let cid = $.QueryString["CountryID"] == undefined ? hard.GetCountryIDByLang() : $.QueryString["CountryID"];
        let did = $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"];
        $("#ddlDriversList>option").remove();

        HardwareWebService.GetAgents_SelectAll(cid, did,
            function (result) {
                $(result).each(function () {
                    $("#ddlDriversList").append($("<option></option>").val(this['AgentID']).html(this['AgentName']));
                });
                $("#ddlDriversList").trigger('change');
            },
        function (e) {
            return false;
        });
    },
    PopulationDevicesDropdown: function () {
        $("#ddlDeviceID>option").remove();
        let cid = $.QueryString["CountryID"] == undefined ? hard.GetCountryIDByLang() : $.QueryString["CountryID"];
        HardwareWebService.Devices_SelectAll(null, parseInt(cid),
            function (response) {
                let result =  JSON.parse(response).rows;
                $(result).each(function () {
                    $("#ddlDeviceID").append($("<option></option>").val(this['DeviceID']).html(this['DeviceID']));
                });
                $("#ddlDeviceID").trigger('change');
            },
        function (e) {
            return false;
        });
    },
    GetCountryIDByLang: function () {
        let lang = $("#hidLanguage").val();
        switch (lang.toLowerCase()) {
            case "he":
                return 1000;
            case "en":
                return 8000;
            case "ge":
                return 5000;
        }
    }
};

var device = {
    rowCount: 0,
    Init: function () {
        this.CreateDeviceGrid(null);
    },
    CreateDeviceGrid: function (data) {
        let langDir = "ltr";
        let lang = $("#hidLanguage").val();
        if (lang != "" && lang != undefined) {
            if (lang.toLowerCase() == "he")
                langDir = "rtl";
        }

        let recordpos = (langDir == 'rtl' ? 'right' : 'left');
        $('#divDevicesList').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var devicesGrid = $("#grdDevicesList").jqGrid({
            direction: langDir,
            datatype: function (pdata) { device.GetDeviceData(pdata, data); },
            autowidth: true,
            width: '100%',
            height: 450,
            colNames: [
                        'ID',
                        $('#hidDeviceID_Grid_Header').val(),
                        $('#hidDeviceTypeName_Grid_Header').val(),
                        $('#hidStatus_Grid_Header').val(),
                        $('#hidComment_Grid_Header').val(),
                        $('#hidEdit_Grid_Header').val(),
                        $('#hidDelete_Grid_Header').val(),
                        'DeviceTypeID', '', 'CountryID'
            ],
            colModel: [
                        { name: 'ID', index: 'ID', sortable: true, key: true, align: recordpos, width: 80 },
                        { name: 'DeviceID', index: 'DeviceID', sortable: true, align: recordpos, width: 350 },
                        { name: 'DeviceTypeName', index: 'DeviceTypeName', sortable: true, align: recordpos, width: 300 },
                        { name: 'StatusName', index: 'StatusName', sortable: true, width: 200, align: 'center', search: false },
                        { name: 'Comment', index: 'Comment', sortable: true, align: recordpos, width: 400 },
                        { name: 'Edit', index: 'Edit', sortable: false, edittype: 'image', formatter: editFormatter, width: 35, align: 'center', search: false },
                        { name: 'Del', index: 'Del', sortable: false, edittype: 'image', formatter: deleteSpecFormatter, width: 45, align: 'center', search: false },
                        { name: 'DeviceTypeID', hidden: 'true' },
                        { name: 'isBusy', hidden: 'true' },
                        { name: 'CountryID', hidden: 'true' }
            ],
            viewrecords: true,
            sortorder: "asc",
            autoencode: false,
            loadonce: false,
            pginput: false,
            altRows: true,
            resizable: false,
            shrinkToFit: true,
            rowNum: 2000,
            ignoreCase: true,
            hoverrows: true,
            recordpos: (langDir == 'rtl' ? 'left' : 'right'),
            pager: '#grdDevicesListPager',
            pgbuttons: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (device.rowCount == $(this).getGridParam('records')) {
                    $('#divDevicesList').unblock();
                }
            },
            onCellSelect: function (rowid, iCol, cellcontent, e) {
                switch (iCol) {
                    case 5:
                        device.DefineDeviceData($(this).getRowData(rowid));
                        break;
                    case 6:
                        if ($(this).getRowData(rowid).isBusy == "false")
                            device.DeleteDevice($(this).getRowData(rowid));
                        break;
                }
                return false;
            },
            ondblClickRow: function (rowid) {
                device.DefineDeviceData($(this).getRowData(rowid));
            }
        });

        $("#grdDevicesList").navGrid("#grdDevicesListPager", { edit: false, add: false, del: false, search: false, refresh: true })
            .navButtonAdd("#grdDevicesListPager", {
                caption: $("#hidAddbuttonCaption").val(),
                buttonicon: "ui-icon-plus",
                cursor: 'pointer',
                onClickButton: function () {
                    device.DefineDeviceDataNew();
                },
                position: "first"
            }).navButtonAdd("#grdDevicesListPager", {
                caption: $("#hidSearchButtonCaption").val(),
                buttonicon: "ui-icon-search",
                cursor: 'pointer',
                onClickButton: function () {
                    devicesGrid[0].toggleToolbar();
                },
                position: "first"
            });
        $("#grdDevicesList").jqGrid('filterToolbar', { stringResult: true, searchOnEnter: true, defaultSearch: 'cn' });
        devicesGrid[0].toggleToolbar();
    },
    GetDeviceData: function (p, d) {
        let cid = $.QueryString["CountryID"] == undefined ? hard.GetCountryIDByLang() : $.QueryString["CountryID"];
        if (d) {
            device.PopulateDeviceGrid(JSON.parse(d).rows);
        } else {        
            HardwareWebService.Devices_SelectAll(null, parseInt(cid),
              function (data, textStatus) {
                  device.PopulateDeviceGrid(JSON.parse(data).rows);
              }, function (data, textStatus) {
                  return false;
              });
        }
        return false;
    },
    PopulateDeviceGrid: function (data) {
        var thegrid = $("#grdDevicesList");
        thegrid.clearGridData();
        device.rowCount = data.length;
        if (!device.rowCount) $('#divDevicesList').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);

    },
    DefineDeviceData: function (objID) {
        if (objID) {
            HardwareWebService.DeviceInfo_Select(objID.ID,
            function (data) {
                if (data) {
                    $("#hidDeviceID").val(data.ID);
                    $("#ddlDeviceType").val(data.DeviceTypeID);
                    $("#ddlStatus").val(data.Status);
                    $("#txtDeviceDeviceID").val(data.DeviceID);
                    $("#txtComment").val(data.Comment);
                    $("#ddlCountry").val(data.CountryID);
                }
                device.DevicesWindowOpen();
            },
            function (ex) {
                return false;
            });
        }

    },
    DevicesWindowOpen: function () {
        $("#divSelectDevices")
            .addClass("dialog")
            .dialog({
                autoOpen: true, bgiframe: false, resizable: false, closeOnEscape: true, height: 480, width: 500, modal: true,
                title: $("#hidTitleAddDevice").val(),
                position: ["center", 100],
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

                },
                buttons: [{
                    text: $("#hidSaveButtonCaption").val(),
                    id: "btnSaveDevice",
                    click: function () {
                        if (device.CheckInputValues()) {
                            device.SaveDevices();
                        }
                    }
                },
                {
                    text: $("#hidCancelButtonCaption").val(),
                    id: "btnCancel",
                    click: function () {
                        $(this).dialog("close");
                    }
                }]
            });

        return false;
    },
    SaveDevices: function () {
        var dev = {
            ID: $("#hidDeviceID").val(),
            DeviceID: $("#txtDeviceDeviceID").val(),
            DeviceTypeID: $("#ddlDeviceType").val(),
            Status: $("#ddlStatus").val(),
            Comment: $("#txtComment").val(),
            CountryID: $("#ddlCountry").val()
        }
        HardwareWebService.Devices_CheckExisting(dev,
            function (result) {
                if (result) {
                    $("<div></div>").dialog({
                        autoOpen: true,
                        modal: true,
                        resizable: false,
                        closeOnEscape: true,
                        height: 210,
                        width: 300,
                        title: $("#hidTitleWarningCaption").val(),
                        open: function (type, data) {
                            $(this).parent().appendTo("form");
                            $(this).html('<p><span class="ui-icon ui-icon-alert" style="float:right; margin:2px 12px 20px 10px;"></span>' + $("#hidExistingDeviceNumber").val() + '</p>');
                        },
                        buttons: [{
                            text: $("#hidCancelButtonCaption").val(),
                            click: function (e) {
                                e.preventDefault();
                                $(this).dialog('destroy');
                                return false;
                            }
                        }]
                    });
                } else {
                    HardwareWebService.Devices_Save(dev,
                      function (data, textStatus) {
                          $.jgrid.gridUnload("#grdDevicesList");
                          device.CreateDeviceGrid(null);
                          setTimeout(function () { $("#divSelectDevices ").dialog("close"); }, 500);
                      }, function (data, textStatus) {
                          return false;
                      });
                }

            })

    },
    DeleteDevice: function (rowID) {
        if (rowID) {
            $("<div></div>").dialog({
                autoOpen: true,
                modal: true,
                resizable: false,
                closeOnEscape: true,
                height: 230,
                width: 400,
                title: 'מחיקה',
                open: function (type, data) {
                    $(this).parent().appendTo("form");
                    $(this).html('<p><span class="ui-icon ui-icon-alert" style="float:right; margin:2px 12px 20px 10px;"></span>' + $("#hidConfirmMsg").val() + '</p>');
                },
                buttons: {
                    Ok: function (e) {
                        e.preventDefault();
                        $("#waitplease").css({ 'display': 'block' });
                        try {
                            HardwareWebService.DeleteDevice(rowID.ID, rowID.CountryID,
                               function (result) {
                                   $.jgrid.gridUnload("#grdDevicesList");
                                   device.rowCount = 0;
                                   device.CreateDeviceGrid(null);
                               },
                               function (ex) {
				   console.log(ex.message);
                               });
                        } catch (e) {
			    console.log(e.message);
                            return false;
                        }
                        $(this).dialog('destroy');
                        return false;
                    },
                    Cancel: function (e) {
                        e.preventDefault();
                        $(this).dialog('destroy');
                        return false;
                    }
                }
            });
            return false;
        }


    },
    DefineDeviceDataNew: function () {
        $("#ddlDeviceType").val("0");
        $("#ddlStatus").val("1");
        $("#txtDeviceDeviceID").val("");
        $("#txtComment").val("");
        $("#hidDeviceID").val("");
        $("#ddlCountry").val("0");
        device.DevicesWindowOpen();
        $("#btnSaveDevice").val($("#hidSaveButtonCaption").val());

    },
    CheckInputValues: function () {
        var result = new Boolean(true);
        if ($("#ddlDeviceType").val() == "0") {
            $("#ddlDeviceType").addClass('ui-state-error');
            return false;
        }
        else {
            $("#ddlDeviceType").removeClass('ui-state-error', 500);
            result = true;
        }   
        if ($("#ddlStatus").val() == "0") {
            $("#ddlStatus").addClass('ui-state-error').focus();
            return false;
        }
        else {
            $("#ddlStatus").removeClass('ui-state-error', 500);
            result = true;
        }
        if ($("#ddlCountry").val() == "0") {
            $("#ddlCountry").addClass('ui-state-error').focus();
            return false;
        }
        else {
            $("#ddlCountry").removeClass('ui-state-error', 500);
            result = true;
        }

        if ($("#txtDeviceDeviceID").val() == "") {
            $("#txtDeviceDeviceID").addClass('ui-state-error').focus();
            return false;
        }
        else {
            $("#txtDeviceDeviceID").removeClass('ui-state-error', 500);
            result = true;
        }
        return result;
    }
}

$(function () {
    window.parent.CloseLoading();
    let lang = $("#hidLanguage").val().toLowerCase() == "he" ? "rtl" : "ltr";
    $("#tabsHardMgn").tabs({
        activate: function (event, ui) {
            switch (ui.newPanel.prop("id")) {
                case "tabsDriverDevices":
                    hard.PopulationDevicesDropdown();
                    break;
                case "tabsDevices":
                    $.jgrid.gridUnload("#grdDevicesList");
                    device.Init();
                    break;
            }
        }
    });
    $("#ddlDeviceID, #ddlDriversList").select2({ dir: lang });
    hard.Init();
    device.Init();
});




$(function () {
    $("#ddlDriversList").change(function () {
        if ($(this).val() != "0")
            $(this).removeClass('ui-state-error', 500);
    });
    $("#ddlDriversList").change(function () {
        if ($(this).val() != "0")
            $(this).removeClass('ui-state-error', 500);
    });
    $("#ddlDeviceID").change(function () {
        if ($(this).val() != "0")
            $(this).removeClass('ui-state-error', 500);
    });

    $("#ddlDeviceType").change(function () {
        if ($(this).val() != "0")
            $(this).removeClass('ui-state-error', 500);
    });
    $("#ddlStatus").change(function () {
        if ($(this).val() != "0")
            $(this).removeClass('ui-state-error', 500);
    });
    $("#txtDeviceDeviceID").change(function () {
        if ($(this).val() != "")
            $(this).removeClass('ui-state-error', 500);
    });
});


Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (args) {
    window.parent.CloseLoading();
});
Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(function () {
    window.parent.ShowLoading();
});