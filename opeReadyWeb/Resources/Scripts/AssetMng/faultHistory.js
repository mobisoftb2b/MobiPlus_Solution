/// <reference path="../Common/_references.js" />
/// <reference path="~/Resources/Scripts/Common/jquery.ajax_upload.0.6.js" />
var rowCount;
var faultHist = {
    GetItemID: function () {
        var param = getArgs();
        if (param.iid)
            return $("#hidItem_ID").val() == "" ? parseInt(param.iid) : parseInt($("#hidItem_ID").val());
        else
            return null;
    },
    Init: function () {
        faultHist.Autocomplete_ReportName();
    },
    PopulationFaultHistoryGrid: function (newData) {
        var langDir = "ltr";
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")langDir = "rtl";
          
        }
        $('#divFaultHistory').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var faultHistoryGrid = $("#tblFaultHistory").jqGrid({
            direction: langDir,
            datatype: function (pdata) { faultHist.getFaultHistoryData(pdata, newData); },
            height: 375,
            autowidth: false,
            colNames: [
                $('#hidFaultHistory_Grid_ReportDate').text(),
                $('#hidFaultHistory_Grid_FaultType_Name').text(),
                $('#hidFaultHistory_Grid_ReportBy').text(),
                $('#hidFaultHistory_Grid_RepairDate').text(),
                $('#hidFaultHistory_Grid_RepairBy').text(),
                $('#hidFaultHistoryAtach_Grid_AttachmentCount').text(),
                "", "", 'ItemFaults_ID', 'Remarks', 'FaultType_ID'],
            colModel: [
           		{ name: 'ReportDate', index: 'ReportDate', formatter: dateFormatter, sortable: true, width: 150 },
                { name: 'FaultType_Name', index: 'FaultType.FaultType_Name', sortable: true, width: 150 },
                { name: 'ReportName', index: 'ReportName', sortable: true, width: 150 },
                { name: 'FixDate', index: 'FixDate', sortable: true, width: 150, formatter: dateFormatter },
                { name: 'FixName', index: 'FixName', sortable: true, width: 150 },
                { name: 'AttachmentsCount', index: 'AttachmentsCount', sortable: false, edittype: 'image', formatter: countFormatter, width: 32, align: 'center' },
                { name: 'Edit', index: 'Edit', sortable: false, edittype: 'image', formatter: editFormatter, width: 32, align: 'center' },
                { name: 'Delete', index: 'Delete', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                { name: 'ItemFaults_ID', hidden: 'true' },
                { name: 'Remarks', hidden: 'true' },
                { name: 'FaultType_ID', hidden: 'true' }
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
            pager: '#pgrFaultHistory',
            pgbuttons: false,
            pginput: false,
            rowNum: 2000,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (rowCount == $(this).getGridParam('records')) {
                    $("#waitplease").css({ 'display': 'none' });
                    $('#divFaultHistory').unblock();
                }
            },
            onCellSelect: function (rowid, iCol) {
                switch (iCol) {
                    case 6:
                        faultHist.FaultHistory_Update($(this).getRowData(rowid));
                        break;
                    case 7:
                        return faultHist.FaultHistory_Delete($(this).getRowData(rowid));
                }
                return false;
            },
            ondblClickRow: function (rowid) {
                faultHist.FaultHistory_Update($(this).getRowData(rowid));
            }
        });
        faultHistoryGrid.jqGrid('gridResize', { minWidth: 674, minHeight: 300 });
        faultHistoryGrid
            .toolbarButtonAdd("#t_tblFaultHistory",
            {
                caption: $('#lblMaintTask_btnAddNewMaintTask').text(),
                position: "first",
                align: (langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-circle-plus',
                onClickButton: function () {
                    faultHist.FaultHistory_New();
                }
            })
            .toolbarButtonAdd("#t_tblFaultHistory",
            {
                caption: "Excel",
                position: "last",
                align: (langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                    if (rowCount == 0) return false;
                    faultHistoryGrid.jqGrid('excelExport', { url: '/opeReady/Handlers/ExcelExport/FaultHistorysExcel.ashx?iid=' + faultHist.GetItemID() });
                    return false;
                }
            });
    },

    getFaultHistoryData: function (pData, newData) {
        if (!newData) {
            AssetManagement.ItemFaults_SelectAll(faultHist.GetItemID(), $("#ddlFaultType").val(),
            function (data) {
                faultHist.ReceivedFaultHistoryData(JSON.parse(getMain(data)).rows);
            }, function () {
                return false;
            }, null);
        } else {
            faultHist.ReceivedFaultHistoryData(JSON.parse(getMain(newData)).rows);
        }
    },

    ReceivedFaultHistoryData: function (data) {
        var thegrid = $("#tblFaultHistory");
        thegrid.clearGridData();
        rowCount = data.length;
        if (!rowCount) $('#divFaultHistory').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },

    FaultHistory_Update: function (rowData) {
        $("#ddlFaultTypeDetails").val(rowData.FaultType_ID);
        $("#txtFaultDate").val(rowData.ReportDate);
        $("#txtReportName").val(rowData.ReportName);
        $("#txtRepairDate").val(rowData.FixDate);
        $("#txtFixName").val(rowData.FixName);
        $("#txtFaultInfoRemarks").val(rowData.Remarks);
        $("#hidItemFaults_ID").val(rowData.ItemFaults_ID);
        $("#btnAddNewFaultHistory").val($("#lblFaultHistory_btnUpdate").text());
        faultHist.divDefineMaintTaskDetails_Open();
    },

    divDefineMaintTaskDetails_Open: function () {
        $("#divDefineFaultHistoryDetails").dialog({ autoOpen: true, bgiframe: true, resizable: true, closeOnEscape: true, width: '650px', modal: true, zIndex: 50,
            title: $('#hidFaultHistory_MainGreeting').text(),
            create: function () {
                $(this).block({
                    css: { border: '0px' },
                    overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                    message: ''
                });
            },
            open: function () {
                $(this).parent().appendTo("form");
                $(this).unblock();
                var pid = getArgs();
                if (!pid.iid) {
                    $("#tabsFaultInfoProfile").tabs().tabs("option", "disabled", [1, 2, 3]);
                    $("#btnUpdate").val($("#hidAddNewItemDetail").text());
                } else {
                    $("#tabsFaultInfoProfile").tabs().tabs({
                        select: function (event, ui) {
                            if (ui.index === 1) {
                                $("#tlbFaultAttachment").GridUnload();
                                faultAttach.PopulationFaultHistoryAttachGrid(null);
                            }
                        }
                    }).tabs({ selected: 0 });
                    $("#btnDeleteUser").show();
                    $("#btnUpdate").val($("#hidUpdateItemDetail").text());
                }
            }
        });
        return false;
    },

    FaultHistory_New: function () {
        $("#ddlFaultTypeDetails,#hidItemFaults_ID").val("0");
        $("#txtFaultDate,#txtReportName,#txtRepairDate,#txtFixName,#txtFaultInfoRemarks").val("");
        $("#btnAddNewFaultHistory").val($("#lblMaintTask_btnAddNewMaintTask").text());
        faultHist.divDefineMaintTaskDetails_Open();
    },

    RequaredFeilds: function () {
        if ($("#txtFaultDate").val() == "") {
            $("#txtFaultDate").addClass('ui-state-error');
            return false;
        }
        if ($("#ddlFaultTypeDetails").val() == "0") {
            $("#ddlFaultTypeDetails").addClass('ui-state-error');
            return false;
        }

        return true;
    },

    FaultHistory_Delete: function (rowObj) {
        if (rowObj) {
            $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
                open: function () {
                    $(this).parent().appendTo("form");
                },
                buttons: {
                    Ok: function (e) {
                        e.preventDefault();
                        RaiseLoader(true);
                        try {
                            AssetManagement.ItemFaults_Delete(rowObj.ItemFaults_ID, faultHist.GetItemID(),
                        function (result) {
                            if (result) {
                                $("#tblFaultHistory").GridUnload();
                                faultHist.PopulationFaultHistoryGrid(result);
                                $("#waitplease").css({ 'display': 'none' });
                                $('#ConfirmDeleteAttachment').dialog('destroy');
                            }
                        },
                        function () {
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
    Autocomplete_ReportName: function () {
        var pid = getArgs();
        if (pid.iid) {
            $("#txtReportName").autocomplete({
                source: function (request, response) {
                    AssetManagement.GetItem_ReportNameList(pid.iid, request.term,
                    function (data) {
                        if (data) {
                            response($.map(data, function (item) {
                                return {
                                    value: item.ReportName
                                };
                            }));
                        };
                    },
                    function () {
                    },
                    null);
                },
                minLength: 1
            });
        }
    }
};
var faultAttach = {
    PopulationFaultHistoryAttachGrid: function (newData) {
        var langDir = "ltr";
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
                langDir = "rtl";
        }
        $('#tabFaultAttachment').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var maintTaskAttachGrid = $("#tlbFaultAttachment").jqGrid({
            direction: langDir,
            datatype: function (pdata) { faultAttach.getFaultHistoryAttachData(pdata, newData); },
            height: 375,
            autowidth: false,
            colNames: [
                $('#hidFaultHistory_Grid_FaultAttach_Date').text(),
                $('#hidFaultHistory_Grid_FaultAttach_Description').text(),
                "", "", 'ItemFaults_ID', 'Attachments_ID'],
            colModel: [
           		{ name: 'Attachments_Date', index: 'Attachments_Date', formatter: dateFormatter, sortable: true, width: 150 },
                { name: 'Attachments_Name', index: 'Attachments_Name', sortable: true, width: 320 },
                { name: 'Edit', index: 'Edit', sortable: false, edittype: 'image', formatter: attachFormatter, width: 32, align: 'center' },
                { name: 'Delete', index: 'Delete', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                { name: 'ItemFaults_ID', hidden: 'true' },
                { name: 'Attachments_ID', hidden: 'true' }
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
            pager: '#pgrFaultAttachment',
            pgbuttons: false,
            pginput: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (rowCount == $(this).getGridParam('records')) {
                    $("#waitplease").css({ 'display': 'none' });
                    $('#tabFaultAttachment').unblock();
                }
            },
            onCellSelect: function (rowid, iCol) {
                switch (iCol) {
                    case 2:
                        faultAttach.FaultHistoryAttach_Download($(this).getRowData(rowid));
                        break;
                    case 3:
                        return faultAttach.ItemFaultAttach_Delete($(this).getRowData(rowid));
                }
                return false;
            },
            ondblClickRow: function (rowid) {
                faultAttach.FaultHistoryAttach_Download($(this).getRowData(rowid));
            }
        });
        maintTaskAttachGrid.jqGrid('gridResize', { minWidth: 674, minHeight: 300 });
        maintTaskAttachGrid
    .toolbarButtonAdd("#t_tlbFaultAttachment",
        {
            caption: $('#lblFaultHistoryAtach_btnUpload').text(),
            position: "first",
            align: (langDir == 'rtl' ? 'right' : 'left'),
            buttonicon: 'ui-icon-circle-plus',
            onClickButton: function () {
                faultAttach.ItemFaultAttach_New();
            }
        });
    },
    getFaultHistoryAttachData: function (pData, newData) {
        if (!newData) {
            AssetManagement.ItemFaultsAttach_SelectAll($("#hidItemFaults_ID").val(),
            function (result) {
                faultAttach.ReceivedFaultHistoryAttachData(JSON.parse(getMain(result)).rows);
            }, function (ex) {
                return false;
            }, null);
        } else {
            faultAttach.ReceivedFaultHistoryAttachData(JSON.parse(getMain(newData)).rows);
        }
    },
    ReceivedFaultHistoryAttachData: function (data) {
        var thegrid = $("#tlbFaultAttachment");
        thegrid.clearGridData();
        rowCount = data.length;
        if (!rowCount) $('#tabFaultAttachment').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },
    ItemFaultAttach_New: function () {
        $("#divFileFaultUpload").dialog({ autoOpen: true, closeOnEscape: true, width: '400px', modal: true, zIndex: 20,
            title: $('#hidMaintTaskAtach_grbAttachments').text(),
            open: function () {
                $(this).parent().appendTo("form");
                $(this).block({
                    css: { border: '0px' },
                    timeout: 100,
                    overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                    message: ''
                });
                $("#btnUploadFault").removeAttr("disabled", 100);
                var button = $('#btnBrowseFault');
                var upload = new AjaxUpload(button, {
                    action: '/opeReady/Handlers/ItemFaultsAttachHandler.ashx',
                    name: 'myfile',
                    autoSubmit: false,
                    onChange: function (file, ext) {
                        if (!checkNotAllowedFileExtension(null, ext)) {
                            $("#btnUploadFault").attr("disabled", true);
                        }
                        else { $("#btnUploadFault").removeAttr("disabled", 100); }
                        $("#lblFaultFileName").block({
                            css: { border: '0px' },
                            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                            message: ''
                        });
                        setTimeout(function () { $("#lblFaultFileName").unblock().text(file); }, 500);
                    },
                    onSubmit: function () {
                        RaiseLoader(true);
                        this.disable();
                    },
                    onComplete: function () {
                        this.enable();
                        faultAttach.UploadComplete();
                        $("#waitplease").css({ 'display': 'none' });
                    }
                });

                $("#btnUploadFault").live("click", function () {
                    if (faultAttach.RequaredItemMaintAttachFields()) {
                        upload.setData({ "Attachments_Name": $("#txtFaultAttachments_Name").val(), "ItemFaults_ID": $("#hidItemFaults_ID").val() });
                        upload.submit();
                    }
                });
            }
        });
        return false;
    },
    RequaredItemMaintAttachFields: function () {
        if ($('#txtFaultAttachments_Name').val() == '')
            $('#txtFaultAttachments_Name').addClass('ui-state-error').focus();
        else {
            $('#txtFaultAttachments_Name').removeClass('ui-state-error', 500);
            return true;
        }
        return false;
    },
    UploadComplete: function () {
        $("#tlbFaultAttachment").GridUnload();
        faultAttach.PopulationFaultHistoryAttachGrid(null);
        $("#waitplease").css({ 'display': 'none' });
        $('#txtFaultAttachments_Name').val("");
        $('#divFileFaultUpload').dialog('destroy');
    },
    FaultHistoryAttach_Download: function (args) {
        RaiseLoader(true);
        var imgId = args.Attachments_ID;
        window.location.href = '/opeReady/Handlers/ItemFaultAttachDownload.ashx?attachid=' + imgId + '&itemfaultid=' + args.ItemFaults_ID;
        $("#waitplease").css({ 'display': 'none' });
    },
    ItemFaultAttach_Delete: function (rowObj) {
        if (rowObj) {
            $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
                open: function () {
                    $(this).parent().appendTo("form");
                },
                buttons: {
                    Ok: function (e) {
                        e.preventDefault();
                        RaiseLoader(true);
                        try {
                            AssetManagement.ItemFaultAttach_Delete(rowObj.ItemFaults_ID, rowObj.Attachments_ID,
                        function (result) {
                            if (result) {
                                $("#tlbFaultAttachment").GridUnload();
                                faultAttach.PopulationFaultHistoryAttachGrid(result);
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
    $("#tblFaultHistory").GridUnload();
    AssetManagement.ItemFaults_SelectAll(faultHist.GetItemID(), $("#ddlFaultType").val(),
            function (data) {
                faultHist.PopulationFaultHistoryGrid(data);
            }, function (ex) {
                return false;
            }, null);
});
$("#btnAddNewFaultHistory").live("click", function () {
    if (faultHist.RequaredFeilds()) {
        RaiseLoader(true);
        var fault = {
            ReportDateStr: $("#txtFaultDate").val(),
            FaultType_ID: $("#ddlFaultTypeDetails").val(),
            ReportName: $("#txtReportName").val(),
            FixDateStr: $("#txtRepairDate").val(),
            FixName: $("#txtFixName").val(),
            Remarks: $("#txtFaultInfoRemarks").val(),
            Item_ID: $("#hidItem_ID").val(),
            ItemFaults_ID: $("#hidItemFaults_ID").val()
        };
        window.AssetManagement.ItemFaults_Save(fault,
            function (data) {
                $("#tblFaultHistory").GridUnload();
                faultHist.PopulationFaultHistoryGrid(data);
                $("#waitplease").css({ 'display': 'none' });
                $('#divDefineFaultHistoryDetails').dialog('destroy');
            }, function (ex) {
                return false;
            }, null);
    }
});

    function countFormatter(cellvalue, options, rowObject) {
        if (rowObject.AttachmentsCount > 0) {
            var img = new Image(32, 30);
            $(img).attr("src", "/opeReady/Resources/images/attachment.png");
            $(img).attr("style", "cursor:pointer;vertical-align:middle");
            return img.outerHTML || new XMLSerializer().serializeToString(img);
        }
        else return '';
    }