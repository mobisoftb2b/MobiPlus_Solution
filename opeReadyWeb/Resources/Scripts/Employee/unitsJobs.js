/// <reference path="../Common/_references.js" />


var unitJob = {
    availableTags: null,
    rowObject: null
};
unitJob.Init = function () {

};

Sys.Application.add_load(applicationLoadHandler);
function applicationLoadHandler() {
    unitJob.Init();
};

unitJob.ReloadCurrentActiveJob = function (personID) {
    try {
        PQ.Admin.WebService.PQWebService.EmploymentHistory_Select(personID, this.ReloadCurrentActiveJobCallbackResult, this.ExecuteFailResult);
    } catch (e) {
        alert(e.Description);
    }
};

unitJob.ReloadCurrentActiveJobCallbackResult = function (result) {
    if (result) {
        $('#divCurrJob').html(result);
        $("#waitplease").css({ 'display': 'none' });
    }
};

unitJob.ReloadCurrentActiveUnit = function (personID) {
    try {
        PQ.Admin.WebService.PQWebService.CurrentActiveUnit_Select(personID, this.ReloadCurrentActiveUnitCallbackResult, this.ExecuteFailResult);
    } catch (e) {
        alert(e.Description);
    }
};

unitJob.ReloadCurrentActiveUnitCallbackResult = function (result) {
    if (result) {
        $('#divCurrUnits').html(result);
        $("#waitplease").css({ 'display': 'none' });
    }
};
unitJob.ExecuteFailResult = function (e) {

};

///----------------------------------------------------- Job Combo population ---------------------------------------------

unitJob.PopulateJobStatusCombo = function () {
    $("#ddlJobStatus>option").remove();
    PQ.Admin.WebService.PQWebService.JobStatus_SelectAll(0, $("#lblGrtJobStatus").text(),
    function (result) {
        $(result).each(function () {
            $("#ddlJobStatus").append($("<option></option>").val(this['JobStatus_ID']).html(this['JobStatus_ORGName']));
        });
    },
    function (e) { });
    return false;
}

unitJob.PopulateJobCategoryCombo = function () {
    $("#ddlJob>option").remove();
    PQ.Admin.WebService.PQWebService.JobCategory_SelectAll($("#lblGrtJobCategory").text(),
    function (result) {
        $(result).each(function () {
            $("#ddlJob").append($("<option></option>").val(this['Job_ID']).html(this['Job_Name']));
        });
    },
    function (e) { });
    return false;
}


///----------------------------------------------------- Job History Grid Population ----------------------------------------------

unitJob.CreateAndPopulateJobUnitGrid = function () {
    var langDir = "ltr", editable = false;
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            langDir = "rtl";
    }
    if ($.cookie("userRole")) {
        if ($.cookie("userRole") == "6")
            editable = true;
    }
    $('#divUnitJob').block({
        css: { border: '0px' },
        timeout: 500,
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    $("#tblJobHistory").jqGrid({
        direction: langDir,
        datatype: function (pdata) { getJobHistoryData(pdata); },
        height: 150,
        autowidth: false,
        colNames: [$('div span[id=hidHistoryFromDate]').text(),
                $('div span[id=hidJobName]').text(),
                $('#hidJobStatus').text(),
                $('div span[id=hidHistoryToDate]').text(),
                $('div span[id=hidHistoryEdit]').text(),
                $('div span[id=hidHistoryJobGridDelete]').text(),
                'Job_ID',
                'Person2Job_isMainJob', 'JobStatus_ID'],
        colModel: [
           		{ name: 'Person2Job_FromDateStr', index: 'Person2Job_FromDateStr', formatter: 'date', sortable: true, sorttype: 'date', width: 125 },                   //0
           		{name: 'Job_Name', index: 'Job_Name', sortable: true, width: 250 },
                { name: 'JobStatus_ORGName', index: 'JobStatus_ORGName', sortable: true, width: 110 },
           		{ name: 'Person2Job_ToDateStr', index: 'Person2Job_ToDateStr', sortable: true, formatter: 'date', sorttype: 'date', width: 125 },          //2   
                {name: 'EditJob', index: 'EditJob', sortable: false, edittype: 'image', formatter: editFormatter, width: 32, align: 'center' },
                { name: 'delJob', index: 'delJob', sortable: false, hidden: editable, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                { name: 'Job_ID', hidden: 'true' },                                                                          //3
                {name: 'Person2Job_isMainJob', hidden: 'true' },                                                                      //4
                {name: 'JobStatus_ID', hidden: 'true' }
           	],
        datefmt: 'd/m/Y',
        viewrecords: true,
        sortname: "Person2Job_FromDateStr",
        sortorder: "desc",
        autoencode: false,
        altRows: true,
        recordpos: 'left',
        loadonce: true,
        pager: '#pgrJobHistory',
        toolbar: [true, "top"],
        hoverrows: false,
        pgbuttons: false,
        pginput: false,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
            //            $(this).jqGrid('sortGrid', "Person2Job_FromDateStr", false);
        },
        onCellSelect: function (rowid, iCol, cellcontent, e) {
            switch (iCol) {
                case 4:
                    employeePages.imgEditCurrActiveJob_click($(this).getRowData(rowid));
                    break;
                case 5:
                    return unitJob.DeleteJobHistory($(this).getRowData(rowid));
                    break;
            }
            return false;
        },
        ondblClickRow: function (rowid, iRow, iCol, e) {
            employeePages.imgEditCurrActiveJob_click($(this).getRowData(rowid));
        }
    });
    $("#tblJobHistory").jqGrid('gridResize', { minWidth: 674, minHeight: 300 });
    if ($.cookie("userRole") != "6") {
        $("#tblJobHistory").toolbarButtonAdd("#t_tblJobHistory",
        {
            caption: $('#hidJU_btnAdd').text(),
            position: "first",
            align: (langDir == 'rtl' ? 'right' : 'left'),
            buttonicon: 'ui-icon-circle-plus',
            onClickButton: function () {
                employeePages.imgEditCurrActiveJob_click(null);
            }
        });
    }
}

function getJobHistoryData(pData) {
    var pid = getArgs();
    if (pid.eid) {
        PQ.Admin.WebService.PQWebService.CreateJobHistoryList(pid.eid,
            function (data, textStatus) {
                ReceivedJobHistoryData(JSON.parse(getMain(data)).rows);
            }, function (data, textStatus) {
                alert('An error has occured retrieving data!');
            });
    }
};

function ReceivedJobHistoryData(data) {
    var thegrid = $("#tblJobHistory");
    thegrid.clearGridData();
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
}

///-----------------------------------------------------End Job History Grid Population ----------------------------------------------

///----------------------------------------------------- Unit History Grid Population ----------------------------------------------
unitJob.CreateAndPopulateUnitHistoryGrid = function () {
    var langDir = "ltr", editable = false;
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            langDir = "rtl";
    }
    if ($.cookie("userRole")) {
        if ($.cookie("userRole") == "6")
            editable = true;
    }
    $('#divUnitJob').block({
        css: { border: '0px' },
        timeout: 500,
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    $("#tblUnitHistory").jqGrid({
        direction: langDir,
        datatype: function (pdata) { getUnitHistoryData(pdata); },
        height: 150,
        autowidth: false,
        colNames: [$('div span[id=hidHistoryUnitHstrFromDate]').text(),
                $('div span[id=hidUnitName]').text(),
                $('div span[id=hidHistoryUnitHstrToDate]').text(),
                $('div span[id=hidHistoryUnitGridEdit]').text(),
                $('div span[id=hidHistoryUnitGridDelete]').text(),
                'Unit_ID',
                'Person2Unit_isMainUnit', 'Unit_Name'],
        colModel: [
           		{ name: 'Person2Unit_FromDateStr', index: 'Person2Unit_FromDateStr', formatter: 'date', sortable: true, sorttype: 'date', width: 135 },     //0
           		{name: 'Unit_Name', index: 'Unit_Name', sortable: true, width: 340 },                                                                       //1
           		{name: 'Person2Unit_ToDateStr', index: 'Person2Unit_ToDateStr', sortable: true, formatter: 'date', sorttype: 'date', width: 135 },          //2   
                {name: 'EditUnit', index: 'EditUnit', sortable: false, edittype: 'image', formatter: editFormatter, width: 32, align: 'center' },
                { name: 'delUnit', index: 'delUnit', sortable: false, hidden: editable, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                { name: 'Unit_ID', hidden: 'true' },                                                                                                        //3
                {name: 'Person2Unit_isMainUnit', hidden: 'true' },                                                                                          //4
                {name: 'Unit_Name', hidden: 'true' }
           	],
        datefmt: 'd/m/Y',
        viewrecords: true,
        sortname: "Person2Unit_FromDate",
        sortorder: "desc",
        autoencode: false,
        altRows: true,
        recordpos: 'left',
        loadonce: false,
        pager: '#pgrUnitHistory',
        toolbar: [true, "top"],
        pgbuttons: false,
        hoverrows: false,
        pginput: false,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
        },
        onCellSelect: function (rowid, iCol, cellcontent, e) {
            switch (iCol) {
                case 3:
                    unitJob.imgEditUnitHistory_click($(this).getRowData(rowid));
                    break;
                case 4:
                    return unitJob.DeleteUnitItemHistory($(this).getRowData(rowid));
                    break;
            }
            return false;
        },
        ondblClickRow: function (rowid, iRow, iCol, e) {
            unitJob.imgEditUnitHistory_click($(this).getRowData(rowid));
        }
    }).setGridParam({ rowNum: 10 }).trigger("reloadGrid");

    $("#tblUnitHistory").jqGrid('gridResize', { minWidth: 674, minHeight: 300 });
    if ($.cookie("userRole") != "6") {
        $("#tblUnitHistory").toolbarButtonAdd("#t_tblUnitHistory",
        {
            caption: $('#hidJU_btnAdd_Edit').text(),
            position: "first",
            align: (langDir == 'rtl' ? 'right' : 'left'),
            buttonicon: 'ui-icon-circle-plus',
            onClickButton: function () {
                FuckingUnitDialogUp();
            }
        });
    }
    $("#tblUnitHistory").jqGrid('sortGrid', "Person2Unit_FromDateStr", true);
}

function getUnitHistoryData(pData) {
    var pid = getArgs();
    if (pid.eid) {
        PQ.Admin.WebService.PQWebService.CreateUnitHistoryList(pid.eid,
            function (data, textStatus) {
                ReceivedUnitHistoryData(JSON.parse(getMain(data)).rows);
            }, function (data, textStatus) {
                alert('An error has occured retrieving data!');
            });
    }
};

function ReceivedUnitHistoryData(data) {
    var thegrid = $("#tblUnitHistory");
    thegrid.clearGridData();
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
}

///------------------------ Delete Job History module -----------------------------------
unitJob.DeleteJobHistory = function (rowObj) {
    if (rowObj != undefined) {
        var pid = getArgs();
        var personID = pid.eid;
        this.rowObject = $(rowObj);
        var jobID = rowObj.Job_ID;
        var jobStatusID = rowObj.JobStatus_ID;
        var fromDateStr = rowObj.Person2Job_FromDateStr;
        $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
            open: function (type, data) {
                $(this).parent().appendTo("form");
            },
            buttons: {
                Ok: function (e) {
                    e.preventDefault();
                    $("#waitplease").css({ 'display': 'block' });
                    try {
                        PQ.Admin.WebService.PQWebService.PersonJobHistory_Delete(personID, jobID, jobStatusID,fromDateStr,
                        function (result) {
                            if (result) {
                                $('#tblJobHistory').GridUnload();
                                unitJob.CreateAndPopulateJobUnitGrid();
                                unitJob.ReloadCurrentActiveJob(pid.eid);
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

///------------------------------------ Edit Unit History Item ----------------------------------

unitJob.imgEditUnitHistory_click = function (item) {
    if (item) {
        $('#txtFromUnitHistory').val(item.Person2Unit_FromDateStr).attr('readonly', 'readonly').datepicker("destroy");
        $('#txtToUnitHistory').val(item.Person2Unit_ToDateStr);
        if (item.Person2Unit_isMainUnit == 'True')
            $('#chkMainUnit').attr('checked', true);
        else
            $('#chkMainUnit').attr('checked', false);
        $('#ddlUnit').val(item.Unit_Name).hide();
        $('#txtUnit').val(item.Unit_Name).show();
        $('#hidUnitID').val(item.Unit_ID);
        $('#btnUnitHistoryAdd').val($('#hidUpdate').text());
    }
    else {
        $('#ddlUnit').val('').show();
        $('#txtUnit').val('').hide();
        $('#txtFromUnitHistory').datepicker({
            changeYear: true, changeMonth: true, dateFormat: dateFormats
        }).val("").removeAttr('readonly');
        $('#txtToUnitHistory').val('');
        $('#chkMainUnit').attr('checked', false);
        $('#hidUnitID').val('');
    }
    divUnitHistoryEdit_Open();
    return false;
}

//----------------------- Delete Unit History Item Module -------------------------------------

unitJob.DeleteUnitItemHistory = function (rowObj) {
    if (rowObj != undefined) {
        var pid = getArgs();
        var personId = pid.eid;
        this.rowObject = $(rowObj);
        var unitId = rowObj.Unit_ID;
        var fromUnitItem = rowObj.Person2Unit_FromDateStr;

        $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
            open: function (type, data) {
                $(this).parent().appendTo("form");
            },
            buttons: {
                Ok: function (e) {
                    e.preventDefault();
                    $("#waitplease").css({ 'display': 'block' });
                    try {
                        PQ.Admin.WebService.PQWebService.Person2Unit_Delete(personId, unitId, fromUnitItem,
                        function (result) {
                            if (result) {
                                $('#tblUnitHistory').block({
                                    css: { border: '0px' },
                                    timeout: 250,
                                    overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 }
                                }).GridUnload();
                                unitJob.CreateAndPopulateUnitHistoryGrid();
                                unitJob.ReloadCurrentActiveUnit(personId);
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
///-----------------------------------------------------End Unit History Grid Population ----------------------------------------------

function ReloadGrids() {
    $('#tblJobHistory').GridUnload();
    unitJob.CreateAndPopulateJobUnitGrid();
    $('#tblUnitHistory').GridUnload();
    unitJob.CreateAndPopulateUnitHistoryGrid();
}


function FuckingUnitDialogUp() {
    $('#ddlUnit').show();
    $('#txtUnit').hide();
    $("#divUnitHistoryEdit input:text").each(function () {
        $(this).val("");
    });
    $('#txtFromUnitHistory').datepicker({
        changeYear: true, changeMonth: true, dateFormat: dateFormats
    }).removeAttr('readonly');
    $('#btnUnitHistoryAdd').val($('#hidAdd').text());

    divUnitHistoryEdit_Open();
    return false;
};
function OnClientPopup_Click(sender, args) {
    $('#treeUnits').toggle(500);
    try {
        unitJob.CreateUnitTree(null);
    } catch (e) {
        return false;
    }
    return false;
};

unitJob.CreateUnitTree = function (userData) {
    var can_select = true;
    try {
        PQ.Admin.WebService.PQWebService.GetUserMenu(userData, function (result) {
            if (result) {
                var _theme, _rtl;
                if ($.cookie("lang")) {
                    var _lang = $.cookie("lang");
                    if (_lang == 'he-IL' || _lang == 'ar') {
                        _theme = "default-rtl";
                        _rtl = true;
                    }
                    else {
                        _theme = "default";
                        _rtl = false;
                    }
                }
                try {
                    var level = $("#lblTreeLebel").text() == "" ? 0 : parseInt($("#lblTreeLebel").text());
                    var arrayIDs = GetArrayTreeIDs(result, level);
                    $('#treeUnits').jstree(
                { "xml_data": { "data": result },
                    "plugins": ["themes", "xml_data", "ui", "types"],
                    "core": { "rtl": _rtl, "initially_open": [arrayIDs], "animation": "200" },
                    "themes": { "theme": _theme },
                    "types": { "types":
                        {
                            "file": {
                                "valid_children": ["default"],
                                "icon": { "image": "/opeReady/Resources/images/active.png" }
                            },
                            "folder": {
                                "valid_children": "all",
                                "icon": { "image": "/opeReady/Resources/images/close.png" },
                                "select_node": function () { return false; }
                            }
                        }
                    }
                }).bind("select_node.jstree", function (event, data) {
                    if (data.inst._get_children().length > 0) {
                        event.stopImmediatePropagation();
                        return false;
                    } else {
                        $('#hidUnitID').val(data.rslt.obj.get(0).id);
                        $('#ddlUnit').val($(data.rslt.obj.find("a").get(0)).text());
                        $('#treeUnits').fadeOut('slow');
                        $('#ddlUnit').removeClass('ui-state-error', 100);
                        return false;
                    }
                });
                } catch (e) {
                }
            }
        }, function (ex) {

        });
    } catch (e) {
        alert(e.Description);
    }
};

function CloseJobHistoryEdit() {
    ReloadGrids();
    $('#divJobHistoryEdit').dialog('destroy');
}


function CloseUnitHistoryEdit() {
    ReloadGrids();
    $('#divUnitHistoryEdit').dialog("destroy");
};

function btnAddJobHistory_Click() {
    if (isJobHistoryFieldsRequare()) {
        var pid = getArgs();
        if (pid.eid) {
            $('#waitplease').css({ 'display': 'block' });
            var person2Job = {
                Person_ID: pid.eid,
                Job_ID: $('#ddlJob').val(),
                JobStatus_ID: $('#ddlJobStatus').val(),
                Person2Job_FromDateStr: $('#txtFromDateJobHistory').val(),
                Person2Job_ToDateStr: $('#txtToDateJobHistory').val()
            };
            PQ.Admin.WebService.EventRecords.Person2Job_Save(person2Job,
            function (result) {
                if (result == "ok") {
                    $('#tblJobHistory').GridUnload();
                    unitJob.CreateAndPopulateJobUnitGrid();
                    unitJob.ReloadCurrentActiveJob(pid.eid);
                    $('#divJobHistoryEdit').dialog('destroy');
                }
            }, function (e) {
                alert("An error has occured saving data!");
            });
            $('#waitplease').css({ 'display': 'none' });
        }
    }
    return false;
};

function btnUnitHistoryAdd_Click() {
    if (isUnitHistoryFieldsRequare()) {
        var pid = getArgs();
        if (pid.eid) {
            $('#waitplease').css({ 'display': 'block' });
            var person2Unit = {
                Person_ID: pid.eid,
                Unit_ID: $('#hidUnitID').val(),
                Person2Unit_FromDateStr: $('#txtFromUnitHistory').val(),
                Person2Unit_ToDateStr: $('#txtToUnitHistory').val()
            };
            PQ.Admin.WebService.EventRecords.Person2Unit_Save(person2Unit,
            function (result) {
                if (result) {
                    $('#tblUnitHistory').GridUnload();
                    unitJob.CreateAndPopulateUnitHistoryGrid();
                    unitJob.ReloadCurrentActiveUnit(pid.eid);
                    $('#divUnitHistoryEdit').dialog('destroy');
                }
            }, function (e) {
                alert("An error has occured saving data!");
            });
            $('#waitplease').css({ 'display': 'none' });
        }
    }
    return false;
};


function isJobHistoryFieldsRequare() {
    if ($("#ddlJob").val() == "0") {
        $('#ddlJob').addClass('ui-state-error').focus();
        return false;
    }
    else {
        $('#ddlJob').removeClass('ui-state-error', 500);
    }
    //-----------------------------------------------------------------------
    if ($("#ddlJobStatus").val().trim() == "0") {
        $('#ddlJobStatus').addClass('ui-state-error').focus();
        return false;
    }
    else
        $('#ddlJobStatus').removeClass('ui-state-error', 500);
    //----------------------------------------------------------------------
    if ($("#txtFromDateJobHistory").val().trim() == "") {
        $('#txtFromDateJobHistory').addClass('ui-state-error').focus();
        return false;
    }
    else
        $('#txtFromDateJobHistory').removeClass('ui-state-error', 500);
    return true;
}

function isUnitHistoryFieldsRequare() {
    if ($("#ddlUnit").val() == "" && $("#hidUnitID").val() == "") {
        $('#ddlUnit').addClass('ui-state-error').focus();
        return false;
    }
    else {
        $('#ddlUnit').removeClass('ui-state-error', 500);
    }
    //----------------------------------------------------------------------
    if ($("#txtFromUnitHistory").val().trim() == "") {
        $('#txtFromUnitHistory').addClass('ui-state-error').focus();
        return false;
    }
    else
        $('#txtFromUnitHistory').removeClass('ui-state-error', 500);
    return true;
}
