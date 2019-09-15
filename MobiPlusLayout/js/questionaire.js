const quest = {
    rowCount: 0,
    CreateGrid: (data) => {
        let langDir = $("#hidLanguage").val().toLowerCase() == "he" ? "rtl" : "ltr";

        let recordpos = (langDir == 'rtl' ? 'right' : 'left');

        $('#divQuestionaire').block({
            css: { border: '0px' },
            overlayCSS: { backgroundColor: '#ffffff', opacity: 0.7 },
            message: ''
        });
        var ttiGrid = $("#grdQuestionaire").jqGrid({
            direction: langDir,
            datatype: function (pdata) { quest.GetQuestionaireData(pdata, data); },
            autowidth: true,
            width: '100%',
            height: $(window).height() - 60,
            colNames: [
              '.',
              $('#hidTaskDate_Grid_Header').val(),
              $('#hidDistribution_Grid_Header').val(),
              $('#hidDriverName_Grid_Header').val(),
              $('#hidCustomer_Grid_Header').val(),
              $('#hidDocNum_Grid_Header').val(),
              $('#hidStatus_Grid_Header').val(),
              $('#hidFileName_Grid_Header').val(),
              '', ''
            ],
            colModel: [
                { name: 'imgStatus', index: 'imgStatus', sortable: false, edittype: 'image', formatter: ImageFormatter, width: 20, align: 'center', search: false },
                { name: 'Date', index: 'Date', sortable: true, sorttype: 'text', formatter: twoLinesTextFormatter, align: 'center', width: 50 },
                { name: 'Distribution', index: 'Distribution', sortable: true, formatter: twoLinesTextFormatter, sorttype: 'int', align: recordpos, width: 100 },
                { name: 'Driver', index: 'Driver', sortable: true, sorttype: 'text', formatter: twoLinesTextFormatter, align: recordpos, width: 150 },
                { name: 'Customer', index: 'Customer', sortable: true, sorttype: 'text', align: 'center', width: 60 },
                { name: 'DocNum', index: 'DocNum', sortable: true, sorttype: 'text', align: 'center', width: 60 },
                { name: 'Status', index: 'Status', sortable: true, sorttype: 'text', align: 'center', width: 60 },
                { name: 'FileName', index: 'FileName', sortable: true, sorttype: 'text', formatter: DownloadAttachFormatter, align: recordpos, width: 100 },
                { name: 'DriverID', hidden: true },
                { name: 'TaskDate1', hidden: true }
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
            pager: '#grdQuestionairePager',
            pgbuttons: false,
            gridComplete: function () {
                $(this).setGridParam({ datatype: 'local', selarrrow: 'false' });
                if (quest.rowCount == $(this).getGridParam('records')) {
                    $('#divQuestionaire').unblock();
                }
            },
            ondblClickRow: function (rowid) {
                quest.QuestionaireOpen($(this).getRowData(rowid));
            }
        });
        ttiGrid.toolbarButtonAdd("#t_grdQuestionaire",
            {
                caption: $("#hidSearchButtonCaption").val(),
                position: "last",
                align: 'left',
                buttonicon: "ui-icon-search",
                onClickButton: function () {
                    ttiGrid[0].toggleToolbar();
                }
            })
        .toolbarButtonAdd("#t_grdQuestionaire",
            {
                caption: "Excel",
                position: (langDir == 'rtl' ? 'left' : 'right'),
                align: (langDir == 'rtl' ? 'right' : 'left'),
                buttonicon: 'ui-icon-contact',
                onClickButton: function () {
                    var urlHandlers = "../../Handlers/ExcelHandler.ashx";
                    var paramHandlers = "?cid=" + $.QueryString["CountryID"] + "&did=" + $.QueryString["DistrID"] + "&driverID=" + $.QueryString["AgentId"] + "&date=" + $.QueryString["FromDate"] + "&toDate=" + $.QueryString["ToDate"];
                    $("#grdQuestionaire").jqGrid('excelExport', { url: urlHandlers + paramHandlers });
                }
            });

        $("#grdQuestionaire").jqGrid('filterToolbar', { stringResult: true, searchOnEnter: true, defaultSearch: 'cn' });
        ttiGrid[0].toggleToolbar();
    },
    GetQuestionaireData: (pdata, records) => {
        if (records) {
            quest.ReceivedQuestionaireData(JSON.parse(records))
        }
        else {
            let params = {
                CountryID: $.QueryString["CountryID"] == undefined ? null : $.QueryString["CountryID"],
                DistrID: $.QueryString["DistrID"] == undefined ? "-1" : $.QueryString["DistrID"],
                AgentId: $.QueryString["AgentId"] == undefined ? null : $.QueryString["AgentId"],
                FromDate: $.QueryString["FromDate"] == undefined ? null : $.QueryString["FromDate"],
                ToDate: $.QueryString["ToDate"] == undefined ? null : $.QueryString["ToDate"],
                QuestionnaireID: $.QueryString["QuestionnaireID"] == undefined ? 1 : $.QueryString["QuestionnaireID"]
            };
            HardwareWebService.Layout_POD_WEB_QUESTIONNAIRE(params,
                function (data, textStatus) {
                    quest.ReceivedQuestionaireData(JSON.parse(data));
                }, function (data, textStatus) {
                    console.log(data.message);
                    return false;
                });
        }
        return false;
    },
    ReceivedQuestionaireData: (data) => {
        var thegrid = $("#grdQuestionaire");
        thegrid.clearGridData();
        quest.rowCount = data.length;
        if (!quest.rowCount) $('#divQuestionaire').unblock();
        for (var i = 0; i < data.length; i++)
            thegrid.addRowData(i + 1, data[i]);
    },
    QuestionaireOpen: (data) => {
        let url = "../Compield/QuestionairePopup.aspx?DocNum=" + data.DocNum + "&TaskDate1="+data.TaskDate1;
        htmlResizablePopUp(url, "", "Save", $(window.parent).height(), $(window.parent).width());
        return false;
    }

}

$(function () {
    window.parent.CloseLoading();
    quest.CreateGrid();
});
