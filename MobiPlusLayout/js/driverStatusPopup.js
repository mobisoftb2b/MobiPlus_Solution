var ds = {
    rowCount: 0,
    Init: function () {
        ds.CreateGrig();
    },
    CreateGrig: function (data) {
        let langDir = $("#hidLanguage").val().toLowerCase() == "he" ? "rtl" : "ltr";

        let recordpos = (langDir == 'rtl' ? 'right' : 'left');

        $('#divDriverStatusDetails').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var driverStatusDetalsGrid = $("#grdDriverStatusDetals").jqGrid({
            direction: langDir,
            datatype: function (pdata) { ds.GetDriverStatusData(pdata, data); },
            autowidth: true,
            width: '100%',
            height: $(window).height() - 80,
            colNames: [
              $('#hidTaskTime_Grid_Header').val(),
              $('#hidShipmentID_Grid_Header').val(),
              $('#hidCust_Grid_Header').val(),
              $('#hidCustAddress_Grid_Header').val(),
              $('#hidTaskID_Grid_Header').val(),
              $('#hidDocNum_Grid_Header').val(),
              $('#hidReportCode_Grid_Header').val(),
              $('#hidDescription_Grid_Header').val(),
              $('#hidComment_Grid_Header').val(),
              $('#hidLastChange_Grid_Header').val()
            ],
            colModel: [
                { name: 'TaskTime', index: 'TaskTime', sortable: true, sorttype: 'int', align: 'center', width: 60 },
                { name: 'ShipmentID', index: 'ShipmentID', sortable: true, sorttype: 'text', align: 'center', width: 80 },
                { name: 'Customer', index: 'Customer', sorttype: 'text', formatter: twoLinesTextFormatter, sortable: true, align: recordpos, width: 130 },
                { name: 'CustAddress', index: 'CustAddress', sortable: true, formatter: twoLinesTextFormatter, sorttype: 'text', align: recordpos, width: 100 },
                { name: 'TaskID', index: 'TaskID', sortable: true, sorttype: 'text', align: recordpos, width: 100 },
                { name: 'DocNumber', index: 'DocNumber', sortable: true, sorttype: 'text', align: recordpos, width: 100 },
                { name: 'ReportCode', index: 'ReportCode', sortable: true, sorttype: 'text', align: 'center', width: 60 },
                { name: 'Description', index: 'Description', sortable: true, sorttype: 'text', align: recordpos, width: 100 },
                { name: 'Comment', index: 'Comment', sortable: true, sorttype: 'text', align: recordpos, width: 100 },
                { name: 'LastChange', index: 'LastChange', sortable: true, sorttype: 'text', align: 'center', width: 100 }
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
            pager: '#grdDriverStatusDetailsPager',
            pgbuttons: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (ds.rowCount == $(this).getGridParam('records')) {
                    $('#divDriverStatusDetails').unblock();
                }
            }
        });
        driverStatusDetalsGrid.toolbarButtonAdd("#t_grdDriverStatusDetals",
          {
              caption: "Search",
              position: "last",
              align: 'left',
              buttonicon: "ui-icon-search",
              onClickButton: function () {
                  driverStatusDetalsGrid[0].toggleToolbar();
              }
          })
      .toolbarButtonAdd("#t_grdDriverStatusDetals",
          {
              caption: "Excel",
              position: (langDir == 'rtl' ? 'left' : 'right'),
              align: (langDir == 'rtl' ? 'right' : 'left'),
              buttonicon: 'ui-icon-contact',
              onClickButton: function () {
                  $("#grdDriverStatusDetals").jqGrid("exportToExcel", {
                      includeLabels: true,
                      includeGroupHeader: true,
                      includeFooter: true,
                      fileName: "DriverStatusDetals.xlsx",
                      maxlength: 40 // maxlength for visible string data 
                  })
              }
          });
       
        $("#grdDriverStatusDetals").jqGrid('filterToolbar', { stringResult: true, searchOnEnter: true, defaultSearch: 'cn' });
        driverStatusDetalsGrid[0].toggleToolbar();
    },
    GetDriverStatusData: function (pdata, records) {
        if (records) {
            ds.ReceivedDriverStatusData(JSON.parse(records).rows)
        }
        else {
            let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];
            let did = $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"];
            let driverID = $.QueryString["AgentId"] == undefined ? null : $.QueryString["AgentId"];
            let date = $.QueryString["FromDate"] == undefined ? null : $.QueryString["FromDate"];
            HardwareWebService.Layout_POD_WEB_DriverStatus_PopUp(cid, did, driverID, date,
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
        var thegrid = $("#grdDriverStatusDetals");
        thegrid.clearGridData();
        ds.rowCount = data.length;
        if (!ds.rowCount) $('#divDriverStatusDetails').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    }
}


$(function () {
    ds.Init();
});
