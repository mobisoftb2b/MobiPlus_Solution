/// <reference path="../Common/_references.js" />
var rowCountmaintTask;
var maintTask = {
    GetItemID: function () {
        var param = getArgs();
        if (param.iid)
            return $("#hidItem_ID").val() == "" ? parseInt(param.iid) : parseInt($("#hidItem_ID").val());
        else
            return null;
    },

    PopulationMainTaskGrid: function (newData) {
        var langDir = "ltr";
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
                langDir = "rtl";
        }
        $('#divDefineMaintTask').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var maintTaskGrid = $("#tblMaintTask").jqGrid({
            direction: langDir,
            datatype: function (pdata) { maintTask.getMainTaskData(pdata, newData); },
            height: 375,
            autowidth: false,
            colNames: [
                $('#hidMaintTask_Grid_MaintTaskDate').text(),
                $('#hidMaintTask_Grid_TaskType_Name').text(),
                $('#hidMaintTask_Grid_Counter').text(),
                $('#hidMaintTask_Grid_ResponsibleName').text(),
                $('#hidMaintTask_Grid_AttachmentsCount').text(),
                "", "", 'ItemMaint_ID', 'Remarks', 'PlanDate', 'MaintType'],
            colModel: [
           		{ name: 'ItemMaint_Date', index: 'ItemMaint_Date', formatter: dateFormatter, sortable: true, width: 150 },
                { name: 'MaintType_Name', index: 'MaintType_Name', sortable: true, width: 150 },
                { name: 'ItemMaint_Counter', index: 'ItemMaint_Counter', sortable: true, width: 150 },
                { name: 'ItemMaint_Name', index: 'ItemMaint_Name', sortable: true, width: 150 },
                { name: 'AttachmentsCount', index: 'AttachmentsCount', sortable: false, edittype: 'image', formatter: countFormatter, width: 32, align: 'center' },
                { name: 'Edit', index: 'Edit', sortable: false, edittype: 'image', formatter: editFormatter, width: 32, align: 'center' },
                { name: 'Delete', index: 'Delete', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                { name: 'ItemMaint_ID', hidden: 'true' },
                { name: 'ItemMaint_Remarks', hidden: 'true' },
                { name: 'ItemMaint_PlanDate', hidden: 'true', formatter: dateFormatter },
                { name: 'MaintType_ID', hidden: 'true' }
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
            pager: '#pgrMaintTask',
            pgbuttons: false,
            rowNum: 2000,
            pginput: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (rowCountmaintTask == $(this).getGridParam('records')) {
                    $("#waitplease").css({ 'display': 'none' });
                    $('#divDefineMaintTask').unblock();
                }
            },
            onCellSelect: function (rowid, iCol, cellcontent, e) {
                switch (iCol) {
                    case 5:
                        maintTask.MainTask_Update($(this).getRowData(rowid));
                        break;
                    case 6:
                        return maintTask.MainTask_Delete($(this).getRowData(rowid));
                }
                return false;
            },
            ondblClickRow: function (rowid, iRow, iCol, e) {
                maintTask.MainTask_Update($(this).getRowData(rowid));
            }
        });
        maintTaskGrid.jqGrid('gridResize', { minWidth: 674, minHeight: 300 });
        maintTaskGrid
    .toolbarButtonAdd("#t_tblMaintTask",
        {
            caption: $('#lblMaintTask_btnAddNewMaintTask').text(),
            position: "first",
            align: (langDir == 'rtl' ? 'right' : 'left'),
            buttonicon: 'ui-icon-circle-plus',
            onClickButton: function () {
                maintTask.MainTask_New();
            }
        })
        .toolbarButtonAdd("#t_tblMaintTask",
            {
                caption: "Excel",
                position: "last",
                align: (langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                    if (rowCountmaintTask == 0) return false;
                    maintTaskGrid.jqGrid('excelExport', { url: '/opeReady/Handlers/ExcelExport/MainTasksExcel.ashx?iid=' + maintTask.GetItemID() });
                }
            });
    },
    getMainTaskData: function (pData, newData) {
        if (!newData) {
            AssetManagement.MaintItem_SelectAll(maintTask.GetItemID(), $("#ddlTaskType").val(),
            function (data, textStatus) {
                maintTask.ReceivedMainTaskData(JSON.parse(getMain(data)).rows);
            }, function (ex) {
                return false;
            }, null);
        } else {
            maintTask.ReceivedMainTaskData(JSON.parse(getMain(newData)).rows);
        }
    },
    ReceivedMainTaskData: function (data) {
        var thegrid = $("#tblMaintTask");
        thegrid.clearGridData();
        rowCountmaintTask = data.length;
        if (!rowCountmaintTask) $('#divDefineMaintTask').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },
    MainTask_Update: function (rowData) {
        $("#ddlTaskTypeDetails").val(rowData.MaintType_ID);
        $("#txtTaskDate").val(rowData.ItemMaint_Date);
        $("#txtNextScheduled").val(rowData.ItemMaint_PlanDate);
        $("#txtMaintTask").val(rowData.ItemMaint_Name);
        $("#txtTaskInfoRemarks").val(rowData.ItemMaint_Remarks);
        $("#txtItemMaintCounter").val(rowData.ItemMaint_Counter);
        $("#hidItemMaint_ID").val(rowData.ItemMaint_ID);
        $("#btnAddNewMaintTask").val($("#lblMaintTask_btnUpdate").text());
        maintTask.divDefineMaintTaskDetails_Open();
    },
    divDefineMaintTaskDetails_Open: function () {
        $("#divDefineMaintTaskDetails").dialog({ autoOpen: true, bgiframe: true, resizable: true, closeOnEscape: true, width: '650px', modal: true, zIndex: 50,
            title: $('#hidMaintTask_MainGreeting').text(),
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
                var tab_count = $('#tabsAssetMngProfile').tabs('length');
                if (!pid.iid) {
                    $("#tabsAssetMngProfile").tabs().tabs("option", "disabled", [1, 2, 3]);
                    $("#btnUpdate").val($("#hidAddNewItemDetail").text());
                } else {
                    $("#tabsAssetMngProfile").tabs().tabs({
                        select: function (event, ui) {
                            if (ui.index === 1) {
                                $("#tlbTaskAttachment").GridUnload();
                                taskAttach.PopulationMainTaskAttachGrid(null);
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

    MainTask_New: function () {
        $("#ddlTaskTypeDetails,#hidItemMaint_ID").val("0");
        $("#txtTaskDate,#txtNextScheduled,#txtMaintTask,#txtTaskInfoRemarks,#txtItemMaintCounter").val("");
        $("#btnAddNewMaintTask").val($("#lblMaintTask_btnAddNewMaintTask").text());
        maintTask.divDefineMaintTaskDetails_Open();
    },

    RequaredFeilds: function () {
        if ($("#txtTaskDate").val() == "") {
            $("#txtTaskDate").addClass('ui-state-error');
            return false;
        }
        if ($("#ddlTaskTypeDetails").val() == "0") {
            $("#ddlTaskTypeDetails").addClass('ui-state-error');
            return false;
        }      
        return true;
    },

    MainTask_Delete: function (rowObj) {
        if (rowObj) {
            $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
                open: function (type, data) {
                    $(this).parent().appendTo("form");
                },
                buttons: {
                    Ok: function (e) {
                        e.preventDefault();
                        $("#waitplease").css({ 'display': 'block' });
                        try {
                            AssetManagement.MainTask_Delete(rowObj.ItemMaint_ID, maintTask.GetItemID(),
                        function (result) {
                            if (result) {
                                $("#tblMaintTask").GridUnload();
                                maintTask.PopulationMainTaskGrid(result);
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
var taskAttach = {
    PopulationMainTaskAttachGrid: function (newData) {
        var  langDir = "ltr";
        if ($.cookie("lang")) {
            if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
                langDir = "rtl";
        }
        $('#divTaskAttachment').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var maintTaskAttachGrid = $("#tlbTaskAttachment").jqGrid({
            direction: langDir,
            datatype: function (pdata) { taskAttach.getMainTaskAttachData(pdata, newData); },
            height: 375,
            autowidth: false,
            colNames: [
                $('#hidMaintTask_Grid_TaskAttach_Date').text(),
                $('#hidMaintTask_Grid_TaskAttach_Description').text(),
                "", "", 'ItemMaint_ID', 'Attachments_ID'],
            colModel: [
           		{ name: 'Attachments_Date', index: 'Attachments_Date', formatter: dateFormatter, sortable: true, width: 150 },
                { name: 'Attachments_Name', index: 'Attachments_Name', sortable: true, width: 320 },
                { name: 'Edit', index: 'Edit', sortable: false, edittype: 'image', formatter: attachFormatter, width: 32, align: 'center' },
                { name: 'Delete', index: 'Delete', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                { name: 'ItemMaint_ID', hidden: 'true' },
                { name: 'Attachments_ID', hidden: 'true' }
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
            pager: '#pgrTaskAttachment',
            pgbuttons: false,
            pginput: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (rowCountmaintTask == $(this).getGridParam('records')) {
                    $("#waitplease").css({ 'display': 'none' });
                    $('#divTaskAttachment').unblock();
                }
            },
            onCellSelect: function (rowid, iCol, cellcontent, e) {
                switch (iCol) {
                    case 2:
                        taskAttach.MainTaskAttach_Download($(this).getRowData(rowid));
                        break;
                    case 3:
                        return taskAttach.ItemMaintAttach_Delete($(this).getRowData(rowid));
                        break;
                }
                return false;
            },
            ondblClickRow: function (rowid, iRow, iCol, e) {
                taskAttach.MainTaskAttach_Download($(this).getRowData(rowid));
            }
        });
        maintTaskAttachGrid.jqGrid('gridResize', { minWidth: 674, minHeight: 300 });
        maintTaskAttachGrid
    .toolbarButtonAdd("#t_tlbTaskAttachment",
        {
            caption: $('#lblMaintTaskAtach_btnUpload').text(),
            position: "first",
            align: (langDir == 'rtl' ? 'right' : 'left'),
            buttonicon: 'ui-icon-circle-plus',
            onClickButton: function () {
                taskAttach.ItemMaintAttach_New();
            }
        });
    },
    getMainTaskAttachData: function (pData, newData) {
        if (!newData) {
            AssetManagement.MaintItemAttach_SelectAll($("#hidItemMaint_ID").val(),
            function (data, textStatus) {
                taskAttach.ReceivedMainTaskAttachData(JSON.parse(getMain(data)).rows);
            }, function (ex) {
                return false;
            }, null);
        } else {
            taskAttach.ReceivedMainTaskAttachData(JSON.parse(getMain(newData)).rows);
        }
    },
    ReceivedMainTaskAttachData: function (data) {
        var thegrid = $("#tlbTaskAttachment");
        thegrid.clearGridData();
        rowCountmaintTask = data.length;
        if (!rowCountmaintTask) $('#divTaskAttachment').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },
    ItemMaintAttach_New: function () {
        $("#divFileUpload").dialog({ autoOpen: true, closeOnEscape: true, width: '400px', modal: true, zIndex: 20,
            title: $('#hidMaintTaskAtach_grbAttachments').text(),
            open: function (type, data) {
                $(this).parent().appendTo("form");
                $(this).block({
                    css: { border: '0px' },
                    timeout: 100,
                    overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                    message: ''
                });
                $("#btnUpload").removeAttr("disabled", 100);
                var param = getArgs();
                var button = $('#btnBrowse');
                var upload = new AjaxUpload(button, {
                    action: '/opeReady/Handlers/ItemMaintAttachHandler.ashx',
                    name: 'myfile',
                    autoSubmit: false,
                    onChange: function (file, ext) {
                        if (!checkNotAllowedFileExtension(null, ext)) {
                            $("#btnUpload").attr("disabled", true);
                        }
                        else { $("#btnUpload").removeAttr("disabled", 100); }
                        $("#lblFileName").block({
                            css: { border: '0px' },
                            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                            message: ''
                        });
                        setTimeout(function () { $("#lblFileName").unblock().text(file); }, 500);
                    },
                    onSubmit: function (file, ext) {
                        $("#waitplease").css({ 'display': 'block' });
                        this.disable();
                    },
                    onComplete: function (file, response) {
                        this.enable();
                        taskAttach.UploadComplete();
                        $("#waitplease").css({ 'display': 'none' });
                    }
                });

                $("#btnUpload").live("click", function () {
                    if (taskAttach.RequaredItemMaintAttachFields()) {
                        upload.setData({ "Attachments_Name": $("#txtAttachments_Name").val(), "ItemMaint_ID": $("#hidItemMaint_ID").val() });

                        upload.submit();
                    }
                });
            }
        });
        return false;
    },
    RequaredItemMaintAttachFields: function () {
        if ($('#txtAttachments_Name').val() == '')
            $('#txtAttachments_Name').addClass('ui-state-error').focus();
        else {
            $('#txtAttachments_Name').removeClass('ui-state-error', 500);
            return true;
        }
        return false;
    },
    UploadComplete: function (sender, args) {
        $("#tlbTaskAttachment").GridUnload();
        taskAttach.PopulationMainTaskAttachGrid(null);
        $("#waitplease").css({ 'display': 'none' });
        $('#txtAttachments_Name').val("");
        $('#divFileUpload').dialog('destroy');
    },
    MainTaskAttach_Download: function (args) {
        $("#waitplease").css({ 'display': 'block' });
        var _imgID = args.Attachments_ID;
        window.location.href = '/opeReady/Handlers/ItemAttachDownload.ashx?attachid=' + _imgID + '&itmaintid=' + args.ItemMaint_ID;
        $("#waitplease").css({ 'display': 'none' });
    },
    ItemMaintAttach_Delete: function (rowObj) {
        if (rowObj) {
            $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
                open: function (type, data) {
                    $(this).parent().appendTo("form");
                },
                buttons: {
                    Ok: function (e) {
                        e.preventDefault();
                        $("#waitplease").css({ 'display': 'block' });
                        try {
                            AssetManagement.ItemMaintAttach_Delete(rowObj.ItemMaint_ID, rowObj.Attachments_ID,
                        function (result) {
                            if (result) {
                                $("#tlbTaskAttachment").GridUnload();
                                taskAttach.PopulationMainTaskAttachGrid(result);
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
    $("#tblMaintTask").GridUnload();
    AssetManagement.MaintItem_SelectAll(maintTask.GetItemID(), $("#ddlTaskType").val(),
            function (data, textStatus) {
                maintTask.PopulationMainTaskGrid(data);
            }, function (ex) {
                return false;
            }, null);
});
$("#btnAddNewMaintTask").live("click", function () {
    if (maintTask.RequaredFeilds()) {
        $("#waitplease").css({ 'display': 'block' });
        var _maintTask = {
            ItemMaint_DateStr: $("#txtTaskDate").val(),
            MaintType_ID: $("#ddlTaskTypeDetails").val(),
            ItemMaint_PlanDateStr: $("#txtNextScheduled").val(),
            ItemMaint_Name: $("#txtMaintTask").val(),
            ItemMaint_Remarks: $("#txtTaskInfoRemarks").val(),
            ItemMaint_Counter: $("#txtItemMaintCounter").val() == "" ? null : $("#txtItemMaintCounter").val(),
            Item: { Item_ID: $("#hidItem_ID").val() },
            ItemMaint_ID: $("#hidItemMaint_ID").val()
        };
        AssetManagement.MaintItem_Save(_maintTask,
            function (data, textStatus) {
                $("#tblMaintTask").GridUnload();
                maintTask.PopulationMainTaskGrid(data);
                $("#waitplease").css({ 'display': 'none' });
                $('#divDefineMaintTaskDetails').dialog('destroy');
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