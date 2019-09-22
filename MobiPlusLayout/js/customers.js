/// <reference path="_references.js" />
/// <reference path="Main.js" />

var cust = {
    rowCount: 0,
    Init: function () {
        cust.CreateGrig(null);
    },
    CreateGrig: function (data) {
        let langDir = $("#hidLanguage").val().toLowerCase() == "he" ? "rtl" : "ltr";

        let recordpos = (langDir == 'rtl' ? 'right' : 'left');

        $('#divCustomers').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var customerGrid = $("#grdCustomers").jqGrid({
            direction: langDir,
            datatype: function (pdata) { cust.GetCustomersData(pdata, data); },
            autowidth: true,
            width: 'auto',
            height: 500,
            colNames: [
              '.',
              $('#hidTaskDate_Grid_Header').val(),
              $('#hidShipment_Grid_Header').val(),
              $('#hidDriver_Grid_Header').val(),                        
              $('#hidCustomer_Grid_Header').val(),
              $('#hidCustomerAddress_Grid_Header').val(),              
              $('#hidTravelHours_Grid_Header').val(),
              $('#hidServiceHours_Grid_Header').val(),
              $('#hidOriginalTime_Grid_Header').val(),
              $('#hidDeliveryTime_Grid_Header').val(),   
			  $('#hidCycle_Grid_Header').val(),
              $('#hidSortOrder_Grid_Header').val(),
              $('#hidActualSortOrder_Grid_Header').val(),
              $('#hidRouteAdherence_Grid_Header').val(),
              $('#hidDelivery_Grid_Header').val(),
              $('#hidCustReturn_Grid_Header').val(),
              $('#hidDriverReturn_Grid_Header').val(),    
			  $('#hidMission_Grid_Header').val(),
			  $('#hidQuality_Grid_Header').val(),
              $('#hidCollectedSurfaces_Grid_Header').val(),
              $('#hidTravelHourMin_Grid_Header').val(),
              $('#hidServiceHourMin_Grid_Header').val(),
              '','', '', ''
            ],
            colModel: [
                { name: 'ImgStatus', index: 'ImgStatus', sortable: true, edittype: 'image', formatter: ImageFormatter, width: 20, align: 'center', search: false },
                { name: 'TaskDate', index: 'TaskDate', sortable: true, sorttype: 'text', align: 'center', width: 80 },
                { name: 'Shipment', index: 'Shipment', sortable: true, sorttype: 'text', align: 'center', width: 50 },
                { name: 'Driver', index: 'Driver', sortable: true, sorttype: 'int', align: recordpos, width: 100, formatter: twoLinesTextFormatter },
                { name: 'Customer', index: 'Customer', sortable: true, sorttype: 'text', align: recordpos, width: 150, formatter: twoLinesTextFormatter },
                { name: 'CustomerAddress', index: 'CustomerAddress', sorttype: 'text', sortable: true, align: recordpos, width: 150, formatter: twoLinesTextFormatter },
                { name: 'TravelHours', index: 'TravelHours', sortable: true, sorttype: 'text', align: recordpos, width: 80, formatter: twoLinesTextFormatter },
                { name: 'ServiceHours', index: 'ServiceHours', sortable: true, sorttype: 'text', align: recordpos, width: 80, formatter: twoLinesTextFormatterSpan, cellattr: function (rowId, cellValue, rawObject) { console.log(JSON.stringify(rawObject)); console.log(rawObject.STYLE_ServiceHours); return ' class=' + (rawObject.STYLE_ServiceHours == 'NewStyle' ? 'New' : rawObject.STYLE_ServiceHours) + ''; } },
                { name: 'OriginalTime', index: 'OriginalTime', sortable: true, sorttype: 'text', align: recordpos, width: 60 },
                { name: 'DeliveryTime', index: 'DeliveryTime', sortable: true, sorttype: 'text', align: 'center', width: 70 },
				{ name: 'Cycle', index: 'Cycle', sortable: true, sorttype: 'text', align: 'center', width: 50 },
                { name: 'SortOrder', index: 'SortOrder', sortable: true, sorttype: 'text', align: 'center', width: 50 },
                { name: 'ActualSortOrder', index: 'ActualSortOrder', sortable: true, sorttype: 'text', align: 'center', width: 50 },
                { name: 'ByTrack', index: 'ByTrack', sorttype: 'text', sortable: true, align: 'center', width: 70 },
                { name: 'Delivery', index: 'Delivery', sortable: true, sorttype: 'text', align: 'center', width: 70 },
                { name: 'CustReturn', index: 'CustReturn', sortable: true, sorttype: 'text', align: 'center', width: 70 },
                { name: 'DriverReturn', index: 'DriverReturn', sortable: true, sorttype: 'text', align: 'center', width: 60, cellattr: function(rowId, cellValue, rawObject) {return ' class=' + rawObject.STYLE_DriverReturn + ''; } },
				{ name: 'Mission', index: 'Mission', sortable: true, sorttype: 'text', align: 'center', width: 60 },
				{ name: 'Quality', index: 'Quality', sortable: true, sorttype: 'text', align: 'center', width: 60 },
                { name: 'CollectedSurfaces', index: 'CollectedSurfaces', sortable: true, sorttype: 'text', align: 'center', width: 40, cellattr: function (rowId, cellValue, rawObject) { return ' class=' + rawObject.STYLE_CollectedSurfaces + ''; } },
				{ name: 'TravelHoursMinutes', index: 'TravelHoursMinutes', sortable: true, sorttype: 'text', align: 'center', width: 60 },
				{ name: 'ServiceHoursMinutes', index: 'ServiceHoursMinutes', sortable: true, sorttype: 'text', align: 'center', width: 60 },
                { name: 'CustomerID', hidden: 'true' },
                { name: 'DriverID', hidden: 'true' },
                { name: 'STYLE_ServiceHours', hidden: 'true' },
		{ name: 'DistrID', hidden: 'true' }
            ],
            viewrecords: true,
            sortorder: "asc",
            autoencode: false,
            pginput: true,
            altRows: false,
            resizable: false,
            shrinkToFit: false,
            rowNum: 100,
            rowList: [100, 200,300],
            toolbar: [true, "top"],
            ignoreCase: true,
            hoverrows: true,
            recordpos: (langDir == 'rtl' ? 'left' : 'right'),
            pager: '#grdCustomersPager',
            pgbuttons: true,
            rownumbers: false,
            gridview: true,
            loadonce: true,
            jsonReader: {
                repeatitems: false,
                root: function (obj) { return obj; },
                page: function (obj) { return customerGrid.jqGrid('getGridParam', 'page'); },
                total: function (obj) { return Math.ceil(obj.length / customerGrid.jqGrid('getGridParam', 'rowNum')); },
                records: function (obj) { return obj.length; }
            },
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (cust.rowCount == $(this).getGridParam('records')) {
                    $('#divCustomers').unblock();
                }
            },
            ondblClickRow: function (rowid) {
                cust.CustomerDetailsOpen($(this).getRowData(rowid));
            }
        });
        customerGrid.toolbarButtonAdd("#t_grdCustomers",
            {
                caption: $("#hidSearchButtonCaption").val(),
                position: "last",
                align: 'left',
                buttonicon: "ui-icon-search",
                onClickButton: function () {
                    customerGrid[0].toggleToolbar();
                }
            })
        .toolbarButtonAdd("#t_grdCustomers",
            {
                caption: "Excel",
                position: (langDir == 'rtl' ? 'left' : 'right'),
                align: (langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                    var urlHandlers = "../../Handlers/CustomerExcelHandler.ashx";
                    var paramHandlers = "?cid=" + $.QueryString["CountryID"] + "&did=" + $.QueryString["DistrID"] + "&driverID=" + $.QueryString["AgentId"] + "&date=" + $.QueryString["FromDate"] + "&toDate=" + $.QueryString["ToDate"];
                    $("#grdCustomers").jqGrid('excelExport', { url: urlHandlers + paramHandlers });
                }
            });
       
        $("#grdCustomers").jqGrid('filterToolbar', { stringResult: true, searchOnEnter: true, defaultSearch: 'cn' });
        customerGrid[0].toggleToolbar();
    },
    GetCustomersData: function (pdata, records) {
        if (records) {
            cust.ReceivedCustomersData(JSON.parse(records).rows)
        }
        else {
            let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];
            let did = $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"];
            let driverID = $.QueryString["AgentId"] == undefined ? null : $.QueryString["AgentId"];
            let date = $.QueryString["FromDate"] == undefined ? null : $.QueryString["FromDate"];
            let toDate = $.QueryString["ToDate"] == undefined ? null : $.QueryString["ToDate"];
            HardwareWebService.Layout_POD_WEB_AgentDailyActivity(cid, did, driverID, date, toDate,
                function (data, textStatus) {
                    cust.ReceivedCustomersData(JSON.parse(data).rows);
                }, function (data, textStatus) {
                    console.log(data.message);
                    return false;
                });
        }
        return false;
    },
    ReceivedCustomersData: function (data) {
        var thegrid = $("#grdCustomers")[0];        
        cust.rowCount = data.length;
        if (!cust.rowCount) $('#divCustomers').unblock();
        thegrid.addJSONData(data);
    },
    CustomerDetailsOpen: function (data) {
        let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];
        let did = data.DistrID == undefined ? null : data.DistrID;
        let driverID = data.DriverID == undefined ? null : data.DriverID;		
        let date = $.QueryString["FromDate"] == undefined ? null : $.QueryString["FromDate"];
        let todate = data.CustomerID == undefined ? null : data.CustomerID;
		let dateFormatted = data.TaskDate.toString().substr(6, 4) + data.TaskDate.toString().substr(3, 2) + data.TaskDate.toString().substr(0, 2);
        var params = {
            CountryID: cid,
            DistrID: did,
            AgentId: driverID,
            FromDate: dateFormatted,
            CustId: todate
        }
        var str = jQuery.param(params);
        let url = "../Compield/CustomerDetails.aspx?" + str;
        htmlResizablePopUp(url, "", "Save", $(window.parent).height(), $(window.parent).width());

        return false;
    }

}

$(function () {
    window.parent.CloseLoading();
    cust.Init();
});




Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (args) {
    window.parent.CloseLoading();
});
Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(function () {
    window.parent.ShowLoading();
});