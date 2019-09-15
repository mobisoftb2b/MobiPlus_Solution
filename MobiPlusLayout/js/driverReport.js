const driverReport = {
    rowCount: 0,
    Init: function () {
        this.CreateGrid(null);
    },
    CreateGrid: function (data) {
        let langDir = "ltr";

        let lang = $("#hidLanguage").val();
        if (lang != "" && lang != undefined) {
            if (lang.toLowerCase() == "he")
                langDir = "rtl";
        }
        let recordpos = (langDir == 'rtl' ? 'right' : 'left');
        $('#divDriverReport').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var driverGrid = $("#grdDriverReport").jqGrid({
            direction: langDir,
            datatype: function (pdata) { driverReport.GetDriverReportData(pdata, data); },
            autowidth: true,
            width: '100%',
            height: 450,
            colNames: [
                        $('#hidDocDate_Grid_Header').val(),
                        $('#hidDocStartTime_Grid_Header').val(),
                        $('#hidDriverName_Grid_Header').val(),
                        $('#hidShipmentNumber_Grid_Header').val(),
                        $('#hidCustomerData_Grid_Header').val(),
                        $('#hidReference_Grid_Header').val(),
                        $('#hidItem_Grid_Header').val(),
                        $('#hidQTY_Grid_Header').val(),
                        $('#hidReasonDescription_Grid_Header').val()
            ],
            colModel: [
                        { name: 'DocDate', index: 'DocDate', sortable: true, sorttype: 'text', align: 'center', width: 60, formatter: DateFormatteryyyymmdd },
                        { name: 'DocStartTime', index: 'DocStartTime', sortable: true, sorttype: 'text', align: 'center', width: 60 },
                        { name: 'DriverName', index: 'DriverName', sortable: true, sorttype: 'text', align: recordpos, width: 150, formatter: twoLinesTextFormatter },
                        { name: 'ShipmentNumber', index: 'ShipmentNumber', sorttype: 'text', sortable: true, align: 'center', width: 80 },
                        { name: 'CustomerData', index: 'CustomerData', sortable: true, sorttype: 'text', align: 'center', width: 80, formatter: twoLinesTextFormatter },
                        { name: 'Reference', index: 'Reference', sortable: true, sorttype: 'int', align: 'center', width: 80 },
                        { name: 'Item', index: 'Item', sortable: true, sorttype: 'text', align: recordpos, width: 200, formatter: twoLinesTextFormatter },
                        { name: 'QTY', index: 'QTY', sortable: true, sorttype: 'text', align: 'center', width: 40},
                        { name: 'ReasonDescription', index: 'ReasonDescription', sortable: true, sorttype: 'text', align: recordpos, width: 80 }
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
            toolbar: [true, "top"],
            ignoreCase: true,
            hoverrows: true,
            recordpos: (langDir == 'rtl' ? 'left' : 'right'),
            pager: '#grdDriverReportPager',
            pgbuttons: false,
	    caption:"Driver Report",
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (driverReport.rowCount == $(this).getGridParam('records')) {
                    $('#divDriverReport').unblock();
		window.parent.CloseLoading();
                }
            }
        });
        driverGrid.toolbarButtonAdd("#t_grdDriverReport",
         {
             caption: $("#hidSearchButtonCaption").val(),
             position: "last",
             align: 'left',
             buttonicon: "ui-icon-search",
             onClickButton: function () {
                 driverGrid[0].toggleToolbar();
             }
         })
        .toolbarButtonAdd("#t_grdDriverReport",
         {
             caption: "Excel",
             position: (langDir == 'rtl' ? 'left' : 'right'),
             align: (langDir == 'rtl' ? 'right' : 'left'),
             buttonicon: 'ui-icon-contact',
             onClickButton: function () {
                 $("#grdDriverReport").jqGrid("exportToExcel", {
                     includeLabels: true,
                     includeGroupHeader: true,
                     includeFooter: true,
                     fileName: "DriverReportExcel.xlsx",
                     maxlength: 40 // maxlength for visible string data 
                 })
             }
         });

        $("#grdDriverReport").jqGrid('filterToolbar', { stringResult: true, searchOnEnter: true, defaultSearch: 'cn' });
        driverGrid[0].toggleToolbar();
    },
    GetDriverReportData: function (pdata, records) {
        if (records) {
            driverReport.ReceivedDriverReportData(JSON.parse(records).rows)
        }
        else {
            let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];
            let did = $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"];
            let driverID = $.QueryString["AgentId"] == undefined ? null : $.QueryString["AgentId"];
            let date = $.QueryString["FromDate"] == undefined ? null : $.QueryString["FromDate"];
            let toDate = $.QueryString["ToDate"] == undefined ? null : $.QueryString["ToDate"];
            HardwareWebService.Layout_POD_WEB_AgentsReport(cid, did, driverID, date, toDate,
                function (data, textStatus) {
                    driverReport.ReceivedDriverReportData(JSON.parse(data).rows);
                }, function (data, textStatus) {
                    console.log(data.message);
                    return false;
                });
        }
        return false;
    },
    ReceivedDriverReportData: function (data) {
        var thegrid = $("#grdDriverReport");
        thegrid.clearGridData();
        driverReport.rowCount = data.length;
        if (!driverReport.rowCount) { $('#divDriverReport').unblock(); window.parent.CloseLoading(); }
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    }
};


const nVisit = {
    rowCount: 0,
    Init: function () {
        this.CreateGrid(null);
    },
    CreateGrid: function (data) {
        let langDir = "ltr";

        let lang = $("#hidLanguage").val();
        if (lang != "" && lang != undefined) {
            if (lang.toLowerCase() == "he")
                langDir = "rtl";
        }
        let recordpos = (langDir == 'rtl' ? 'right' : 'left');
        $('#divNotVisit').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var nVisitGrid = $("#grdNotVisit").jqGrid({
            direction: langDir,
            datatype: function (pdata) { nVisit.GetDriverReportData(pdata, data); },
            autowidth: true,
            width: '100%',
            height: 450,
            colNames: [
                        $('#hidTaskDate_Grid_Header').val(),
                        $('#hidDriverName_Grid_Header').val(),
                        $('#hidShipmentID_Grid_Header').val(),
                        $('#hidCustomerData_Grid_Header').val(),
                        $('#hidReportDescription_Grid_Header').val(),
                        $('#hidDelivery_Grid_Header').val(),
            ],
            colModel: [
                        { name: 'TaskDate', index: 'TaskDate', sortable: true, sorttype: 'text', align: 'center', width: 100, formatter: DateFormatteryyyymmdd  },
                        { name: 'DriverName', index: 'DriverName', sortable: true, sorttype: 'text', align: recordpos, width: 100, formatter: twoLinesTextFormatter },
                        { name: 'ShipmentID', index: 'ShipmentID', sortable: true, sorttype: 'int', align: 'center', width: 100 },
                        { name: 'CustomerData', index: 'CustomerData', sortable: true, sorttype: 'text', align: recordpos, width: 100, formatter: twoLinesTextFormatter },
                        { name: 'ReportDescription', index: 'ReportDescription', sortable: true, sorttype: 'text', align: recordpos, width: 150, search: true, formatter: twoLinesTextFormatter },
                        { name: 'Delivery', index: 'Delivery', sortable: true, sorttype: 'text', align: recordpos, width: 80 },
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
            toolbar: [true, "top"],
            ignoreCase: true,
            hoverrows: true,
            recordpos: (langDir == 'rtl' ? 'left' : 'right'),
            pager: '#grdNotVisitPager',
            pgbuttons: false,
 	    caption:"Undelivered/Unvisited",
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (nVisit.rowCount == $(this).getGridParam('records')) {
                    $('#divNotVisit').unblock();
		    window.parent.CloseLoading();
                }
            }
        });
        nVisitGrid.toolbarButtonAdd("#t_grdNotVisit",
         {
             caption: $("#hidSearchButtonCaption").val(),
             position: "last",
             align: 'left',
             buttonicon: "ui-icon-search",
             onClickButton: function () {
                 nVisitGrid[0].toggleToolbar();
             }
         })
        .toolbarButtonAdd("#t_grdNotVisit",
         {
             caption: "Excel",
             position: (langDir == 'rtl' ? 'left' : 'right'),
             align: (langDir == 'rtl' ? 'right' : 'left'),
             buttonicon: 'ui-icon-contact',
             onClickButton: function () {
                 $("#grdNotVisit").jqGrid("exportToExcel", {
                     includeLabels: true,
                     includeGroupHeader: true,
                     includeFooter: true,
                     fileName: "UndeliveredExcel.xlsx",
                     maxlength: 40 // maxlength for visible string data 
                 })
             }
         });

        $("#grdNotVisit").jqGrid('filterToolbar', { stringResult: true, searchOnEnter: true, defaultSearch: 'cn' });
        nVisitGrid[0].toggleToolbar();
	//$('#grdNotVisit>.ui-jqgrid-titlebar-close>span').removeClass('ui-icon-circle-triangle-n');
    },
    GetDriverReportData: function (pdata, records) {
        if (records) {
            nVisit.ReceivedDriverReportData(JSON.parse(records).rows)
        }
        else {
            let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];
            let did = $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"];
            let driverID = $.QueryString["AgentId"] == undefined ? null : $.QueryString["AgentId"];
            let date = $.QueryString["FromDate"] == undefined ? null : $.QueryString["FromDate"];
            let toDate = $.QueryString["ToDate"] == undefined ? null : $.QueryString["ToDate"];
            HardwareWebService.Layout_POD_WEB_AgentsReport1(cid, did, driverID, date, toDate,
                function (data, textStatus) {
                    nVisit.ReceivedDriverReportData(JSON.parse(data).rows);
                }, function (data, textStatus) {
                    console.log(data.message);
                    return false;
                });
        }
        return false;
    },
    ReceivedDriverReportData: function (data) {
        var thegrid = $("#grdNotVisit");
        thegrid.clearGridData();
        nVisit.rowCount = data.length;
        if (!nVisit.rowCount) { $('#divNotVisit').unblock(); window.parent.CloseLoading(); }
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    }
};


$(function () {
    driverReport.Init();
    nVisit.Init();
});

Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (args) {
    window.parent.CloseLoading();
});
Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(function () {
    window.parent.ShowLoading();
});