/// <reference path="_references.js" />
/// <reference path="Main.js" />


var activity = {
    rowCount: 0,
    Init: function () {
        activity.CreateGrig();
    },
    CreateGrig: function (data) {
        let langDir = $("#hidLanguage").val().toLowerCase() == "he" ? "rtl" : "ltr";

        let recordpos = (langDir == 'rtl' ? 'right' : 'left');

        $('#divContActivityDetails').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var activityGrid = $("#grdContActivityDetails").jqGrid({
            direction: langDir,
            datatype: function (pdata) { activity.GetConcActivityData(pdata, data); },
            autowidth: true,
            width: '100%',
            height: $(window).height() - 60,
            colNames: [
              '.',
               $('#hidShipment_Grid_Header').val(),
              $('#hidDriverName_Grid_Header').val(),
              $('#hidCycle_Grid_Header').val(),  
              $('#hidOrder_Grid_Header').val(),
              $('#hidActualSortOrder_Grid_Header').val(),
              $('#hidCustomer_Grid_Header').val(),
              $('#hidAddress_Grid_Header').val(),
              $('#hidTravelHours_Grid_Header').val(),
              $('#hidServiceHours_Grid_Header').val(),
              $('#hidOriginalTime_Grid_Header').val(),
              $('#hidDeliveryTime_Grid_Header').val(),
              $('#hidDeliveries_Grid_Header').val(),
              $('#hidAgentReturn_Grid_Header').val(),
              $('#hidDriverReturn_Grid_Header').val(),
              $('#hidPallets_Grid_Header').val(),
              $('#hidDriverStatus_Grid_Header').val()
            ],
            colModel: [
                { name: 'ImgStatus', index: 'ImgStatus', sortable: false, edittype: 'image', formatter: ImageFormatter, width: 20, align: 'center', search: false },
                { name: 'Shipment', index: 'Shipment', sortable: true, sorttype: 'int', align: recordpos, width: 100 },
                { name: 'DriverName', index: 'DriverName', sortable: true, sorttype: 'text', formatter: twoLinesTextFormatter, align: recordpos, width: 150 },
                { name: 'Cycle', index: 'Cycle', sorttype: 'text', sortable: true, align: 'center', width: 60 },
                { name: 'SortOrder', index: 'SortOrder', sorttype: 'text', sortable: true, align: 'center', width: 60 },
                { name: 'ActualSortOrder', index: 'ActualSortOrder', sorttype: 'text', sortable: true, align: 'center', width: 60 },
                { name: 'Cust', index: 'Cust', sorttype: 'text', sortable: true, formatter: twoLinesTextFormatter, align: recordpos, width: 60 },
                { name: 'CustAddress', index: 'CustAddress', sortable: true, sorttype: 'text', formatter: twoLinesTextFormatter, align: recordpos, width: 60 },
                { name: 'TravelHours', index: 'TravelHours', sortable: true, sorttype: 'text', formatter: twoLinesTextFormatter, align: recordpos, width: 100 },
                { name: 'ServiceHours', index: 'ServiceHours', sortable: true, sorttype: 'text', formatter: twoLinesTextFormatter, align: recordpos, width: 60 },
                { name: 'OriginalTime', index: 'OriginalTime', sortable: true, sorttype: 'text', align: 'center', width: 70 },
                { name: 'DeliveryTime', index: 'DeliveryTime', sortable: true, sorttype: 'text', align: 'center', width: 70 },
                { name: 'Delivery', index: 'Delivery', sortable: true, sorttype: 'text', align: 'center', width: 70 },
                { name: 'AgentReturn', index: 'AgentReturn', sortable: true, sorttype: 'text', align: recordpos, width: 70 },
                { name: 'DriverReturn', index: 'DriverReturn', sortable: true, sorttype: 'text', align: 'center', width: 60 },
                { name: 'CollectedSurfaces', index: 'CollectedSurfaces', cellattr: function (rowId, cellValue, rawObject) { return ' class=' + rawObject.STYLE_CollectedSurfaces + ''; }, sortable: true, sorttype: 'text', align: 'center', width: 60 },
                { name: 'DriverStatus', index: 'DriverStatus', sortable: true, sorttype: 'text', formatter: twoLinesTextFormatter, align: recordpos, width: 300 }
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
            pager: '#grdContActivityDetailsPager',
            pgbuttons: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (activity.rowCount == $(this).getGridParam('records')) {
                    $('#divContActivityDetails').unblock();
                }
            }
        });
        activityGrid.toolbarButtonAdd("#t_grdContActivityDetails",
            {
                caption: "Search",
                position: "first",
                align: 'left',
                buttonicon: "ui-icon-search",
                onClickButton: function () {
                    activityGrid[0].toggleToolbar();
                }
            })
        .toolbarButtonAdd("#t_grdContActivityDetails",
            {
                caption: "Excel",
                position: "last",
                align: (langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                    $("#grdContActivityDetails").jqGrid("exportToExcel", {
                        includeLabels: true,
                        includeGroupHeader: true,
                        includeFooter: true,
                        fileName: "ContActivityDetails.xlsx",
                        maxlength: 40 // maxlength for visible string data 
                    })
                }
            });
        $("#grdContActivityDetails").jqGrid('filterToolbar', { stringResult: true, searchOnEnter: true, defaultSearch: 'cn' });
        activityGrid[0].toggleToolbar();
    },
    GetConcActivityData: function (pdata, records) {
        debugger;
        if (records) {
            activity.ReceivedConcActivityData(JSON.parse(records).rows)
        }
        else {
            let cycle = $.QueryString["Cycle"] == undefined ? null : $.QueryString["Cycle"];
            let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];
            let did = $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"];
            let driverID = $.QueryString["AgentId"] == undefined ? null : $.QueryString["AgentId"];
            let date = $.QueryString["FromDate"] == undefined ? null : $.QueryString["FromDate"];
            let shipment = $.QueryString["Shipment"] == undefined ? null : $.QueryString["Shipment"];
            HardwareWebService.Layout_POD_WEB_ConcentrationActivityPopup(cid, did, driverID, date, shipment, cycle,
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
        var thegrid = $("#grdContActivityDetails");
        thegrid.clearGridData();
        activity.rowCount = data.length;
        if (!activity.rowCount) $('#divContActivityDetails').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    }
}





$(function () {
    activity.Init();
});

