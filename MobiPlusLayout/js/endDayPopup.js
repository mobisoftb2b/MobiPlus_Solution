var dep = {
    rowCount: 0,
    Init: function () {
        dep.CreateGrig();
    },
    CreateGrig: function (data) {
        let langDir = $("#hidLanguage").val().toLowerCase() == "he" ? "rtl" : "ltr";

        let recordpos = (langDir == 'rtl' ? 'right' : 'left');

        $('#divDayEndDetails').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var dsGrid = $("#grdDayEndDetails").jqGrid({
            direction: langDir,
            datatype: function (pdata) { dep.GetDayEndData(pdata, data); },
            autowidth: true,
            width: '100%',
            height: $(window).height() - 80,
            colNames: [
                '.',
              $('#hidShipment_Grid_Header').val(),
              $('#hidDriverName_Grid_Header').val(),
              $('#hidOrder_Grid_Header').val(),
              $('#hidCustomer_Grid_Header').val(),
              $('#hidAddress_Grid_Header').val(),
			  $('#hidCycle_Grid_Header').val(),
              $('#hidDelivery_Grid_Header').val(),
              $('#hidAgentReturn_Grid_Header').val(),
              $('#hidDriverReturn_Grid_Header').val(),
              $('#hidCollectedSurfaces_Grid_Header').val(),
              $('#hidDriverStatus_Grid_Header').val()
            ],
            colModel: [
                { name: 'ImgStatus', index: 'ImgStatus', sortable: false, edittype: 'image', formatter: ImageFormatter, width: 20, align: 'center', search: false },
                { name: 'Shipment', index: 'Shipment', sortable: true, sorttype: 'int', align: recordpos, width: 100 },
                { name: 'DriverName', index: 'DriverName', sortable: true, sorttype: 'text', formatter: twoLinesTextFormatter, align: recordpos, width: 120 },
                { name: 'Order', index: 'Order', sortable: true, sorttype: 'text', align: 'center', width: 100 },
                { name: 'Customer', index: 'Customer', sortable: true, sorttype: 'text', formatter: twoLinesTextFormatter, align: recordpos, width: 100 },
                { name: 'CustomerAddress', index: 'CustomerAddress', sortable: true, sorttype: 'text', formatter: twoLinesTextFormatter, align: recordpos, width: 100 },
				{ name: 'CycleDetails', index: 'CycleDetails', sorttype: 'text', sortable: true, align: 'center', width: 50 },
                { name: 'Delivery', index: 'Delivery', sorttype: 'text', sortable: true, align: 'center', width: 100 },
                { name: 'AgentReturn', index: 'AgentReturn', sortable: true, sorttype: 'text', align: 'center', width: 100 },
                { name: 'DriverReturn', index: 'DriverReturn', sortable: true, sorttype: 'text', align: 'center', width: 100 },
                { name: 'CollectedSurfaces', index: 'CollectedSurfaces', cellattr: function (rowId, cellValue, rawObject) { return ' class=' + rawObject.STYLE_CollectedSurfaces + ''; }, sortable: true, sorttype: 'text', align: 'center', width: 60 },
                { name: 'Status', index: 'Status', sortable: true, sorttype: 'text', formatter: twoLinesTextFormatter, align: recordpos, width: 100 }
            ],
            viewrecords: true,
            sortorder: "asc",
            autoencode: false,
            loadonce: false,
            pginput: false,
            altRows: true,
            resizable: false,
            shrinkToFit: true,
            rowNum: 20000,
            toolbar: [true, "top"],
            ignoreCase: true,
            hoverrows: true,
            recordpos: (langDir == 'rtl' ? 'left' : 'right'),
            pager: '#grdDayEndDetailsPager',
            pgbuttons: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (dep.rowCount == $(this).getGridParam('records')) {
                    $('#divDayEndDetails').unblock();
                }
            }
        });
        dsGrid.toolbarButtonAdd("#t_grdDayEndDetails",
        {
            caption: $("#hidSearchButtonCaption").val(),
            position: "last",
            align: 'left',
            buttonicon: "ui-icon-search",
            onClickButton: function () {
                dsGrid[0].toggleToolbar();
            }
        }).toolbarButtonAdd("#t_grdDayEndDetails",
        {
            caption: "Excel",
            position: (langDir == 'rtl' ? 'left' : 'right'),
            align: (langDir == 'rtl' ? 'right' : 'left'),
            buttonicon: 'ui-icon-contact',
            onClickButton: function () {
                $("#grdDayEndDetails").jqGrid("exportToExcel", {
                    includeLabels: true,
                    includeGroupHeader: true,
                    includeFooter: true,
                    fileName: "DayEndDetails.xlsx",
                    maxlength: 40 // maxlength for visible string data 
                })
            }
        });
        //dsGrid.navGrid("#grdDayEndDetailsPager", { edit: false, add: false, del: false, search: false, refresh: true })
        //   .navButtonAdd("#grdDayEndDetailsPager", {
        //       caption: $("#hidSearchButtonCaption").val(),
        //       buttonicon: "ui-icon-search",
        //       cursor: 'pointer',
        //       onClickButton: function () {
        //           dsGrid[0].toggleToolbar();
        //       },
        //       position: "first"
        //   });
        $("#grdDayEndDetails").jqGrid('filterToolbar', { stringResult: true, searchOnEnter: true, defaultSearch: 'cn' });
        dsGrid[0].toggleToolbar();
    },
    GetDayEndData: function (pdata, records) {
        if (records) {
            dep.ReceivedDayEndData(JSON.parse(records).rows)
        }
        else {
            let reportID = $.QueryString["ID"] == undefined ? null : $.QueryString["ID"];
            let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];
            let did = $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"];
            let driverID = $.QueryString["AgentId"] == undefined ? null : $.QueryString["AgentId"];
            let date = $.QueryString["FromDate"] == undefined ? null : $.QueryString["FromDate"];
			let cycle = $.QueryString["Cycle"] == undefined ? null : $.QueryString["Cycle"];  
            HardwareWebService.Layout_POD_WEB_EndDay_PopUp(cid, did, driverID, date,cycle,
                function (data, textStatus) {
                    dep.ReceivedDayEndData(JSON.parse(data).rows);
                }, function (data, textStatus) {
                    console.log(data.message);
                    return false;
                });
        }
        return false;
    },
    ReceivedDayEndData: function (data) {
        var thegrid = $("#grdDayEndDetails");
        thegrid.clearGridData();
        dep.rowCount = data.length;
        if (!dep.rowCount) $('#divDayEndDetails').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    }
}


$(function () {
    dep.Init();
});
