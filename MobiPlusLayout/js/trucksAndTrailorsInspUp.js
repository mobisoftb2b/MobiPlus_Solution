/// <reference path="_references.js" />
/// <reference path="Main.js" />
const ttiUp = {           
    rowCount: 0,
    Init: function () {
        ttiUp.CreateGrig();
    },
    CreateGrig: function (data) {
        let langDir = $("#hidLanguage").val().toLowerCase() == "he" ? "rtl" : "ltr";

        let recordpos = (langDir == 'rtl' ? 'right' : 'left');

      
        var ttiGrid = $("#grdTrucksAndTrailorsInsp").jqGrid({
            direction: langDir,
            datatype: function (pdata) { ttiUp.GetTrucksAndTrailorData(pdata, data); },
            autowidth: true,
            width: '100%',
            height: $(window).height() - 60,
            colNames: [             
              $('#hidQuestion_Grid_Header').val(),
              $('#hidAnswer_Grid_Header').val()
            ],
            colModel: [
               { name: 'questionDesc', index: 'questionDesc', sortable: true, sorttype: 'text', align: recordpos, width: 80, cellattr: function (rowId, cellValue, rawObject) { return ' class=' + rawObject.STYLE_questionDesc + ''; } },
               { name: 'answerDesc', index: 'answerDesc', sortable: true, formatter: twoLinesTextFormatter, sorttype: 'int', align: 'center', width: 100, cellattr: function (rowId, cellValue, rawObject) { return ' class=' + rawObject.STYLE_answerDesc + ''; } }
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
//            toolbar: [true, "top"],
            ignoreCase: true,
            hoverrows: true,
            recordpos: (langDir == 'rtl' ? 'left' : 'right'),
            pager: '#grdTrucksAndTrailorsInspPager',
            pgbuttons: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (ttiUp.rowCount == $(this).getGridParam('records')) {
                    $('#divTrucksAndTrailorInsp').unblock();
                }
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
            });
       
       
        $("#grdTrucksAndTrailorsInsp").jqGrid('filterToolbar', { stringResult: true, searchOnEnter: true, defaultSearch: 'cn' });
        ttiGrid[0].toggleToolbar();
    },
    GetTrucksAndTrailorData: function (pdata, records) {
        if (records) {
            ttiUp.ReceivedTrucksAndTrailorData(JSON.parse(records))
        }
        else {
            let docNum = $.QueryString["DocNum"] == undefined ? null : $.QueryString["DocNum"];
            HardwareWebService.Layout_POD_WEB_TrucksAndTrailorUpData(docNum,
                function (data, textStatus) {
                    ttiUp.ReceivedTrucksAndTrailorData(JSON.parse(data));
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
        ttiUp.rowCount = data.length;
        if (!ttiUp.rowCount) $('#divTrucksAndTrailorInsp').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    }

}

$(function () {
    ttiUp.Init();
});




Sys.WebForms.PageRequestManager.getInstance().add_endRequest(function (args) {
    window.parent.CloseLoading();
});
Sys.WebForms.PageRequestManager.getInstance().add_beginRequest(function () {
    window.parent.ShowLoading();
});