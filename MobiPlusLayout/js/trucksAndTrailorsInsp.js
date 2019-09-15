/// <reference path="_references.js" />
/// <reference path="Main.js" />
const tti = {           
    rowCount: 0,
    Init: function () {
        tti.CreateGrig();
    },
    CreateGrig: function (data) {
        let langDir = $("#hidLanguage").val().toLowerCase() == "he" ? "rtl" : "ltr";

        let recordpos = (langDir == 'rtl' ? 'right' : 'left');

        $('#divTrucksAndTrailorInsp').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var ttiGrid = $("#grdTrucksAndTrailorsInsp").jqGrid({
            direction: langDir,
            datatype: function (pdata) { tti.GetTrucksAndTrailorData(pdata, data); },
            autowidth: true,
            width: '100%',
            height: $(window).height() - 60,
            colNames: [
              '.',
              $('#hidTaskDate_Grid_Header').val(),
              $('#hidDistribution_Grid_Header').val(),
              $('#hidDriverName_Grid_Header').val(),
              $('#hidCarNumber_Grid_Header').val(),
              $('#hidTaskTime_Grid_Header').val(),
              $('#hidDriverStatus_Grid_Header').val(),
              $('#hidFileName_Grid_Header').val(), ''
            ],
            colModel: [
                { name: 'imgStatus', index: 'imgStatus', sortable: false, edittype: 'image', formatter: ImageFormatter, width: 20, align: 'center', search: false },
                { name: 'TaskDate', index: 'TaskDate', sortable: true, sorttype: 'text', align: 'center', width: 80 },
                { name: 'Distribution', index: 'Distribution', sortable: true,formatter:twoLinesTextFormatter, sorttype: 'int', align: recordpos, width: 100 },
                { name: 'Name', index: 'Name', sortable: true, sorttype: 'text', formatter: twoLinesTextFormatter, align: recordpos, width: 150 },
                { name: 'CarNumber', index: 'CarNumber', sortable: true, sorttype: 'text', align: 'center', width: 50 },
                { name: 'DocTime', index: 'DocTime', sorttype: 'text', sortable: true, align: 'center', width: 60 },
                { name: 'DriverStatus', index: 'DriverStatus', sortable: true, sorttype: 'text', align: 'center', width: 60 },
                { name: 'FileName', index: 'FileName', sortable: true, sorttype: 'text', formatter: DownloadAttachFormatter, align: recordpos, width: 100 },
                { name: 'DocNum', hidden:true },
            ],
            viewrecords: true,
            sortorder: "asc",
            autoencode: false,
            loadonce: false,
            pginput: false,
            altRows: false,
            resizable: false,
            shrinkToFit: true,
            rowNum: 20000,
            toolbar: [true, "top"],
            ignoreCase: true,
            hoverrows: true,
            recordpos: (langDir == 'rtl' ? 'left' : 'right'),
            pager: '#grdTrucksAndTrailorsInspPager',
            pgbuttons: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (tti.rowCount == $(this).getGridParam('records')) {
                    $('#divTrucksAndTrailorInsp').unblock();
                }
            },
            ondblClickRow: function (rowid) {
                tti.TrucksAndTrailorOpen($(this).getRowData(rowid));
            }
        });
        ttiGrid.toolbarButtonAdd("#t_grdTrucksAndTrailorsInsp",
            {
                caption: $("#hidSearchButtonCaption").val(),
                position: "last",
                align: 'left',
                buttonicon: "ui-icon-search",
                onClickButton: function () {
                    ttiGrid[0].toggleToolbar();
                }
            })
        .toolbarButtonAdd("#t_grdTrucksAndTrailorsInsp",
            {
                caption: "Excel",
                position: (langDir == 'rtl' ? 'left' : 'right'),
                align: (langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                    var urlHandlers = "../../Handlers/ExcelHandler.ashx";
                    var paramHandlers = "?cid=" + $.QueryString["CountryID"] + "&did=" + $.QueryString["DistrID"] + "&driverID=" + $.QueryString["AgentId"] + "&date=" + $.QueryString["FromDate"] + "&toDate=" + $.QueryString["ToDate"];
                    $("#grdTrucksAndTrailorsInsp").jqGrid('excelExport', { url: urlHandlers + paramHandlers });
                }
            });
       
        $("#grdTrucksAndTrailorsInsp").jqGrid('filterToolbar', { stringResult: true, searchOnEnter: true, defaultSearch: 'cn' });
        ttiGrid[0].toggleToolbar();
    },
    GetTrucksAndTrailorData: function (pdata, records) {
        if (records) {
            tti.ReceivedTrucksAndTrailorData(JSON.parse(records))
        }
        else {
            let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];
            let did = $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"];
            let driverID = $.QueryString["AgentId"] == undefined ? null : $.QueryString["AgentId"];
            let date = $.QueryString["FromDate"] == undefined ? null : $.QueryString["FromDate"];
            let toDate = $.QueryString["ToDate"] == undefined ? null : $.QueryString["ToDate"];
            HardwareWebService.Layout_POD_WEB_TrucksAndTrailorData(cid, did, driverID, date, toDate,
                function (data, textStatus) {
                    tti.ReceivedTrucksAndTrailorData(JSON.parse(data));
                }, function (data, textStatus) {
                    console.log(data.message);
                    return false;
                });
        }
        return false;
    },
    ReceivedTrucksAndTrailorData: function (data) {
        var thegrid = $("#grdTrucksAndTrailorsInsp");
        thegrid.clearGridData();
        tti.rowCount = data.length;
        if (!tti.rowCount) $('#divTrucksAndTrailorInsp').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },
    TrucksAndTrailorOpen: function (data) {
        let url = "../Compield/TrucksAndTrailorInspectionPopup.aspx?DocNum=" + data.DocNum;
        htmlResizablePopUp(url, "", "Save", $(window.parent).height(), $(window.parent).width());      
        return false;
    }

}

$(function () {
    window.parent.CloseLoading();
    tti.Init();
});




Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (args) {
    window.parent.CloseLoading();
});
Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(function () {
    window.parent.ShowLoading();
});