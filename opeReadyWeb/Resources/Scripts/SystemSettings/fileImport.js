var fileImport = {};

fileImport.btnFilter_Click = function () {

};

fileImport.PopulateExtSrcSubDataGrid = function (externalSourceTypeID) {
    var _langDir;
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            _langDir = "rtl";
        else
            _langDir = "ltr";
    }
    $('#frmExtSrcSubData').block({
        css: { border: '0px' },
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    try {
        $("#tblExtSrcSubData").jqGrid({
            direction: _langDir,
            datatype: function (pdata) {
                PQ.Admin.WebService.SystemSettingsService.RunPopulateExtSrcSubDataGrid(externalSourceTypeID,
                        function (data) {
                            var parsedData = JSON.parse(data);
                            rowCount = parsedData.rows.length;
                            var thegrid = $("#tblExtSrcSubData")[0];
                            thegrid.addJSONData(parsedData);
                            data = null;
                        }, function (ex) { });
            },
            height: 'auto',
            colNames: [
                        $("#hidFileImport_lblSubCatName").text(), $("#hidFileImport_lblIsValidForCalc").text(), "", ""
                    ],
            colModel: [
               		{ name: 'ExternalEventSubCategoryName', index: 'ExternalEventSubCategoryName', sortable: true, sorttype: 'text', width: 250 },
                    { name: 'isValidForCalc', index: 'isValidForCalc', sortable: false, edittype: 'image', formatter: fileImport.checkboxFormatter, width: 102, align: 'center' },
                    { name: 'ExternalEventSubCategoryID', key: true, hidden: 'true' },
                    { name: 'ExternalEventSubCategoryID', hidden: 'true' },
               	],
            viewrecords: true,
            sortorder: "asc",
            autoencode: false,
            loadonce: false,
            pginput: true,
            altRows: true,
            hoverrows: false,
            recordpos: (_langDir == 'rtl' ? 'left' : 'right'),
            jsonReader: {
                root: "rows",
                page: "page",
                total: "total",
                records: "records",
                repeatitems: false,
                userdata: "userData",
                id: "ExternalSourceType_ID"
            },
            pgbuttons: false,
            pginput: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (rowCount == $(this).getGridParam('records')) {
                    setTimeout(function () { $("#waitplease").css({ 'display': 'none' }); }, 150);
                    $('#frmExtSrcSubData').unblock();
                    rowCount = 0;
                }
            }
        });
    } catch (e) {
    }
};

fileImport.checkboxFormatter = function (cellvalue, options, rowObject) {
    var html;
    if (cellvalue) {
        html = "<input type='checkbox' id='chkIsValid" + options.rowId + "' checked='checked' />";
        $("#tblExtSrcSubData").setRowData(options.rowId, rowObject);
    }
    else
        html = "<input type='checkbox' id='chkIsValid" + options.rowId + "'  />";

    $("#chkIsValid" + options.rowId).live("click", function (a) {
        $("#waitplease").css({ 'display': 'block' });
        rowObject.isValidForCalc = a.target.checked;
        PQ.Admin.WebService.SystemSettingsService.ExtSrcSubData_SetIsValid(rowObject,
        function (data) {
            setTimeout(function () { $("#waitplease").css({ 'display': 'none' }); }, 250);
        },
        function (e) { });
    })
    return html;
};

fileImport.SaveCheckBoxValue = function (rowObject) {
    $("#waitplease").css({ 'display': 'block' });
    PQ.Admin.WebService.SystemSettingsService.ExtSrcSubData_SetIsValid(rowObject,
        function (data) {
            setTimeout(function () { $("#waitplease").css({ 'display': 'none' }); }, 250);
        },
        function (e) { });
};


function btnUpdate_Click() {
    $("#waitplease").css({ 'display': 'block' });
    var extSourceType = {
        ExternalSourceTypeID: $("#ddlExternalSourceType").val(),
        TrainingEventType_ID: $("#ddlEventType").val(),
        InputDirectory: $("#txtFileInputDirection").val(),
        OutputDirectory: $("#txtFileOutputDirection").val(),
        ErrorDirectory: $("#txtFileErrorDirection").val(),
        ExternalSourcePersonMatch_ID: $("#ddlExternalSourcePersonMatch").val(),
        SyncEmployeesFromSource: $("#chkSyncEmployeesFromSource").attr('checked')
    }; 
    PQ.Admin.WebService.SystemSettingsService.ExternalSourceType_Save(extSourceType,
            function (data) {
                setTimeout(function () { $("#waitplease").css({ 'display': 'none' }); }, 500);
            }, function (ex) {
            });
};

function btnRunProc_Click() {
    $("#waitplease").css({ 'display': 'block' });
    PQ.Admin.WebService.SystemSettingsService.RunProcPopulateExternalFiles_Main(
                        function (data) {
                            setTimeout(function () { $("#waitplease").css({ 'display': 'none' }); }, 1500);
                        }, function (ex) {
                        });

};
