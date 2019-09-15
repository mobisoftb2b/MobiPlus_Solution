var rowCount;
var executionLevel = {};

executionLevel.CreateExecutionLevelGrid = function (eSettings) {
    var _langDir;
    if ($.cookie("lang")) {
        if ($.cookie("lang") == "he-IL" || $.cookie("lang") == "ar")
            _langDir = "rtl";
        else
            _langDir = "ltr";
    }
    $('#divExecutionLevel').block({
        css: { border: '0px' },
        overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
        message: ''
    });
    $("#tblExecutionLevel").jqGrid({
        direction: _langDir,
        datatype: function (pdata) { executionLevel.getExecutionLevelData(); },
        height: 375,
        colNames: [
                    $('#hidExecutionLevel_Grid_ExecutionLevelName').text(),
                    $('#hidExecutionLevel_Grid_MatchScore').text(),
                    '', 'ExecutionLevelID', '', ''],
        colModel: [
               		{ name: 'ExecutionLevel_ORGName', index: 'ExecutionLevel_ORGName', sortable: true, sorttype: 'text', width: 250 },
                    { name: 'MatchScore', index: 'MatchScore', align: 'center', sortable: true, width: 130 },
                    { name: 'EditType', index: 'EditType', sortable: false, edittype: 'image', formatter: editFormatter, width: 35, align: 'center' },
                    { name: 'ExecutionLevel_ID', hidden: 'true' },
                    { name: 'TipFormula', hidden: 'true' },
                    { name: 'SemsFormula', hidden: 'true' },
               	],
        viewrecords: true,
        sortorder: "asc",
        autoencode: false,
        loadonce: false,
        pginput: true,
        altRows: true,
        hoverrows: false,
        recordpos: (_langDir == 'rtl' ? 'left' : 'right'),
        pager: '#pgrExecutionLevel',
        pgbuttons: false,
        pginput: false,
        gridComplete: function () {
            $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
            if (rowCount == $(this).getGridParam('records')) {
                setTimeout(function () { $("#waitplease").css({ 'display': 'none' }); }, 150);
                $('#divExecutionLevel').unblock();
                rowCount = 0;
            }
        },
        onCellSelect: function (rowid, iCol, cellcontent, e) {
            if (iCol === 2) {
                executionLevel.DefineExecutionLevel_Open($(this).getRowData(rowid));
            }
        },
        ondblClickRow: function (rowid, iRow, iCol, e) {
            executionLevel.DefineExecutionLevel_Open($(this).getRowData(rowid));
        }
    });
};

executionLevel.getExecutionLevelData = function () {
    PQ.Admin.WebService.SystemSettingsService.ExecutionLevel_SelectAll(
            function (data) {
                executionLevel.ReceivedExecutionLevelData(JSON.parse(getMain(data)).rows);
            }, function (ex) {
                return false;
            });
};

executionLevel.ReceivedExecutionLevelData = function (data) {
    var thegrid = $("#tblExecutionLevel");
    thegrid.clearGridData();
    rowCount = data.length;
    if (!rowCount) $('#divExecutionLevel').unblock();
    for (var i = 0; i < data.length; i++)
        thegrid.addRowData(i + 1, data[i]);
};

executionLevel.SaveExecutionLevelData = function (editdata) {
    PQ.Admin.WebService.SystemSettingsService.ExecutionLevel_Save(editdata,
            function (data) {
                $("#tblExecutionLevel").GridUnload();
                executionLevel.CreateExecutionLevelGrid();
                $('#divExecutionLevelDetails').dialog('destroy');
            }, function (ex) {
                return false;
            });
};

executionLevel.DefineExecutionLevel_Open = function (data) {
    $("#txtExLevelName").val(data.ExecutionLevel_ORGName);
    $("#txtMatchScore").val(data.MatchScore);
    $("#hidExecutionLevelID").val(data.ExecutionLevel_ID);
    $("#txtTipFormula").val(data.TipFormula);
    $("#txtSemsFormula").val(data.SemsFormula);
    divExecutionLevelDetails_Open();
};