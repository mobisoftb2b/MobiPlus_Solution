/// <reference path="../Common/jquery-1.5.2.js" />
/// <reference path="../Common/jquery.jqGrid.min.js" />
/// <reference path="../Common/jquery-ui-1.8.12.custom.min.js" />

var workStation = {
    rowCount: 0,
    CreateWorkStationGrid: function (stationData) {
        var _langDir;
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
                _langDir = "rtl";
            else
                _langDir = "ltr";
        }
        $('#divWorkStations').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        $("#tblWorkStations").jqGrid({
            direction: _langDir,
            datatype: function (pdata) { workStation.getWorkStationData(stationData); },
            height: 375,
            colNames: [
                    $('#hidWS_Grid_StationDescription').text(),
                    $('#hidWS_Grid_StationType').text(),
                    $('#hidWS_Grid_StationIP').text(),
                    '', '', 'Station_ID'],
            colModel: [
       		        { name: 'Station_Description', index: 'Station_Description', sortable: true, sorttype: 'text', width: 220 },
               		{ name: 'StationType_DescStr', index: 'StationType_DescStr', sortable: true, sorttype: 'text', width: 200 },
                    { name: 'Station_IP', index: 'Station_IP', sortable: true, sorttype: 'int', align: 'center', width: 100 },
                    { name: 'EditAlert', index: 'EditAlert', sortable: false, edittype: 'image', formatter: editFormatter, width: 35, align: 'center' },
                    { name: 'DelAlert', index: 'DelAlert', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                    { name: 'Station_ID', hidden: 'true' }
               	],
            viewrecords: true,
            sortorder: "asc",
            autoencode: false,
            pginput: true,
            altRows: true,
            hoverrows: false,
            toolbar: [true, "top"],
            recordpos: (_langDir == 'rtl' ? 'left' : 'right'),
            pager: '#pgrWorkStations',
            pgbuttons: false,
            pginput: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (workStation.rowCount == $(this).getGridParam('records')) {
                    $("#waitplease").css({ 'display': 'none' });
                    $('#divWorkStations').unblock();
                }
            },
            onCellSelect: function (rowid, iCol, cellcontent, e) {
                switch (iCol) {
                    case 3:
                        workStation.DefineWorkStation_Open($(this).getRowData(rowid));
                        break;
                    case 4:
                        return workStation.DefineWorkStation_Delete($(this).getRowData(rowid));
                        break;
                }
                return false;
            },
            ondblClickRow: function (rowid, iRow, iCol, e) {
                workStation.DefineWorkStation_Open($(this).getRowData(rowid));
            }
        });
        $("#tblWorkStations")
        .jqGrid('gridResize', { minWidth: 750, minHeight: 300 })
        .toolbarButtonAdd("#t_tblWorkStations",
            {
                caption: $('#hidWS_btnAddWorkStation').text(),
                position: "first",
                align: (_langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-circle-plus',
                onClickButton: function () {
                    workStation.DefineWorkStation_New();
                }
            })
    },
    getWorkStationData: function (stationData) {
        if (stationData) {
            workStation.ReceivedWorkStationData(JSON.parse(getMain(stationData)).rows);
        }
        else {
            OpSemsService.WorkStation_SelectALL(
            function (data, textStatus) {
                workStation.ReceivedWorkStationData(JSON.parse(getMain(data)).rows);
            }, function (data, textStatus) {
                $('#divWorkStations').unblock();
                return false;
            }, null);
        }
    },
    ReceivedWorkStationData: function (data) {
        var thegrid = $("#tblWorkStations");
        thegrid.clearGridData();
        this.rowCount = data.length;
        if (!this.rowCount) $('#divWorkStations').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },
    DefineWorkStation_Open: function (rowData) {
        if (rowData) {
            $("#btnAddStation").val($("#hidWS_btnStationUpdate").text());
            OpSemsService.WorkStation_Select(rowData.Station_ID,
            function (data) {
                if (data) {
                    $("#ddlStationType").val(data.StationType.StationType_ID)
                    $("#txtStationDesc").val(data.Station_Description);
                    $("#txtStationIP").val(data.Station_IP);
                    $("#txtValidFrom").val(data.Station_ValidFromStr);
                    $("#txtValidTo").val(data.Station_ValidToStr);
                    $("#hidStation_ID").val(data.Station_ID);
                }
                workStation.divWorkStationDetails_Open();
            },
        function (ex) {
            return false;
        });
        }
    },
    divWorkStationDetails_Open: function () {
        $("#divWorkStationDetails").dialog({ autoOpen: true, bgiframe: true, resizable: false, closeOnEscape: true, width: '600px', modal: true, zIndex: 50,
            title: $('#hidWS_HeaderDefine').text(),
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
            }
        });
        return false;
    },
    DefineWorkStation_New: function () {
        $("#btnAddStation").val($("#hidWS_btnAddStation").text());
        $("input:text").val("");
        $("#ddlStationType").val(-1);
        $("#hidStation_ID").val("");
        workStation.divWorkStationDetails_Open();
    },
    DefineWorkStation_Save: function () {
        if (workStation.RequaredWorkStationFields()) {
            $("#waitplease").css({ 'display': 'block' });
            var _station = {
                StationType: { StationType_ID: $("#ddlStationType").val() },
                Station_IP: $("#txtStationIP").val(),
                Station_ValidFromStr: $("#txtValidFrom").val(),
                Station_ValidToStr: $("#txtValidTo").val(),
                Station_ID: $("#hidStation_ID").val() == "" ? -1 : parseInt($("#hidStation_ID").val()),
                Station_Description: $("#txtStationDesc").val()
            };
            OpSemsService.WorkStation_Save(_station,
              function (data) {
                  if (data) {
                      $("#tblWorkStations").GridUnload();
                      workStation.CreateWorkStationGrid();
                      $("#waitplease").css({ 'display': 'none' });
                      $("#divWorkStationDetails").dialog("destroy");
                      $("#hidStation_ID").val("");
                  }
              },
          function (ex) {
              $("#waitplease").css({ 'display': 'none' });
              return false;
          });
        }
    },
    DefineWorkStation_Delete: function (rowData) {
        if (rowData) {
            $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
                open: function (type, data) {
                    $(this).parent().appendTo("form");
                },
                buttons: {
                    Ok: function (e) {
                        e.preventDefault();
                        $("#waitplease").css({ 'display': 'block' });
                        try {
                            OpSemsService.WorkStation_Delete(rowData.Station_ID,
                        function (result) {
                            if (result) {
                                $("#tblWorkStations").GridUnload();
                                workStation.CreateWorkStationGrid(result);
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
    RequaredWorkStationFields: function () {
        var result = new Boolean(true);
        if ($("#txtStationDesc").val() == "") {
            $("#txtStationDesc").addClass('ui-state-error').effect("pulsate");
            return false;
        }
        else {
            $("#txtStationDesc").removeClass('ui-state-error', 200);
            result = true;
        }
        if ($("#ddlStationType").val() == "-1") {
            $("#ddlStationType").addClass('ui-state-error').effect("pulsate");
            return false;
        }
        else {
            $("#ddlStationType").removeClass('ui-state-error', 200);
            result = true;
        }
        if ($("#txtStationIP").val() == "") {
            $("#txtStationIP").addClass('ui-state-error').effect("pulsate");
            return false;
        }
        else {
            $("#txtStationIP").removeClass('ui-state-error', 200);
            result = true;
        }
        if ($("#txtValidFrom").val() == "") {
            $("#txtValidFrom").addClass('ui-state-error').effect("pulsate");
            return false;
        }
        else {
            $("#txtValidFrom").removeClass('ui-state-error', 200);
            result = true;
        }
        return result;
    }
};

$("#btnAddStation").live("click", function () {
    workStation.DefineWorkStation_Save();
});
$("#divWorkStationDetails").delegate("#ddlStationType", "change", function () {
    if ($(this).val() != "0")
        $(this).removeClass('ui-state-error', 200);
});
$("#divWorkStationDetails").delegate("#txtStationDesc", "change", function () {
    if ($(this).val() != "")
        $(this).removeClass('ui-state-error', 200);
});
$("#divWorkStationDetails").delegate("#txtValidFrom", "change", function () {
    if ($(this).val() != "")
        $(this).removeClass('ui-state-error', 200);
});
$("#divWorkStationDetails").delegate("#txtStationIP", "change", function () {
    if ($(this).val() != "")
        $(this).removeClass('ui-state-error', 200);
});