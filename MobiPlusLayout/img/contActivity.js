/// <reference path="_references.js" />
/// <reference path="Main.js" />


var activity = {
    rowCount: 0,
    Init: function() {
        activity.CreateGrig();
    },
    CreateGrig: function(data) {
        let langDir = $("#hidLanguage").val().toLowerCase() == "he" ? "rtl" : "ltr";

        let recordpos = (langDir == 'rtl' ? 'right' : 'left');

        $('#divContActivity').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var activityGrid = $("#grdContActivity").jqGrid({
            direction: langDir,
            datatype: function (pdata) { activity.GetConcActivityData(pdata, data); },
            autowidth: true,
            width: '100%',
            height: 450,
            colNames: [
                $('#hidDriverID_Grid_Header').val(),
                $('#hidDriverName_Grid_Header').val(),
                $('#hidDeviceID_Grid_Header').val(),
                $('#hidDeviceTypeName_Grid_Header').val(),
                $('#hidComment_Grid_Header').val(),
                $('#hidIsActive_Grid_Header').val(),
                $('#hidEdit_Grid_Header').val(),
                $('#hidDelete_Grid_Header').val(), ''
            ],
            colModel: [
                { name: 'DriverID', index: 'DriverID', sortable: true, sorttype: 'int', align: recordpos, width: 100 },
                { name: 'DriverName', index: 'DriverName', sortable: true, sorttype: 'text', align: recordpos, width: 250 },
                { name: 'DeviceID', index: 'DeviceID', sortable: true, sorttype: 'text', align: recordpos, width: 250 },
                { name: 'DeviceTypeName', index: 'DeviceTypeName', sorttype: 'text', sortable: true, align: recordpos, width: 200 },
                { name: 'Comments', index: 'Comments', sortable: true, sorttype: 'text', align: recordpos, width: 400 },
                { name: 'IsActive', index: 'IsActive', sortable: true, sorttype: 'int', formatter: checkboxPic, align: 'center', width: 80, search: false },
                { name: 'Edit', index: 'Edit', sortable: false, edittype: 'image', formatter: editFormatter, width: 35, align: 'center', search: false },
                { name: 'Del', index: 'Del', sortable: false, edittype: 'image', formatter: deleteFormatter, width: 45, align: 'center', search: false },
                { name: 'ID', hidden: 'true' }
            ],
            viewrecords: true,
            sortorder: "asc",
            autoencode: false,
            loadonce: false,
            pginput: false,
            altRows: true,
            resizable: false,
            shrinkToFit: true,
            rowNum: 2000,
            ignoreCase: true,
            hoverrows: true,
            recordpos: (langDir == 'rtl' ? 'left' : 'right'),
            pager: '#grdContActivityPager',
            pgbuttons: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (activity.rowCount == $(this).getGridParam('records')) {
                    $('#divContActivity').unblock();
                }
            },
            ondblClickRow: function (rowid, iRow, iCol, e) {
                activity.DefineDevice4DriverData($(this).getRowData(rowid));
            }
        });
        activityGrid.navGrid("#grdContActivityPager", { edit: false, add: false, del: false, search: false, refresh: true })
            .navButtonAdd("#grdContActivityPager", {
                caption: $("#hidAddbuttonCaption").val(),
                buttonicon: "ui-icon-plus",
                cursor: 'pointer',
                onClickButton: function () {
                    activity.Devices4DriverDataNew();
                },
                position: "first"
            }).navButtonAdd("#grdContActivityPager", {
                caption: $("#hidSearchButtonCaption").val(),
                buttonicon: "ui-icon-search",
                cursor: 'pointer',
                onClickButton: function () {
                    activityGrid[0].toggleToolbar();
                },
                position: "first"
            });
        $("#grdContActivity").jqGrid('filterToolbar', { stringResult: true, searchOnEnter: true, defaultSearch: 'cn' });
        activityGrid[0].toggleToolbar();
    },
    GetConcActivityData: function (pdata, records) {
        if (records) {
            activity.ReceivedConcActivityData(JSON.parse(records).rows)
        }
        else {
            let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];
            let did = $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"];
            let driverID = $.QueryString["AgentId"] == undefined ? null : $.QueryString["AgentId"];
            let date = $.QueryString["FromDate"] == undefined ? null : $.QueryString["FromDate"];
            HardwareWebService.Layout_POD_WEB_ConcentrationActivity(cid, did, driverID, date,
                function (data, textStatus) {
                    activity.ReceivedConcActivityData(JSON.parse(data).rows);
                }, function (data, textStatus) {
                    console.log(data.message);
                    return false;
                });
        }
        return false;
    },
    ReceivedConcActivityData: function (data) {
        var thegrid = $("#grdContActivity");
        thegrid.clearGridData();
        activity.rowCount = data.length;
        if (!hard.rowCount) $('#divContActivity').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },

}





$(function () {
    window.parent.CloseLoading();
    activity.Init();
});




Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (args) {
    window.parent.CloseLoading();
});
Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(function () {
    window.parent.ShowLoading();
});