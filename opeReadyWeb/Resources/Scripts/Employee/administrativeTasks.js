var rowCount;
var administrativeTasks = {
    availableTags: null,
    rowObject: null,
    rowCount: 0
};

///----------------------------------------------------- Admin Task Grid Population ----------------------------------------------
administrativeTasks.CreateAndPopulateAdminTasksGrid = function () {
    var _langDir, editable = false;
    var pid = getArgs();
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            _langDir = "rtl";
        else
            _langDir = "ltr";
    }
    $('#divAdminTask').block({
        css: { border: '0px' },
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    if ($.cookie("userRole")) {
        if ($.cookie("userRole") == "6")
            editable = true;
    }
    var adminTaskGrid = $("#tblAdminTask").jqGrid({
        direction: _langDir,
        datatype: function (pdata) { administrativeTasks.getAdminTaskData(pdata) },
        height: 375,
        autowidth: false,
        colNames: [$('div span[id=hidEventRecordsFromDate]').text(),
                $('div span[id=hidRequirementType]').text(),
                $('div span[id=hidRemarks]').text(),
                $('div span[id=hidEventRecordsEdit]').text(),
                $('div span[id=hidEventRecordsDelete]').text(),
                'SubQualificationType_ID', 'PersonQualification_ToDate'],
        colModel: [
           		{ name: 'PersonQualification_FromDateStr', index: 'PersonQualification_FromDateStr', formatter: 'date', sortable: true, sorttype: 'date', width: 125 },
           		{ name: 'SubQualificationType_Name', index: 'SubQualificationType_Name', sortable: true, width: 180 },                                                                       //1
           		{name: 'PersonQualification_Remarks', index: 'PersonQualification_Remarks', sortable: true, sorttype: 'text', width: 320 },
                { name: 'EditAdTask', index: 'EditAdTask', sortable: false, edittype: 'image', formatter: editFormatter, width: 32, align: 'center' },
                { name: 'DelAdTask', index: 'DelAdTask', sortable: false, hidden: editable, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                { name: 'SubQualificationType_ID', hidden: 'true', key: true },
                { name: 'PersonQualification_ToDateStr', hidden: 'true' }
           	],
        imgpath: '<%= ResolveClientUrl("~/Resources/Styles/redmon/images") %>',
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
        pager: $('#pgrAdminTask'),
        pgbuttons: false,
        pginput: false,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
            if (rowCount == $(this).getGridParam('records')) {
                $("#waitplease").css({ 'display': 'none' });
                $('#divAdminTask').unblock();
            }
        },
        onCellSelect: function (rowid, iCol, cellcontent, e) {
            switch (iCol) {
                case 3:
                    AdministrativeTasksEdit_click($(this).getRowData(rowid));
                    break;
                case 4:
                    return administrativeTasks.DeleteAdministrativeTask($(this).find('.jqgrow')[rowid - 1]);
                    break;
            }
            return false;
        },
        ondblClickRow: function (rowid, iRow, iCol, e) {
            AdministrativeTasksEdit_click($(this).getRowData(rowid));
        }
    });
    adminTaskGrid.jqGrid('sortGrid', "PersonQualification_FromDateStr", true);
    adminTaskGrid.jqGrid('gridResize', { minWidth: 674, minHeight: 300 });
    if ($.cookie("userRole") != "6") {
        adminTaskGrid.toolbarButtonAdd("#t_tblAdminTask",
        {
            caption: $('#hidAT_btnAdd').text(),
            position: "first",
            align: (_langDir == 'rtl' ? 'right' : 'left'),
            buttonicon: 'ui-icon-circle-plus',
            onClickButton: function () {
                AddNewAdminTask_Click();
            }
        });
    }
}

administrativeTasks.getAdminTaskData = function (pData) {
    var pid = getArgs();
    if (pid.eid) {
        PQ.Admin.WebService.PQWebService.PersonSubQualification_Select(pid.eid,
            function (data, textStatus) {
                administrativeTasks.ReceivedAdminTaskData(JSON.parse(getMain(data)).rows);
            }, function (data, textStatus) {
                alert('An error has occured retrieving data!');
            });
    }
};

administrativeTasks.ReceivedAdminTaskData = function (data) {
    var thegrid = $("#tblAdminTask");
    thegrid.clearGridData();
    rowCount = data.length;
    if (rowCount == 0) $('#divAdminTask').unblock();
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
}


administrativeTasks.PersonSubQualification_Save = function (_tasksParams) {
    PQ.Admin.WebService.PQWebService.PersonSubQualification_Save(_tasksParams,
            function (data) {
                try {
                    $("#tblAdminTask").GridUnload();
                    administrativeTasks.CreateAndPopulateAdminTasksGrid();
                    $("#divAdminTasksEdit").dialog('destroy');
                    $("#waitplease").css({ 'display': 'none' });
                } catch (e) { }

            }, function (data) {
                return false;
            });
};

administrativeTasks.PopulateAdminTasksCombo = function () {
    $("#ddlPersonSubQualification>option").remove();
    PQ.Admin.WebService.PQWebService.SubQualificationType_SelectAll(0, $("#hidGrtSubQualificationType").text(),
    function (result) {
        $(result).each(function () {
            $("#ddlPersonSubQualification").append($("<option></option>").val(this['SubQualificationType_ID']).html(this['SubQualificationType_Name']));
        });
    },
    function (e) { });
    $("#waitplease").css({ 'display': 'none' });
    return false;
}


///------------------------ Delete admin task module -----------------------------------
administrativeTasks.DeleteAdministrativeTask = function (rowObj) {
    if (rowObj != undefined) {
        var pid = getArgs();
        var adminTask = { Person_ID: pid.eid, PersonQualification_FromDateStr: $(rowObj).find("td").eq(0).html(), SubQualificationType_ID: $(rowObj).find("td").eq(5).html() };
        $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
            open: function (type, data) {
                $(this).parent().appendTo("form");
            },
            buttons: {
                Ok: function (e) {
                    e.preventDefault();
                    try {
                        PQ.Admin.WebService.PQWebService.PersonSubQualification_Delete(adminTask, function (result) {
                            if (result) {
                                $("#tblAdminTask").block({
                                    css: { border: '0px' },
                                    timeout: 500,
                                    overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
                                    message: ''
                                }).GridUnload();
                                administrativeTasks.CreateAndPopulateAdminTasksGrid();
                                $("#waitplease").css({ 'display': 'none' });
                                $('#ConfirmDeleteAttachment').dialog('destroy');
                            }
                        }, this.ExecuteFailResult);
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
};

////-------------------------------------- Administrative Tasks ------------------------------------------
function AdministrativeTasksEdit_click(trObj) {
    if (trObj) {
        var admintaskId = trObj.SubQualificationType_ID;
        var remarks = unescape(trObj.PersonQualification_Remarks);
        $('#txtAdTaskFromDate').val(trObj.PersonQualification_FromDateStr);
        $('#ddlPersonSubQualification').val(parseInt(admintaskId)).hide();
        $('#editorAdminTaskRemarks').val(remarks);
        $('#txtPersonSubQualification').val(trObj.SubQualificationType_Name).show();
        $('#btnAddAdTask').val($('#hidUpdate').text());
        divAdminTasksEdit_Open();
    }
    return false;
}

function RequaredAdminTaskFields() {
    if ($("#ddlPersonSubQualification").val() == "0") {
        $('#ddlPersonSubQualification').addClass('ui-state-error').focus();
        return false;
    }
    else {
        $('#ddlPersonSubQualification').removeClass('ui-state-error', 500);
    }
    if ($("#txtAdTaskFromDate").val().trim() == "") {
        $('#txtAdTaskFromDate').addClass('ui-state-error').focus();
        return false;
    }
    else {
        $('#txtAdTaskFromDate').removeClass('ui-state-error', 500);
    }
    btnAddAdTask_Click();
}

function btnAddAdTask_Click() {
    $("#waitplease").css({ 'display': 'block' });
    var pid = getArgs();
    if (pid.eid) {
        var _tasksParams = {
            Person_ID: parseInt(pid.eid),
            PersonQualification_FromDateStr: $('#txtAdTaskFromDate').val(),
            PersonQualification_ToDateStr: null,
            SubQualificationType_ID: $('#ddlPersonSubQualification').val(),
            PersonQualification_Remarks: $("#editorAdminTaskRemarks").val()
        };
        administrativeTasks.PersonSubQualification_Save(_tasksParams);
    }
}


function AddNewAdminTask_Click() {
    $('.input-medium').each(function () {
        $(this).val("");
    });
    $('#editorAdminTaskRemarks').val("");
    $('#ddlPersonSubQualification').val('0').show();
    $('#txtPersonSubQualification').val('').hide();
    divAdminTasksEdit_Open();
    $('#btnAddAdminTask').val($('#hidAdd').text());
    return false;
};
