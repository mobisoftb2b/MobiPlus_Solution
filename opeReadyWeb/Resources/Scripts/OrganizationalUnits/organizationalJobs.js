var rowCount;
var orgJob = {};
//---------------------------------------- Begin population grid -----------------------------------------
orgJob.CreateJobSettingsGrid = function () {
    var _langDir;
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            _langDir = "rtl";
        else
            _langDir = "ltr";
    }
    $('#divJobSettings').block({
        css: { border: '0px' },
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    $("#tblJobSettings").jqGrid({
        direction: _langDir,
        datatype: function (pdata) { orgJob.getJobCollectionData(pdata); },
        height: 375,
        width: 'auto',
        colNames: [
                    $('#hidJob_Grid_Job_Name').text(),
                    '', '', 'Job_ID', 'Job_ValidFromDate', 'Job_ValidToDate'],
        colModel: [
                    { name: 'Job_Name', index: 'Job_Name', sortable: true, sorttype: 'text', width: 450 },
                    { name: 'EditAlert', index: 'EditAlert', sortable: false, edittype: 'image', formatter: editFormatter, width: 35, align: 'center' },
                    { name: 'DelAlert', index: 'DelAlert', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center' },
                    { name: 'Job_ID', hidden: 'true' },
                    { name: 'Job_ValidFromDateStr', hidden: 'true' },
                    { name: 'Job_ValidToDateStr', hidden: 'true' }
               	],
        viewrecords: true,
        sortorder: "asc",
        rowNum: 2000,
        autoencode: false,
        loadonce: true,
        pginput: true,
        altRows: true,
        hoverrows: false,
        toolbar: [true, "top"],
        recordpos: (_langDir == 'rtl' ? 'left' : 'right'),
        pager: '#pgrJobSettings',
        pgbuttons: false,
        pginput: false,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
            if (rowCount == $(this).getGridParam('records')) {
                $("#waitplease").css({ 'display': 'none' });
                $('#divJobSettings').unblock();
                rowCount = 0;
            }
            
        },
        onCellSelect: function (rowid, iCol, cellcontent, e) {
            switch (iCol) {
                case 1:
                    orgJob.DefineJobSettings_Open($(this).getRowData(rowid));
                    break;
                case 2:
                    return orgJob.DefineJobSettings_Delete($(this).getRowData(rowid).Job_ID);
                    break;
            }
            return false;
        },
        ondblClickRow: function (rowid, iRow, iCol, e) {
            orgJob.DefineJobSettings_Open($(this).getRowData(rowid));
        }
    });
    $("#tblJobSettings")
        .jqGrid('gridResize', { minWidth: 750, minHeight: 300 })
        .toolbarButtonAdd("#t_tblJobSettings",
            {
                caption: $('#hidJobSettings_btnAddNewJob').text(),
                position: "first",
                align: (_langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-circle-plus',
                onClickButton: function () {
                    orgJob.DefineJobSettings_New();                    
                }
            });

};
orgJob.getJobCollectionData = function (pData) {
    PQ.Admin.WebService.OrgUnitsService.JobCollection_SelectAll(
            function (data, textStatus) {
                orgJob.ReceivedJobCollectionData(JSON.parse(getMain(data)).rows);
            }, function (data, textStatus) {
                alert('An error has occured retrieving data!');
            });
};

orgJob.ReceivedJobCollectionData = function (data) {
    var thegrid = $("#tblJobSettings");
    thegrid.clearGridData();
    rowCount = data.length;
    if (!rowCount) $('#divJobSettings').unblock();
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
}

//---------------------------------------- End population grid -----------------------------------------

orgJob.DefineJobSettings_New = function () {
    $("#txtJobName").val("").focus();
    $("#hidJobID").val("");
    $("#txtFromDateJob").val("");
    $("#txtToDateJob").val("");
    $("#btnAddOrgJobSetting").val($("#hidOrgJob_btnAddJobSetting").text());
    divJobSettingsDetails_Open();
};

orgJob.DefineJobSettings_Open = function (jobs) {
    $("#hidJobID").val(jobs.Job_ID);
    $("#txtJobName").val(jobs.Job_Name);
    $("#txtFromDateJob").val(jobs.Job_ValidFromDateStr);
    $("#txtToDateJob").val(jobs.Job_ValidToDateStr);
    $("#btnAddOrgJobSetting").val($("#hidOrgJob_btnUpdateJobSetting").text());
    divJobSettingsDetails_Open();
};

orgJob.DefineJobSettings_Delete = function (jobID) {
    if (jobID) {
        $("#ConfirmDeleteAttachment").dialog({ autoOpen: true, modal: true, resizable: false, closeOnEscape: true, height: 150,
            open: function (type, data) {
                $(this).parent().appendTo("form");
            },
            buttons: {
                Ok: function (e) {
                    e.preventDefault();
                    $("#waitplease").css({ 'display': 'block' });
                    try {
                        PQ.Admin.WebService.OrgUnitsService.JobCollection_DeleteOne(jobID,
                        function (result) {
                            if (result) {
                                $("#tblJobSettings").GridUnload();
                                orgJob.CreateJobSettingsGrid();
                                $('#ConfirmDeleteAttachment').dialog('destroy');
                            }
                            else {
                                $('#ConfirmDeleteAttachment').dialog('destroy');
                                RaiseWarningAlert($("#hidOrgJobs_DeleteJobError").text());
                            }
                            $("#waitplease").css({ 'display': 'none' });
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
};



orgJob.JobSettings_Save = function (value) {
    PQ.Admin.WebService.OrgUnitsService.JobCollection_Save(value,
        function (data) {
            if (data) {
                $("#tblJobSettings").GridUnload();
                orgJob.CreateJobSettingsGrid();
                $('#divJobSettingsDetails').dialog('destroy');
            }
            $("#waitplease").css({ 'display': 'none' });
        },
        function (e) {
            $("#waitplease").css({ 'display': 'none' });
            return false;
        });
};