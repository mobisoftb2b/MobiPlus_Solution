var rowCount;
var lastsel;
var readiness = {};
readiness.Init = function () {

};

readiness.CreateReadinessLevelGrid = function (eSettings) {
    var _langDir;
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            _langDir = "rtl";
        else
            _langDir = "ltr";
    }
    $('#divReadinessLevel').block({
        css: { border: '0px' },
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    $("#tblReadinessLevel").jqGrid({
        direction: _langDir,
        datatype: function (pdata) { readiness.getReadinessLevelData(); },
        height: 160,
        colNames: [
                    $('#hidReadinessLevels_Grid_ReadinessLevel_ORGName').text(),
                    $('#hidReadinessLevels_Grid_MultiplierFactor').text(),
                    $('#hidReadinessLevels_Grid_ThresholdScore').text(),
                    '', 'ReadinessLevelID'],
        colModel: [
               		{ name: 'ORGName', index: 'ORGName', sortable: true, sorttype: 'text', width: 250 },
                    { name: 'MultiplierFactor', index: 'MultiplierFactor', align: 'center', sortable: true, width: 130 },
                    { name: 'ThresholdScore', index: 'ThresholdScore', sortable: true, align: 'center', width: 130 },
                    { name: 'EditType', index: 'EditType', sortable: false, edittype: 'image', formatter: editFormatter, width: 35, align: 'center' },
                    { name: 'ReadinessLevelID', hidden: 'true' }
               	],
        viewrecords: true,
        sortorder: "asc",
        autoencode: false,
        loadonce: false,
        pginput: true,
        altRows: true,
        hoverrows: false,
        recordpos: (_langDir == 'rtl' ? 'left' : 'right'),
        pager: '#pgrReadinessLevel',
        pgbuttons: false,
        pginput: false,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
            if (rowCount == $(this).getGridParam('records')) {
                $("#waitplease").css({ 'display': 'none' });
                $('#divReadinessLevel').unblock();
                rowCount = 0;
            }
        },
        onCellSelect: function (rowid, iCol, cellcontent, e) {
            if (iCol === 4) {
                readiness.DefineReadinessLevel_Open($(this).getRowData(rowid));
            }
        },
        ondblClickRow: function (rowid, iRow, iCol, e) {
            readiness.DefineReadinessLevel_Open($(this).getRowData(rowid));
        }
    });
};

readiness.getReadinessLevelData = function () {
    PQ.Admin.WebService.SystemSettingsService.ReadinessLevel_SelectAll(
            function (data, textStatus) {
                readiness.ReceivedEventTypeSettingData(JSON.parse(getMain(data)).rows);
            }, function (data, textStatus) {
                return false;
            });
};

readiness.ReceivedEventTypeSettingData = function (data) {
    var thegrid = $("#tblReadinessLevel");
    thegrid.clearGridData();
    rowCount = data.length;
    if (!rowCount) $('#divReadinessLevel').unblock();
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
};

readiness.SaveReadinessLevelData = function (editdata) {
    PQ.Admin.WebService.SystemSettingsService.ReadinessLevel_Save(editdata,
            function (data) {
                $("#tblReadinessLevel").GridUnload();
                readiness.CreateReadinessLevelGrid();
                $('#divReadinessLevelDetails').dialog('destroy');
            }, function (ex) {
                return false;
            });
};

readiness.DefineReadinessLevel_Open = function (data) {
    $("#txtORGName").val(data.ORGName);
    $("#txtThresholdScore").val(data.ThresholdScore);
    $("#txtMultiplierFactor").val(data.MultiplierFactor);
    $("#hidReadinessLevel_ID").val(data.ReadinessLevelID);
    divReadinessLevelDetails_Open();
};

readiness.UpdateMultiJobReadiness = function (value) {
    PQ.Admin.WebService.SystemSettingsService.UpdateMultiJobReadiness(value,
        function (data) {
            setTimeout(function () { $("#waitplease").css({ 'display': 'none' }); }, 250);
        }, function (ex) {
            return false;
        });
};

readiness.GetchkMultiJobReadiness = function () {
    PQ.Admin.WebService.SystemSettingsService.DateFormat_SelectCurrent(
        function (data) {
            $("#chkMultiJobReadiness").attr("checked", data.MultiJobReadiness);
        }, function (ex) {
            return false;
        });
};
