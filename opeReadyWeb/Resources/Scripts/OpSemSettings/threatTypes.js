/// <reference path="../Common/jquery-1.6.4.min.js" />
/// <reference path="../Common/jquery-ui-1.8.12.custom.min.js" />
/// <reference path="../Common/jquery.color.utils-0.1.0.js" />
/// <reference path="../Common/jquery.common.js" />



var threatType = {
    rowCount: 0,
    CreateThreatTypeGrid: function (threatTypeData) {
        var _langDir;
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
                _langDir = "rtl";
            else
                _langDir = "ltr";
        }
        $('#divThreatTypes').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var tblThreatTypes = $("#tblThreatTypes").jqGrid({
            direction: _langDir,
            datatype: function (pdata) { threatType.getThreatTypeData(threatTypeData); },
            height: 375,
            colNames: [
                    $('#hidTT_Grid_ThreatType_Name').text(),
                    $('#hidTT_Grid_ThreatCategoriesDesc').text(),
                    $('#hidTT_Grid_Color').text(),
                    $('#hidTT_Grid_IsDisplayed').text(),
                    '', '', 'ThreatType_ID'],
            colModel: [
       		        { name: 'ThreatType_Name', index: 'ThreatType_Name', sortable: true, sorttype: 'text', width: 220 },
               		{ name: 'ThreatCategoriesDesc', index: 'ThreatCategoriesDesc', sortable: true, sorttype: 'text', width: 200 },
                    { name: 'Color', index: 'Color', sortable: true, sorttype: 'int', align: 'center', width: 100 },
                    { name: 'IsDisplayed', index: 'IsDisplayed', sortable: false, formatter: checkboxPic, align: 'center', width: 100 },
                    { name: 'Edit', index: 'Edit', sortable: false, edittype: 'image', formatter: editFormatter, width: 35, align: 'center' },
                    { name: 'Delete', index: 'Delete', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                    { name: 'ThreatType_ID', hidden: 'true' }
               	],
            viewrecords: true,
            sortorder: "asc",
            autoencode: false,
            pginput: true,
            altRows: true,
            hoverrows: false,
            toolbar: [true, "top"],
            recordpos: (_langDir == 'rtl' ? 'left' : 'right'),
            pager: '#pgrThreatTypes',
            pgbuttons: false,
            pginput: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (threatType.rowCount == $(this).getGridParam('records')) {
                    $("#waitplease").css({ 'display': 'none' });
                    $('#divThreatTypes').unblock();
                }
            },
            onCellSelect: function (rowid, iCol, cellcontent, e) {
                switch (iCol) {
                    case 4:
                        threatType.DefineThreatType_Open($(this).getRowData(rowid));
                        break;
                    case 5:
                        return threatType.DefinThreatType_Delete($(this).getRowData(rowid));
                        break;
                }
                return false;
            },
            ondblClickRow: function (rowid, iRow, iCol, e) {
                threatType.DefineThreatType_Open($(this).getRowData(rowid));
            }
        })
        .jqGrid('gridResize', { minWidth: 750, minHeight: 300 })
        .toolbarButtonAdd("#t_tblThreatTypes",
            {
                caption: $('#hidTT_btnAddThreatType').text(),
                position: "first",
                align: (_langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-circle-plus',
                onClickButton: function () {
                    threatType.DefineThreatType_New();
                }
            })
         .toolbarButtonAdd("#t_tblThreatTypes",
            {
                caption: "Excel",
                position: "last",
                align: (_langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                    if (threatType.rowCount == 0) return false;
                    tblThreatTypes.jqGrid('excelExport', { url: '/opeReady/Handlers/ExcelExport/ThreatTypeExcel.ashx' });
                }
            });
    },
    getThreatTypeData: function (threatTypeData) {
        if (threatTypeData) {
            threatType.ReceivedThreatTypeData(JSON.parse(getMain(threatTypeData)).rows);
        }
        else {
            OpSemsService.ThreatType_SelectALL(null,
            function (data, textStatus) {
                threatType.ReceivedThreatTypeData(JSON.parse(getMain(data)).rows);
            }, function (data, textStatus) {
                $('#divThreatTypes').unblock();
                return false;
            }, null);
        }
    },
    ReceivedThreatTypeData: function (data) {
        var thegrid = $("#tblThreatTypes");
        thegrid.clearGridData();
        this.rowCount = data.length;
        if (!this.rowCount) $('#divThreatTypes').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },
    DefineThreatType_Open: function (rowData) {
        if (rowData) {
            $("#btnAddThreat").val($("#hidTT_btnThreatTypeUpdate").text());
            OpSemsService.ThreatType_Select(rowData.ThreatType_ID,
            function (data) {
                if (data) {
                    $("#ddlThreatCategory").val(data.ThreatCategories.ThreatCategory_ID);
                    $("#txtThreatTypesName").val(data.ThreatType_Name);
                    $("#txtThreatTypeDescription").val(data.Description);
                    $("#txtColor").val(data.Color.replace(" ", "")).css({ "background": "#" + colourNameToHex(data.Color.replace(" ", "")), "color": "#" + hexInvert(colourNameToHex((data.Color.replace(" ", "")).toLowerCase())) }).trigger("change");
                    $("#chkIsDisplay").attr("checked", data.IsDisplayed);
                    $("#chkIsPermited").attr("checked", data.IsPermited == true ? true : false);
                    $("#txtRandomTest").val(data.RandomTest);
                    $("#hidThreatType_ID").val(data.ThreatType_ID);
                }
                threatType.divThreatTypeDetails_Open();
            },
        function (ex) {
            return false;
        });
        }
    },
    divThreatTypeDetails_Open: function () {
        $("#divThreatTypesDetails").dialog({ autoOpen: true, bgiframe: true, resizable: false, closeOnEscape: true, width: '600px', modal: true, zIndex: 50,
            title: $('#hidTT_HeaderDefine').text(),
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
    DefineThreatType_New: function () {
        $("#btnAddThreat").val($("#hidTT_btnAddThreat").text());
        $("input:text").val("");
        $("#ddlThreatCategory").val("0");
        $("#hidThreatType_ID").val("");
        threatType.divThreatTypeDetails_Open();
    },
    DefineThreatType_Save: function () {
        if (threatType.RequaredThreatTypeFields()) {
            $("#waitplease").css({ 'display': 'block' });
            var _station = {
                ThreatCategories: { ThreatCategory_ID: $("#ddlThreatCategory").val() },
                ThreatType_Name: $("#txtThreatTypesName").val(),
                Description: $("#txtThreatTypeDescription").val(),
                Color: $("#txtColor").val(),
                ThreatType_ID: $("#hidThreatType_ID").val() == "" ? 0 : parseInt($("#hidThreatType_ID").val()),
                IsDisplayed: $("#chkIsDisplay").attr("checked"),
                IsPermited: $("#chkIsPermited").attr("checked"),
                RandomTest: $("#txtRandomTest").val() == "" ? null : parseInt($("#txtRandomTest").val())
            };
            OpSemsService.ThreatType_Save(_station,
              function (data) {
                  if (data) {
                      $("#tblThreatTypes").GridUnload();
                      threatType.CreateThreatTypeGrid(data);
                      $("#waitplease").css({ 'display': 'none' });
                      $("#divThreatTypesDetails").dialog("destroy");
                      $("#hidThreatType_ID").val("");
                  }
              },
          function (ex) {
              $("#waitplease").css({ 'display': 'none' });
              return false;
          });
        }
    },
    DefinThreatType_Delete: function (rowData) {
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
                            OpSemsService.ThreatType_Delete(rowData.ThreatType_ID,
                        function (result) {
                            if (result) {
                                $("#tblThreatTypes").GridUnload();
                                threatType.CreateThreatTypeGrid(result);
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
    RequaredThreatTypeFields: function () {
        var result = new Boolean(true);
        if ($("#txtThreatTypesName").val() == "") {
            $("#txtThreatTypesName").addClass('ui-state-error').effect("pulsate");
            return false;
        }
        else {
            $("#txtThreatTypesName").removeClass('ui-state-error', 200);
            result = true;
        }
        if ($("#ddlThreatCategory").val() == "0") {
            $("#ddlThreatCategory").addClass('ui-state-error').effect("pulsate");
            return false;
        }
        else {
            $("#ddlThreatCategory").removeClass('ui-state-error', 200);
            result = true;
        }
        //        if ($("#txtThreatTypeDescription").val() == "") {
        //            $("#txtThreatTypeDescription").addClass('ui-state-error').effect("pulsate");
        //            return false;
        //        }
        //        else {
        //            $("#txtThreatTypeDescription").removeClass('ui-state-error', 200);
        //            result = true;
        //        }
        if ($("#txtColor").val() == "") {
            $("#txtColor").addClass('ui-state-error').effect("pulsate");
            return false;
        }
        else {
            $("#txtColor").removeClass('ui-state-error', 200);
            result = true;
        }
        return result;
    }
};