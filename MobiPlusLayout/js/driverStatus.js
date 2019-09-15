var ds = {
    rowCount: 0,
    Init: function () {
        ds.CreateGrig();
    },
    CreateGrig: function (data) {
        let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];
        let langDir = $("#hidLanguage").val().toLowerCase() == "he" ? "rtl" : "ltr";

        let recordpos = (langDir == 'rtl' ? 'right' : 'left');

        $('#divDriverStatus').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var dsGrid = $("#grdDriverStatus").jqGrid({
            direction: langDir,
            datatype: function (pdata) { ds.GetDriverStatusData(pdata, data); },
            autowidth: true,
            width: 'auto',
            height: $(window).height() - 100,
            colNames: [
   	      $('#hidTaskDate_Grid_Header').val(),
              $('#hidDriverID_Grid_Header').val(),
              $('#hidDriverName_Grid_Header').val(),
              $('#hidCycle_Grid_Header').val(),
              $('#hidUpdateDate_Grid_Header').val(),
              $('#hidLineDownload_Grid_Header').val(),
              $('#hidWise_Grid_Header').val(),
              $('#hidimgArriveBB_Grid_Header').val(),
              $('#hidimgLeaveBB_Grid_Header').val(),
              $('#hidToDiplomat_Grid_Header').val(),
              $('#hidLineEnded_Grid_Header').val()
            ],
            colModel: [
		{ name: 'TaskDate', index: 'TaskDate', sortable: true, sorttype: 'text', align: 'center', width: 80 },
                { name: 'DriverID', index: 'DriverID', sortable: true, sorttype: 'int', align: recordpos, width: 100 },
                { name: 'DriverName', index: 'DriverName', sortable: true, sorttype: 'text', align: recordpos, width: 120 },
                { name: 'Cycle', index: 'Cycle', sorttype: 'text', sortable: true, align: 'center', width: 50 },
                { name: 'UpdateDate', index: 'UpdateDate', sortable: true, sorttype: 'text', align: 'center', width: 60 },
                { name: 'imgLineDownload', sortable: false, edittype: 'image', formatter: ImageFormatter, cellattr: function (rowId, cellValue, rawObject, cm, rdata) { if (rdata.imgLineDownload == 'YES1') { return ' class="BackGreen"'; } else { return ' class="BackRed"'; } }, align: 'center', width: 100, search: false },
                { name: 'imgWise', sortable: true, sortable: false, edittype: 'image', formatter: ImageFormatter, cellattr: function (rowId, cellValue, rawObject, cm, rdata) { if (rdata.imgWise == 'YES1') { return ' class="BackGreen"'; } else { return ' class="BackRed"'; } }, align: 'center', width: 100, search: false },
                { name: 'imgArriveBB', sortable: true, sortable: false, edittype: 'image', formatter: ImageFormatter, cellattr: function (rowId, cellValue, rawObject, cm, rdata) { if (rdata.imgArriveBB == 'YES1') { return ' class="BackGreen"'; } else { return ' class="BackRed"'; } }, align: 'center', width: 100, search: false },
                { name: 'imgLeaveBB', sortable: true, sortable: false, edittype: 'image', formatter: ImageFormatter, cellattr: function (rowId, cellValue, rawObject, cm, rdata) { if (rdata.imgLeaveBB == 'YES1') { return ' class="BackGreen"'; } else { return ' class="BackRed"'; } }, align: 'center', width: 100, search: false },
                { name: 'imgToDiplomat', sortable: false, edittype: 'image', formatter: ImageFormatter, cellattr: function (rowId, cellValue, rawObject, cm, rdata) { if (rdata.imgToDiplomat == 'YES1') { return ' class="BackGreen"'; } else { return ' class="BackRed"'; } }, align: 'center', width: 100, search: false },
                { name: 'imgLineEnded', sortable: false, edittype: 'image', formatter: ImageFormatter, cellattr: function (rowId, cellValue, rawObject, cm, rdata) { if (rdata.imgLineEnded == 'YES1') { return ' class="BackGreen"'; } else { return ' class="BackRed"'; } }, align: 'center', width: 100, search: false },
            ],            
            pager: '#grdDriverStatusPager',
            viewrecords: true,
            sortorder: "asc",
            autoencode: false,
            pginput: true,
            altRows: false,
            resizable: false,
            shrinkToFit: false,
            rowNum: 100,
            rowList: [100, 200, 300],
            toolbar: [true, "top"],
            ignoreCase: true,
            hoverrows: true,
            recordpos: (langDir == 'rtl' ? 'left' : 'right'),
            pgbuttons: true,
            rownumbers: false,
            gridview: true,
            loadonce: true,
            jsonReader: {
                repeatitems: false,
                root: function (obj) { return obj; },
                page: function (obj) { return dsGrid.jqGrid('getGridParam', 'page'); },
                total: function (obj) { return Math.ceil(obj.length / dsGrid.jqGrid('getGridParam', 'rowNum')); },
                records: function (obj) { return obj.length; }
            },
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (ds.rowCount == $(this).getGridParam('records')) {
                    $('#divDriverStatus').unblock();
                }
            },
            ondblClickRow: function (rowid) {
                ds.DriverStatusDetailsOpen($(this).getRowData(rowid));
            },
            onInitGrid: function () {
                if (cid == '5000') {
                    $("#grdDriverStatus").jqGrid('hideCol', 'imgArriveBB');
                    $("#grdDriverStatus").jqGrid('hideCol', 'imgLeaveBB');
                }
            }
        });
        dsGrid.toolbarButtonAdd("#t_grdDriverStatus",
           {
               caption: $("#hidSearchButtonCaption").val(),
               position: "last",
               align: 'left',
               buttonicon: "ui-icon-search",
               onClickButton: function () {
                   dsGrid[0].toggleToolbar();
               }
           })
       .toolbarButtonAdd("#t_grdDriverStatus",
           {
               caption: "Excel",
               position: (langDir == 'rtl' ? 'left' : 'right'),
               align: (langDir == 'rtl' ? 'right' : 'left'),
               buttonicon: 'ui-icon-contact',
               onClickButton: function () {
                   var urlHandlers = "../../Handlers/DriverStatusHandler.ashx";
                   var paramHandlers = "?cid=" + $.QueryString["CountryID"] + "&did=" + $.QueryString["DistrID"] + "&driverID=" + $.QueryString["AgentId"] + "&date=" + $.QueryString["FromDate"] + "&toDate=" + $.QueryString["ToDate"];
                   $("#grdDriverStatus").jqGrid('excelExport', { url: urlHandlers + paramHandlers });
               }
           });
       
        $("#grdDriverStatus").jqGrid('filterToolbar', { stringResult: true, searchOnEnter: true, defaultSearch: 'cn' });
        dsGrid[0].toggleToolbar();
    },
    GetDriverStatusData: function (pdata, records) {
        window.parent.ShowLoading();
        if (records) {
            ds.ReceivedDriverStatusData(JSON.parse(records).rows)
        }
        else {
            let reportID = $.QueryString["ID"] == undefined ? null : $.QueryString["ID"];
            let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];
            let did = $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"];
            let driverID = $.QueryString["AgentId"] == undefined ? null : $.QueryString["AgentId"];
            let date = $.QueryString["FromDate"] == undefined ? null : $.QueryString["FromDate"];
	    let toDate = $.QueryString["ToDate"] == undefined ? null : $.QueryString["ToDate"];
            HardwareWebService.Layout_POD_WEB_DriverStatus_DSA(cid, did, driverID, date, toDate,
                function (data, textStatus) {
                    ds.ReceivedDriverStatusData(JSON.parse(data).rows);
                }, function (data, textStatus) {
                    console.log(data.message);
                    return false;
                });
        }
        return false;
    },
    ReceivedDriverStatusData: function (data) {
        var thegrid = $("#grdDriverStatus")[0];        
        ds.rowCount = data.length;
        if (!ds.rowCount) $('#divDriverStatus').unblock();
       thegrid.addJSONData(data);
        window.parent.CloseLoading();
    },
    DriverStatusDetailsOpen: function (data) {
        let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];
        let did = $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"];
        let driverID = $.QueryString["AgentId"] == undefined ? null : $.QueryString["AgentId"];
        let date = $.QueryString["FromDate"] == undefined ? null : $.QueryString["FromDate"];
		let dateFormatted = data.TaskDate.toString().substr(6, 4) + data.TaskDate.toString().substr(3, 2) + data.TaskDate.toString().substr(0, 2);
        var params = {
            CountryID: cid,
            DistrID: did,
            AgentId: data.DriverID,
            FromDate: dateFormatted
        }
        var str = jQuery.param(params);
        let url = "../Compield/DriverStatusPopup.aspx?" + str;
        htmlResizablePopUp(url, "", "Save", $(window.parent).height(), $(window.parent).width());
        return false;
    }
}


$(function (e) {
    ds.Init();
});
