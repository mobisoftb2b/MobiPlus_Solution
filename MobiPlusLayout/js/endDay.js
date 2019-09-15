var de = {
    rowCount: 0,
    Init: function () {
        de.CreateGrig();
    },
    CreateGrig: function (data) {
        let langDir = $("#hidLanguage").val().toLowerCase() == "he" ? "rtl" : "ltr";

        let recordpos = (langDir == 'rtl' ? 'right' : 'left');

        $('#divDayEnd').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var dsGrid = $("#grdDayEnd").jqGrid({
            direction: langDir,
            datatype: function (pdata) { de.GetDayEndData(pdata, data); },
            autowidth: true,
            width: '100%',
            height: $(window).height() - 80,
            colNames: [
                '.',
              $('#hidTaskDate_Grid_Header').val(),
              $('#hidDriverID_Grid_Header').val(),
              $('#hidDriverName_Grid_Header').val(),
			  $('#hidCycle_Grid_Header').val(),
              $('#hidDelivery_Grid_Header').val(),
              $('#hidAgentReturn_Grid_Header').val(),
              $('#hidDriverReturn_Grid_Header').val(),
              $('#hidPallets_Grid_Header').val(),
              $('#hidKmPlanned_Grid_Header').val(),
              $('#hidActualKM_Grid_Header').val()
            ],
            colModel: [
                { name: 'ImgStatus', index: 'ImgStatus', sortable: true, edittype: 'image', formatter: ImageFormatter, width: 20, align: 'center', search: false },
                { name: 'TaskDate', index: 'TaskDate', sortable: true, sorttype: 'text', align: 'center', width: 80 },
                { name: 'DriverID', index: 'DriverID', sortable: true, sorttype: 'int', align: recordpos, width: 100 },
                { name: 'DriverName', index: 'DriverName', sortable: true, sorttype: 'text', align: recordpos, width: 120 },
				{ name: 'EndDayCycle', index: 'EndDayCycle1', sorttype: 'text', sortable: true, align: 'center', width: 60 },
                { name: 'Delivery', index: 'Delivery', sorttype: 'text', sortable: true, align: 'center', width: 100 },
                { name: 'AgentReturn', index: 'AgentReturn', sortable: true, sorttype: 'text', align: 'center', width: 100 },
                { name: 'DriverReturn', index: 'DriverReturn', sortable: true, sorttype: 'text', align: 'center', width: 100 },
                { name: 'CollectedSurfaces', index: 'CollectedSurfaces', sortable: true, sorttype: 'text', align: 'center', width: 100, cellattr: function (rowId, cellValue, rawObject) { return ' class=' + rawObject.STYLE_CollectedSurfaces + ''; } },
                { name: 'DistansePlanned', index: 'DistansePlanned', sortable: true, sorttype: 'text', align: 'center', width: 100 },
                { name: 'DistanseReal', index: 'DistanseReal', sortable: true, sorttype: 'text', formatter: twoLinesTextFormatter, align: recordpos, width: 100 }
            ],
            pager: '#grdDayEndPager',
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
                if (de.rowCount == $(this).getGridParam('records')) {
                    $('#divDayEnd').unblock();
                }
            },
            ondblClickRow: function (rowid) {
                de.DayEndDetailsOpen($(this).getRowData(rowid));
            }
        });
        dsGrid.toolbarButtonAdd("#t_grdDayEnd",
         {
             caption: $("#hidSearchButtonCaption").val(),
             position: "last",
             align: 'left',
             buttonicon: "ui-icon-search",
             onClickButton: function () {
                 dsGrid[0].toggleToolbar();
             }
         })
     .toolbarButtonAdd("#t_grdDayEnd",
         {
             caption: "Excel",
             position: (langDir == 'rtl' ? 'left' : 'right'),
             align: (langDir == 'rtl' ? 'right' : 'left'),
             buttonicon: 'ui-icon-contact',
             onClickButton: function () {
                 var urlHandlers = "../../Handlers/DayEndExcelHandler.ashx";
                 var paramHandlers = "?cid=" + $.QueryString["CountryID"] + "&did=" + $.QueryString["DistrID"] + "&driverID=" + $.QueryString["AgentId"] + "&date=" + $.QueryString["FromDate"] + "&toDate=" + $.QueryString["ToDate"];
                 $("#grdDayEnd").jqGrid('excelExport', { url: urlHandlers + paramHandlers });
             }
         });
        
        $("#grdDayEnd").jqGrid('filterToolbar', { stringResult: true, searchOnEnter: true, defaultSearch: 'cn' });
        dsGrid[0].toggleToolbar();
    },
    GetDayEndData: function (pdata, records) {
        window.parent.ShowLoading();
        if (records) {
            de.ReceivedDayEndData(JSON.parse(records).rows)
        }
        else {
            let reportID = $.QueryString["ID"] == undefined ? null : $.QueryString["ID"];
            let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];
            let did = $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"];
            let driverID = $.QueryString["AgentId"] == undefined ? null : $.QueryString["AgentId"];
            let date = $.QueryString["FromDate"] == undefined ? null : $.QueryString["FromDate"];
            let toDate = $.QueryString["ToDate"] == undefined ? null : $.QueryString["ToDate"];
            HardwareWebService.Layout_POD_WEB_EndDay(cid, did, driverID, date, toDate,
                function (data, textStatus) {
                    de.ReceivedDayEndData(JSON.parse(data).rows);
                }, function (data, textStatus) {
                    console.log(data.message);
                    return false;
                });
        }
        return false;
    },
    ReceivedDayEndData: function (data) {
        var thegrid = $("#grdDayEnd")[0];        
        de.rowCount = data.length;
        if (!de.rowCount) $('#divDayEnd').unblock();
        thegrid.addJSONData(data);
        window.parent.CloseLoading();
    },
    DayEndDetailsOpen: function (data) {
        let cid = $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"];
        let did = $.QueryString["DistrID"] == undefined ? null : $.QueryString["DistrID"];
        let driverID = $.QueryString["AgentId"] == undefined ? null : $.QueryString["AgentId"];
        let date = $.QueryString["FromDate"] == undefined ? null : $.QueryString["FromDate"];
		let dateFormatted = data.TaskDate.toString().substr(6, 4) + data.TaskDate.toString().substr(3, 2) + data.TaskDate.toString().substr(0, 2);
        var params = {
            CountryID: cid,
            DistrID: did,
            AgentId: data.DriverID,
            FromDate: dateFormatted,
            Cycle: data.EndDayCycle
        }
        var str = jQuery.param(params);
        let url = "../Compield/DayEndPopup.aspx?" + str;
        htmlResizablePopUp(url, "", "Save", $(window.parent).height(), $(window.parent).width());
        return false;
    }
}


$(function () {
    de.Init();
});
