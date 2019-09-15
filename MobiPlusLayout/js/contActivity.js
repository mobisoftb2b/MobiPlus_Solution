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
            height: 500,
            colNames: [
              '.',
              $('#hidTaskDate_Grid_Header').val(),
              $('#hidDriverID_Grid_Header').val(),
              $('#hidDriverName_Grid_Header').val(),
              $('#hidShipment_Grid_Header').val(),
              $('#hidCycle_Grid_Header').val(),
              $('#hidVisit_Grid_Header').val(),
              $('#hidDelivery_Grid_Header').val(),
              $('#hidTT_Grid_Header').val(),
              $('#hidNotVisited_Grid_Header').val(),
              $('#hidNotFullDelivery_Grid_Header').val(),
              $('#hidAgentReturn_Grid_Header').val(),
              $('#hidDriverReturn_Grid_Header').val(),
              $('#hidDriverStatus_Grid_Header').val(),
              $('#hidProgress_Grid_Header').val(),
              $('#hidKPI_Grid_Header').val()
            ],
            colModel: [
                { name: 'ImgStatus', index: 'ImgStatus', sortable: true, edittype: 'image', formatter: ImageFormatter, width: 20, align: 'center', search: false },
                { name: 'TaskDate', index: 'TaskDate', sortable: true, sorttype: 'text', align: 'center', width: 80 },
                { name: 'DriverID', index: 'DriverID', sortable: true, sorttype: 'int', align: recordpos, width: 100 },
                { name: 'DriverName', index: 'DriverName', sortable: true, sorttype: 'text', align: recordpos, width: 150 },
                { name: 'Shipment', index: 'Shipment', sortable: true, sorttype: 'text', align: 'center', width: 80 },
                { name: 'Cycle', index: 'Cycle', sorttype: 'text', sortable: true, align: 'center', width: 50 },
                { name: 'Visit', index: 'Visit', sortable: true, sorttype: 'text', align: 'center', width: 80 },
                { name: 'Delivery', index: 'Delivery', sortable: true, sorttype: 'text', align: recordpos, width: 100 },
                { name: 'TT', index: 'TT', sortable: true, sorttype: 'text', align: 'center', width: 60 },
                { name: 'NotVisited', index: 'NotVisited', sortable: true, sorttype: 'text', align: recordpos, width: 60 },
                { name: 'NotFullDelivery', index: 'NotFullDelivery', sortable: true, sorttype: 'text', align: 'center', width: 70 },
                { name: 'AgentReturn', index: 'AgentReturn', sortable: true, sorttype: 'text', align: recordpos, width: 70 },
                { name: 'DriverReturn', index: 'DriverReturn', sortable: true, sorttype: 'text', align: 'center', width: 60 },
                { name: 'DriverStatus', index: 'DriverStatus', sortable: true, sorttype: 'text', formatter: twoLinesTextFormatter, align: recordpos, width: 250 },
                { name: 'Progress', index: 'Progress', sortable: false, edittype: 'text', formatter: BarFormatter, width: 80, align: recordpos, search: false },
                { name: 'KPI', index: 'KPI', sortable: true, sorttype: 'text', align: 'center', width: 50 }
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
            pager: '#grdContActivityPager',
            pgbuttons: true,
            rownumbers: false,
            gridview: true,
            loadonce: true,
            jsonReader: {
                repeatitems: false,
                root: function (obj) { return obj; },
                page: function (obj) { return activityGrid.jqGrid('getGridParam', 'page'); },
                total: function (obj) { return Math.ceil(obj.length / activityGrid.jqGrid('getGridParam', 'rowNum')); },
                records: function (obj) { return obj.length; }
            },
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (activity.rowCount == $(this).getGridParam('records')) {
                    $('#divContActivity').unblock();
                }
            },
            ondblClickRow: function (rowid) {
                activity.ConcActivityDetailsOpen($(this).getRowData(rowid));
            }          
        });
        activityGrid.toolbarButtonAdd("#t_grdContActivity",
            {
                caption: $("#hidSearchButtonCaption").val(),
                position: "last",
                align: 'left',
                buttonicon: "ui-icon-search",
                onClickButton: function () {
                    activityGrid[0].toggleToolbar();
                }
            })
        .toolbarButtonAdd("#t_grdContActivity",
            {
                caption: "Excel",
                position: (langDir == 'rtl' ? 'left' : 'right'),
                align: (langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                     var urlHandlers = "../../Handlers/ContActivityHandler.ashx";
                    var paramHandlers = "?ID=" + $.QueryString["ID"] + "&cid=" + $.QueryString["CountryID"] + "&did=" + $.QueryString["DistrID"] + "&driverID=" + $.QueryString["AgentId"] + "&date=" + $.QueryString["FromDate"] + "&toDate=" + $.QueryString["ToDate"];
                    $("#grdContActivity").jqGrid('excelExport', { url: urlHandlers + paramHandlers });
                }
            });
		activityGrid.navGrid("#grdContActivityPager", { edit: false, add: false, del: false, search: false, refresh: true });      
        $("#grdContActivity").jqGrid('filterToolbar', { stringResult: true, searchOnEnter: true, defaultSearch: 'cn' });
     
        activityGrid[0].toggleToolbar();
    },
    GetConcActivityData: function (pdata, records) {
        if (records) {
            activity.ReceivedConcActivityData(JSON.parse(records).rows)
        }
        else {
            let reportID = $.QueryString["ID"] == undefined ? null : $.QueryString["ID"];
            let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];
            let did = $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"];
            let driverID = $.QueryString["AgentId"] == undefined ? null : $.QueryString["AgentId"];
            let date = $.QueryString["FromDate"] == undefined ? null : $.QueryString["FromDate"];
            let toDate = $.QueryString["ToDate"] == undefined ? null : $.QueryString["ToDate"];
            HardwareWebService.Layout_POD_WEB_ConcentrationActivity(reportID, cid, did, driverID, date,toDate,
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
        var thegrid = $("#grdContActivity")[0];        
        activity.rowCount = data.length;
        if (!activity.rowCount) $('#divContActivity').unblock();
        thegrid.addJSONData(data);
    },
    ConcActivityDetailsOpen: function (data) {
        let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];
        let did = $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"];
        let driverID = $.QueryString["AgentId"] == undefined ? null : $.QueryString["AgentId"];
        let date = $.QueryString["FromDate"] == undefined ? null : $.QueryString["FromDate"];
        let dateFormatted = data.TaskDate.toString().substr(6, 4) + data.TaskDate.toString().substr(3, 2) + data.TaskDate.toString().substr(0, 2);
        var params = {
            Cycle: data.Cycle,
            CountryID: cid,
            DistrID: did,
            AgentId: data.DriverID,
            FromDate: dateFormatted,
            Shipment: data.Shipment
        }
        var str = jQuery.param( params );
        let url = "../Compield/ConcentrationActivityPopup.aspx?" + str;
        htmlResizablePopUp(url, "", "Save", $(window.parent).height(), $(window.parent).width());
        
        return false;
    }

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