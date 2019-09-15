/// <reference path="_references.js" />
/// <reference path="Main.js" />

var custDetails = {
    rowCount: 0,
    Init: function () {
        custDetails.CreateGrig(null);
    },
    CreateGrig: function (data) {
        let langDir = $("#hidLanguage").val().toLowerCase() == "he" ? "rtl" : "ltr";

        let recordpos = (langDir == 'rtl' ? 'right' : 'left');

        $('#divCustomerDetails').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var customerGrid = $("#grdCustomerDetails").jqGrid({
            direction: langDir,
            datatype: function (pdata) { custDetails.GetCustomersData(pdata, data); },
            autowidth: true,
            width: '100%',
            height: $(window).height() - 60,
            colNames: [
              '.',
              $('#hidShipment_Grid_Header').val(),
              $('#hidDriver_Grid_Header').val(),                        
              $('#hidCustomer_Grid_Header').val(),
              $('#hidCustomerAddress_Grid_Header').val(),
              $('#hidTaskDescription_Grid_Header').val(),
              $('#hidDeliveryNum_Grid_Header').val(),
              $('#hidComment_Grid_Header').val(),
              $('#hidDescription_Grid_Header').val()
            ],
            colModel: [
                { name: 'ImgStatus', index: 'ImgStatus', sortable: false, edittype: 'image', formatter: ImageFormatter, width: 20, align: 'center', search: false },
                { name: 'Shipment', index: 'Shipment', sortable: true, sorttype: 'text', align: 'center', width: 50 },
                { name: 'Driver', index: 'Driver', sortable: true, sorttype: 'int', align: recordpos, width: 100, formatter: twoLinesTextFormatter },
                { name: 'Customer', index: 'Customer', sortable: true, sorttype: 'text', align: recordpos, width: 150, formatter: twoLinesTextFormatter },
                { name: 'CustomerAddress', index: 'CustomerAddress', sorttype: 'text', sortable: true, align: recordpos, width: 150, formatter: twoLinesTextFormatter },
                { name: 'TaskDescription', index: 'TaskDescription', sortable: true, sorttype: 'text', align: recordpos, width: 60, formatter: twoLinesTextFormatter },
                { name: 'DeliveryNum', index: 'DeliveryNum', sortable: true, sorttype: 'text', align: recordpos, width: 60, formatter: twoLinesTextFormatter },
                { name: 'Comment', index: 'Comment', sortable: true, sorttype: 'text', align: recordpos, width: 60 },
                { name: 'Description', index: 'Description', sortable: true, sorttype: 'text', align: 'center', width: 100 }
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
            pager: '#grdCustomersPager',
            pgbuttons: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (custDetails.rowCount == $(this).getGridParam('records')) {
                    $('#divCustomerDetails').unblock();
                }
            }
        });
        customerGrid.toolbarButtonAdd("#t_grdCustomerDetails",
            {
                caption: 'Search',
                position: "last",
                align: 'left',
                buttonicon: "ui-icon-search",
                onClickButton: function () {
                    customerGrid[0].toggleToolbar();
                }
            })
        .toolbarButtonAdd("#t_grdCustomerDetails",
            {
                caption: "Excel",
                position: (langDir == 'rtl' ? 'left' : 'right'),
                align: (langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                    $("#grdCustomerDetails").jqGrid("exportToExcel", {
                        includeLabels: true,
                        includeGroupHeader: true,
                        includeFooter: true,
                        fileName: "CustomerDetails.xlsx",
                        maxlength: 40 // maxlength for visible string data 
                    })
                }
            });
       
        $("#grdCustomerDetails").jqGrid('filterToolbar', { stringResult: true, searchOnEnter: true, defaultSearch: 'cn' });
        customerGrid[0].toggleToolbar();
    },
    GetCustomersData: function (pdata, records) {
        if (records) {
            custDetails.ReceivedCustomersData(JSON.parse(records).rows)
        }
        else {
            let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];
            let did = $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"];
            let driverID = $.QueryString["AgentId"] == undefined ? null : $.QueryString["AgentId"];
            let date = $.QueryString["FromDate"] == undefined ? null : $.QueryString["FromDate"];
            let toDate = $.QueryString["CustId"] == undefined ? null : $.QueryString["CustId"];
            HardwareWebService.Layout_POD_WEB_AgentDailyActivityPopup(cid, did, driverID, date, toDate,
                function (data, textStatus) {
                    custDetails.ReceivedCustomersData(JSON.parse(data).rows);
                }, function (data, textStatus) {
                    console.log(data.message);
                    return false;
                });
        }
        return false;
    },
    ReceivedCustomersData: function (data) {
        var thegrid = $("#grdCustomerDetails");
        thegrid.clearGridData();
        custDetails.rowCount = data.length;
        if (!custDetails.rowCount) $('#divCustomerDetails').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    }

}

$(function () {
    custDetails.Init();
});




Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (args) {
    window.parent.CloseLoading();
});
Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(function () {
    window.parent.ShowLoading();
});